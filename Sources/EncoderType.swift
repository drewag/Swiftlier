//
//  EncoderType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol EncoderType {
    func encode<Value: RawEncodableType>(_ data: Value, forKey key: CoderKey<Value>.Type)
    func encode<Value: RawEncodableType>(_ data: Value?, forKey key: OptionalCoderKey<Value>.Type)
    func encode<Value: EncodableType>(_ data: Value, forKey key: NestedCoderKey<Value>.Type)
    func encode<Value: EncodableType>(_ data: Value?, forKey key: OptionalNestedCoderKey<Value>.Type)

    func encode<Value: RawEncodableType>(_ data: [Value], forKey key: CoderKey<Value>.Type)
    func encode<Value: EncodableType>(_ data: [Value], forKey key: NestedCoderKey<Value>.Type)
}
