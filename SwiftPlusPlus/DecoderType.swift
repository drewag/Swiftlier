//
//  DecoderType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol DecoderType {
    func decode<K: CoderKeyType>(key: K.Type) -> K.ValueType
    func decode<K: OptionalCoderKeyType>(key: K.Type) -> K.ValueType?
    func decode<K: NestedCoderKeyType>(key: K.Type) -> K.ValueType?
    func decode<K: OptionalNestedCoderKeyType>(key: K.Type) -> K.ValueType?
}