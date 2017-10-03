//
//  JSON.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 3/23/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct JSON: NativeTypesStructured {
    public let object: Any

    public init(data: Data) throws {
        self.object = try JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions()
        )
    }

    public init(object: Any) {
        self.object = object
    }

    public init<E: Encodable>(encodable: E, purpose: EncodingPurpose = .saveLocally, userInfo: [CodingUserInfoKey:Any] = [:]) throws {
        let encoder = JSONEncoder()
        var userInfo = userInfo
        userInfo[CodingOptions.encodingPurpose] = purpose
        encoder.userInfo = userInfo
        let data = try encoder.encode(encodable)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        self.init(object: object)
    }

    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.object, options: [])
    }

    public func decode<D: Decodable>(source: DecodingSource = .local, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> D {
        let decoder = JSONDecoder()
        var userInfo = userInfo
        userInfo[CodingOptions.decodingSource] = source
        decoder.userInfo = userInfo
        return try decoder.decode(D.self, from: self.data())
    }
}
