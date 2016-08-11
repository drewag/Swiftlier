//
//  TaskService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/10/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct TaskService {
    private var backgroundOperationQueue = NSOperationQueue()

    private init() {}
    private static let singleton = TaskService()

    static public func performInBackground(block: () -> ()) {
        return self.singleton.performInBackground(block)
    }

    static public func performInForeground(block: () -> ()) {
        return self.singleton.performInForeground(block)
    }

    private func performInBackground(block: () -> ()) {
        let operation = NSBlockOperation(block: block)
        self.backgroundOperationQueue.addOperation(operation)
    }

    private func performInForeground(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}