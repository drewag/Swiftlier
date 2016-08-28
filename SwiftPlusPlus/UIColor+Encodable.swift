//
//  UIColor+Encodable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct Color: EncodableType {
    public let color: UIColor

    public init(_ color: UIColor) {
        self.color = color
    }

    private struct Keys {
        struct red: CoderKeyType { typealias ValueType = Float }
        struct green: CoderKeyType { typealias ValueType = Float }
        struct blue: CoderKeyType { typealias ValueType = Float }
        struct alpha: CoderKeyType { typealias ValueType = Float }
    }

    public func encode(encoder: EncoderType) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        encoder.encode(Float(red), forKey: Keys.red.self)
        encoder.encode(Float(green), forKey: Keys.green.self)
        encoder.encode(Float(blue), forKey: Keys.blue.self)
        encoder.encode(Float(alpha), forKey: Keys.alpha.self)
    }

    public init?(decoder: DecoderType) {
        let red = CGFloat(decoder.decode(Keys.red.self))
        let green = CGFloat(decoder.decode(Keys.red.self))
        let blue = CGFloat(decoder.decode(Keys.red.self))
        let alpha = CGFloat(decoder.decode(Keys.red.self))

        self.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}