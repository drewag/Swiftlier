//
//  Encodable.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol Encodable {
    func encode(_ encoder: Encoder)
}

extension Encodable where Self: Decodable {
    public func copyUsingEncoding() -> Self {
        let object = NativeTypesEncoder.objectFromEncodable(self, mode: .saveLocally)
        return try! NativeTypesDecoder.decodableTypeFromObject(object, mode: .saveLocally)
    }
}

extension RawRepresentable where RawValue: RawCodable {
    public func encode(_ encoder: Encoder) {
        encoder.encodeAsEntireValue(self.rawValue)
    }
}
