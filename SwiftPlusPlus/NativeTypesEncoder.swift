//
//  NativeTypesEncoder.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class NativeTypesEncoder: EncoderType {
    private var raw: AnyObject?

    public class func objectFromEncodable(encodable: EncodableType) -> AnyObject {
        let encoder = NativeTypesEncoder()
        encodable.encode(encoder)
        return encoder.raw!
    }

    public func encode<K: CoderKeyType>(data: K.ValueType, forKey key: K.Type) {
        switch self.raw {
        case var dict as [String:AnyObject]:
            dict[key.toString()] = data.asObject
            self.raw = dict
        case nil:
            self.raw = [key.toString():data.asObject]
        default:
            fatalError("Unexpected type")
        }
    }

    public func encode<K: OptionalCoderKeyType>(data: K.ValueType?, forKey key: K.Type) {
        self.addValue(data?.asObject, key: key.toString())
    }

    public func encode<K: NestedCoderKeyType>(data: K.ValueType, forKey key: K.Type) {
        self.addValue(NativeTypesEncoder.objectFromEncodable(data), key: key.toString())
    }

    public func encode<K: OptionalNestedCoderKeyType>(data: K.ValueType?, forKey key: K.Type) {
        if let data = data {
            self.addValue(NativeTypesEncoder.objectFromEncodable(data), key: key.toString())
        }
        else {
            self.addValue(nil, key: key.toString())
        }
    }

    public func encode<K: CoderKeyType>(data: [K.ValueType], forKey key: K.Type) {
        var array = [AnyObject]()
        for value in data {
            array.append(value.asObject)
        }
        self.addValue(array, key: key.toString())
    }

    public func encode<K: NestedCoderKeyType>(data: [K.ValueType], forKey key: K.Type) {
        var array = [AnyObject]()
        for value in data {
            let object = NativeTypesEncoder.objectFromEncodable(value)
            array.append(object)
        }
        self.addValue(array, key: key.toString())
    }
}

private extension NativeTypesEncoder {
    func addValue(value: AnyObject?, key: String) {
        switch self.raw {
        case var dict as [String:AnyObject]:
            dict[key] = value
            self.raw = dict
        case nil:
            if let value = value {
                self.raw = [key:value]
            }
        default:
            fatalError("Unexpected type")
        }
    }
}