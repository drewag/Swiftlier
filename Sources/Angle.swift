//
//  Angle.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/8/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import Foundation
#endif

public protocol AngleValue: FloatingPoint, ExpressibleByFloatLiteral {
    var cosine: Self {get}
    var sine: Self {get}
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
    func truncatingRemainder(dividingBy other: Self) -> Self
}

public let π = Angle(radians: Float.pi)

public struct Angle<Value: AngleValue>: Equatable, Comparable {
    public enum Unit {
        case radians
        case degrees
    }

    public static var zero: Angle<Value> {
        return Angle(radians: 0)
    }

    fileprivate let value: Value
    fileprivate let unit: Unit

    fileprivate init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }

    public init(radians: Value) {
        self.value = radians
        self.unit = .radians
    }

    public init(degrees: Value) {
        self.value = degrees
        self.unit = .degrees
    }

    public var degrees: Value {
        switch self.unit {
        case .degrees:
            return self.value
        case .radians:
            return self.value * 180 / .pi
        }
    }

    public var radians: Value {
        switch self.unit {
        case .degrees:
            return self.value * .pi / 180
        case .radians:
            return self.value
        }
    }

    public var cosine: Value {
        return self.radians.cosine
    }

    public var sine: Value {
        return self.radians.sine
    }
}

public func ==<Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Bool {
    let left = lhs.normalized(in: lhs.unit)
    let right = rhs.normalized(in: lhs.unit)
    return left == right
}

public func <<Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Bool {
    let left = lhs.normalized(in: lhs.unit)
    let right = rhs.normalized(in: lhs.unit)
    return left < right
}

public func <=<Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Bool {
    let left = lhs.normalized(in: lhs.unit)
    let right = rhs.normalized(in: lhs.unit)
    return left <= right
}

public func ><Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Bool {
    let left = lhs.normalized(in: lhs.unit)
    let right = rhs.normalized(in: lhs.unit)
    return left > right
}

public func >=<Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Bool {
    let left = lhs.normalized(in: lhs.unit)
    let right = rhs.normalized(in: lhs.unit)
    return left >= right
}

public func +<Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
    if lhs.unit == rhs.unit {
        return Angle(value: Angle.normalized(lhs.value + rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        return Angle(radians: Angle.normalized(lhs.radians + rhs.radians, with: .radians))
    }
}

public func +=<Value: AngleValue>( lhs: inout Angle<Value>, rhs: Angle<Value>) {
    if lhs.unit == rhs.unit {
        lhs = Angle(value: Angle.normalized(lhs.value + rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        lhs = Angle(radians: Angle.normalized(lhs.radians + rhs.radians, with: .radians))
    }
}

public func -<Value: AngleValue>(lhs: Angle<Value>, rhs: Angle<Value>) -> Angle<Value> {
    if lhs.unit == rhs.unit {
        return Angle(value: Angle.normalized(lhs.value - rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        return Angle(radians: Angle.normalized(lhs.radians - rhs.radians, with: .radians))
    }
}

public func -=<Value: AngleValue>( lhs: inout Angle<Value>, rhs: Angle<Value>) {
    if lhs.unit == rhs.unit {
        lhs = Angle(value: Angle.normalized(lhs.value - rhs.value, with: lhs.unit), unit: lhs.unit)
    }
    else {
        lhs = Angle(radians: Angle.normalized(lhs.radians - rhs.radians, with: .radians))
    }
}

public func /<Value: AngleValue>(lhs: Angle<Value>, rhs: Value) -> Angle<Value> {
    return Angle(value: Angle.normalized(lhs.value / rhs, with: lhs.unit), unit: lhs.unit)
}

public func /=<Value: AngleValue>( lhs: inout Angle<Value>, rhs: Value) {
    lhs = Angle(value: Angle.normalized(lhs.value / rhs, with: lhs.unit), unit: lhs.unit)
}

public func *<Value: AngleValue>(lhs: Angle<Value>, rhs: Value) -> Angle<Value> {
    return Angle(value: Angle.normalized(lhs.value * rhs, with: lhs.unit), unit: lhs.unit)
}

public func *=<Value: AngleValue>( lhs: inout Angle<Value>, rhs: Value) {
    lhs = Angle(value: Angle.normalized(lhs.value * rhs, with: lhs.unit), unit: lhs.unit)
}

extension Float: AngleValue {
    public var sine: Float {
        return sin(self)
    }

    public var cosine: Float {
        return cos(self)
    }
}

extension Double: AngleValue {
    public var sine: Double {
        return sin(self)
    }

    public var cosine: Double {
        return cos(self)
    }
}

extension CGFloat: AngleValue {
    public var sine: CGFloat {
        return sin(self)
    }

    public var cosine: CGFloat {
        return cos(self)
    }
}

private extension Angle {
    static func normalized(_ value: Value, with unit: Unit) -> Value {
        switch unit {
        case .degrees:
            return value.truncatingRemainder(dividingBy: 360)
        case .radians:
            return value.truncatingRemainder(dividingBy: 2 * .pi)
        }
    }

    func normalized(in unit: Unit) -> Value {
        switch unit {
        case .degrees:
            return Angle.normalized(self.degrees, with: .degrees)
        case .radians:
            return Angle.normalized(self.radians, with: .radians)
        }
    }
}
