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
