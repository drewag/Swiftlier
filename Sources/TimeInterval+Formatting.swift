//
//  NSTimeInterval+Formatting.swift
//  Meditate
//
//  Created by Andrew J Wagner on 4/3/16.
//  Copyright © 2016 Learn Brigade. All rights reserved.
//

import Foundation

extension TimeInterval {
    public var displayString: String {
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
        let hours = Int((self / 60 / 60).truncatingRemainder(dividingBy: 60))
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
}
