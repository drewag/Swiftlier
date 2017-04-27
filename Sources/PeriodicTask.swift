//
//  PeriodicTask.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 10/1/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import Foundation

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
#endif
