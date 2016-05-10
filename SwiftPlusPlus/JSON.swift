//
//  JSON.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 3/23/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct JSON: CustomStringConvertible {
    public let object: AnyObject

    public init(data: NSData) throws {
        self.object = try NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions()
        )
    }

    public init(object: AnyObject) {
        self.object = object
    }

    public var string: String? {
        return self.object as? String
    }

    public var int: Int? {
        if let int = self.object as? Int {
            return int
        }
        else if let string = self.string {
            return Int(string)
        }
        return nil
    }

    public var bool: Bool? {
        if let bool = self.object as? Bool {
            return bool
        }
        else if let string = self.string {
            if string == "true" {
                return true
            }
            else if string == "false" {
                return false
            }
        }
        return nil
    }

    public var array: [JSON]? {
        if let array = self.object as? [AnyObject] {
            return array.map {JSON(object: $0)}
        }
        else if let dict = self.object as? [String:AnyObject] where dict.count == 1 {
            return Array(dict.values).map {JSON(object: $0)}
        }
        return nil
    }

    public var dictionary: [String:JSON]? {
        guard let dict = self.object as? [String:AnyObject] else {
            return nil
        }
        var output = [String:JSON]()
        for (key, element) in dict {
            output[key] = JSON(object: element)
        }
        return output
    }

    public subscript(string: String) -> JSON? {
        if let dict = self.object as? [String:AnyObject],
            let foundValue = dict[string]
        {
            return JSON(object: foundValue)
        }
        return nil
    }

    public subscript(int: Int) -> JSON? {
        if let array = self.object as? [AnyObject] where int < array.count {
            return JSON(object: array[int])
        }
        return nil
    }

    public var description: String {
        return "\(self.object)"
    }

    public func toData() throws -> NSData {
        return try NSJSONSerialization.dataWithJSONObject(
            self.object,
            options: NSJSONWritingOptions()
        )
    }

}
