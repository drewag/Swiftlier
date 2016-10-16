//
//  Date+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/4/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension Date {
    public var isToday: Bool {
        let cal = Calendar.current
        let units = Set<Calendar.Component>([.era, .year, .month, .day])
        var components = cal.dateComponents(units, from: Date())
        let today = cal.date(from: components)
        components = cal.dateComponents(units, from: self)
        let otherDate = cal.date(from: components)

        return today == otherDate
    }

    public var isThisYear: Bool {
        let cal = Calendar.current
        let units = Set<Calendar.Component>([.era, .year])
        var components = cal.dateComponents(units, from: Date())
        let today = cal.date(from: components)
        components = cal.dateComponents(units, from: self)
        let otherDate = cal.date(from: components)

        return today == otherDate
    }

    public var time: DispatchWallTime {
        let seconds = self.timeIntervalSince1970
        let wholeSecsFloor = floor(seconds)
        let nanosOnly = seconds - wholeSecsFloor
        let nanosFloor = floor(nanosOnly * Double(NSEC_PER_SEC))
        let spec = timespec(tv_sec: Int(wholeSecsFloor),
                                  tv_nsec: Int(nanosFloor))
        return DispatchWallTime(timespec: spec)
    }
}
