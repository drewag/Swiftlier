//
//  TaskService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/10/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public enum TaskResult {
    case success
    case error(UserReportableError)
}

public final class TaskService {
    public static let singleton = TaskService()

    private var backgroundOperationQueue = NSOperationQueue()
    private typealias PeriodicTaskSpec = (task: PeriodicTask, period: TaskPeriod)
    private var scheduledPeriodicTasks = [String:PeriodicTaskSpec]()
    private var scheduledSingleTasks = [SingleTask]()

    private init() {}

    var logTasks = false

    static public func performInBackground(block: () -> ()) {
        return self.singleton.performInBackground(block)
    }

    static public func performInForeground(waitForCompletion wait: Bool = false, block: () -> ()) {
        return self.singleton.performInForeground(wait, block: block)
    }

    public func schedule(singleTask task: SingleTask, at date: NSDate) {
        guard date.timeIntervalSinceDate(NSDate()) >= 0 else {
            return
        }

        if let existingIndex = self.index(of: task) {
            self.scheduledSingleTasks.removeAtIndex(existingIndex)
        }

        task.scheduledFor = date
        self.scheduledSingleTasks.append(task)

        dispatch_after(date.time, dispatch_get_main_queue(), {
            guard let _ = self.index(of: task) where date == task.scheduledFor else {
                return
            }
            if self.logTasks {
                self.logTask("Performing \(task.identifier) in foreground")
            }
            task.perform()

            guard let index = self.index(of: task) else {
                return
            }
            self.scheduledSingleTasks.removeAtIndex(index)
        })
        logTask("Scheduled \(task.identifier) for \(date)")
    }

    public func unschedule(singleTask task: SingleTask) {
        guard let existingIndex = self.index(of: task) else {
            return
        }

        self.scheduledSingleTasks.removeAtIndex(existingIndex)
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
        for (index, task) in self.scheduledSingleTasks.enumerate() {
            if task === singleTask {
                return index
            }
        }
        return nil
    }

    func performInBackground(block: () -> ()) {
        let operation = NSBlockOperation(block: block)
        self.backgroundOperationQueue.addOperation(operation)
    }

    func performInForeground(waitForCompletion: Bool, block: () -> ()) {
        if waitForCompletion {
            let semaphore = dispatch_semaphore_create(0)
            dispatch_async(dispatch_get_main_queue()) {
                block()
                dispatch_semaphore_signal(semaphore)
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
        else {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    }

    func schedule(periodicTask task: PeriodicTask, with period: TaskPeriod, at date: NSDate) {
        guard self.scheduledPeriodicTasks[task.uniqueIdentifier] != nil else {
            return
        }

        let scheduledCount = task.scheduleCount + 1
        self.scheduledPeriodicTasks[task.uniqueIdentifier]!.task.scheduleCount = scheduledCount
        dispatch_after(date.time, dispatch_get_main_queue(), {
            guard scheduledCount == self.scheduledPeriodicTasks[task.uniqueIdentifier]!.task.scheduleCount else {
                return
            }
            self.performTask(withIdentifier: task.uniqueIdentifier, with: period)
        })
        logTask("Scheduled \(task.uniqueIdentifier) for \(date)")
    }

    func performTask(withIdentifier uniqueIdentifier: String, with period: TaskPeriod) {
        guard let task = self.scheduledPeriodicTasks[uniqueIdentifier]?.task else {
            return
        }

        self.scheduledPeriodicTasks[uniqueIdentifier]!.task.isRunning = true

        func onComplete(result: TaskResult) {
            guard self.scheduledPeriodicTasks[uniqueIdentifier] != nil else {
                return
            }

            switch result {
            case .success:
                let date = NSDate()
                self.scheduledPeriodicTasks[uniqueIdentifier]!.task.lastSuccessfulRun = date
                self.schedule(periodicTask: task, with: period, at: period.nextDate(date))
            case .error(_):
                let date = NSDate().dateByAddingTimeInterval(60 * 60) // Retry in 1 hour
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

    func logTask(message: String) {
        if self.logTasks {
            print(message)
        }
    }
}
