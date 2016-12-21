//
//  Encodable.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol EncodableType {
    func encode(_ encoder: EncoderType)
}

extension EncodableType where Self: DecodableType {
    public func copyUsingEncoding() -> Self {
        let object = NativeTypesEncoder.objectFromEncodable(self, mode: .saveLocally)
        return try! NativeTypesDecoder.decodableTypeFromObject(object, mode: .saveLocally)
    }
}
