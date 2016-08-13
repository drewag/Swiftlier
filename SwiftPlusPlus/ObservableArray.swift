//
//  ObservableArray.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/9/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public final class ObservableArray<Element> {
    public typealias DidInsert = (Element, at: Int) -> ()
    public typealias DidRemove = (Element, at: Int) -> ()
    public typealias DidRemoveAll = (oldValues: [Element]) -> ()
    public typealias DidMove = (Element, from: Int, to: Int) -> ()
    public typealias ObservationHandlers = (insert: DidInsert?, remove: DidRemove?, removeAll: DidRemoveAll?, didMove: DidMove?)

    private var observers: [(observer: WeakWrapper, handlers: [ObservationHandlers])] = []
    private var onHasObserversChanged: ((Bool) -> ())?
    private var isOrderedBefore: ((lhs: Element, rhs: Element) -> Bool)?

    public private(set) var values: [Element]

    public convenience init() {
        self.init([])
    }

    public init(
        _ values: [Element],
        enforceOrder isOrderedBefore: ((lhs: Element, rhs: Element) -> Bool)? = nil,
        onHasObserversChanged: ((Bool) -> ())? = nil
        )
    {
        self.values = values
        self.isOrderedBefore = isOrderedBefore
        self.onHasObserversChanged = onHasObserversChanged
    }

    public func add(
        observer observer: AnyObject,
        onDidInsert: DidInsert? = nil,
        onDidRemove: DidRemove? = nil,
        onDidRemoveAll: DidRemoveAll? = nil,
        onDidMove: DidMove? = nil
        )
    {
        guard onDidInsert != nil || onDidRemove != nil || onDidRemoveAll != nil else {
            return
        }

        let handlers: ObservationHandlers = (
            insert: onDidInsert,
            remove: onDidRemove,
            removeAll: onDidRemoveAll,
            didMove: onDidMove
        )
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
        if let isOrderedBefore = self.isOrderedBefore {
            for (index, otherElement) in self.values.enumerate() {
                if isOrderedBefore(lhs: element, rhs: otherElement) {
                    self.values.insert(element, atIndex: index)
                    self.executeWithAllHandlers({ handler in
                        handler.insert?(element, at: index)
                    })
                    return
                }
            }
        }

        self.values.append(element)
        let index = self.values.count - 1
        self.executeWithAllHandlers({ handler in
            handler.insert?(element, at: index)
        })
    }

    public func insert(element: Element, at index: Int) {
        if self.isOrderedBefore != nil {
            self.append(element)
        }

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
        let oldValues = self.values
        self.values.removeAll()
        self.executeWithAllHandlers({ handler in
            handler.removeAll?(oldValues: oldValues)
        })
    }

    public func resort() {
        guard let isOrderedBefore = self.isOrderedBefore else {
            return
        }

        var unsortedTemplate = [(id: Int, element: Element)]()
        for (index, element) in self.values.enumerate() {
            let value = (id: index, element: element)
            unsortedTemplate.append(value)
        }
        let sortedTemplate = unsortedTemplate.sort({ isOrderedBefore(lhs: $0.element, rhs: $1.element) })

        var toIndex = self.values.count - 1
        for (sortedId, _) in sortedTemplate.reverse() {
            var fromIndex = 0
            for (unsortedId, _) in unsortedTemplate {
                if sortedId == unsortedId {
                    if fromIndex != toIndex {
                        // move
                        let element = self.values.removeAtIndex(fromIndex)
                        self.values.insert(element, atIndex: toIndex)
                        let template = unsortedTemplate.removeAtIndex(fromIndex)
                        unsortedTemplate.insert(template, atIndex: toIndex)
                        self.executeWithAllHandlers({ handler in
                            handler.didMove?(element, from: fromIndex, to: toIndex)
                        })
                    }
                    break
                }
                fromIndex += 1
            }
            toIndex -= 1
        }
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