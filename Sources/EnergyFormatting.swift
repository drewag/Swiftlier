//
//  EnergyFormatting.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/3/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

#if os(iOS)
private let energyFormatter = EnergyFormatter()

extension Double {
    public var energyFromCalries: String {
        return energyFormatter.string(fromValue: self, unit: .calorie)
    }
}

extension Int {
    public var energyFromCalories: String {
        return Double(self).energyFromCalries
    }
}

extension Float {
    public var energyFromCalories: String {
        return Double(self).energyFromCalries
    }
}
#endif
