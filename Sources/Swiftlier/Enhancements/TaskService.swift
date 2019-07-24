//
//  TaskService.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/10/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import Foundation

public enum TaskResult {
    case success
    case error(ReportableError)
}

public final class TaskService {
    public static let singleton = TaskService()

    fileprivate var backgroundOperationQueue = OperationQueue()
    fileprivate typealias PeriodicTaskSpec = (task: PeriodicTask, period: TaskPeriod)
    fileprivate var scheduledPeriodicTasks = [String:PeriodicTaskSpec]()
    fileprivate var scheduledSingleTasks = [SingleTask]()

    fileprivate init() {}

    var logTasks = false

    public func schedule(singleTask task: SingleTask, at date: Date) {
        guard date.timeIntervalSince(Date()) >= 0 else {
            return
        }

        if let existingIndex = self.index(of: task) {
            self.scheduledSingleTasks.remove(at: existingIndex)
        }

        task.scheduledFor = date
        self.scheduledSingleTasks.append(task)

        DispatchQueue.main.asyncAfter(wallDeadline: date.dispatchTime) {
            guard let _ = self.index(of: task), date == task.scheduledFor else {
                return
            }
            if self.logTasks {
                self.logTask("Performing \(task.identifier) in foreground")
            }
            task.perform()

            guard let index = self.index(of: task) else {
                return
            }
            self.scheduledSingleTasks.remove(at: index)
        }
        logTask("Scheduled \(task.identifier) for \(date)")
    }

    public func unschedule(singleTask task: SingleTask) {
        guard let existingIndex = self.index(of: task) else {
            return
        }

        self.scheduledSingleTasks.remove(at: existingIndex)
    }

    public func schedule(periodicTask task: PeriodicTask, with period: TaskPeriod) {
        TaskService.performInForeground {
            self.scheduledPeriodicTasks[task.uniqueIdentifier] = (task: task, period: period)

            guard !task.isRunning else {
                return
            }

            if let lastSuccessfulRun = task.lastSuccessfulRun {
                guard !period.contains(lastSuccessfulRun) else {
                    self.schedule(periodicTask: task, with: period, at: period.nextDate(lastSuccessfulRun))
                    return
                }
            }

            self.performTask(withIdentifier: task.uniqueIdentifier, with: period)
        }
    }

    public func unschedule(periodicTask task: PeriodicTask) {
        TaskService.performInForeground {
            self.scheduledPeriodicTasks[task.uniqueIdentifier] = nil
        }
    }

    public func manuallyPerform(periodicTask task: PeriodicTask) {
        guard let (_, period) = self.scheduledPeriodicTasks[task.uniqueIdentifier] else {
            return
        }

        self.performTask(withIdentifier: task.uniqueIdentifier, with: period)
    }
}

public enum TaskPeriod {
    case interval(seconds: Double)
}

public enum TaskQueue {
    case foreground
    case background
}

public protocol PeriodicTask {
    var uniqueIdentifier: String { get }
    var performIn: TaskQueue { get }
    var isRunning: Bool { get set }
    var scheduleCount: Int { get set }

    func perform(_ onComplete: @escaping (TaskResult) -> ())
}

public final class BlockSingleTask: SingleTask {
    private let block: () -> ()

    public let identifier: String
    public var scheduledFor: Date?

    public init(identifier: String, scheduleAt date: Date? = nil, block: @escaping () -> ()) {
        self.identifier = identifier
        self.block = block
        if let date = date {
            self.schedule(at: date)
        }
    }

    deinit {
        self.unschedule()
    }
    
    public func perform() {
        return self.block()
    }
}

public protocol SingleTask: class {
    var identifier: String { get }
    var scheduledFor: Date? { get set }

    func perform()
}

public final class BlockPeriodicTask: PeriodicTask {
    public let uniqueIdentifier: String
    public let performIn: TaskQueue
    private let block: (@escaping (TaskResult) -> ()) -> ()

    public var isRunning = false
    public var scheduleCount: Int = 0

    public init(uniqueIdentifier: String, performIn: TaskQueue, scheduleNowWith period: TaskPeriod?, block: @escaping (@escaping (TaskResult) -> ()) -> ()) {
        self.uniqueIdentifier = uniqueIdentifier
        self.performIn = performIn
        self.block = block
        if let period = period {
            self.schedule(with: period)
        }
    }

    deinit {
        self.unschedule()
    }

    public func perform(_ onComplete: @escaping (TaskResult) -> ()) {
        return self.block(onComplete)
    }
}

private extension TaskService {
    func index(of singleTask: SingleTask) -> Int? {
        for (index, task) in self.scheduledSingleTasks.enumerated() {
            if task === singleTask {
                return index
            }
        }
        return nil
    }

    func performInBackground(_ block: @escaping () -> ()) {
        let operation = BlockOperation(block: block)
        self.backgroundOperationQueue.addOperation(operation)
    }

    func performInForeground(afterDelay delay: TimeInterval?, waitForCompletion: Bool, block: @escaping () -> ()) {
        if waitForCompletion {
            let semaphore = DispatchSemaphore(value: 0)
            func execute() {
                block()
                semaphore.signal()
            }
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: execute)
            }
            else {
                DispatchQueue.main.async(execute: execute)
            }
            semaphore.wait()
        }
        else {
            if let delay = delay {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
            }
            else {
                DispatchQueue.main.async(execute: block)
            }
        }
    }

    func schedule(periodicTask task: PeriodicTask, with period: TaskPeriod, at date: Date) {
        guard self.scheduledPeriodicTasks[task.uniqueIdentifier] != nil else {
            return
        }

        let scheduledCount = task.scheduleCount + 1
        self.scheduledPeriodicTasks[task.uniqueIdentifier]!.task.scheduleCount = scheduledCount
        DispatchQueue.main.asyncAfter(wallDeadline: date.dispatchTime) {
            guard scheduledCount == self.scheduledPeriodicTasks[task.uniqueIdentifier]?.task.scheduleCount else {
                return
            }
            self.performTask(withIdentifier: task.uniqueIdentifier, with: period)
        }
        logTask("Scheduled \(task.uniqueIdentifier) for \(date)")
    }

    func performTask(withIdentifier uniqueIdentifier: String, with period: TaskPeriod) {
        guard let task = self.scheduledPeriodicTasks[uniqueIdentifier]?.task else {
            return
        }

        self.scheduledPeriodicTasks[uniqueIdentifier]!.task.isRunning = true

        func onComplete(_ result: TaskResult) {
            guard self.scheduledPeriodicTasks[uniqueIdentifier] != nil else {
                return
            }

            let date = Date()
            switch result {
            case .success:
                self.scheduledPeriodicTasks[uniqueIdentifier]!.task.lastSuccessfulRun = date
            case .error(_):
                break
            }
            self.schedule(periodicTask: task, with: period, at: period.nextDate(date))
            self.scheduledPeriodicTasks[uniqueIdentifier]!.task.isRunning = false
        }

        switch task.performIn {
        case .foreground:
            logTask("Performing \(uniqueIdentifier) in foreground")
            task.perform(onComplete)
        case .background:
            logTask("Performing \(uniqueIdentifier) in background")
            TaskService.performInBackground {
                task.perform { result in
                    TaskService.performInForeground {
                        onComplete(result)
                    }
                }
            }
        }
    }

    func logTask(_ message: String) {
        if self.logTasks {
            print(message)
        }
    }
}

extension PeriodicTask {
    private var defaultsKey: String {
        return "PeriodicTask-\(self.uniqueIdentifier)"
    }

    var lastSuccessfulRun: Date? {
        get {
            let defaults = UserDefaults.standard
            let seconds = defaults.double(forKey: self.defaultsKey)
            guard seconds > 0 else {
                return nil
            }

            return Date(timeIntervalSince1970: seconds)
        }

        set {
            let defaults = UserDefaults.standard

            let seconds = newValue?.timeIntervalSince1970 ?? 0
            defaults.set(seconds, forKey: self.defaultsKey)
        }
    }

    public func schedule(with period: TaskPeriod) {
        TaskService.singleton.schedule(periodicTask: self, with: period)
    }

    public func unschedule() {
        TaskService.singleton.unschedule(periodicTask: self)
    }

    public func performManually() {
        TaskService.singleton.manuallyPerform(periodicTask: self)
    }
}

extension TaskPeriod {
    func contains(_ date: Date) -> Bool {
        switch self {
        case .interval(seconds: let seconds):
            return Date().timeIntervalSince(date) <= seconds
        }
    }
    
    func nextDate(_ after: Date) -> Date {
        switch self {
        case .interval(seconds: let seconds):
            return after.addingTimeInterval(seconds)
        }
    }
}

extension SingleTask {
    var isScheduled: Bool {
        return self.scheduledFor != nil
    }
}

extension SingleTask {
    public func schedule(at date: Date) {
        TaskService.singleton.schedule(singleTask: self, at: date)
    }

    public func unschedule() {
        TaskService.singleton.unschedule(singleTask: self)
    }
}
#endif
