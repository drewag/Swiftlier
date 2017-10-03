//
//  ValueTypePersistenceService.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/21/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public protocol InstanceEquatable {
    func isSameInstanceAs(_ other: Self) -> Bool
}

import Foundation

open class ValueTypePersistenceService<Value: Codable>: PersistenceService<Value>, ErrorGenerating where Value: InstanceEquatable, Value: Equatable {
    public func save(value: Value) throws {
        for existingValue in self.values {
            if value.isSameInstanceAs(existingValue) {
                throw self.error("creating \(self.valueName.lowercased())", because: "it already exists")
            }
        }

        var values = self.values
        values!.append(value)
        try self.save(values: values!)
        self.values = values
    }

    public func delete(value: Value) throws {
        for (index, existingValue) in self.values.enumerated() {
            if value.isSameInstanceAs(existingValue) {
                var values = self.values
                values!.remove(at: index)
                try self.save(values: values!)
                self.values = values
                return
            }
        }

        throw self.error("deleting \(self.valueName.lowercased())", because: "it could not be found")
    }

    public func update(value: Value, withUpdatedValue updatedValue: Value) throws {
        guard value != updatedValue else {
            return
        }

        for (index, existingValue) in self.values.enumerated() {
            if value.isSameInstanceAs(existingValue) {
                var values = self.values
                values!.remove(at: index)
                values!.insert(updatedValue, at: index)
                try self.save(values: values!)
                self.values = values
                return
            }
        }

        throw self.error("updating \(self.valueName.lowercased())", because: "it could not be found")
    }

    public func replace(values: [Value]) throws {
        try self.save(values: values)
        self.values = values
    }
}

