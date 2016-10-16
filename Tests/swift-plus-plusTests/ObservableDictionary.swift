//
//  ObservableDictionary.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import SwiftPlusPlus

public final class ObservableDictionary<Key: Hashable, Value> {
    public typealias DidChange = (_ oldValue: Value, _ newValue: Value, _ at: Key) -> ()
    public typealias DidInsert = (Value, _ at: Key) -> ()
    public typealias DidRemove = (Value, _ at: Key) -> ()
    public typealias DidRemoveAll = (_ oldValues: [Key:Value]) -> ()
    public typealias ObservationHandlers = (changed: DidChange?, insert: DidInsert?, remove: DidRemove?, removeAll: DidRemoveAll?)

    fileprivate var observers: [(observer: WeakWrapper, handlers: [ObservationHandlers])] = []
    fileprivate var onHasObserversChanged: ((Bool) -> ())?

    public fileprivate(set) var values: [Key:Value]

    public init(_ values: [Key:Value], onHasObserversChanged: ((Bool) -> ())? = nil) {
        self.values = values
        self.onHasObserversChanged = onHasObserversChanged
    }

    public func add(
        observer: AnyObject,
        onDidChange: DidChange? = nil,
        onDidInsert: DidInsert? = nil,
        onDidRemove: DidRemove? = nil,
        onDidRemoveAll: DidRemoveAll? = nil
        )
    {
        guard onDidInsert != nil || onDidRemove != nil || onDidRemoveAll != nil else {
            return
        }

        let handlers: ObservationHandlers = (changed: onDidChange, insert: onDidInsert, remove: onDidRemove, removeAll: onDidRemoveAll)
        if let index = self.index(ofObserver: observer) {
            self.observers[index].handlers.append(handlers)
        }
        else {
            let oldCount = self.observers.count
            self.observers.append((observer: WeakWrapper(observer), handlers: [handlers]))
            if oldCount == 0 {
                self.onHasObserversChanged?(true)
            }
        }
    }

    public func remove(observer: AnyObject) {
        if let index = self.index(ofObserver: observer) {
            self.observers.remove(at: index)
            if self.observers.count == 0 {
                self.onHasObserversChanged?(false)
            }
        }
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.values[key]
        }
        set {
            if let oldValue = self.values[key] {
                self.values[key] = newValue
                if let newValue = newValue {
                    self.executeWithAllHandlers({ handler in
                        handler.changed?(oldValue, newValue, key)
                    })
                }
                else {
                    self.executeWithAllHandlers({ handler in
                        handler.remove?(oldValue, key)
                    })
                }
            }
            else {
                self.values[key] = newValue
                if let newValue = newValue {
                    self.executeWithAllHandlers({ handler in
                        handler.insert?(newValue, key)
                    })
                }
            }
        }
    }

    public func removeAll() {
        let oldValues = self.values
        self.values.removeAll()
        self.executeWithAllHandlers({ handler in
            handler.removeAll?(oldValues)
        })
    }
}

private extension ObservableDictionary {
    func index(ofObserver observer: AnyObject) -> Int? {
        var index: Int = 0
        for (possibleObserver, _) in self.observers {
            if possibleObserver.value === observer {
                return index
            }
            index += 1
        }
        return nil
    }

    func executeWithAllHandlers(_ callback: (_ handlers: ObservationHandlers) -> ()) {
        for (_, handlers) in self.observers {
            for handler in handlers {
                callback(handler)
            }
        }
    }
}
