//
//  Encodable.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol EncodableType {
    init?(decoder: DecoderType)

    func encode(encoder: EncoderType)
}

extension EncodableType {
    func copy() -> Self {
        let object = NativeTypesEncoder.objectFromEncodable(self)
        return NativeTypesDecoder.decodableTypeFromObject(object)!
    }
}