//
//  NativeTypesEncoder.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class NativeTypesEncoder: EncoderType {
    fileprivate var raw: Any?

    public class func objectFromEncodable(_ encodable: EncodableType) -> Any {
        let encoder = NativeTypesEncoder()
        encodable.encode(encoder)
        return encoder.raw ?? [:]
    }

    public func encode<Value: RawEncodableType>(_ data: Value, forKey key: CoderKey<Value>.Type) {
        self.addValue(data.asObject, keyPath: key.path)
    }

    public func encode<Value: RawEncodableType>(_ data: Value?, forKey key: OptionalCoderKey<Value>.Type) {
        self.addValue(data?.asObject, keyPath: key.path)
    }

    public func encode<Value: EncodableType>(_ data: Value, forKey key: NestedCoderKey<Value>.Type) {
        self.addValue(NativeTypesEncoder.objectFromEncodable(data), keyPath: key.path)
    }

    public func encode<Value: EncodableType>(_ data: Value?, forKey key: OptionalNestedCoderKey<Value>.Type) {
        if let data = data {
            self.addValue(NativeTypesEncoder.objectFromEncodable(data), keyPath: key.path)
        }
        else {
            self.addValue(nil, keyPath: key.path)
        }
    }

    public func encode<Value: RawEncodableType>(_ data: [Value], forKey key: CoderKey<Value>.Type) {
        var array = [Any]()
        for value in data {
            array.append(value.asObject)
        }
        self.addValue(array as Any?, keyPath: key.path)
    }

    public func encode<Value: EncodableType>(_ data: [Value], forKey key: NestedCoderKey<Value>.Type) {
        var array = [Any]()
        for value in data {
            let object = NativeTypesEncoder.objectFromEncodable(value)
            array.append(object)
        }
        self.addValue(array as Any?, keyPath: key.path)
    }
}

private extension NativeTypesEncoder {
    func addValue(_ value: Any?, keyPath path: [String]) {
        let rawDict: [String:Any]
        switch self.raw {
        case let dict as [String:Any]:
            rawDict = dict
        case nil:
            rawDict = [String:Any]()
        default:
            fatalError("Unexpected type")
        }

        self.raw = self.valueDict(forRemainingPath: path, withValue: value, andOriginalDict: rawDict) as Any?
    }

    func valueDict(forRemainingPath path: [String], withValue value: Any?, andOriginalDict originalDict: [String:Any]) -> [String:Any] {
        var originalDict = originalDict
        var path = path
        let object: Any?
        guard path.count > 1 else {
            object = value
            originalDict[path.first!] = object
            return originalDict
        }

        let key = path.removeFirst()
        if let nextDict = originalDict[key] as? [String:Any] {
            object = self.valueDict(forRemainingPath: path, withValue: value, andOriginalDict: nextDict) as Any?
        }
        else {
            object = self.valueDict(forRemainingPath: path, withValue: value, andOriginalDict: [String:Any]()) as Any?
        }

        originalDict[key] = object
        return originalDict
    }
}
