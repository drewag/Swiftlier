//
//  NativeTypesDecoder.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class NativeTypesDecoder: DecoderType {
    let raw: AnyObject

    public class func decodableTypeFromObject<E: EncodableType>(raw: AnyObject) -> E? {
        let decoder = NativeTypesDecoder(raw: raw)
        return E(decoder: decoder)
    }

    private init(raw: AnyObject) {
        self.raw = raw
    }

    public func decode<K: CoderKeyType>(key: K.Type) -> K.ValueType {
        switch self.raw {
        case let dict as [String:AnyObject]:
            return dict[key.toString()] as! K.ValueType
        default:
            fatalError("Unexpected type")
        }
    }

    public func decode<K: OptionalCoderKeyType>(key: K.Type) -> K.ValueType? {
        switch self.raw {
        case let dict as [String:AnyObject]:
            return dict[key.toString()] as? K.ValueType
        default:
            fatalError("Unexpected type")
        }
    }


    public func decode<K: NestedCoderKeyType>(key: K.Type) -> K.ValueType {
        switch self.raw {
        case let dict as [String:AnyObject]:
            guard let dict = dict[key.toString()] as? [String: AnyObject] else {
                fatalError("Unexpected type")
            }
            return NativeTypesDecoder.decodableTypeFromObject(dict)!
        default:
            fatalError("Unexpected type")
        }
    }

    public func decode<K: OptionalNestedCoderKeyType>(key: K.Type) -> K.ValueType? {
        switch self.raw {
        case let dict as [String:AnyObject]:
            guard let dict = dict[key.toString()] as? [String: AnyObject] else {
                return nil
            }
            return NativeTypesDecoder.decodableTypeFromObject(dict)
        default:
            fatalError("Unexpected type")
        }
    }

    public func decodeArray<K: CoderKeyType>(key: K.Type) -> [K.ValueType] {
        switch self.raw {
        case let dict as [String:AnyObject]:
            guard let array = dict[key.toString()] as? [AnyObject] else {
                fatalError("Unexpected type")
            }
            var output: [K.ValueType] = []
            for raw in array {
                output.append(raw as! K.ValueType)
            }
            return output
        default:
            fatalError("Unexpected type")
        }
    }

    public func decodeArray<K: NestedCoderKeyType>(key: K.Type) -> [K.ValueType] {
        switch self.raw {
        case let dict as [String:AnyObject]:
            guard let array = dict[key.toString()] as? [AnyObject] else {
                fatalError("Unexpected type")
            }
            var output: [K.ValueType] = []
            for raw in array {
                let object: K.ValueType = NativeTypesDecoder.decodableTypeFromObject(raw)!
                output.append(object)
            }
            return output
        default:
            fatalError("Unexpected type")
        }
    }
}
