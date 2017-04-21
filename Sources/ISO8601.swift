//
//  ISO8601.swift
//  web
//
//  Created by Andrew J Wagner on 4/21/17.
//
//

import Foundation

public struct Config {
    public var timeZoneIdentifier: String = "Z"

    public init() {

    }
}

public struct CustomISO8601Formatter {

    // MARK: - Shared
    public static let shared = CustomISO8601Formatter(config: Config())

    // MARK: - Properties
    public let config: Config

    // MARK: Init
    public init(config: Config) {
        self.config = config
    }

    // MARK: - DateFormatter
    public var stringToDateFormatter: DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd HHmmssZ"

        return formatter
    }()

    public var stringToDateMillisecondsFormatter: DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd HHmmss.SSSZ"

        return formatter
    }()

    public var dateToStringFormatter: DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter
    }()

    /**
     Parse an ISO8601 string to Date
     - parameter string: The string to parse
     - returns: A date representation of string formatted using ISO8601, nil if fails
     */
    public func date(string: String) -> Date? {
        var basicString = string

        if let regex = try? NSRegularExpression(pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}", options: []),
            let result = regex.firstMatch(in: string, options: .anchored, range: NSMakeRange(0, string.characters.count)) {
            basicString = (basicString as NSString).replacingOccurrences(of: "-", with: "", options: [], range: result.range)
        }

        basicString = basicString
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: "GMT", with: "")
            .replacingOccurrences(of: "T", with: " ")
            .replacingOccurrences(of: ",", with: ".")

        if !basicString.hasSuffix("Z") {
            basicString += "Z"
        }

        return stringToDateFormatter.date(from: basicString)
            ?? stringToDateMillisecondsFormatter.date(from: basicString)
    }
    
    public func string(date: Date) -> String {
        return dateToStringFormatter.string(from: date) + config.timeZoneIdentifier
    }
}
