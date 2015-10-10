//
//  NSDate+Formatting.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

private let dateAndTimeFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd' at 'hh:mm a"
    return dateFormatter
}()

private let dateFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MMM. dd, yyyy"
    return dateFormatter
}()

private let railsDateTimeFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    let timeZone = NSTimeZone(name: "UTC")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

private let railsDateFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    return dateFormatter
}()

private let authTokenDate: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "ddMMyyyy"
    return dateFormatter
}()

extension NSDate {
    var asDateAndTime: String {
        return dateAndTimeFormatter.stringFromDate(self)
    }

    var asDate: String {
        return dateFormatter.stringFromDate(self)
    }

    var asRailsDateTimeString: String {
        return railsDateTimeFormatter.stringFromDate(self)
    }

    var asSQLiteDateTimeString: String {
        return railsDateTimeFormatter.stringFromDate(self)
    }

    var asRailsDateString: String {
        return railsDateFormatter.stringFromDate(self)
    }

    var asSQLiteDateString: String {
        return railsDateFormatter.stringFromDate(self)
    }

    var asAuthToken: String {
        return authTokenDate.stringFromDate(self)
    }

    class func fromRailsDateTimeString(railsString: String) -> NSDate? {
        return railsDateTimeFormatter.dateFromString(railsString)
    }

    class func fromRailsDateString(railsString: String) -> NSDate? {
        return railsDateFormatter.dateFromString(railsString)
    }
}