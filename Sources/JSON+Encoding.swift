//
//  JSONEncoder.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/11/17.
//
//

import Foundation


extension JSON {
    public static func encode(_ encodable: EncodableType, mode: EncodingMode) -> String {
        let object = NativeTypesEncoder.objectFromEncodable(encodable, mode: mode)
        return try! self.valueString(fromRaw: object)
    }

    public static func encode(_ encodable: EncodableType, mode: EncodingMode) -> Data {
        return self.encode(encodable, mode: mode).data(using: .utf8)!
    }

    public static func encode(_ encodables: [EncodableType], mode: EncodingMode) -> String {
        let object = NativeTypesEncoder.objectFromCombiningEncodables(encodables, mode: mode)
        return try! self.valueString(fromRaw: object)
    }

    public static func encode(_ encodables: [String:EncodableType], mode: EncodingMode) -> String {
        var object = [String:Any]()

        for (key, value) in encodables {
            object[key] = NativeTypesEncoder.objectFromEncodable(value, mode: mode)
        }

        return try! self.valueString(fromRaw: object)
    }

    public static func encode(_ encodables: [String:EncodableType], mode: EncodingMode) -> Data {
        return self.encode(encodables, mode: mode).data(using: .utf8)!
    }

    public static func encode(_ encodables: [EncodableType], mode: EncodingMode) -> Data {
        return self.encode(encodables, mode: mode).data(using: .utf8)!
    }

    public static func encode(_ object: Any) throws -> String {
        return try self.valueString(fromRaw: object)
    }

    public static func encode(_ object: Any) throws -> Data {
        return try self.encode(object).data(using: .utf8)!
    }
}

private extension JSON {
    static func valueString(fromRaw raw: Any) throws -> String {
        switch raw {
        case let string as String:
            return "\"\(escape(string))\""
        case let bool as Bool:
            return bool ? "true" : "false"
        case let int as Int:
            return "\(int)"
        case let double as Double:
            return "\(double)"
        case let float as Float:
            return "\(float)"
        case let data as Data:
            return "\"\(data.base64)\""
        case let date as Date:
            return "\(date.iso8601DateTime)"
        case _ as NSNull:
            return "null"
        case let dict as [String:Any]:
            let output = try dict.map({ key, value in
                return "\"\(escape(key))\":\(try self.valueString(fromRaw: value))"
            }).joined(separator: ",")
            return "{\(output)}"
        case let array as [Any]:
            let output = try array.map({try self.valueString(fromRaw: $0)}).joined(separator: ",")
            return "[\(output)]"
        default:
            throw LocalUserReportableError(source: "JSONEncoder", operation: "encoding", message: "Found unrecognized value", reason: .internal)
        }
    }

    static func escape(_ string: String) -> String {
        var output = ""
        for character in string.characters {
            switch character {
            case "\"":
                output.append("\\\"")
            case "\\":
                output.append("\\\\")
            case "/":
                output.append("\\/")
            case "\n":
                output.append("\\n")
            case "\r":
                output.append("\\r")
            case "\u{8}":
                output.append("\\b")
            case "\u{000C}":
                output.append("\\f")
            case "\t":
                output.append("\\t")
            default:
                output.append(character)
            }
        }
        return output
    }
}
