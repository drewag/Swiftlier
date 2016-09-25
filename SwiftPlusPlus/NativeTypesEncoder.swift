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
        return encoder.raw ?? [:]
    }

    public func encode<Value: RawEncodableType>(data: Value, forKey key: CoderKey<Value>.Type) {
        self.addValue(data.asObject, keyPath: key.path)
    }

    public func encode<Value: RawEncodableType>(data: Value?, forKey key: OptionalCoderKey<Value>.Type) {
        self.addValue(data?.asObject, keyPath: key.path)
    }

    public func encode<Value: EncodableType>(data: Value, forKey key: NestedCoderKey<Value>.Type) {
        self.addValue(NativeTypesEncoder.objectFromEncodable(data), keyPath: key.path)
    }

    public func encode<Value: EncodableType>(data: Value?, forKey key: OptionalNestedCoderKey<Value>.Type) {
        if let data = data {
            self.addValue(NativeTypesEncoder.objectFromEncodable(data), keyPath: key.path)
        }
        else {
            self.addValue(nil, keyPath: key.path)
        }
    }

    public func encode<Value: RawEncodableType>(data: [Value], forKey key: CoderKey<Value>.Type) {
        var array = [AnyObject]()
        for value in data {
            array.append(value.asObject)
        }
        self.addValue(array, keyPath: key.path)
    }

    public func encode<Value: EncodableType>(data: [Value], forKey key: NestedCoderKey<Value>.Type) {
        var array = [AnyObject]()
        for value in data {
            let object = NativeTypesEncoder.objectFromEncodable(value)
            array.append(object)
        }
        self.addValue(array, keyPath: key.path)
    }
}

private extension NativeTypesEncoder {
    func addValue(value: AnyObject?, keyPath path: [String]) {
        let rawDict: [String:AnyObject]
        switch self.raw {
        case let dict as [String:AnyObject]:
            rawDict = dict
        case nil:
            rawDict = [String:AnyObject]()
        default:
            fatalError("Unexpected type")
        }

        self.raw = self.valueDict(forRemainingPath: path, withValue: value, andOriginalDict: rawDict)
    }

    func valueDict(forRemainingPath path: [String], withValue value: AnyObject?, andOriginalDict originalDict: [String:AnyObject]) -> [String:AnyObject] {
        var originalDict = originalDict
        var path = path
        let object: AnyObject?
        if path.count == 1 {
            object = value
        }
        else if let nextDict = originalDict[path.removeFirst()] as? [String:AnyObject] {
            object = self.valueDict(forRemainingPath: path, withValue: value, andOriginalDict: nextDict)
        }
        else {
            object = self.valueDict(forRemainingPath: path, withValue: value, andOriginalDict: [String:AnyObject]())
        }

        originalDict[path.first!] = object
        return originalDict
    }
}
