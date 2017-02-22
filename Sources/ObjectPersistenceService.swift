//
//  ObjectPersistenceService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/21/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

public protocol InstanceEquatable {
    func isSameInstanceAs(_ other: Self) -> Bool
}

open class ObjectPersistenceService<Value: CodableType> where Value: InstanceEquatable, Value: Equatable {
    public var values: [Value]!

    public init() throws {
        self.values = try self.loadValues()
    }


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

private extension ObjectPersistenceService {
    var valueName: String {
        return "\(Value.self)"
    }

    var filePath: String {
        return FileManager.default.documentsDirectoryPath / "\(self.valueName.lowercased())s.plist"
    }

    func loadValues() throws -> [Value] {
        return try FileArchive.unarchiveArrayOfEncodableFromFile(self.filePath) ?? []
    }

    func save(values: [Value]) throws {
        try FileArchive.archiveArrayOfEncodable(values, toFile: self.filePath, options: .completeFileProtection)
    }
}
