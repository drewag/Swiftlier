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

private let timeFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "h':'mm a"
    return dateFormatter
}()

private let dateFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MMM. dd, yyyy"
    return dateFormatter
}()

private let shortDateFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MM'/'dd'/'yyyy"
    return dateFormatter
}()

private let shortestDateFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MM'/'dd'/'yy"
    return dateFormatter
}()

private let dayAndMonthFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MM'/'dd"
    return dateFormatter
}()

private let railsDateTimeFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    let timeZone = NSTimeZone(name: "UTC")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

private let iso8601DateTimeFormatter: NSDateFormatter = {
    var dateFormatter = NSDateFormatter()
    let timeZone = NSTimeZone(name: "UTC")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
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
    public var asDateAndTime: String {
        return dateAndTimeFormatter.stringFromDate(self)
    }

    public var asDate: String {
        return dateFormatter.stringFromDate(self)
    }

    public var asTime: String {
        return timeFormatter.stringFromDate(self)
    }

    public var asShortDate: String {
        return shortDateFormatter.stringFromDate(self)
    }

    public var asShortestDate: String {
        return shortestDateFormatter.stringFromDate(self)
    }

    public var asDayAndMonth: String {
        return dayAndMonthFormatter.stringFromDate(self)
    }

    public var asRailsDateTimeString: String {
        return railsDateTimeFormatter.stringFromDate(self)
    }

    public var asIso8601DateTimeString: String {
        return iso8601DateTimeFormatter.stringFromDate(self)
    }

    public var asSQLiteDateTimeString: String {
        return railsDateTimeFormatter.stringFromDate(self)
    }

    public var asRailsDateString: String {
        return railsDateFormatter.stringFromDate(self)
    }

    public var asSQLiteDateString: String {
        return railsDateFormatter.stringFromDate(self)
    }

    public var asAuthToken: String {
        return authTokenDate.stringFromDate(self)
    }

    public class func fromRailsDateTimeString(railsString: String) -> NSDate? {
        return railsDateTimeFormatter.dateFromString(railsString)
    }

    public class func fromRailsDateString(railsString: String) -> NSDate? {
        return railsDateFormatter.dateFromString(railsString)
    }

    public class func fromIso8601DateTimeString(dateTimeString: String) -> NSDate? {
        return iso8601DateTimeFormatter.dateFromString(dateTimeString)
    }
}