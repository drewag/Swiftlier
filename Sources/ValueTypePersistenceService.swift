//
//  ValueTypePersistenceService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/21/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import Foundation

public protocol InstanceEquatable {
    func isSameInstanceAs(_ other: Self) -> Bool
}

open class ValueTypePersistenceService<Value: CodableType>: PersistenceService<Value> where Value: InstanceEquatable, Value: Equatable {
    public func save(value: Value) throws {
        for existingValue in self.values {
            if value.isSameInstanceAs(existingValue) {
                throw LocalUserReportableError(
                    source: "ObjectPersistenceService",
                    operation: "creating \(self.valueName.lowercased())",
                    message: "That \(self.valueName.lowercased()) exists. Please make it unique and try again.",
                    reason: .user
                )
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

        throw LocalUserReportableError(
            source: "ObjectPersistenceService",
            operation: "deleting \(self.valueName.lowercased())",
            message: "\(self.valueName) not found",
            reason: .internal
        )
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

        throw LocalUserReportableError(
            source: "ObjectPersistenceService",
            operation: "updating \(self.valueName.lowercased())",
            message: "\(self.valueName) not found",
            reason: .internal
        )
    }

    public func replace(values: [Value]) throws {
        try self.save(values: values)
        self.values = values
    }
}
#endif
