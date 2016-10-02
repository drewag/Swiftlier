//
//  TaskService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/10/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public final class TaskService {
    public static let singleton = TaskService()

    private var backgroundOperationQueue = NSOperationQueue()
    private typealias TaskSpec = (task: PeriodicTask, period: TaskPeriod)
    private var scheduledTasks = [String:TaskSpec]()

    private init() {}

    static public func performInBackground(block: () -> ()) {
        return self.singleton.performInBackground(block)
    }

    static public func performInForeground(waitForCompletion wait: Bool = false, block: () -> ()) {
        return self.singleton.performInForeground(wait, block: block)
    }

    public func schedule(periodicTask task: PeriodicTask, with period: TaskPeriod) {
        TaskService.performInForeground {
            self.scheduledTasks[task.uniqueIdentifier] = (task: task, period: period)

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
            self.scheduledTasks[task.uniqueIdentifier] = nil
        }
    }

    public func manuallyPerform(periodicTask task: PeriodicTask) {
        guard let (_, period) = self.scheduledTasks[task.uniqueIdentifier] else {
            return
        }

        self.performTask(withIdentifier: task.uniqueIdentifier, with: period)
    }
}

private extension TaskService {
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
        guard self.scheduledTasks[task.uniqueIdentifier] != nil else {
            return
        }

        let scheduledCount = task.scheduleCount + 1
        self.scheduledTasks[task.uniqueIdentifier]!.task.scheduleCount = scheduledCount
        dispatch_after(date.time, dispatch_get_main_queue(), {
            guard scheduledCount == self.scheduledTasks[task.uniqueIdentifier]!.task.scheduleCount else {
                return
            }
            self.performTask(withIdentifier: task.uniqueIdentifier, with: period)
        })
        print("Scheduled \(task.uniqueIdentifier) for \(date)")
    }

    func performTask(withIdentifier uniqueIdentifier: String, with period: TaskPeriod) {
        guard let task = self.scheduledTasks[uniqueIdentifier]?.task else {
            return
        }

        self.scheduledTasks[uniqueIdentifier]!.task.isRunning = true

        func onComplete(result: TaskResult) {
            guard self.scheduledTasks[uniqueIdentifier] != nil else {
                return
            }

            switch result {
            case .success:
                let date = NSDate()
                self.scheduledTasks[uniqueIdentifier]!.task.lastSuccessfulRun = date
                self.schedule(periodicTask: task, with: period, at: period.nextDate(date))
            case .error(_):
                let date = NSDate().dateByAddingTimeInterval(60 * 60) // Retry in 1 hour
                self.schedule(periodicTask: task, with: period, at: date)
            }
            self.scheduledTasks[uniqueIdentifier]!.task.isRunning = false
        }

        switch task.performIn {
        case .foreground:
            print("Performing \(uniqueIdentifier) in foreground")
            task.perform(onComplete)
        case .background:
            print("Performing \(uniqueIdentifier) in background")
            TaskService.performInBackground {
                task.perform { result in
                    TaskService.performInForeground {
                        onComplete(result)
                    }
                }
            }
        }
    }
}
