//
//  ReferencePersistenceService.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/21/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

open class ReferencePersistenceService<Value: Codable>: PersistenceService<Value> where Value: AnyObject {
    public func saveAllValues() throws {
        try self.save(values: self.values)
    }

    public func add(value: Value) throws {
        for existingValue in self.values {
            guard existingValue !== value else {
                return
            }
        }
        self.values.append(value)
        try self.saveAllValues()
    }

    public func delete(value: Value) throws {
        for (index, existingValue) in self.values.enumerated() {
            if value === existingValue {
                var values = self.values
                values!.remove(at: index)
                try self.save(values: values!)
                self.values = values
                return
            }
        }

        throw GenericSwiftlierError("deleting \(self.valueName.lowercased())", because: "\(self.valueName) could not be not found")
    }
}
