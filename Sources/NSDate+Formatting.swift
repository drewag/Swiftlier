//
//  Date+Formatting.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

private let dateAndTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd' at 'hh:mm a"
    return dateFormatter
}()

private let timeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "h':'mm a"
    return dateFormatter
}()

private let dateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MMM. dd, yyyy"
    return dateFormatter
}()

private let shortDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MM'/'dd'/'yyyy"
    return dateFormatter
}()

private let shortestDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MM'/'dd'/'yy"
    return dateFormatter
}()

private let dayAndMonthFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MM'/'dd"
    return dateFormatter
}()

private let railsDateTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

private let iso8601DateTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

private let railsDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    return dateFormatter
}()

private let authTokenDate: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ddMMyyyy"
    return dateFormatter
}()

private let preciseTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "HH':'mm':'ss"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

extension Date {
    public var asDateAndTime: String {
        return dateAndTimeFormatter.string(from: self)
    }

    public var asDate: String {
        return dateFormatter.string(from: self)
    }

    public var asTime: String {
        return timeFormatter.string(from: self)
    }

    public var asShortDate: String {
        return shortDateFormatter.string(from: self)
    }

    public var asShortestDate: String {
        return shortestDateFormatter.string(from: self)
    }

    public var asDayAndMonth: String {
        return dayAndMonthFormatter.string(from: self)
    }

    public var asRailsDateTimeString: String {
        return railsDateTimeFormatter.string(from: self)
    }

    public var asIso8601DateTimeString: String {
        return iso8601DateTimeFormatter.string(from: self)
    }

    public var asSQLiteDateTimeString: String {
        return railsDateTimeFormatter.string(from: self)
    }

    public var asRailsDateString: String {
        return railsDateFormatter.string(from: self)
    }

    public var asSQLiteDateString: String {
        return railsDateFormatter.string(from: self)
    }

    public var asAuthToken: String {
        return authTokenDate.string(from: self)
    }

    public var asPreciseTime: String {
        return preciseTimeFormatter.string(from: self)
    }
}

extension String {
    public var railsDateTime: Date? {
        return railsDateTimeFormatter.date(from: self)
    }

    public var railsDate: Date? {
        return railsDateFormatter.date(from: self)
    }

    public var iso8601DateTime: Date? {
        return iso8601DateTimeFormatter.date(from: self)
    }
}
