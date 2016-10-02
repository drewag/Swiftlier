//
//  NSDate+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/4/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import UIKit

extension NSDate {
    public var isToday: Bool {
        let cal = NSCalendar.currentCalendar()
        let units = NSCalendarUnit.Era
            .union(.Year)
            .union(.Month)
            .union(.Day)
        var components = cal.components(units, fromDate: NSDate())
        let today = cal.dateFromComponents(components)
        components = cal.components(units, fromDate: self)
        let otherDate = cal.dateFromComponents(components)

        return today == otherDate
    }

    public var isThisYear: Bool {
        let cal = NSCalendar.currentCalendar()
        let units = NSCalendarUnit.Era
            .union(.Year)
        var components = cal.components(units, fromDate: NSDate())
        let today = cal.dateFromComponents(components)
        components = cal.components(units, fromDate: self)
        let otherDate = cal.dateFromComponents(components)

        return today == otherDate
    }

    public var time: dispatch_time_t {
        let seconds = self.timeIntervalSince1970
        let wholeSecsFloor = floor(seconds)
        let nanosOnly = seconds - wholeSecsFloor
        let nanosFloor = floor(nanosOnly * Double(NSEC_PER_SEC))
        var thisStruct = timespec(tv_sec: Int(wholeSecsFloor),
                                  tv_nsec: Int(nanosFloor))
        return dispatch_walltime(&thisStruct, 0)
    }
}
