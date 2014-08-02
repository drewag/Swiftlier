//
//  Observable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/17/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation


struct ObservationOptions : RawOptionSet {
    typealias RawType = UInt

    var value: RawType
    init(_ value: RawType) {
        self.value = value
    }

    static var None: ObservationOptions { return ObservationOptions(0) }
    static var Initial: ObservationOptions { return ObservationOptions(1) }
}

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
            for (observer, handlers) in self._observers {
                if observer.value {
                    for handler in handlers {
                        handler(change: Update(oldValue: oldValue, newValue: value))
                    }
                }
                else {
                    if let index = self._indexOfObserver(observer) {
                        self._observers.removeAtIndex(index)
                    }
                }
            }
        }
    }

    // MARK: Initializers

    init(_ value: ValueType) {
        self.value = value
    }

    // MARK: Methods

    func addObserver(observer: AnyObject, handler: DidChangeHandler) {
        self.addObserver(observer, options: ObservationOptions.None, handler: handler)
    }


    func addObserver(observer: AnyObject, options: ObservationOptions, handler: DidChangeHandler) {
        if let index = self._indexOfObserver(observer) {
            // since the observer exists, add the handler to the existing array
            self._observers[index].handlers.append(handler)
        }
        else {
            // since the observer does not already exist, add a new tuple with the
            // observer and an array with the handler
            self._observers.append(observer: WeakWrapper(observer), handlers: [handler])
        }

        if (options & ObservationOptions.Initial) {
            handler(change: Change(newValue: self.value))
        }
    }

    func removeObserver(observer: AnyObject) {
        if let index = self._indexOfObserver(observer) {
            self._observers.removeAtIndex(index)
        }
    }

    // MARK: Private Properties

    private var _observers: [(observer: WeakWrapper<AnyObject>, handlers: [DidChangeHandler])] = []

    // MARK: Private Methods

    private func _indexOfObserver(observer: AnyObject) -> Int? {
        var index: Int = 0
        for (possibleObserver, handlers) in self._observers {
            if possibleObserver.value === observer {
                return index
            }
            index++
        }
        return nil
    }
}

private class WeakWrapper<T : AnyObject> {
    weak var value: T?
    init(_ value: T) {
        self.value = value
    }
}

extension ObservationOptions {
    static func fromMask(raw: RawType) -> ObservationOptions {
        return ObservationOptions(raw)
    }

    static func convertFromNilLiteral() -> ObservationOptions {
        return self.None
    }

    func getLogicValue() -> Bool {
        return self.value > 0
    }

    static func fromRaw(raw: RawType) -> ObservationOptions? {
        return ObservationOptions(raw)
    }

    func toRaw() -> RawType {
        return self.value
    }
}


func ==(lhs: ObservationOptions, rhs: ObservationOptions) -> Bool {
    return lhs.value == rhs.value
}