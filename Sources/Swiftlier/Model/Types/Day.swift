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

    /// Supports
    /// - YYYY-MM-DD
    /// - MM/DD/YYYY
    /// - MM/DD/YY
    /// - MM/DD
    public init(_ string: String) throws {
        var rawYear: Int
        let rawMonth: Int
        let rawDay: Int

        if string.contains("-") {
            // YYYY-MM-DD
            let components = string.components(separatedBy: "-")
            guard components.count == 3 else {
                throw GenericSwiftlierError("creating day", because: "'\(string)' is not a valid date")
            }
            guard let parsedYear = Int(components[0]) else { throw Day.invalidDateError(string: string) }
            guard let parsedMonth = Int(components[1]) else { throw Day.invalidDateError(string: string) }
            guard let parsedDay = Int(components[2]) else { throw Day.invalidDateError(string: string) }

            rawYear = parsedYear
            rawMonth = parsedMonth
            rawDay = parsedDay
        }
        else {
            // MM/DD/YYYY, MM/DD/YY, MM/DD
            let components = string.components(separatedBy: "/")
            switch components.count {
            case 2:
                // MM/DD
                guard let parsedMonth = Int(components[0]) else { throw Day.invalidDateError(string: string) }
                guard let parsedDay = Int(components[1]) else { throw Day.invalidDateError(string: string) }
                rawYear = Date.now.day.year
                rawMonth = parsedMonth
                rawDay = parsedDay
            case 3:
                // MM/DD/YYYY, MM/DD/YY
                guard let parsedYear = Int(components[2]) else { throw Day.invalidDateError(string: string) }
                guard let parsedMonth = Int(components[0]) else { throw Day.invalidDateError(string: string) }
                guard let parsedDay = Int(components[1]) else { throw Day.invalidDateError(string: string) }
                rawYear = parsedYear
                rawMonth = parsedMonth
                rawDay = parsedDay
            default:
                throw GenericSwiftlierError("creating day", because: "'\(string)' is not a valid date")
            }
        }

        guard rawYear > 0 else {
            throw GenericSwiftlierError("creating day", because: "'\(string)' is not a valid date")
        }

        if rawYear < 50 {
            rawYear += 2000
        }
        else if rawYear < 100 {
            rawYear += 1900
        }

        let maxDay: Int
        switch rawMonth {
        case 1, 3, 5, 7, 8, 10, 12:
            maxDay = 31
        case 4, 6, 9, 11:
            maxDay = 30
        case 2 where rawYear % 4 == 0 && (rawYear % 100 != 0 || rawYear % 400 == 0):
            // Leap year
            maxDay = 29
        case 2:
            // Non-leap year
            maxDay = 28
        default:
            throw Day.invalidDateError(string: string)
        }

        guard rawDay > 0 && rawDay <= maxDay else {
            throw Day.invalidDateError(string: string)
        }

        self.year = rawYear
        self.month = rawMonth
        self.day = rawDay
    }

    public enum Weekday: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    public var isLeapYear: Bool {
        return self.year % 4 == 0 && (self.year % 100 != 0 || self.year % 400 == 0)
    }

    public var century: Int {
        return self.year / 100
    }

    public var dayOfWeek: Weekday {
        // The Key Value Method
        // http://mathforum.org/dr.math/faq/faq.calendar.html
        let value: Int
        switch self.month {
        case 1, 10:
            value = 1
        case 2,3,11:
            value = 4
        case 4, 7:
            value = 0
        case 5:
            value = 2
        case 8:
            value = 3
        default:
            value = 6
        }

        let leapYearAdjustment: Int
        if self.isLeapYear && (self.month == 1 || self.month == 2) {
            leapYearAdjustment = -1
        }
        else {
            leapYearAdjustment = 0
        }

        let centuryCode: Int
        switch self.century % 4 {
        case 0:
            centuryCode = 6
        case 1:
            centuryCode = 4
        case 2:
            centuryCode = 2
        default:
            centuryCode = 0
        }

        let rawWeekDay = ((self.year % 100) / 4 + self.day + value + leapYearAdjustment + centuryCode + (self.year % 100)) % 7
        return Weekday(rawValue: rawWeekDay) ?? .saturday
    }

    public var midnight: Date {
        return self.description.railsDate!
    }
}

extension Day: CustomStringConvertible {
    public var description: String {
        var output = "\(self.year)-"

        switch self.month {
        case 1...9:
            output += "0\(self.month)"
        default:
            output += "\(self.month)"
        }

        output += "-"

        switch self.day {
        case 1...9:
            output += "0\(self.day)"
        default:
            output += "\(self.day)"
        }
        return output
    }
}

extension Date {
    public var day: Day {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
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
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }

        if lhs.month != rhs.month {
            return lhs.month < rhs.month
        }

        return lhs.day < rhs.day
    }

    public static func ==(lhs: Day, rhs: Day) -> Bool {
        return lhs.year == rhs.year
            && lhs.month == rhs.month
            && lhs.day == rhs.day
    }
}

extension Day: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

private extension Day {
    static func invalidDateError(string: String) -> GenericSwiftlierError {
        return GenericSwiftlierError("creating day", because: "'\(string)' is not a valid date")
    }
}
