//
//  NativeTypesDecoder.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct DecodingError: UserReportableError {
    public let alertTitle: String = "Error Decoding"
    public let alertMessage: String
    public let otherInfo: [String : String]? = nil

    public init(description: String) {
        self.alertMessage = description
    }
}

public final class NativeTypesDecoder: DecoderType {
    let raw: Any
    public let mode: DecodingMode

    public class func decodableTypeFromObject<E: DecodableType>(_ raw: Any, mode: DecodingMode) throws -> E {
        guard !(raw is NSNull) else {
            throw DecodingError(description: "Was null")
        }

        let decoder = NativeTypesDecoder(raw: raw, mode: mode)
        return try E(decoder: decoder)
    }

    fileprivate init(raw: Any, mode: DecodingMode) {
        self.raw = raw
        self.mode = mode
    }

    public func decode<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> Value {
        guard let object = self.object(forKeyPath: key.path) else {
            throw DecodingError(description: "Required value not found for key \(key.path)")
        }
        if Value.self is RawEncodableType.Type {
            guard let value = object as? Value else {
                throw DecodingError(description: "Value of wrong type found for key \(key.path)")
            }
            return value
        }
        return try NativeTypesDecoder.decodableTypeFromObject(object, mode: self.mode)
    }

    public func decode<Value: DecodableType>(_ key: OptionalCoderKey<Value>.Type) throws -> Value? {
        guard let object = self.object(forKeyPath: key.path) else {
            return nil
        }
        if Value.self is RawEncodableType.Type {
            return object as? Value
        }
        return try? NativeTypesDecoder.decodableTypeFromObject(object, mode: self.mode)
    }

    public func decodeArray<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> [Value] {
        let object = self.object(forKeyPath: key.path)
        guard let array = object as? [Any] else {
            if object is NSNull || object == nil {
                return []
            }
            else {
                fatalError("Unexpected type")
            }
        }
        var output: [Value] = []
        for raw in array {
            if raw is RawEncodableType {
                guard let _ = raw as? Value else {
                    throw DecodingError(description: "Value of wrong type found in array for key \(key.path)")
                }
                output.append(raw as! Value)
            }
            else {
                let object: Value = try NativeTypesDecoder.decodableTypeFromObject(raw, mode: self.mode)
                output.append(object)
            }
        }
        return output
    }

    public func decodeAsEntireValue<Value: DecodableType>() throws -> Value {
        if Value.self is RawEncodableType.Type {
            guard let value = self.raw as? Value else {
                throw DecodingError(description: "Value of wrong type found as entire value")
            }
            return value
        }
        else {
            return try NativeTypesDecoder.decodableTypeFromObject(self.raw, mode: self.mode)
        }
    }
}

private extension NativeTypesDecoder {
    func object(forKeyPath path: [String]) -> Any? {
        switch self.raw {
        case var dict as [String:Any]:
            for (i, key) in path.enumerated() {
                guard i < path.count - 1 else {
                    return dict[key]
                }
                guard let newDict = dict[key] as? [String:Any] else {
                    return nil
                }
                dict = newDict
            }
            return nil
        default:
            fatalError("Unexpected type")
        }
    }
}
