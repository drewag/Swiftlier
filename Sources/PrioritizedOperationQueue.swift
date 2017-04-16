//
//  PrioritizedOperationQueue.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 3/4/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public protocol PrioritizedOperationIdentifier: Equatable {
    var name: String {get}
}

/**
 Queue operations and execute them in an order based on their priority
 
 Important Notes:
 - If an operation fails, all remaining operations are canceled and notified on their `onError` callback
 - When an operation is queued, operations are not automatically started. You must explicitly call `execute` to start operations
 - All operation callbacks are executed on the main thread
 - Operations are provided a child operation queue to queue dependent operations. If these operations are already queued (at a lower priority)
 on the parent queue, they will be pulled from the parent queue and executed as a part of the current operation.
*/
public class PrioritizedOperationQueue {
    public enum Priority: Int {
        case automatic
        case userInterface
        case userRequested
    }

    fileprivate var operations = [AnyOperation]()
    fileprivate var parentQueue: PrioritizedOperationQueue? = nil

    public init() {}

    fileprivate init(parent: PrioritizedOperationQueue) {
        self.parentQueue = parent
    }

    fileprivate var onFinishedAllRemainingOperations: [(ReportableResult<Void>) -> ()] = []
    public let isExecuting = Observable(false)

    public func queueOperation<Result, Identifier: PrioritizedOperationIdentifier>(
        _ identifier: Identifier,
        prioritizedAs priority: Priority,
        execute: @escaping (_ childOperationQueue: PrioritizedOperationQueue, _ completion: @escaping (ReportableResult<Result>) -> ()) -> (),
        onError: ((ReportableError) -> ())?,
        onSuccess: ((Result) -> ())?
        )
    {
        guard let existingOperation: Operation<Result, Identifier> = self.getOperationMatching(identifier: identifier) else {
            let operation = Operation(identifier: identifier, execute: execute, onError: onError, onSuccess: onSuccess, priority: priority)
            self.insert(new: operation)
            return
        }

        if !existingOperation.isExecuting {
            // Update the execution block to the latest version as long as it isn't already executing
            existingOperation.execute = execute
        }
        existingOperation.addListeners(onError: onError, onSuccess: onSuccess)
        self.insert(new: existingOperation)
    }

    public func execute(onFinishedAllRemainingOperations: ((ReportableResult<Void>) -> ())? = nil) {
        if let onFinishedAllRemainingOperations = onFinishedAllRemainingOperations {
            self.onFinishedAllRemainingOperations.append(onFinishedAllRemainingOperations)
        }

        guard !self.isExecuting.value else {
            return
        }

        self.isExecuting.value = true
        self.executeRemainingOperations()
    }
}

private protocol AnyOperation {
    var priority: PrioritizedOperationQueue.Priority {set get}
    var onError: [(ReportableError) -> ()] {get set}
    func execute(on queue: PrioritizedOperationQueue, onComplete: @escaping (ReportableError?) -> ())
}

private class Operation<Result, Identifier: PrioritizedOperationIdentifier>: AnyOperation {
    let identifier: Identifier

    var isExecuting = false

    var execute: (_ childOperationQueue: PrioritizedOperationQueue, _ completion: @escaping (ReportableResult<Result>) -> ()) -> ()
    var onError: [(ReportableError) -> ()]
    var onSuccess: [(Result) -> ()]
    var priority: PrioritizedOperationQueue.Priority

    init(
        identifier: Identifier,
        execute: @escaping (_ childOperationQueue: PrioritizedOperationQueue, _ completion: @escaping (ReportableResult<Result>) -> ()) -> (),
        onError: ((ReportableError) -> ())?,
        onSuccess: ((Result) -> ())?,
        priority: PrioritizedOperationQueue.Priority
        )
    {
        self.identifier = identifier
        self.execute = execute
        if let onError = onError {
            self.onError = [onError]
        }
        else {
            self.onError = []
        }
        if let onSuccess = onSuccess {
            self.onSuccess = [onSuccess]
        }
        else {
            self.onSuccess = []
        }
        self.priority = priority
    }
}

private extension PrioritizedOperationQueue {
    func getOperationMatching<Result, Identifier: PrioritizedOperationIdentifier>(identifier: Identifier) -> Operation<Result, Identifier>? {
        for (index, existingOperation) in self.operations.enumerated() {
            guard let existingOperation = existingOperation as? Operation<Result, Identifier>
                , identifier == existingOperation.identifier
                else
            {
                continue
            }
            self.operations.remove(at: index)
            return existingOperation
        }

        return self.parentQueue?.getOperationMatching(identifier: identifier)
    }

    func insert(new: AnyOperation) {
        for (index, operation) in self.operations.enumerated() {
            if new.priority.rawValue <= operation.priority.rawValue {
                continue
            }

            self.operations.insert(new, at: index)
            return
        }

        self.operations.append(new)
    }

    func executeRemainingOperations() {
        guard self.operations.count > 0 else {
            self.reportFinishedRemainign(withResult: .success(()))
            return
        }
        let next = self.operations.removeFirst()

        next.execute(on: self) { error in
            if let error = error {
                self.cancelRemainingOperations(dueToError: error)
                return
            }

            self.executeRemainingOperations()
        }
    }

    func cancelRemainingOperations(dueToError error: ReportableError) {
        for operation in self.operations {
            operation.report(error: error)
        }
        self.operations.removeAll()
        self.reportFinishedRemainign(withResult: .error(error))
    }

    func reportFinishedRemainign(withResult result: ReportableResult<Void>) {
        for block in self.onFinishedAllRemainingOperations {
            block(result)
        }
        self.onFinishedAllRemainingOperations.removeAll()
        self.isExecuting.value = false
    }
}

private extension AnyOperation {
    func report(error: ReportableError) {
        for block in self.onError {
            block(error)
        }
    }
}

private extension Operation {
    func addListeners(onError: ((ReportableError) -> ())?, onSuccess: ((Result) -> ())?) {
        if let onError = onError {
            self.onError.append(onError)
        }
        if let onSuccess = onSuccess {
            self.onSuccess.append(onSuccess)
        }
    }

    func report(successResultingIn result: Result) {
        for block in self.onSuccess {
            block(result)
        }
    }

    func execute(on queue: PrioritizedOperationQueue, onComplete: @escaping (ReportableError?) -> ()) {
        let childQueue = PrioritizedOperationQueue(parent: queue)
        self.execute(childQueue) { result in
            switch result {
            case .error(let error):
                self.report(error: error)
                onComplete(error)
            case .success(let result):
                self.report(successResultingIn: result)
                onComplete(nil)
            }
        }
        childQueue.execute()
    }
}
