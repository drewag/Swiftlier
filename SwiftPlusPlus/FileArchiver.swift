//
//  FileArchiver.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct FileArchive {
    public static func archiveEncodable(encodable: EncodableType, toFile file: String, encrypt: (NSData) throws -> NSData = {return $0}) throws {
        let object = NativeTypesEncoder.objectFromEncodable(encodable)
        let data = try encrypt(NSKeyedArchiver.archivedDataWithRootObject(object))
        try data.writeToFile(file, options: NSDataWritingOptions.AtomicWrite)
    }

    public static func archiveDictionaryOfEncodable<E: EncodableType>(dictionary: [String:E], toFile file: String, encrypt: (NSData) throws -> NSData = {return $0}) throws {
        var finalDict = [String:AnyObject]()

        for (key, value) in dictionary {
            finalDict[key] = NativeTypesEncoder.objectFromEncodable(value)
        }

        let data = try encrypt(NSKeyedArchiver.archivedDataWithRootObject(finalDict))
        try data.writeToFile(file, options: NSDataWritingOptions.AtomicWrite)
    }

    public static func archiveArrayOfEncodable<E: EncodableType>(array: [E], toFile file: String, encrypt: (NSData) throws -> NSData = {return $0}) throws {
        var finalArray = [AnyObject]()

        for value in array {
            finalArray.append(NativeTypesEncoder.objectFromEncodable(value))
        }

        let data = try encrypt(NSKeyedArchiver.archivedDataWithRootObject(finalArray))
        try data.writeToFile(file, options: NSDataWritingOptions.AtomicWrite)
    }

    public static func unarchiveEncodableFromFile<E: EncodableType>(file: String, decrypt: (NSData) throws -> NSData = {return $0}) throws -> E? {
        guard var data = NSData(contentsOfFile: file) else {
            return nil
        }
        data = try decrypt(data)

        guard let object = NSKeyedUnarchiver.unarchiveObjectWithData(data) else {
            throw LocalUserReportableError(
                source: "FileArchive",
                operation: "loading data",
                message: "Invalid file found",
                type: .Internal
            )
        }

        return NativeTypesDecoder.decodableTypeFromObject(object)
    }

    public static func unarchiveDictionaryOfEncodableFromFile<E: EncodableType>(file: String, decrypt: (NSData) throws -> NSData = {return $0}) throws -> [String:E]? {
        guard var data = NSData(contentsOfFile: file) else {
            return nil
        }
        data = try decrypt(data)

        guard let rawDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String:[String: AnyObject]] else {
            throw LocalUserReportableError(
                source: "FileArchive",
                operation: "loading data",
                message: "Invalid file found",
                type: .Internal
            )
        }

        var finalDict = [String:E]()

        for (key, subDict) in rawDict {
            finalDict[key] = NativeTypesDecoder.decodableTypeFromObject(subDict)
        }

        return finalDict
    }

    public static func unarchiveArrayOfEncodableFromFile<E: EncodableType>(file: String, decrypt: (NSData) throws -> NSData = {return $0}) throws -> [E]? {
        guard var data = NSData(contentsOfFile: file) else {
            return nil
        }
        data = try decrypt(data)

        guard let rawArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject] else {
            throw LocalUserReportableError(
                source: "FileArchive",
                operation: "loading data",
                message: "Invalid file found",
                type: .Internal
            )
        }

        var finalArray = [E]()

        for rawObject in rawArray {
            if let object: E = NativeTypesDecoder.decodableTypeFromObject(rawObject) {
                finalArray.append(object)
            }
        }

        return finalArray
    }
}