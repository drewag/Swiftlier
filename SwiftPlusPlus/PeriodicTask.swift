//
//  PeriodicTask.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/1/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public enum TaskResult {
    case success
    case error(UserReportableError)
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

    func perform(onComplete: (TaskResult) -> ())
}

extension PeriodicTask {
    private var defaultsKey: String {
        return "PeriodicTask-\(self.uniqueIdentifier)"
    }

    var lastSuccessfulRun: NSDate? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            let seconds = defaults.doubleForKey(self.defaultsKey)
            guard seconds > 0 else {
                return nil
            }

            return NSDate(timeIntervalSince1970: seconds)
        }

        set {
            let defaults = NSUserDefaults.standardUserDefaults()

            let seconds = newValue?.timeIntervalSince1970 ?? 0
            defaults.setDouble(seconds, forKey: self.defaultsKey)
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
    func contains(date: NSDate) -> Bool {
        switch self {
        case .interval(seconds: let seconds):
            return NSDate().timeIntervalSinceDate(date) <= seconds
        }
    }

    func nextDate(after: NSDate) -> NSDate {
        switch self {
        case .interval(seconds: let seconds):
            return after.dateByAddingTimeInterval(seconds)
        }
    }
}
