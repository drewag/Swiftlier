//
//  Observable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/17/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/**
    Options for observing an observable
*/
public struct ObservationOptions: BitwiseOperationsType, BooleanType  {
    let rawValue: UInt

    public static var None: ObservationOptions { return ObservationOptions(rawValue: 0) }
    /**
        Call the observation callback immediately with the current value
    */
    public static var Initial: ObservationOptions { return ObservationOptions(rawValue: 1) }
    /**
        Remove observer after first call
    */
    public static var OnlyOnce: ObservationOptions { return ObservationOptions(rawValue: 2) }

    public static var allZeros: ObservationOptions {
        return self.None
    }

    public var boolValue: Bool {
        return self.rawValue != 0
    }
}

/**
    Change indicator that a value has been set
*/
public class SetValue<T> {
    /**
        The new value of the observable
    */
    public let newValue: T

    init(newValue: T) {
        self.newValue = newValue
    }
}

/**
    Change indicator that a value has been updated
    that includes an old value
*/
public class UpdateValue<T>: SetValue<T> {
    /**
        The old value of the observable
    */
    public let oldValue: T

    init(oldValue: T, newValue: T) {
        self.oldValue = oldValue
        super.init(newValue: newValue)
    }
}

/**
    Store a value that can be observed by external objects
*/
public final class Observable<T> {
    public typealias DidChangeHandler = (change: SetValue<T>) -> ()

    // MARK: Properties

    /**
        The current value
    */
    public var value : T {
        didSet {
            var handlersToCall = [DidChangeHandler]()

            for observerIndex in Array((0..<self._observers.count).reverse()) {
                let observer = self._observers[observerIndex].observer
                var handlers = self._observers[observerIndex].handlers

                if observer.value != nil {
                    for handlerIndex in Array((0..<handlers.count).reverse()) {
                        let handlerSpec = handlers[handlerIndex]
                        handlersToCall.append(handlerSpec.handler)
                        if handlerSpec.options & ObservationOptions.OnlyOnce {
                            handlers.removeAtIndex(handlerIndex)
                        }
                    }
                    
                    if handlers.count == 0 {
                        self._observers.removeAtIndex(observerIndex)
                    }
                    else {
                        self._observers[observerIndex] = (observer: observer, handlers: handlers)
                    }
                }
                else {
                    if let index = self._indexOfObserver(observer) {
                        self._observers.removeAtIndex(index)
                    }
                }
            }

            let change = UpdateValue(oldValue: oldValue, newValue: value)
            for handler in handlersToCall {
                handler(change: change)
            }
        }
    }

    /**
        Whether there is at least 1 current observer
    */
    public var hasObserver: Bool {
        return _observers.count > 0
    }

    // MARK: Initializers

    public init(_ value: T, onHasObserversChanged: ((Bool) -> ())? = nil) {
        self.value = value
        self._onHasObserverChanged = onHasObserversChanged
    }

    // MARK: Methods

    /**
        Add handler for when the value has changed

        - parameter observer: observing object to be referenced later to remove the hundler
        - parameter handler: callback to be called when value is changed
    */
    public func addObserver(observer: AnyObject, handler: DidChangeHandler) {
        self.addObserver(observer, options: ObservationOptions.None, handler: handler)
    }

    /**
        Add handler for when the value has changed

        - parameter observer: observing object to be referenced later to remove the hundler
        - parameter options: observation options
        - parameter handler: callback to be called when value is changed
    */
    public func addObserver(observer: AnyObject, options: ObservationOptions, handler: DidChangeHandler) {
        if let index = self._indexOfObserver(observer) {
            // since the observer exists, add the handler to the existing array
            self._observers[index].handlers.append((options: options, handler: handler))
        }
        else {
            // since the observer does not already exist, add a new tuple with the
            // observer and an array with the handler
            let oldCount = self._observers.count
            self._observers.append((observer: WeakWrapper(observer), handlers: [(options: options, handler: handler)]))
            if oldCount == 0 {
                self._onHasObserverChanged?(true)
            }
        }

        if (options & ObservationOptions.Initial) {
            handler(change: SetValue(newValue: self.value))
        }
    }

    /**
        Remove all handlers for the given observer

        - parameter observer: the observer to remove handlers from
    */
    public func removeObserver(observer: AnyObject) {
        if let index = self._indexOfObserver(observer) {
            self._observers.removeAtIndex(index)
            if self._observers.count == 0 {
                self._onHasObserverChanged?(false)
            }
        }
    }

    // MARK: Private Properties

    typealias HandlerSpec = (options: ObservationOptions, handler: DidChangeHandler)
    private var _observers: [(observer: WeakWrapper, handlers: [HandlerSpec])] = []
    private var _onHasObserverChanged: ((Bool) -> ())?

    // MARK: Private Methods

    private func _indexOfObserver(observer: AnyObject) -> Int? {
        var index: Int = 0
        for (possibleObserver, _) in self._observers {
            if possibleObserver.value === observer {
                return index
            }
            index += 1
        }
        return nil
    }
}

func ==(lhs: ObservationOptions, rhs: ObservationOptions) -> Bool {
    return lhs.rawValue == rhs.rawValue
}


public func &(lhs: ObservationOptions, rhs: ObservationOptions) -> ObservationOptions {
    let raw = lhs.rawValue & rhs.rawValue
    return ObservationOptions(rawValue: raw)
}

public func |(lhs: ObservationOptions, rhs: ObservationOptions) -> ObservationOptions {
    let raw = lhs.rawValue | rhs.rawValue
    return ObservationOptions(rawValue: raw)
}

public func ^(lhs: ObservationOptions, rhs: ObservationOptions) -> ObservationOptions {
    let raw = lhs.rawValue ^ rhs.rawValue
    return ObservationOptions(rawValue: raw)
}

public prefix func ~(x: ObservationOptions) -> ObservationOptions {
    let raw = x.rawValue ^ ~ObservationOptions.allZeros.rawValue
    return ObservationOptions(rawValue: raw)
}
