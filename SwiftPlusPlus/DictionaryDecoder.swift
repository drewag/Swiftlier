//
//  DictionaryDecoder.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class DictionaryDecoder: DecoderType {
    let dictionary: [String:AnyObject]

    public class func decodableObjectFromDictionary<E: EncodableType>(dictionary: [String:AnyObject]) -> E? {
        let decoder = DictionaryDecoder(dictionary: dictionary)
        return E(decoder: decoder)
    }

    private init(dictionary: [String:AnyObject]) {
        self.dictionary = dictionary
    }

    public func decode<K: CoderKeyType>(key: K.Type) -> K.ValueType {
        return self.dictionary[key.toString()] as! K.ValueType
    }

    public func decode<K: OptionalCoderKeyType>(key: K.Type) -> K.ValueType? {
        return self.dictionary[key.toString()] as? K.ValueType
    }


    public func decode<K: NestedCoderKeyType>(key: K.Type) -> K.ValueType? {
        guard let dict = self.dictionary[key.toString()] as? [String: AnyObject] else {
            return nil
        }
        return DictionaryDecoder.decodableObjectFromDictionary(dict)
    }
}