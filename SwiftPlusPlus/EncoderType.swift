//
//  EncoderType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol EncoderType {
    func encode<K: CoderKeyType>(data: K.ValueType, forKey key: K.Type)
    func encode<K: OptionalCoderKeyType>(data: K.ValueType?, forKey key: K.Type)
    func encode<K: NestedCoderKeyType>(data: K.ValueType, forKey key: K.Type)
    func encode<K: OptionalNestedCoderKeyType>(data: K.ValueType?, forKey key: K.Type)

    func encode<K: CoderKeyType>(data: [K.ValueType], forKey key: K.Type)
    func encode<K: NestedCoderKeyType>(data: [K.ValueType], forKey key: K.Type)
}
