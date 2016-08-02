//
//  ObservableDictionary.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public final class ObservableDictionary<Key: Hashable, Value> {
    public typealias DidChange = (oldValue: Value, newValue: Value, at: Key) -> ()
    public typealias DidInsert = (Value, at: Key) -> ()
    public typealias DidRemove = (Value, at: Key) -> ()
    public typealias DidRemoveAll = (oldValues: [Key:Value]) -> ()
    public typealias ObservationHandlers = (changed: DidChange?, insert: DidInsert?, remove: DidRemove?, removeAll: DidRemoveAll?)

    private var observers: [(observer: WeakWrapper, handlers: [ObservationHandlers])] = []
    private var onHasObserversChanged: ((Bool) -> ())?

    public private(set) var values: [Key:Value]

    public init(_ values: [Key:Value], onHasObserversChanged: ((Bool) -> ())? = nil) {
        self.values = values
        self.onHasObserversChanged = onHasObserversChanged
    }

    public func add(
        observer observer: AnyObject,
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

    public func remove(observer observer: AnyObject) {
        if let index = self.index(ofObserver: observer) {
            self.observers.removeAtIndex(index)
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
                        handler.changed?(oldValue: oldValue, newValue: newValue, at: key)
                    })
                }
                else {
                    self.executeWithAllHandlers({ handler in
                        handler.remove?(oldValue, at: key)
                    })
                }
            }
            else {
                self.values[key] = newValue
                if let newValue = newValue {
                    self.executeWithAllHandlers({ handler in
                        handler.insert?(newValue, at: key)
                    })
                }
            }
        }
    }

    public func removeAll() {
        let oldValues = self.values
        self.values.removeAll()
        self.executeWithAllHandlers({ handler in
            handler.removeAll?(oldValues: oldValues)
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

    func executeWithAllHandlers(callback: (handlers: ObservationHandlers) -> ()) {
        for (_, handlers) in self.observers {
            for handler in handlers {
                callback(handlers: handler)
            }
        }
    }
}