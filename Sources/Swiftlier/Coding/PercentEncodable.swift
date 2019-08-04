//
//  PercentEncodable.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

/// A type that can be percent encoded
public protocol PercentEncodable {
    func addingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String?
}
extension String: PercentEncodable {}

extension Dictionary where Key: PercentEncodable, Value: PercentEncodable {
    /// Percent encode all the keys and values of a dictionary of strings
    public var percentEncoded: [String:String]? {
        var returnDict = [String:String]()
        for (key, value) in self {
            if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
            {
                returnDict[encodedKey] = encodedValue
            }
            else {
                return nil
            }
        }
        return returnDict
    }

    /// String URL query from this dictionary
    public var URLEncodedString: String? {
        return self.percentEncoded?.map({"\($0)=\($1)"}).joined(separator: "&")
    }

    /// Data URL query from this dictionary
    public var URLEncodedData: Data? {
        return self.URLEncodedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
}
