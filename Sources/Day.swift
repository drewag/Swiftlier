//
//  Day.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 6/1/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

public struct Day {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}

extension Date {
    public var day: Day {
        let cal = Calendar.current
        let units = Set<Calendar.Component>([.year, .month, .day])
        let components = cal.dateComponents(units, from: self)

        return Day(
            year: components.year!,
            month: components.month!,
            day: components.day!
        )
    }
}

extension Day: Comparable {
    public static func <(lhs: Day, rhs: Day) -> Bool {
        return lhs.year <= rhs.year
            && lhs.month <= rhs.month
            && lhs.day < rhs.day
    }

    public static func ==(lhs: Day, rhs: Day) -> Bool {
        return lhs.year == rhs.year
            && lhs.month == rhs.month
            && lhs.day == rhs.day
    }
}
