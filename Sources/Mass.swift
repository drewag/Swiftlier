//
//  Mass.swift
//  web
//
//  Created by Andrew J Wagner on 7/9/17.
//
//

import Foundation

public struct Mass {
    public enum Unit: Int, CustomStringConvertible {
        case grams = 11
        case kilograms = 14
        case ounces = 1537
        case pounds = 1538
        case stones = 1539

        public var description: String {
            switch self {
            case .grams:
                return "g"
            case .kilograms:
                return "kg"
            case .ounces:
                return "oz"
            case .pounds:
                return "lb"
            case .stones:
                return "st"
            }
        }
    }

    public let unit: Unit
    private(set) var value: Double

    public init(_ value: Double, in unit: Unit) {
        self.unit = unit
        self.value = value
    }

    public func description(in unit: Unit) -> String {
        switch unit {
        case .grams:
            return "\(Int(round(self.grams))) \(unit)"
        case .kilograms:
            return "\(Int(round(self.kilograms))) \(unit)"
        case .ounces:
            return "\(Int(round(self.ounces))) \(unit)"
        case .pounds:
            return "\(Int(round(self.pounds))) \(unit)"
        case .stones:
            return "\(Int(round(self.stones))) \(unit)"
        }
    }


    public func `in`(_ unit: Unit) -> Double {
        switch unit {
        case .grams:
            return self.grams
        case .kilograms:
            return self.kilograms
        case .ounces:
            return self.ounces
        case .pounds:
            return self.pounds
        case .stones:
            return self.stones
        }
    }

    public var grams: Double {
        switch self.unit {
        case .grams:
            return self.value
        case .kilograms:
            return self.value / 1000
        case .ounces:
            return self.value / 0.035274
        case .pounds:
            return self.value / 0.0022046
        case .stones:
            return self.value / 0.00015747
        }
    }

    public var kilograms: Double {
        switch self.unit {
        case .grams:
            return self.value / 1000
        case .kilograms:
            return self.value
        case .ounces:
            return self.value / 35.274
        case .pounds:
            return self.value / 2.2046
        case .stones:
            return self.value / 0.15747
        }
    }

    public var ounces: Double {
        switch self.unit {
        case .grams:
            return self.value / 28.34952
        case .kilograms:
            return self.value / 0.02834952
        case .ounces:
            return self.value
        case .pounds:
            return self.value * 16
        case .stones:
            return self.value * 224
        }
    }

    public var pounds: Double {
        switch self.unit {
        case .grams:
            return self.value / 28.34952 / 16
        case .kilograms:
            return self.value / 0.02834952 / 16
        case .ounces:
            return self.value / 16
        case .pounds:
            return self.value
        case .stones:
            return self.value * 14
        }
    }

    public var stones: Double {
        switch self.unit {
        case .grams:
            return self.value / 28.34952 / 224
        case .kilograms:
            return self.value / 0.02834952 / 224
        case .ounces:
            return self.value / 224
        case .pounds:
            return self.value / 14
        case .stones:
            return self.value
        }
    }
}
