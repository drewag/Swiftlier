//
//  SpecDecoder.swift
//  drewag.me
//
//  Created by Andrew J Wagner on 3/20/17.
//
//

import Foundation

public class SpecDecoder: Decoder {
    fileprivate var specDict = [String:String]()
    public let codingPath: [CodingKey] = []
    public let userInfo: [CodingUserInfoKey:Any]

    public class func spec<D: Decodable>(forType: D.Type, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> String {
        let decoder = SpecDecoder(userInfo: userInfo)

        let _ = try D(from: decoder)
        let data = try JSONSerialization.data(withJSONObject: decoder.specDict, options: .prettyPrinted)
        return String(data: data, encoding: .utf8)!
    }

    fileprivate init(userInfo: [CodingUserInfoKey:Any] = [:]) {
        self.userInfo = userInfo
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(SpecDecodingContainer(decoder: self))
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding an unkeyed container is not supported"))
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding a single value container is not supported"))
    }
}

private class SpecDecodingContainer<MyKey: CodingKey>: KeyedDecodingContainerProtocol {
    typealias Key = MyKey

    let codingPath: [CodingKey] = []
    let decoder: SpecDecoder

    var optionalKeys: [String:Bool] = [:]

    init(decoder: SpecDecoder) {
        self.decoder = decoder
    }

    var allKeys: [Key] {
        return []
    }

    func contains(_ key: Key) -> Bool {
        return true
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        self.optionalKeys[key.stringValue] = true
        return false
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        self.recordType(named: "bool", for: key)
        return true
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        self.recordType(named: "int", for: key)
        return 0
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        self.recordType(named: "int8", for: key)
        return 0
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        self.recordType(named: "int16", for: key)
        return 0
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        self.recordType(named: "int32", for: key)
        return 0
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        self.recordType(named: "int64", for: key)
        return 0
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        self.recordType(named: "uint", for: key)
        return 0
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        self.recordType(named: "uint8", for: key)
        return 0
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        self.recordType(named: "uint16", for: key)
        return 0
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        self.recordType(named: "uint32", for: key)
        return 0
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        self.recordType(named: "uint64", for: key)
        return 0
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        self.recordType(named: "float", for: key)
        return 0
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        self.recordType(named: "double", for: key)
        return 0
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        self.recordType(named: "string", for: key)
        return ""
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Swift.Decodable {
        if type == Date.self {
            self.recordType(named: "date", for: key)
            return Date.now as! T
        }
        else if type == Data.self {
            self.recordType(named: "data", for: key)
            return Data() as! T
        }
        else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: "an unsupported type was found"))
        }
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding nested containers is not supported"))
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding unkeyed containers is not supported"))
    }

    func superDecoder() throws -> Swift.Decoder {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding super encoders containers is not supported"))
    }

    func superDecoder(forKey key: Key) throws -> Swift.Decoder {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding super decoders is not supported"))
    }
}

private extension SpecDecodingContainer {
    func recordType(named name: String, for key: Key) {
        let isOptional = self.optionalKeys[key.stringValue, default: false]
        self.decoder.specDict[key.stringValue] = "\(name)\(isOptional ? "?" : "")"
    }
}
