//
//  SingleTask.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/1/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import Foundation

public protocol SingleTask: class {
    var identifier: String { get }
    var scheduledFor: Date? { get set }

    func perform()
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
