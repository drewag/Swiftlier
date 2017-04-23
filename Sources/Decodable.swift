//
//  Decodable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 12/20/16.
//  Copyright © 2016 Drewag. All rights reserved.
//

public protocol Decodable {
    init(decoder: Decoder) throws
}

extension RawRepresentable where RawValue: RawCodable, Self: ErrorGenerating {
    public init(decoder: Decoder) throws {
        let raw: RawValue = try decoder.decodeAsEntireValue()
        guard let value = Self(rawValue: raw) else {
            throw Self.error("decoding value", because: "the optino is not recognized")
        }
        self = value
    }
}
