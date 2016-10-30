//
//  TaskService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/10/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import Foundation

public enum TaskResult {
    case success
    case error(UserReportableError)
}

public final class TaskService {
    public static let singleton = TaskService()

    fileprivate var backgroundOperationQueue = OperationQueue()
    fileprivate typealias PeriodicTaskSpec = (task: PeriodicTask, period: TaskPeriod)
    fileprivate var scheduledPeriodicTasks = [String:PeriodicTaskSpec]()
    fileprivate var scheduledSingleTasks = [SingleTask]()

    fileprivate init() {}

    var logTasks = false

    static public func performInBackground(_ block: @escaping () -> ()) {
        return self.singleton.performInBackground(block)
    }

    static public func performInForeground(waitForCompletion wait: Bool = false, block: @escaping () -> ()) {
        return self.singleton.performInForeground(wait, block: block)
    }

    public func schedule(singleTask task: SingleTask, at date: Date) {
        guard date.timeIntervalSince(Date()) >= 0 else {
            return
        }

        if let existingIndex = self.index(of: task) {
            self.scheduledSingleTasks.remove(at: existingIndex)
        }

        task.scheduledFor = date
        self.scheduledSingleTasks.append(task)

        DispatchQueue.main.asyncAfter(wallDeadline: date.time) {
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

    func performInForeground(_ waitForCompletion: Bool, block: @escaping () -> ()) {
        if waitForCompletion {
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.main.async {
                block()
                semaphore.signal()
            }
            semaphore.wait()
        }
        else {
            DispatchQueue.main.async(execute: block)
        }
    }

    func schedule(periodicTask task: PeriodicTask, with period: TaskPeriod, at date: Date) {
        guard self.scheduledPeriodicTasks[task.uniqueIdentifier] != nil else {
            return
        }

        let scheduledCount = task.scheduleCount + 1
        self.scheduledPeriodicTasks[task.uniqueIdentifier]!.task.scheduleCount = scheduledCount
        DispatchQueue.main.asyncAfter(wallDeadline: date.time) {
            guard scheduledCount == self.scheduledPeriodicTasks[task.uniqueIdentifier]!.task.scheduleCount else {
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

            switch result {
            case .success:
                let date = Date()
                self.scheduledPeriodicTasks[uniqueIdentifier]!.task.lastSuccessfulRun = date
                self.schedule(periodicTask: task, with: period, at: period.nextDate(date))
            case .error(_):
                let date = Date().addingTimeInterval(60 * 60) // Retry in 1 hour
                self.schedule(periodicTask: task, with: period, at: date)
            }
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
#endif
