//
//  Enum+Convenience.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 1/27/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

extension RawRepresentable where RawValue == Int {
    public static var count: Int {
        var counter = 0
        while let _ = Self(rawValue: counter) {
            counter += 1
        }
        return counter
    }
}
