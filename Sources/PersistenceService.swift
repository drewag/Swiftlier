//
//  PersistenceService.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 3/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import Foundation

open class PersistenceService<Value: CodableType> {
    public var values: [Value]!

    public init() throws {
        self.values = try self.loadValues()
    }
}

extension PersistenceService {
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
#endif
