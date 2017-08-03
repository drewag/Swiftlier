//
//  ObservableArray.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/9/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

public final class ObservableArray<Element> {
    public typealias DidInsert = (Element, _ at: Int) -> ()
    public typealias DidRemove = (Element, _ at: Int) -> ()
    public typealias DidRemoveAll = (_ oldValues: [Element]) -> ()
    public typealias DidMove = (Element, _ from: Int, _ to: Int) -> ()
    public typealias ObservationHandlers = (insert: DidInsert?, remove: DidRemove?, removeAll: DidRemoveAll?, didMove: DidMove?)

    fileprivate var observers: [(observer: WeakWrapper<AnyObject>, handlers: [ObservationHandlers])] = []
    fileprivate var onHasObserversChanged: ((Bool) -> ())?
    fileprivate var isOrderedBefore: ((_ lhs: Element, _ rhs: Element) -> Bool)?

    public fileprivate(set) var values: [Element]

    public convenience init() {
        self.init([])
    }

    public init(
        _ values: [Element],
        enforceOrder isOrderedBefore: ((_ lhs: Element, _ rhs: Element) -> Bool)? = nil,
        onHasObserversChanged: ((Bool) -> ())? = nil
        )
    {
        self.values = values
        self.isOrderedBefore = isOrderedBefore
        self.onHasObserversChanged = onHasObserversChanged
    }

    public func add(
        observer: AnyObject,
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

    #if os(iOS)
    public func add(observer: AnyObject, forSection section: Int, in tableView: UITableView, withIndexOffset indexOffset: Int = 0) {
        self.add(
            observer: observer,
            onDidInsert: { _, index in
                let indexPath = IndexPath(item: index + indexOffset, section: section)
                tableView.insertRows(at: [indexPath], with: .automatic)
            },
            onDidRemove: { _, index in
                let indexPath = IndexPath(item: index + indexOffset, section: section)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            },
            onDidRemoveAll: { _ in
                tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            },
            onDidMove: { _, from, to in
                tableView.moveRow(
                    at: IndexPath(row: from + indexOffset, section: section),
                    to: IndexPath(row: to + indexOffset, section: section)
                )
            }
        )
    }
    #endif

    #if os(iOS)
    public func add(observer: AnyObject, forSection section: Int, in collectionView: UICollectionView, withIndexOffset indexOffset: Int = 0) {
        self.add(
            observer: observer,
            onDidInsert: { _, index in
                let indexPath = IndexPath(item: index + indexOffset, section: section)
                collectionView.insertItems(at: [indexPath])
            },
            onDidRemove: { _, index in
                let indexPath = IndexPath(item: index + indexOffset, section: section)
                collectionView.deleteItems(at: [indexPath])
            },
            onDidRemoveAll: { _ in
                collectionView.reloadData()
            },
            onDidMove: { _, from, to in
                collectionView.moveItem(
                    at: IndexPath(item: from + indexOffset, section: section),
                    to: IndexPath(item: to + indexOffset, section: section)
                )
            }
        )
    }
    #endif

    public func remove(observer: AnyObject) {
        if let index = self.index(ofObserver: observer) {
            self.observers.remove(at: index)
            if self.observers.count == 0 {
                self.onHasObserversChanged?(false)
            }
        }
    }

    public func append(_ element: Element) {
        if let isOrderedBefore = self.isOrderedBefore {
            for (index, otherElement) in self.values.enumerated() {
                if isOrderedBefore(element, otherElement) {
                    self.values.insert(element, at: index)
                    self.executeWithAllHandlers({ handler in
                        handler.insert?(element, index)
                    })
                    return
                }
            }
        }

        self.values.append(element)
        let index = self.values.count - 1
        self.executeWithAllHandlers({ handler in
            handler.insert?(element, index)
        })
    }

    public func insert(_ element: Element, at index: Int) {
        if self.isOrderedBefore != nil {
            self.append(element)
        }

        self.values.insert(element, at: index)
        self.executeWithAllHandlers({ handler in
            handler.insert?(element, index)
        })
    }

    public func remove(at index: Int) {
        let element = self.values[index]
        self.values.remove(at: index)
        self.executeWithAllHandlers({ handler in
            handler.remove?(element, index)
        })
    }

    public func removeAll() {
        let oldValues = self.values
        self.values.removeAll()
        self.executeWithAllHandlers({ handler in
            handler.removeAll?(oldValues)
        })
    }

    public func resort() {
        guard let isOrderedBefore = self.isOrderedBefore else {
            return
        }

        var unsortedTemplate = [(id: Int, element: Element)]()
        for (index, element) in self.values.enumerated() {
            let value = (id: index, element: element)
            unsortedTemplate.append(value)
        }
        let sortedTemplate = unsortedTemplate.sorted(by: { isOrderedBefore($0.element, $1.element) })

        var toIndex = self.values.count - 1
        for (sortedId, _) in sortedTemplate.reversed() {
            var fromIndex = 0
            for (unsortedId, _) in unsortedTemplate {
                if sortedId == unsortedId {
                    if fromIndex != toIndex {
                        // move
                        let element = self.values.remove(at: fromIndex)
                        self.values.insert(element, at: toIndex)
                        let template = unsortedTemplate.remove(at: fromIndex)
                        unsortedTemplate.insert(template, at: toIndex)
                        self.executeWithAllHandlers({ handler in
                            handler.didMove?(element, fromIndex, toIndex)
                        })
                    }
                    break
                }
                fromIndex += 1
            }
            toIndex -= 1
        }
    }

    public func sync(with newValues: [Element], isEqual: (Element, Element) -> Bool) {
        var newIndex = newValues.count - 1
        var existingIndex = self.values.count - 1

        while newIndex >= 0 && existingIndex >= 0 {
            let new = newValues[newIndex]

            guard !isEqual(new, self.values[existingIndex]) else {
                newIndex -= 1
                existingIndex -= 1
                continue
            }

            var index: Int? = nil
            for i in 0 ... existingIndex {
                if isEqual(self.values[i], new) {
                    index = i
                    break
                }
            }
            if let index = index {
                self.values.remove(at: index)
                self.values.insert(new, at: existingIndex)
                self.executeWithAllHandlers({ handler in
                    handler.didMove?(new, index, existingIndex)
                })
                existingIndex -= 1
                newIndex -= 1
            }
            else {
                self.insert(new, at: existingIndex + 1)
                newIndex -= 1
            }
        }

        while existingIndex >= 0 {
            self.remove(at: existingIndex)
            existingIndex -= 1
        }

        while newIndex >= 0 {
            self.insert(newValues[newIndex], at: 0)
            newIndex -= 1
        }
    }
}

extension ObservableArray {
    public func remove(where passes: (Element) throws -> Bool) rethrows {
        guard let index = try self.values.index(where: passes) else {
            return
        }

        self.remove(at: index)
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

    func executeWithAllHandlers(_ callback: (_ handlers: ObservationHandlers) -> ()) {
        for (_, handlers) in self.observers {
            for handler in handlers {
                callback(handler)
            }
        }
    }
}
