//
//  DecoderType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol DecoderType {
    func decode<Value: RawEncodableType>(key: CoderKey<Value>.Type) -> Value
    func decode<Value: RawEncodableType>(key: OptionalCoderKey<Value>.Type) -> Value?
    func decode<Value: EncodableType>(key: NestedCoderKey<Value>.Type) -> Value
    func decode<Value: EncodableType>(key: OptionalNestedCoderKey<Value>.Type) -> Value?

    func decodeArray<Value: RawEncodableType>(key: CoderKey<Value>.Type) -> [Value]
    func decodeArray<Value: EncodableType>(key: NestedCoderKey<Value>.Type) -> [Value]
}