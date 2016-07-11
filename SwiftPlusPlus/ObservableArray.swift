//
//  ObservableArray.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/9/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public final class ObservableArray<Element> {
    public typealias DidChange = ([Element]) -> ()
    public typealias DidInsert = (Element, at: Int) -> ()
    public typealias DidRemove = (Element, at: Int) -> ()
    public typealias DidRemoveAll = () -> ()
    public typealias ObservationHandlers = (changed: DidChange?, insert: DidInsert?, remove: DidRemove?, removeAll: DidRemoveAll?)

    private var observers: [(observer: WeakWrapper, handlers: [ObservationHandlers])] = []
    private var onHasObserversChanged: ((Bool) -> ())?

    public private(set) var values: [Element]

    public init(_ values: [Element], onHasObserversChanged: ((Bool) -> ())? = nil) {
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
        guard onDidChange != nil || onDidInsert != nil || onDidRemove != nil || onDidRemoveAll != nil else {
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

    public func append(element: Element) {
        self.values.append(element)
        let index = self.values.count - 1
        self.executeWithAllHandlers({ handler in
            handler.insert?(element, at: index)
        })
    }

    public func insert(element: Element, at index: Int) {
        self.values.insert(element, atIndex: index)
        self.executeWithAllHandlers({ handler in
            handler.insert?(element, at: index)
        })
    }

    public func remove(at index: Int) {
        let element = self.values[index]
        self.values.removeAtIndex(index)
        self.executeWithAllHandlers({ handler in
            handler.remove?(element, at: index)
        })
    }

    public func removeAll() {
        self.values.removeAll()
        self.executeWithAllHandlers({ handler in
            handler.removeAll?()
        })
    }
}

private extension ObservableArray {
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