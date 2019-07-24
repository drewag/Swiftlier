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

    public init<E: Encodable>(encodable: E, destination: CodingLocation = .local, purpose: CodingPurpose = .create, userInfo: [CodingUserInfoKey:Any] = [:]) throws {
        let encoder = JSONEncoder()
        encoder.userInfo = userInfo
        encoder.userInfo.set(purposeDefault: purpose)
        encoder.userInfo.set(locationDefault: destination)
        let data = try encoder.encode(encodable)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        self.init(object: object)
    }

    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.object, options: [])
    }

    public func decode<D: Decodable>(source: CodingLocation = .local, purpose: CodingPurpose = .create, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> D {
        let decoder = JSONDecoder()
        decoder.userInfo = userInfo
        decoder.userInfo.set(purposeDefault: purpose)
        decoder.userInfo.set(locationDefault: source)
        return try decoder.decode(D.self, from: self.data())
    }
}
