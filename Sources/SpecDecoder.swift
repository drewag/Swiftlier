//
//  SpecDecoder.swift
//  drewag.me
//
//  Created by Andrew J Wagner on 3/20/17.
//
//

import Foundation

public class SpecDecoder: DecoderType {
    public let mode = DecodingMode.saveLocally
    private var specDict = [String:String]()

    public class func spec<E: DecodableType>(forType: E.Type) throws -> String {
        let decoder = SpecDecoder()

        let _ = try E(decoder: decoder)
        let data = try JSONSerialization.data(withJSONObject: decoder.specDict, options: .prettyPrinted)
        return String(data: data, encoding: .utf8)!
    }

    fileprivate init() {}

    public func decode<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> Value {
        let name = key.path.joined(separator: "")
        let value: Value
        let type: String
        (type, value) = self.typeAndValue(withName: name)
        specDict[name] = type
        return value
    }

    public func decode<Value: DecodableType>(_ key: OptionalCoderKey<Value>.Type) throws -> Value? {
        let name = key.path.joined(separator: "")
        let value: Value
        let type: String
        (type, value) = self.typeAndValue(withName: name)
        specDict[name] = type
        return value
    }

    public func decodeArray<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> [Value] {
        fatalError("Not available")
    }

    public func decodeAsEntireValue<Value: DecodableType>() throws -> Value {
        fatalError("Not available")
    }
}

private extension SpecDecoder {
    func typeAndValue<Value: DecodableType>(withName name: String) -> (String,Value) {
        if Value.self == String.self {
            return ("string", "" as! Value)
        }
        else if Value.self == Bool.self {
            return ("bool", true as! Value)
        }
        else if Value.self == Int.self {
            return ("int", Int(0) as! Value)
        }
        else if Value.self == Double.self {
            return ("double", Double(0) as! Value)
        }
        else if Value.self == Float.self {
            return ("float", Float(0) as! Value)

        }
        else if Value.self == Data.self {
            return ("data", Data() as! Value)
        }
        else if Value.self == Date.self {
            return ("date", Date() as! Value)
        }
        else {
            fatalError("Unknown raw value type")
        }
    }
}
