//
//  MultiCallback.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/5/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

/**
    Object that allows the registration of multiple callbacks
*/
public final class MultiCallback<CallbackArguments> {
    public typealias CallBackType = (CallbackArguments) -> ()
    
    // MARK: Properties
    
    fileprivate var observers: [(observer: WeakWrapper, callbacks: [CallBackType])] = []
    fileprivate var onHasObserverChanged: ((Bool) -> ())?

    /**
     Whether there is at least 1 current observer
     */
    public var hasObserver: Bool {
        return observers.count > 0
    }

    // MARK: Initializers
    
    public init(onHasObserversChanged: ((Bool) -> ())? = nil) {
        self.onHasObserverChanged = onHasObserversChanged
    }

    // MARK: Methods
    
    /**
        Add a callback for when object is triggered
    
        - parameter observer: observing object to be referenced later to remove the hundler
        - parameter callback: callback to be called
    */
    public func addObserver(_ observer: AnyObject, callback: @escaping CallBackType) {
        if let index = self.indexOfObserver(observer) {
            // since the observer exists, add the callback to the existing array
            self.observers[index].callbacks.append(callback)
        }
        else {
            // since the observer does not already exist, add a new tuple with the
            // observer and an array with the callback
            let oldCount = self.observers.count
            self.observers.append((observer: WeakWrapper(observer), callbacks: [callback]))
            if oldCount == 0 {
                self.onHasObserverChanged?(true)
            }
        }
    }
    
    /**
        Remove a callback for when object is triggered
    
        - parameter observer: observing object passed in when registering the callback originally
    */
    public func removeObserver(_ observer: AnyObject) {
        if let index = self.indexOfObserver(observer) {
            self.observers.remove(at: index)
            if self.observers.count == 0 {
                self.onHasObserverChanged?(false)
            }
        }
    }
    
    /**
        Trigger registered callbacks to be called with the given arguments
    
        Callbacks are all executed on the same thread before this method returns
    
        - parameter arguments: the arguments to trigger the callbacks with
    */
    public func triggerWithArguments(_ arguments: CallbackArguments) {
        for (observer, callbacks) in self.observers {
            if observer.value != nil {
                for callback in callbacks {
                    callback(arguments)
                }
            }
            else {
                if let index = self.indexOfObserver(observer) {
                    self.observers.remove(at: index)
                }
            }
        }
    }
}

// MARK - Private Methods

private extension MultiCallback {
    func indexOfObserver(_ observer: AnyObject) -> Int? {
        var index: Int = 0
        for (possibleObserver, _) in self.observers {
            if possibleObserver.value === observer {
                return index
            }
            index += 1
        }
        return nil
    }
}
