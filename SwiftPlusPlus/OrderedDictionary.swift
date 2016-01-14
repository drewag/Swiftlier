//
//  OrderedDictionary.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/20/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public struct OrderedDictionary<Key: Hashable, Value> {
    private var valueStore = [Value?]()
    private var lookup = [Key:Int]()

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
            }
            valueStore.append(newValue)
            lookup[key] = valueStore.count - 1
        }
    }

    public var values: [Value] {
        return self.valueStore.flatMap({$0})
    }
}

extension OrderedDictionary where Value: Equatable {
    public func indexOfValueWithKey(key: Key) -> Int? {
        let object = self[key]
        return self.values.indexOfObjectPassingTest {$0 == object}
    }
}
