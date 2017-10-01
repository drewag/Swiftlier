//
//  Coding+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/30/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

extension Encodable where Self: Decodable {
    public func copyUsingEncoding() throws -> Self {
        let data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode(type(of: self), from: data)
    }
}
