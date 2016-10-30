//
//  BlockSingleTask.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import Foundation

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
#endif
