//
//  AlwaysEqual.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 3/4/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public protocol AlwaysEqual: Equatable {}
extension AlwaysEqual {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return true
    }
}
