//
//  FileArchiver.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct FileArchive {
    public static func archiveEncodable(encodable: EncodableType, toFile file: String) -> Bool {
        let object = NativeTypesEncoder.objectFromEncodable(encodable)
        return NSKeyedArchiver.archiveRootObject(object, toFile: file)
    }

    public static func archiveDictionaryOfEncodable<E: EncodableType>(dictionary: [String:E], toFile file: String) -> Bool {
        var finalDict = [String:AnyObject]()

        for (key, value) in dictionary {
            finalDict[key] = NativeTypesEncoder.objectFromEncodable(value)
        }

        return NSKeyedArchiver.archiveRootObject(finalDict, toFile: file)
    }

    public static func archiveArrayOfEncodable<E: EncodableType>(array: [E], toFile file: String) -> Bool {
        var finalArray = [AnyObject]()

        for value in array {
            finalArray.append(NativeTypesEncoder.objectFromEncodable(value))
        }

        return NSKeyedArchiver.archiveRootObject(finalArray, toFile: file)
    }

    public static func unarchiveEncodableFromFile<E: EncodableType>(file: String) -> E? {
        guard let object = NSKeyedUnarchiver.unarchiveObjectWithFile(file) else {
            return nil
        }

        return NativeTypesDecoder.decodableTypeFromObject(object)
    }

    public static func unarchiveDictionaryOfEncodableFromFile<E: EncodableType>(file: String) -> [String:E]? {
        guard let rawDict = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [String:[String: AnyObject]] else {
            return nil
        }

        var finalDict = [String:E]()

        for (key, subDict) in rawDict {
            finalDict[key] = NativeTypesDecoder.decodableTypeFromObject(subDict)
        }

        return finalDict
    }

    public static func unarchiveArrayOfEncodableFromFile<E: EncodableType>(file: String) -> [E]? {
        guard let rawArray = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [AnyObject] else {
            return nil
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