//
//  Path+Coding.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension DirectoryPath {
    @discardableResult
    public func addFile<E: Swift.Encodable>(named: String, containingEncodable encodable: E, userInfo: [CodingUserInfoKey:Any] = [:], canOverwrite: Bool, options: NSData.WritingOptions = .atomic, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let object = try NativeTypesEncoder.object(from: encodable, userInfo: userInfo)
        let data = try FileArchive.data(from: object, encrypt: encrypt)
        return try self.addFile(named: named, containing: data, canOverwrite: canOverwrite)
    }

    @discardableResult
    public func addFile<E: Swift.Encodable>(named: String, containingEncodableDict dict: [String:E], userInfo: [CodingUserInfoKey:Any] = [:], canOverwrite: Bool, options: NSData.WritingOptions = .atomic, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        var finalDict = [String:Any]()

        for (key, value) in dict {
            finalDict[key] = try NativeTypesEncoder.object(from: value, userInfo: userInfo)
        }

        let data = try FileArchive.data(from: finalDict, encrypt: encrypt)
        return try self.addFile(named: named, containing: data, canOverwrite: canOverwrite, options: options)
    }

    @discardableResult
    public func addFile<E: Swift.Encodable>(named: String, containingEncodableArray array: [E], userInfo: [CodingUserInfoKey:Any] = [:], canOverwrite: Bool, options: NSData.WritingOptions = .atomic, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        var finalArray = [Any]()

        for value in array {
            finalArray.append(try NativeTypesEncoder.object(from: value, userInfo: userInfo))
        }

        let data = try FileArchive.data(from: finalArray, encrypt: encrypt)
        return try self.addFile(named: named, containing: data, canOverwrite: canOverwrite, options: options)
    }
}

extension Path {
    @discardableResult
    public func createFile<E: Swift.Encodable>(containingEncodable encodable: E, userInfo: [CodingUserInfoKey:Any] = [:], canOverwrite: Bool, options: NSData.WritingOptions = .atomic, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containingEncodable: encodable, userInfo: userInfo, canOverwrite: canOverwrite, options: options, encrypt: encrypt)
    }

    @discardableResult
    public func createFile<E: Swift.Encodable>(containingEncodableDict encodableDict: [String:E], userInfo: [CodingUserInfoKey:Any] = [:], options: NSData.WritingOptions = .atomic, canOverwrite: Bool, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containingEncodableDict: encodableDict, userInfo: userInfo, canOverwrite: canOverwrite, options: options, encrypt: encrypt)
    }

    @discardableResult
    public func createFile<E: Swift.Encodable>(containingEncodableArray encodableArray: [E], userInfo: [CodingUserInfoKey:Any] = [:], canOverwrite: Bool, options: NSData.WritingOptions = .atomic, encrypt: (Data) throws -> Data = {return $0}) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containingEncodableArray: encodableArray, userInfo: userInfo, canOverwrite: canOverwrite, options: options, encrypt: encrypt)
    }
}

extension FilePath {
    public func decodable<E: Swift.Decodable>(userInfo: [CodingUserInfoKey:Any] = [:], decrypt: (Data) throws -> Data = {return $0}) throws -> E {
        guard let object = try FileArchive.object(from: try self.contents(), decrypt: decrypt) else {
            throw ReportableError("unarching \(E.self)", because: "the file is invalid")
        }

        let value: E = try NativeTypesDecoder.decodable(from: object, userInfo: userInfo)
        return value
    }

    public func decodableDict<E: Swift.Decodable>(userInfo: [CodingUserInfoKey:Any] = [:], decrypt: (Data) throws -> Data = {return $0}) throws -> [String:E] {
        guard let rawDict = try FileArchive.object(from: try self.contents(), decrypt: decrypt) as? [String:[String: Any]] else {
            throw ReportableError("unarching \(E.self)", because: "the file is invalid")
        }

        var finalDict = [String:E]()

        for (key, subDict) in rawDict {
            finalDict[key] = try NativeTypesDecoder.decodable(from: subDict, userInfo: userInfo) as E
        }

        return finalDict
    }

    public func decodableArray<E: Swift.Decodable>(userInfo: [CodingUserInfoKey:Any] = [:], decrypt: (Data) throws -> Data = {return $0}) throws -> [E] {
        guard let rawArray = try FileArchive.object(from: try self.contents(), decrypt: decrypt) as? [Any] else {
            throw ReportableError("unarching \(E.self)", because: "the file is invalid")
        }

        var finalArray = [E]()

        for rawObject in rawArray {
            if let object: E = try? NativeTypesDecoder.decodable(from: rawObject, userInfo: userInfo) {
                finalArray.append(object)
            }
        }

        return finalArray
    }
}

private struct FileArchive {
    static func data(from object: Any, encrypt: (Data) throws -> Data) throws -> Data {
        #if os(Linux)
            return try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        #else
            do {
                return try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            }
            catch {
                if #available(OSX 10.11, *) {
                    return try encrypt(NSKeyedArchiver.archivedData(withRootObject: object))
                } else {
                    throw ReportableError("encoding data", because: "Mac OS 10.11 or newer is required")
                }
            }
        #endif
    }

    static func object(from data: Data, decrypt: (Data) throws -> Data) throws -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
        }
        catch {
            #if os(Linux)
                throw error
            #else
                return NSKeyedUnarchiver.unarchiveObject(with: try decrypt(data))
            #endif
        }
    }
}

