//
//  Angle.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/8/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Foundation
#endif

public let π = Angle(radians: Float(M_PI))

public struct Angle: Equatable, Comparable {
    public enum Unit {
        case radians
        case degrees
    }

    public static let zero = Angle(radians: 0 as Float)

    fileprivate let value: Float
    fileprivate let unit: Unit

    fileprivate init(value: Float, unit: Unit) {
        self.value = value
        self.unit = unit
    }

    public init(radians: CGFloat) {
        self.init(radians: Float(radians))
    }

    public init(radians: Float) {
        self.value = Angle.normalized(radians, with: .radians)
        self.unit = .radians
    }

    public init(degrees: CGFloat) {
        self.init(degrees: Float(degrees))
    }

    public init(degrees: Float) {
        self.value = Angle.normalized(degrees, with: .degrees)
        self.unit = .degrees
    }

    public func degrees() -> Float {
        switch self.unit {
        case .degrees:
            return self.value
        case .radians:
            return self.value * 180 / Float(M_PI)
        }
    }

    public func degrees() -> CGFloat {
        return CGFloat(self.degrees() as Float)
    }

    public func radians() -> Float {
        switch self.unit {
        case .degrees:
            return self.value * Float(M_PI) / 180
        case .radians:
            return self.value
        }
    }

    public func radians() -> CGFloat {
        return CGFloat(self.radians() as Float)
    }

    public func cosine() -> Float {
        return cos(self.radians())
    }

    public func sine() -> Float {
        return sin(self.radians())
    }

    public func cosine() -> CGFloat {
        return CGFloat(self.cosine() as Float)
    }

    public func sine() -> CGFloat {
        return CGFloat(self.sine() as Float)
    }

    fileprivate static func normalized(_ value: Float, with unit: Unit) -> Float {
        switch unit {
        case .degrees:
            if value < 0 {
                return value + 360
            }
            else if value > 360 {
                return value - 360
            }
            else {
                return value
            }
        case .radians:
            if value < 0 {
                return value + Float(2 * M_PI)
            }
            else if value > Float(2 * M_PI) {
                return value - Float(2 * M_PI)
            }
            else {
                return value
            }
        }
    }
}

public func ==(lhs: Angle, rhs: Angle) -> Bool {
    if lhs.unit == rhs.unit {
        return lhs.value == rhs.value
    }
    else {
        return lhs.radians() == rhs.radians() as Float
    }
}

public func <(lhs: Angle, rhs: Angle) -> Bool {
    if lhs.unit == rhs.unit {
        return lhs.value < rhs.value
    }
    else {
        return lhs.radians() < rhs.radians() as Float
    }
}

public func <=(lhs: Angle, rhs: Angle) -> Bool {
    if lhs.unit == rhs.unit {
        return lhs.value <= rhs.value
    }
    else {
        return lhs.radians() <= rhs.radians() as Float
    }
}

public func >(lhs: Angle, rhs: Angle) -> Bool {
    if lhs.unit == rhs.unit {
        return lhs.value > rhs.value
    }
    else {
        return lhs.radians() > rhs.radians() as Float
    }
}

public func >=(lhs: Angle, rhs: Angle) -> Bool {
    if lhs.unit == rhs.unit {
        return lhs.value >= rhs.value
    }
    else {
        return lhs.radians() >= rhs.radians() as Float
    }
}

public func +(lhs: Angle, rhs: Angle) -> Angle {
    if lhs.unit == rhs.unit {
        return Angle(value: Angle.normalized(lhs.value + rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        return Angle(radians: Angle.normalized(lhs.radians() + rhs.radians(), with: .radians))
    }
}

public func +=( lhs: inout Angle, rhs: Angle) {
    if lhs.unit == rhs.unit {
        lhs = Angle(value: Angle.normalized(lhs.value + rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        lhs = Angle(radians: Angle.normalized(lhs.radians() + rhs.radians(), with: .radians))
    }
}

public func -(lhs: Angle, rhs: Angle) -> Angle {
    if lhs.unit == rhs.unit {
        return Angle(value: lhs.value - rhs.value, unit: lhs.unit)
    }
    else {
        return Angle(radians: (lhs.radians() - rhs.radians()) as Float)
    }
}

public func -=( lhs: inout Angle, rhs: Angle) {
    if lhs.unit == rhs.unit {
        lhs = Angle(value: Angle.normalized(lhs.value - rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        lhs = Angle(radians: Angle.normalized(lhs.radians() - rhs.radians(), with: .radians))
    }
}

public func /(lhs: Angle, rhs: Angle) -> Angle {
    if lhs.unit == rhs.unit {
        return Angle(value: Angle.normalized(lhs.value / rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        return Angle(radians: Angle.normalized(lhs.radians() / rhs.radians(), with: .radians))
    }
}

public func *(lhs: Angle, rhs: Angle) -> Angle {
    if lhs.unit == rhs.unit {
        return Angle(value: Angle.normalized(lhs.value * rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        return Angle(radians: Angle.normalized(lhs.radians() * rhs.radians(), with: .radians))
    }
}

public func /(lhs: Angle, rhs: Float) -> Angle {
    return Angle(value: Angle.normalized(lhs.value / rhs, with: lhs.unit), unit: lhs.unit)
}

public func *(lhs: Angle, rhs: Float) -> Angle {
    return Angle(value: Angle.normalized(lhs.value * rhs, with: lhs.unit), unit: lhs.unit)
}
