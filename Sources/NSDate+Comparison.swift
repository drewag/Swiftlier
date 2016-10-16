//
//  Date+Comparison.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/25/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince(rhs) < 0
}

public func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince(rhs) > 0
}
