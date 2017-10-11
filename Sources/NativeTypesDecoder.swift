//
//  NativeTypesDecoder.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class NativeTypesDecoder: ErrorGenerating {
    public class func decodable<E: Decodable>(from raw: Any, source: CodingLocation = .local, purpose: CodingPurpose = .create, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> E {
        guard !(raw is NSNull) else {
            throw self.error("decoding a \(self)", because: "root value was null")
        }

        let data = try JSONSerialization.data(withJSONObject: raw, options: [])
        let decoder = JSONDecoder()
        decoder.userInfo = userInfo
        decoder.userInfo.set(purposeDefault: purpose)
        decoder.userInfo.set(locationDefault: source)
        return try decoder.decode(E.self, from: data)
    }
}
