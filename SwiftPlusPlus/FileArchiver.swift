//
//  FileArchiver.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

struct FileArchive {
    static func archiveEncodable(encodable: EncodableType, toFile file: String) -> Bool {
        let dictionary = DictionaryEncoder.dictionaryFromEncodable(encodable)
        return NSKeyedArchiver.archiveRootObject(dictionary, toFile: file)
    }

    static func archiveDictionaryOfEncodable<E: EncodableType>(dictionary: [String:E], toFile file: String) -> Bool {
        var finalDict = [String:AnyObject]()

        for (key, value) in dictionary {
            finalDict[key] = DictionaryEncoder.dictionaryFromEncodable(value)
        }

        return NSKeyedArchiver.archiveRootObject(finalDict, toFile: file)
    }

    static func archiveArrayOfEncodable<E: EncodableType>(array: [E], toFile file: String) -> Bool {
        var finalArray = [[String:AnyObject]]()

        for value in array {
            finalArray.append(DictionaryEncoder.dictionaryFromEncodable(value))
        }

        return NSKeyedArchiver.archiveRootObject(finalArray, toFile: file)
    }

    static func unarchiveEncodableFromFile<E: EncodableType>(file: String) -> E? {
        guard let dict = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [String:AnyObject] else {
            return nil
        }

        return DictionaryDecoder.decodableObjectFromDictionary(dict)
    }

    static func unarchiveDictionaryOfEncodableFromFile<E: EncodableType>(file: String) -> [String:E]? {
        guard let rawDict = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [String:[String: AnyObject]] else {
            return nil
        }

        var finalDict = [String:E]()

        for (key, subDict) in rawDict {
            finalDict[key] = DictionaryDecoder.decodableObjectFromDictionary(subDict)
        }

        return finalDict
    }

    static func unarchiveArrayOfEncodableFromFile<E: EncodableType>(file: String) -> [E]? {
        guard let rawArray = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? [[String:AnyObject]] else {
            return nil
        }

        var finalArray = [E]()

        for dict in rawArray {
            if let object: E = DictionaryDecoder.decodableObjectFromDictionary(dict) {
                finalArray.append(object)
            }
        }

        return finalArray
    }
}