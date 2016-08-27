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

    static public func performInForeground(waitForCompletion wait: Bool = false, block: () -> ()) {
        return self.singleton.performInForeground(wait, block: block)
    }

    private func performInBackground(block: () -> ()) {
        let operation = NSBlockOperation(block: block)
        self.backgroundOperationQueue.addOperation(operation)
    }

    private func performInForeground(waitForCompletion: Bool, block: () -> ()) {
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
}