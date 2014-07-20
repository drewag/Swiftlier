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

    var value : ValueType {
        didSet {
            for (owner, handlers) in self._observers {
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

    // #pragma mark - Private Properties

    var _observers: [(AnyObject,[DidChangeHandler])] = []

    // #pragma mark - Private Methods

    func _modifyHandlersForOwner(owner: AnyObject, modify: (handlers: [DidChangeHandler]) -> [DidChangeHandler]?) {
        var index : Int = 0
        for (possibleOwner, handlers) in self._observers {
            if possibleOwner === owner {
                if let newHandlers = modify(handlers: handlers) {
                    self._observers[index] = (owner, newHandlers)
                }
                else {
                    self._observers.removeAtIndex(index)
                }
                break
            }
        }
        if let newHandlers = modify(handlers: []) {
            self._observers.append((owner, newHandlers))
        }
    }
}