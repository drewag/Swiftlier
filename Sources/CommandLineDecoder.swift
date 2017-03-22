//
//  CommandLineDecoder.swift
//  drewag.me
//
//  Created by Andrew J Wagner on 3/16/17.
//
//

import Foundation

public class CommandLineDecoder: DecoderType {
    public let mode = DecodingMode.saveLocally

    public class func prompt<E: DecodableType>() throws -> E {
        let decoder = CommandLineDecoder()

        return try E(decoder: decoder)
    }

    fileprivate init() {}

    public func decode<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> Value {
        var value: Value?
        repeat {
            value = self.promptForValue(withName: key.path.joined(separator: " "))
            if value == nil {
                print("This value is required")
                continue
            }
        } while value == nil

        return value!
    }

    public func decode<Value: DecodableType>(_ key: OptionalCoderKey<Value>.Type) throws -> Value? {
        return self.promptForValue(withName: key.path.joined(separator: " "))
    }

    public func decodeArray<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> [Value] {
        fatalError("Not available")
    }

    public func decodeAsEntireValue<Value: DecodableType>() throws -> Value {
        fatalError("Not available")
    }
}

private extension CommandLineDecoder {
    func promptForValue<Value: DecodableType>(withName name: String) -> Value? {
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
