//
//  Structured.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/15/17.
//
//

import Foundation

public protocol Structured {
    var string: String? {get}
    var int: Int? {get}
    var double: Double? {get}
    var bool: Bool? {get}
    var array: [Self]? {get}
    var dictionary: [String:Self]? {get}
    subscript(string: String) -> Self? {get}
    subscript(int: Int) -> Self? {get}
}

extension Structured {
    public var url: URL? {
        guard let string = self.string else {
            return nil
        }
        return URL(string: string)
    }

    // Key Path Format
    // - Each element is separated by a period (.)
    // - Access an element in an array with arrayName[index]
    //
    // Example: "key1.array[2].value1" gets "example" from:
    // [
    //     "key1": [
    //          "array": [
    //              [
    //                  "value1": "example"
    //              ]
    //          ]
    //     ]
    // ]
    public func object(atKeyPath keyPath: String) throws -> Self? {
        guard !keyPath.isEmpty else {
            return self
        }

        var components = keyPath.components(separatedBy: ".")
        let next = components.removeFirst()
        guard let startIndex = next.firstIndex(of: "[") else {
            return try self[next]?.object(atKeyPath: components.joined(separator: "."))
        }

        guard next.last == "]" else {
            throw GenericSwiftlierError("parsing keypath", because: "no matching bracket ']' was found at the end")
        }

        let name = String(next[next.startIndex...next.index(before: startIndex)])
        let lastIndex = next.index(next.endIndex, offsetBy: -2)
        let indexString = String(next[next.index(after: startIndex)...lastIndex])
        guard let index = Int(indexString) else {
            throw GenericSwiftlierError("parsing keypath", because: "invalid index '\(indexString)'")
        }

        guard let array = self[name]?.array, index < array.count else {
            return nil
        }

        return try array[index].object(atKeyPath: components.joined(separator: "."))
    }
}
