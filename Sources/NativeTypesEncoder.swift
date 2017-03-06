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
    fileprivate var wasCanceled = false
    public let mode: EncodingMode

    public class func objectFromEncodable(_ encodable: EncodableType, mode: EncodingMode) -> Any {
        return self.objectFromCombiningEncodables([encodable], mode: mode)
    }

    public class func objectFromCombiningEncodables(_ encodables: [EncodableType], mode: EncodingMode) -> Any {
        let encoder = NativeTypesEncoder(raw: nil, mode: mode)
        for encodable in encodables {
            encodable.encode(encoder)
        }
        return encoder.raw ?? [:]
    }

    public func encodeAsEntireValue<Value: RawEncodableType>(_ data: Value) {
        self.raw = data
    }

    fileprivate init(raw: Any?, mode: EncodingMode) {
        self.raw = raw
        self.mode = mode
    }

    public func encode<Value: EncodableType>(_ data: Value, forKey key: CoderKey<Value>.Type) {
        if let raw = data as? RawEncodableType {
            self.addValue(raw.asObject, keyPath: key.path)
        }
        else if let object = NativeTypesEncoder.cancelableObjectFromEncodable(data, mode: self.mode) {
            self.addValue(object, keyPath: key.path)
        }
    }

    public func encode<Value: EncodableType>(_ data: Value?, forKey key: OptionalCoderKey<Value>.Type) {
        if let data = data {
            if let raw = data as? RawEncodableType {
                self.addValue(raw.asObject, keyPath: key.path)
            }
            else if let object = NativeTypesEncoder.cancelableObjectFromEncodable(data, mode: self.mode) {
                self.addValue(object, keyPath: key.path)
            }
            else {
                print("Invalid optional value data")
            }
        }
        else {
            self.addValue(nil, keyPath: key.path)
        }
    }

    public func encode<Value: EncodableType>(_ data: [Value], forKey key: CoderKey<Value>.Type) {
        var array = [Any]()
        for value in data {
            if let raw = value as? RawEncodableType {
                array.append(raw.asObject)
            }
            else if let object = NativeTypesEncoder.cancelableObjectFromEncodable(value, mode: self.mode) {
                array.append(object)
            }
            else {
                print("Invalid data array value: \(value)")
            }
        }
        self.addValue(array as Any?, keyPath: key.path)
    }

    public func encodeAsEntireValue<Value: EncodableType>(_ data: Value?) {
        guard let data = data else {
            self.raw = nil
            return
        }
        if let raw = data as? RawEncodableType {
            self.raw = raw.asObject
        }
        else {
            self.raw = NativeTypesEncoder.objectFromEncodable(data, mode: self.mode)
        }
    }

    public func cancelEncoding() {
        self.raw = nil
        self.wasCanceled = true
    }
}

private extension NativeTypesEncoder {
    class func cancelableObjectFromEncodable(_ encodable: EncodableType, mode: EncodingMode) -> Any? {
        let encoder = NativeTypesEncoder(raw: nil, mode: mode)
        encodable.encode(encoder)
        if encoder.wasCanceled {
            return nil
        }
        return encoder.raw ?? [:]
    }

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
            object = value ?? NSNull()
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
