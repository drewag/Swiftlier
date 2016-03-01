//
//  DictionaryEncoder.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class DictionaryEncoder: EncoderType {
    private var dict = [String:AnyObject]()

    public class func dictionaryFromEncodable(encodable: EncodableType) -> [String:AnyObject] {
        let encoder = DictionaryEncoder()
        encodable.encode(encoder)
        return encoder.dict
    }

    public func encode<K: CoderKeyType>(data: K.ValueType, forKey key: K.Type) {
        dict[key.toString()] = data.asObject
    }

    public func encode<K: OptionalCoderKeyType>(data: K.ValueType?, forKey key: K.Type) {
        dict[key.toString()] = data?.asObject
    }

    public func encode<K: NestedCoderKeyType>(data: K.ValueType, forKey key: K.Type) {
        dict[key.toString()] = DictionaryEncoder.dictionaryFromEncodable(data)
    }
}