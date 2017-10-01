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

    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.object, options: [])
    }
}
