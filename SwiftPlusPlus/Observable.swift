//
//  Observable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/17/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

class Change<T> {
    let newValue: T

    init(newValue: T) {
        self.newValue = newValue
    }
}

class Update<T>: Change<T> {
    let oldValue: T

    init(oldValue: T, newValue: T) {
        self.oldValue = oldValue
        super.init(newValue: newValue)
    }
}

class Observable<ValueType> {
    typealias DidChangeHandler = (change: Change<ValueType>) -> ()

    // MARK: Properties

    var value : ValueType {
        didSet {
            for (owner, handlers) in self._observers {
                for handler in handlers {
                    handler(change: Update(oldValue: oldValue, newValue: value))
                }
            }
        }
    }

    // MARK: Initializers

    init(_ value: ValueType) {
        self.value = value
    }

    // MARK: Methods

    func addObserverForOwner(owner: AnyObject, triggerImmediately: Bool, handler: DidChangeHandler) {
        if let index = self._indexOfOwner(owner) {
            // since the owner exists, add the handler to the existing array
            self._observers[index].handlers.append(handler)
        }
        else {
            // since the owner does not already exist, add a new tuple with the
            // owner and an array with the handler
            self._observers.append(owner: owner, handlers: [handler])
        }

        if (triggerImmediately) {
            handler(change: Change(newValue: self.value))
        }
    }

    func removeObserversForOwner(owner: AnyObject) {
        if let index = self._indexOfOwner(owner) {
            self._observers.removeAtIndex(index)
        }
    }

    // MARK: Private Properties

    private var _observers: [(owner: AnyObject, handlers: [DidChangeHandler])] = []

    // MARK: Private Methods

    private func _indexOfOwner(owner: AnyObject) -> Int? {
        var index: Int = 0
        for (possibleOwner, handlers) in self._observers {
            if possibleOwner === owner {
                return index
            }
            index++
        }
        return nil
    }
}