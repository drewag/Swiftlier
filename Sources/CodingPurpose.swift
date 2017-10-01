//
//  CodingTarget.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/29/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public enum EncodingPurpose {
    case saveLocally
    case create
    case update
}

public enum DecodingSource {
    case local
    case remote
}

public struct CodingOptions {
    public static let encodingPurpose = CodingUserInfoKey(rawValue: "swiftlier.encodingPurpose")!
    public static let decodingSource = CodingUserInfoKey(rawValue: "swiftlier.decodingSource")!
}

extension Encoder {
    public var purpose: EncodingPurpose {
        guard let mode = self.userInfo[CodingOptions.encodingPurpose] as? EncodingPurpose else {
            return .saveLocally
        }
        return mode
    }
}

extension Decoder {
    public var source: DecodingSource {
        guard let mode = self.userInfo[CodingOptions.decodingSource] as? DecodingSource else {
            return .local
        }
        return mode
    }
}

