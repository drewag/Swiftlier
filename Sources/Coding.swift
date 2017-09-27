//
//  Codable.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 12/20/16.
//  Copyright © 2016 Drewag. All rights reserved.
//

import Foundation

/* ---------------- Core Protocols ---------------- */

@available(*, deprecated, message: "Use Swift native Codable instead")
public protocol Codable: Encodable, Decodable, ErrorGenerating {}

public protocol RawCodable: Codable {
    init()
    var asObject: Any { get }
}

@available(*, deprecated, message: "Use Swift native Decodable instead")
public protocol Decodable {
    init(decoder: Decoder) throws
}

@available(*, deprecated, message: "Use Swift native Encodable instead")
public protocol Encodable {
    func encode(_ encoder: Encoder)
}

public enum DecodingMode {
    case saveLocally
    case remote
}

@available(*, deprecated, message: "Use Swift native Decoder instead")
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

@available(*, deprecated, message: "Use Swift native Encoder instead")
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

public protocol AnyCoderKey {
    static var path: [String] {get}
}

open class CoderKey<Value: Encodable>: AnyCoderKey {
    open class var customKey: String? { return nil }
}

open class OptionalCoderKey<Value: Encodable>: AnyCoderKey {
    open class var customKey: String? { return nil }
}

extension CoderKey {
    public static var path: [String] {
        return self.customKey?.components(separatedBy: ".")
            ?? [String(describing: Mirror(reflecting: self).subjectType).components(separatedBy: ".").first!]
    }
}

extension OptionalCoderKey {
    public static var path: [String] {
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
            throw Self.error("decoding value", because: "the option is not recognized")
        }
        self = value
    }
}
