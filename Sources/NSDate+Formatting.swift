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
    public var dateAndTime: String {
        return dateAndTimeFormatter.string(from: self)
    }

    public var date: String {
        return dateFormatter.string(from: self)
    }

    public var time: String {
        return timeFormatter.string(from: self)
    }

    public var shortDate: String {
        return shortDateFormatter.string(from: self)
    }

    public var shortestDate: String {
        return shortestDateFormatter.string(from: self)
    }

    public var dayAndMonth: String {
        return dayAndMonthFormatter.string(from: self)
    }

    public var railsDateTime: String {
        return railsDateTimeFormatter.string(from: self)
    }

    public var iso8601DateTime: String {
        return iso8601DateTimeFormatter.string(from: self)
    }

    public var sqliteDateTime: String {
        return railsDateTimeFormatter.string(from: self)
    }

    public var railsDate: String {
        return railsDateFormatter.string(from: self)
    }

    public var sqliteDate: String {
        return railsDateFormatter.string(from: self)
    }

    public var authToken: String {
        return authTokenDate.string(from: self)
    }

    public var preciseTime: String {
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

    public var date: Date? {
        return dateFormatter.date(from: self)
    }
}
