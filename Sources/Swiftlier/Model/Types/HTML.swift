//
//  HTML.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 11/23/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public protocol HTML: CustomStringConvertible {
}

extension String: HTML {
    public var description: String {
        return self
    }
}
