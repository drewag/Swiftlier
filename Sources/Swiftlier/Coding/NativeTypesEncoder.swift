//
//  NativeTypesEncoder.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public final class NativeTypesEncoder  {
    public class func object<E: Swift.Encodable>(from encodable: E, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> Any {
        let encoder = JSONEncoder()
        encoder.userInfo = userInfo
        let data = try encoder.encode(encodable)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        return object
    }
}
