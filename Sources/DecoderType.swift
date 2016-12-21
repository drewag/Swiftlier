//
//  DecoderType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public enum DecodingMode {
    case saveLocally
    case remote
}

public protocol DecoderType {
    var mode: DecodingMode {get}

    func decode<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> Value
    func decode<Value: DecodableType>(_ key: OptionalCoderKey<Value>.Type) throws -> Value?

    func decodeArray<Value: DecodableType>(_ key: CoderKey<Value>.Type) throws -> [Value]

    func decodeAsEntireValue<Value: DecodableType>() throws -> Value
}
