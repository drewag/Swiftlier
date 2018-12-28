//
//  CommandLineDecoder.swift
//  drewag.me
//
//  Created by Andrew J Wagner on 3/16/17.
//
//

import Foundation

public class CommandLineDecoder: Decoder {
    public class func prompt<D: Decodable>(defaults: [String:String] = [:], userInfo: [CodingUserInfoKey:Any] = [:]) throws -> D {
        let decoder = CommandLineDecoder(defaults: defaults, userInfo: userInfo)
        return try D(from: decoder)
    }

    public var codingPath: [CodingKey] = []
    public let userInfo: [CodingUserInfoKey: Any]
    public let defaults: [String:String]

    fileprivate init(defaults: [String:String], userInfo: [CodingUserInfoKey:Any]) {
        self.defaults = defaults
        self.userInfo = userInfo
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(CommandLineDecodingContainer(defaults: self.defaults))
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding an unkeyed container is not supported"))
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding a single value container is not supported"))
    }
}

private class CommandLineDecodingContainer<MyKey: CodingKey>: KeyedDecodingContainerProtocol {
    typealias Key = MyKey

    let codingPath: [CodingKey] = []
    let defaults: [String:String]
    var lastInput = [String:String]()

    init(defaults: [String:String]) {
        self.defaults = defaults
    }

    var allKeys: [Key] {
        return []
    }

    func contains(_ key: Key) -> Bool {
        return true
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        print("\(key.stringValue) (optional)? ", terminator: "")
        let input = readLine(strippingNewline: true) ?? ""
        self.lastInput[key.stringValue] = input
        return input.isEmpty
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        var input: String
        if let lastInput = self.lastInput[key.stringValue] {
            input = lastInput
        }
        else {
            print("\(key.stringValue)? ", terminator: "")
            input = readLine(strippingNewline: true) ?? ""
        }
        return (input.lowercased() == "y") || (input.lowercased() == "yes")
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return self.promptForValue(withName: key.stringValue, create: { Int($0) }, errorString: "Must be an integer")
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return self.promptForValue(withName: key.stringValue, create: { Int8($0) }, errorString: "Must be an Int8")
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return self.promptForValue(withName: key.stringValue, create: { Int16($0) }, errorString: "Must be an Int16")
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return self.promptForValue(withName: key.stringValue, create: { Int32($0) }, errorString: "Must be an Int32")
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return self.promptForValue(withName: key.stringValue, create: { Int64($0) }, errorString: "Must be an Int64")
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return self.promptForValue(withName: key.stringValue, create: { UInt($0) }, errorString: "Must be an UInt")

    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return self.promptForValue(withName: key.stringValue, create: { UInt8($0) }, errorString: "Must be an UInt8")
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return self.promptForValue(withName: key.stringValue, create: { UInt16($0) }, errorString: "Must be an UInt16")
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return self.promptForValue(withName: key.stringValue, create: { UInt32($0) }, errorString: "Must be an UInt32")
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return self.promptForValue(withName: key.stringValue, create: { UInt64($0) }, errorString: "Must be an UInt64")
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        return self.promptForValue(withName: key.stringValue, create: { Float($0) }, errorString: "Must be a decimal")
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        return self.promptForValue(withName: key.stringValue, create: { Double($0) }, errorString: "Must be an decimal")
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return self.promptForValue(withName: key.stringValue, create: { $0.isEmpty ? nil : $0 }, errorString: "Must not be empty")
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Swift.Decodable {
        if type == Date.self {
            return self.promptForValue(withName: key.stringValue, create: { input in
                return input.date ?? input.railsDateTime ?? input.railsDate ?? input.iso8601DateTime
            }, errorString: "Invalid date/time") as! T
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

private extension CommandLineDecodingContainer {
    func promptForValue<Value>(withName name: String, create: (String) -> (Value?), errorString: String) -> Value {
        var input: String
        if let lastInput = self.lastInput[name] {
            input = lastInput
        }
        else if let existing = self.defaults[name] {
            input = existing
        }
        else {
            print("\(name)? ", terminator: "")
            input = readLine(strippingNewline: true) ?? ""
        }

        repeat {
            if let value = create(input) {
                return value
            }
            print(errorString)
            print("\(name)? ", terminator: "")
            input = readLine(strippingNewline: true) ?? ""
        } while input.isEmpty

        fatalError()
    }

    func promptForValue<Value: Decodable>(withName name: String) -> Value? {
        var input: String = ""
        repeat {
            print("\(name)? ", terminator: "")
            input = readLine(strippingNewline: true) ?? ""
            guard !input.isEmpty else {
                return nil
            }

            if Value.self == String.self {
                return input as? Value
            }
            else if Value.self == Bool.self {
                let value = (input.lowercased() == "y") || (input.lowercased() == "yes")
                return value as? Value
            }
            else if Value.self == Int.self {
                guard let value = Int(input) else {
                    print("Must be an integer")
                    continue
                }
                return value as? Value
            }
            else if Value.self == Double.self {
                guard let value = Double(input) else {
                    print("Must be a decimal")
                    continue
                }
                return value as? Value
            }
            else if Value.self == Float.self {
                guard let value = Float(input) else {
                    print("Must be a decimal")
                    continue
                }
                return value as? Value
            }
            else if Value.self == Data.self {
                return input.data(using: .utf8) as? Value
            }
            else if Value.self == Date.self {
                guard let value = input.date ?? input.railsDateTime ?? input.railsDate ?? input.iso8601DateTime else {
                    print("Invalid date/time")
                    continue
                }
                return value as? Value
            }
            else {
                fatalError("Unknown raw value type")
            }
        } while input.isEmpty

        return nil
    }
}
