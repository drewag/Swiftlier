//
//  EncoderType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public enum EncodingMode {
    case saveLocally
    case create
    case update
}

public protocol EncoderType {
    var mode: EncodingMode {get}

    func encode<Value: EncodableType>(_ data: Value, forKey key: CoderKey<Value>.Type)
    func encode<Value: EncodableType>(_ data: Value?, forKey key: OptionalCoderKey<Value>.Type)
    func encode<Value: EncodableType>(_ data: [Value], forKey key: CoderKey<Value>.Type)

    // Only the last call to this will apply as it replaces the entire value dictionary with this value
    func encodeAsEntireValue<Value: EncodableType>(_ data: Value?)
    func cancelEncoding()
}
