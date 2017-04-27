//
//  PercentEncodable.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

public protocol PercentEncodable {
    func addingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String?
}
extension String: PercentEncodable {}

extension Dictionary where Key: PercentEncodable, Value: PercentEncodable {
    public var URLEncodedDictionary: [String:String]? {
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

    public var URLEncodedString: String? {
        return self.URLEncodedDictionary?.map({"\($0)=\($1)"}).joined(separator: "&")
    }

    public var URLEncodedData: Data? {
        return self.URLEncodedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
}
