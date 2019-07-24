//
//  HeartRateFormatter.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

public class HeartRateFormatter: Formatter {
    override public func string(for obj: Any?) -> String? {
        if let number = obj {
            return "\(number) bpm"
        }
        return nil
    }
}
