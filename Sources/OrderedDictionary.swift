//
//  OrderedDictionary.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/20/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public struct OrderedDictionary<Key: Hashable, Value> {
    fileprivate var valueStore = [Value?]()
    fileprivate var lookup = [Key:Int]()

    public init() {}
    public init(values: [(Key,Value)]) {
        for (key, value) in values {
            self[key] = value
        }
    }

    public var count: Int = 0

    public subscript(key: Key) -> Value? {
        get {
            if let index = lookup[key] {
                return self.valueStore[index]
            }
            return nil
        }
        set {
            if let existingIndex = lookup[key] {
                valueStore[existingIndex] = nil
                count -= 1
            }
            if let index = newValue {
                valueStore.append(index)
                lookup[key] = valueStore.count - 1
                count += 1
            }
        }
    }

    public var values: [Value] {
        return self.valueStore.flatMap({$0})
    }

    public var keys: [Key] {
        var all = [(Key,Int)]()
        for (key, index) in self.lookup {
            all.append((key, index))
        }
        return all.sorted(by: {$0.1 < $1.1}).map({$0.0})
    }

    public mutating func removeAll() {
        self.valueStore.removeAll()
        self.lookup.removeAll()
        self.count = 0
    }
}

extension OrderedDictionary where Value: Equatable {
    public func indexOfValueWithKey(_ key: Key) -> Int? {
        let object = self[key]
        return self.values.indexOfValue(passing: {$0 == object})
    }
}
