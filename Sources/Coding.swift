//
//  Codable.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 12/20/16.
//  Copyright © 2016 Drewag. All rights reserved.
//

import Foundation

/* ---------------- Core Protocols ---------------- */

public protocol Codable: Encodable, Decodable, ErrorGenerating {}

public protocol RawCodable: Codable {
    init()
    var asObject: Any { get }
}

public protocol Decodable {
    init(decoder: Decoder) throws
}

public protocol Encodable {
    func encode(_ encoder: Encoder)
}

public enum DecodingMode {
    case saveLocally
    case remote
}

public protocol Decoder {
    var mode: DecodingMode {get}

    func decode<Value: Decodable>(_ key: CoderKey<Value>.Type) throws -> Value
    func decode<Value: Decodable>(_ key: OptionalCoderKey<Value>.Type) throws -> Value?

    func decodeArray<Value: Decodable>(_ key: CoderKey<Value>.Type) throws -> [Value]

    func decodeAsEntireValue<Value: Decodable>() throws -> Value
}

public enum EncodingMode {
    case saveLocally
    case create
    case update
}

public protocol Encoder {
    var mode: EncodingMode {get}

    func encode<Value>(_ data: Value, forKey key: CoderKey<Value>.Type)
    func encode<Value>(_ data: Value?, forKey key: OptionalCoderKey<Value>.Type)
    func encode<Value>(_ data: [Value], forKey key: CoderKey<Value>.Type)

    // Only the last call to this will apply as it replaces the entire value dictionary with this value
    func encodeAsEntireValue<Value: Encodable>(_ data: Value?)
    func cancelEncoding()
}

/* ---------------- RawCodable ---------------- */

extension RawCodable {
    public func encode(_ encoder: Encoder) {
        encoder.encodeAsEntireValue(self)
    }
}

extension RawCodable {
    public init(decoder: Decoder) throws {
        self = try decoder.decodeAsEntireValue()
    }
}

extension String: RawCodable { public var asObject: Any { return self as Any } }
extension Bool: RawCodable { public var asObject: Any { return self as Any } }
extension Int: RawCodable { public var asObject: Any { return self as Any } }
extension Double: RawCodable { public var asObject: Any { return self as Any } }
extension Float: RawCodable { public var asObject: Any { return self as Any } }
extension Data: RawCodable { public var asObject: Any { return self as Any } }

open class CoderKey<Value: Encodable> {
    open class var customKey: String? { return nil }
}

open class OptionalCoderKey<Value: Encodable> {
    open class var customKey: String? { return nil }
}

extension CoderKey {
    static var path: [String] {
        return self.customKey?.components(separatedBy: ".")
            ?? [String(describing: Mirror(reflecting: self).subjectType).components(separatedBy: ".").first!]
    }
}

extension OptionalCoderKey {
    static var path: [String] {
        return self.customKey?.components(separatedBy: ".")
            ?? [String(describing: Mirror(reflecting: self).subjectType).components(separatedBy: ".").first!]
    }
}

/* ---------------- Encodable ---------------- */

extension Encodable where Self: Decodable {
    public func copyUsingEncoding() -> Self {
        let object = NativeTypesEncoder.objectFromEncodable(self, mode: .saveLocally)
        return try! NativeTypesDecoder.decodableTypeFromObject(object, mode: .saveLocally)
    }
}

extension RawRepresentable where RawValue: RawCodable {
    public func encode(_ encoder: Encoder) {
        encoder.encodeAsEntireValue(self.rawValue)
    }
}

/* ---------------- Decodables ---------------- */

extension RawRepresentable where RawValue: RawCodable, Self: ErrorGenerating {
    public init(decoder: Decoder) throws {
        let raw: RawValue = try decoder.decodeAsEntireValue()
        guard let value = Self(rawValue: raw) else {
            throw Self.error("decoding value", because: "the optino is not recognized")
        }
        self = value
    }
}
