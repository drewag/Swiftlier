//
//  CoderKey.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol RawCodable: Codable {
    init()
    var asObject: Any { get }
}

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

extension Date: Codable {
    public func encode(_ encoder: Encoder) {
        encoder.encodeAsEntireValue(self.iso8601DateTime)
    }

    public init(decoder: Decoder) throws {
        let string: String = try decoder.decodeAsEntireValue()
        guard let date = string.iso8601DateTime else {
            throw Date.error("decoding date from \(string)", because: "it is an invalid date")
        }
        self = date
    }
}

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
