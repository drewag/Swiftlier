//
//  Observable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/17/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

class Observable<ValueType> {
    typealias DidChangeHandler = (oldValue: ValueType?, newValue: ValueType) -> ()

    var observers: [(AnyObject,[DidChangeHandler])] = []
    var value : ValueType {
        didSet {
            for (owner, handlers) in self.observers {
                for handler in handlers {
                    handler(oldValue: oldValue, newValue: value)
                }
            }
        }
    }
    init(_ value: ValueType) {
        self.value = value
    }

    func addObserverForOwner(owner: AnyObject, triggerImmediately: Bool = true, handler: DidChangeHandler) {
        self._modifyHandlersForOwner(owner) { (handlers) in
            var copy = handlers
            copy.append(handler)
            return copy
        }
        if (triggerImmediately) {
            handler(oldValue: nil, newValue: self.value)
        }
    }

    func removeObserversForOwner(owner: AnyObject) {
        self._modifyHandlersForOwner(owner) { (_) in return nil }
    }

    func _modifyHandlersForOwner(owner: AnyObject, modify: (handlers: [DidChangeHandler]) -> [DidChangeHandler]?) {
        var index : Int = 0
        for (possibleOwner, handlers) in self.observers {
            if possibleOwner === owner {
                if let newHandlers = modify(handlers: handlers) {
                    self.observers[index] = (owner, newHandlers)
                }
                else {
                    self.observers.removeAtIndex(index)
                }
                break
            }
        }
        if let newHandlers = modify(handlers: []) {
            self.observers.append((owner, newHandlers))
        }
    }
}