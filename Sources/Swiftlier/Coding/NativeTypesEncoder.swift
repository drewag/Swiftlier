//
//  NativeTypesEncoder.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

/// Generate native types object from an encodable object
///
/// - Top level object is an array or dictionary
/// - All objects are String, NSNumber, array, dictionary, or NSNull
/// - All dictionary keys are String
public final class NativeTypesEncoder {
    /// Generate native types object from an encodable object
    ///
    /// - Top level object is an array or dictionary
    /// - All objects are String, NSNumber, array, dictionary, or NSNull
    /// - All dictionary keys are String
    public class func object<E: Encodable>(from encodable: E, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> Any {
        let encoder = JSONEncoder()
        encoder.userInfo = userInfo
        let data = try encoder.encode(encodable)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        return object
    }
}
