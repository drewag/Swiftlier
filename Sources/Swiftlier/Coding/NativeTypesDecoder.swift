//
//  NativeTypesDecoder.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

/// Decode a decodable instance from a native types object
///
/// - Top level object must be an array or dictionary
/// - All objects must be String, NSNumber, array, dictionary, or NSNull
/// - All dictionary keys must be String
public final class NativeTypesDecoder {
    /// Decode a decodable instance from a native types object
    ///
    /// - Top level object must be an array or dictionary
    /// - All objects must be String, NSNumber, array, dictionary, or NSNull
    /// - All dictionary keys must be String
    public class func decodable<E: Decodable>(from raw: Any, source: CodingLocation = .local, purpose: CodingPurpose = .create, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> E {
        guard !(raw is NSNull) else {
            throw GenericSwiftlierError(while: "decoding a \(self)", reason: "The root value was null", details: nil)
        }

        let data = try JSONSerialization.data(withJSONObject: raw, options: [])
        let decoder = JSONDecoder()
        decoder.userInfo = userInfo
        decoder.userInfo.set(purposeDefault: purpose)
        decoder.userInfo.set(locationDefault: source)
        return try decoder.decode(E.self, from: data)
    }
}
