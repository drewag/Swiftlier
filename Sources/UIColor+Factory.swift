//
//  UIColor+Factory.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIColor {
    convenience public init(hex : Int) {
        let blue = CGFloat(hex & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let red = CGFloat((hex >> 16) & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
    }

    convenience public init(hexString: String) throws {
        if !hexString.hasPrefix("#") {
            throw NSError(domain: "UIColor.init(hexString:)", code: 0, userInfo: [NSLocalizedDescriptionKey:"Missing # prefix"])
        }

        var finalHexString = hexString
        let length = hexString.characters.count
        switch length {
            case 3:
                finalHexString = "#" + hexString.substring(from: 1).repeating(nTimes: 3)
            case 4:
                finalHexString = "#" + hexString.substring(from: 1).repeating(nTimes: 2)
            case 7:
                break
            default:
                throw NSError(domain: "UIColor.init(hexString:)", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid length (only 2, 3, or 6 is valid)"])
        }

        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: finalHexString)
        scanner.scanLocation = 1 // bypass '#' character
        scanner.scanHexInt32(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha:1.0)
    }

    public func darker(byPercent percent: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: max(brightness - percent, 0), alpha: alpha)
    }

    public func lighter(byPercent percent: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: min(brightness + percent, 1), alpha: alpha)
    }
}
#endif
