//
//  PersistenceService.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 3/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import Foundation

open class PersistenceService<Value: Codable> {
    public var values: [Value]!

    public init() throws {
        try self.reload()
    }

    public func reload() throws {
        self.values = try self.loadValues()
    }
}

extension PersistenceService {
    var valueName: String {
        return "\(Value.self)"
    }

    var filePath: String {
        return FileManager.default.documentsDirectoryURL.appendingPathComponent("\(self.valueName.lowercased())s.plist").relativePath
    }

    func loadValues() throws -> [Value] {
        return try FileArchive.unarchiveArrayOfEncodableFromFile(self.filePath) ?? []
    }

    func save(values: [Value]) throws {
        try FileArchive.archiveArrayOfEncodable(values, toFile: self.filePath, options: .completeFileProtection)
    }
}
#endif
