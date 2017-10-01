//
//  UIColor+Encodable.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public struct Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }

    public let color: UIColor

    public init(_ color: UIColor) {
        self.color = color
    }

    public func encode(to encoder: Encoder) throws {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Float(red), forKey: .red)
        try container.encode(Float(green), forKey: .green)
        try container.encode(Float(blue), forKey: .blue)
        try container.encode(Float(alpha), forKey: .alpha)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = CGFloat(try container.decode(Float.self, forKey: .red))
        let green = CGFloat(try container.decode(Float.self, forKey: .green))
        let blue = CGFloat(try container.decode(Float.self, forKey: .blue))
        let alpha = CGFloat(try container.decode(Float.self, forKey: .alpha))

        self.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
#endif
