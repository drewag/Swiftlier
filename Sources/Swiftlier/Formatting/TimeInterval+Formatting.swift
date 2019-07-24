//
//  NSTimeInterval+Formatting.swift
//  Meditate
//
//  Created by Andrew J Wagner on 4/3/16.
//  Copyright © 2016 Learn Brigade. All rights reserved.
//

import Foundation

extension TimeInterval {
    public var seconds: Int {
        return Int(self.truncatingRemainder(dividingBy: 60))
    }

    public var minutes: Int {
        return Int((self / 60).truncatingRemainder(dividingBy: 60))
    }

    public var hours: Int {
        return Int((self / 60 / 60).truncatingRemainder(dividingBy: 60))
    }

    public var days: Int {
        return Int((self / 60 / 60 / 24).truncatingRemainder(dividingBy: 24))

    }

    /// Largest unit
    public var roughly: String {
        if self.days > 1 {
            return "\(self.days) days"
        }
        else if self.days == 1 {
            return "\(self.days) day"
        }
        else if self.hours > 1 {
            return "\(self.hours) hours"
        }
        else if self.hours == 1 {
            return "\(self.hours) hour"
        }
        else if self.minutes > 1 {
            return "\(self.minutes) minutes"
        }
        else if self.minutes == 1 {
            return "\(self.minutes) minute"
        }
        else {
            return "seconds"
        }
    }

    /// H:M with rounded minutes
    public var shortestDisplay: String {
        let minutes = self.minutes + Int((Float(self.seconds) / 60).rounded())
        let hours = self.hours

        var output = ""
        if minutes < 10 {
            output = "0\(minutes)"
        }
        else {
            output = "\(minutes)"
        }
        if hours > 0 {
            if hours < 10 {
                output = "0\(hours):" + output
            }
            else {
                output = "\(hours):" + output
            }
        }
        else {
            output = "0:" + output
        }
        return output
    }

    /// M:S with hours as minutes
    public var shortestWithSeconds: String {
        let seconds = self.seconds
        let minutes = self.minutes + self.hours * 60

        var output = ""
        if seconds < 10 {
            output = "0\(seconds)"
        }
        else {
            output = "\(seconds)"
        }
        if minutes > 0 {
            if minutes < 10 {
                output = "0\(minutes):" + output
            }
            else {
                output = "\(minutes):" + output
            }
        }
        else {
            output = "0:" + output
        }
        return output
    }

    /// Hh Mm Ss hiding smallest units of 0 length
    public var shortDisplay: String {
        let seconds = self.seconds
        let minutes = self.minutes
        let hours = self.hours
        switch self {
        case 0:
            return "0"
        case let x where x < 60:
            return "\(seconds)s"
        case let x where x < 60 * 60:
            if seconds > 0 {
                return "\(minutes)m \(seconds)s"
            }
            return "\(minutes)m"
        default:
            if seconds > 0 {
                return "\(hours)h \(minutes)m \(seconds)s"
            }
            else if minutes > 0 {
                return "\(hours)h \(minutes)m"
            }
            else {
                return "\(hours)h"
            }
        }
    }

    /// Hh Mm
    public var shortDisplayRoundedMinutes: String {
        let minutes = self.minutes + Int((Double(self.seconds)/60).rounded())
        let hours = self.hours
        switch self {
        case 0:
            return "0"
        case let x where x < 60 * 60:
            return "\(minutes)m"
        default:
            if minutes > 0 {
                return "\(hours)h \(minutes)m"
            }
            else {
                return "\(hours)h"
            }
        }
    }

    /// H hours M minutes S seconds
    public var longDisplay: String {
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int((self / 60 / 60).truncatingRemainder(dividingBy: 60))
        switch Int(self) {
        case 0:
            return "0 seconds"
        case 1:
            return "\(seconds) second"
        case let x where x < 60:
            return "\(seconds) seconds"
        case let x where x < 60 * 60:
            var output = ""
            switch minutes {
            case 1:
                output += "1 minute"
            default:
                output += "\(minutes) minutes"
            }
            switch seconds {
            case 0:
                break
            case 1:
                output += ", 1 second"
            default:
                output += ", \(seconds) seconds"
            }
            return output
        default:
            var output = ""
            switch hours {
            case 1:
                output += "1 hour"
            default:
                output += "\(hours) hours"
            }
            switch minutes {
            case 0:
                break
            case 1:
                output += "1 minute"
            default:
                output += "\(minutes) minutes"
            }
            switch seconds {
            case 0:
                break
            case 1:
                output += ", 1 second"
            default:
                output += ", \(seconds) seconds"
            }
            return output
        }
    }
}
