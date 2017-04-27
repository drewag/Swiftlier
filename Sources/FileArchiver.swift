//
//  FileArchiver.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension DirectoryPath {
    @discardableResult
    public func addFile(named: String, containingEncodable encodable: Encodable, canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let object = NativeTypesEncoder.objectFromEncodable(encodable, mode: .saveLocally)
        let data = try FileArchive.data(from: object, encrypt: encrypt)
        return try self.addFile(named: named, containing: data, canOverwrite: canOverwrite)
    }

    @discardableResult
    public func addFile<E: Encodable>(named: String, containingEncodable dict: [String:E], canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        var finalDict = [String:Any]()

        for (key, value) in dict {
            finalDict[key] = NativeTypesEncoder.objectFromEncodable(value, mode: .saveLocally)
        }

        let data = try FileArchive.data(from: finalDict, encrypt: encrypt)
        return try self.addFile(named: named, containing: data, canOverwrite: canOverwrite)
    }

    @discardableResult
    public func addFile<E: Encodable>(named: String, containingEncodable array: [E], canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        var finalArray = [Any]()

        for value in array {
            finalArray.append(NativeTypesEncoder.objectFromEncodable(value, mode: .saveLocally))
        }

        let data = try FileArchive.data(from: finalArray, encrypt: encrypt)
        return try self.addFile(named: named, containing: data, canOverwrite: canOverwrite)
    }
}

extension Path {
    @discardableResult
    public func createFile(containingEncodable encodable: Encodable, canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containingEncodable: encodable, canOverwrite: canOverwrite, encrypt: encrypt)
    }

    @discardableResult
    public func createFile<E: Encodable>(containingEncodable encodableDict: [String:E], canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containingEncodable: encodableDict, canOverwrite: canOverwrite, encrypt: encrypt)
    }

    @discardableResult
    public func createFile<E: Encodable>(containingEncodable encodableArray: [E], canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containingEncodable: encodableArray, canOverwrite: canOverwrite, encrypt: encrypt)
    }
}

extension FilePath {
    public func decodable<E: Decodable>(decrypt: (Data) throws -> Data = {return $0}) throws -> E {
        guard let object = try FileArchive.object(from: try self.contents(), decrypt: decrypt) else {
            throw self.error("unarching \(E.self)", because: "the file is invalid")
        }

        let value: E = try NativeTypesDecoder.decodableTypeFromObject(object, mode: .saveLocally)
        return value
    }

    public func decodableDict<E: Decodable>(decrypt: (Data) throws -> Data = {return $0}) throws -> [String:E] {
        guard let rawDict = try FileArchive.object(from: try self.contents(), decrypt: decrypt) as? [String:[String: Any]] else {
            throw self.error("unarching \(E.self)", because: "the file is invalid")
        }

        var finalDict = [String:E]()

        for (key, subDict) in rawDict {
            finalDict[key] = try NativeTypesDecoder.decodableTypeFromObject(subDict, mode: .saveLocally) as E
        }

        return finalDict
    }

    public func decodableArray<E: Decodable>(decrypt: (Data) throws -> Data = {return $0}) throws -> [E] {
        guard let rawArray = try FileArchive.object(from: try self.contents(), decrypt: decrypt) as? [Any] else {
            throw self.error("unarching \(E.self)", because: "the file is invalid")
        }

        var finalArray = [E]()

        for rawObject in rawArray {
            if let object: E = try? NativeTypesDecoder.decodableTypeFromObject(rawObject, mode: .saveLocally) {
                finalArray.append(object)
            }
        }

        return finalArray
    }
}

private struct FileArchive: ErrorGenerating {
    static func data(from object: Any, encrypt: (Data) throws -> Data) throws -> Data {
        return try encrypt(NSKeyedArchiver.archivedData(withRootObject: object))
        //return try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
    }

    static func object(from data: Data, decrypt: (Data) throws -> Data) throws -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(with: try decrypt(data))
        //return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
    }
}

