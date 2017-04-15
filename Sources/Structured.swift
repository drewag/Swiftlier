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
}
