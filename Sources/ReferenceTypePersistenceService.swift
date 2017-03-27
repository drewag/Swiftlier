//
//  ReferenceTypePersistenceService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/21/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import Foundation

open class ReferenceTypePersistenceService<Value: CodableType>: PersistenceService<Value> where Value: AnyObject {
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

        throw LocalUserReportableError(
            source: "ObjectPersistenceService",
            operation: "deleting \(self.valueName.lowercased())",
            message: "\(self.valueName) not found",
            reason: .internal
        )
    }
}
#endif
