//
//  BlockPeriodicTask.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/1/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
public final class BlockPeriodicTask: PeriodicTask {
    public let uniqueIdentifier: String
    public let performIn: TaskQueue
    private let block: ((TaskResult) -> ()) -> ()

    public var isRunning = false
    public var scheduleCount: Int = 0

    public init(uniqueIdentifier: String, performIn: TaskQueue, scheduleNowWith period: TaskPeriod?, block: @escaping ((TaskResult) -> ()) -> ()) {
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

    public func perform(_ onComplete: (TaskResult) -> ()) {
        return self.block(onComplete)
    }
}
#endif
