//
//  Date+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 1/4/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension Date {
    public var isToday: Bool {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let units = Set<Calendar.Component>([.era, .year, .month, .day])
        var components = cal.dateComponents(units, from: Date.now)
        let today = cal.date(from: components)
        components = cal.dateComponents(units, from: self)
        let otherDate = cal.date(from: components)

        return today == otherDate
    }

    public var isTomorrow: Bool {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let units = Set<Calendar.Component>([.era, .year, .month, .day])
        var components = cal.dateComponents(units, from: Date(timeIntervalSinceNow: 60 * 60 * 24))
        let tomorrow = cal.date(from: components)
        components = cal.dateComponents(units, from: self)
        let otherDate = cal.date(from: components)

        return tomorrow == otherDate
    }

    public var isThisWeek: Bool {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let units = Set<Calendar.Component>([.era, .year, .weekOfYear])
        let today = cal.dateComponents(units, from: Date.now)
        let other = cal.dateComponents(units, from: self)

        return today.era == other.era
            && today.year == other.year
            && today.weekOfYear == other.weekOfYear
    }

    public var isThisYear: Bool {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let units = Set<Calendar.Component>([.era, .year])
        var components = cal.dateComponents(units, from: Date.now)
        let today = cal.date(from: components)
        components = cal.dateComponents(units, from: self)
        let otherDate = cal.date(from: components)

        return today == otherDate
    }

    public var isInFuture: Bool {
        return (self.timeIntervalSinceNow > 0)
    }

    public var isInPast: Bool {
        return (self.timeIntervalSinceNow < 0)
    }

    public var beginningOfDay: Date {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let units = Set<Calendar.Component>([.era, .year, .month, .day])
        let components = cal.dateComponents(units, from: self)
        return cal.date(from: components)!
    }

    public var beginningOfWeek: Date {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let weekDay = cal.dateComponents([.weekday], from: self).weekday!
        let units = Set<Calendar.Component>([.era, .year, .month, .day])
        var components = cal.dateComponents(units, from: cal.date(byAdding: .day, value: -(weekDay - 1), to: self)!)
        components.weekday = cal.firstWeekday
        return cal.date(from: components)!
    }

    public var beginningOfMonth: Date {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        let units = Set<Calendar.Component>([.era, .year, .month])
        var components = cal.dateComponents(units, from: self)
        components.day = 1
        return cal.date(from: components)!
    }

    public var beginningOfNextDay: Date {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        return cal.date(byAdding: .day, value: 1, to: self.beginningOfDay)!
    }

    public var beginningOfNextWeek: Date {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        return cal.date(byAdding: .day, value: 7, to: self.beginningOfWeek)!
    }

    public var beginningOfNextMonth: Date {
        #if os(Linux)
        // https://forums.swift.org/t/possible-bug-in-datecomponents-method-running-on-ubuntu-16-04/25702/2
        let cal = Calendar(identifier: .gregorian)
        #else
        let cal = Calendar.current
        #endif
        return cal.date(byAdding: .month, value: 1, to: self.beginningOfMonth)!
    }
}
