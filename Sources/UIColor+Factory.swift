//
//  UIColor+Factory.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIColor: ErrorGenerating {}
extension UIColor {
    convenience public init(hex : Int) {
        let blue = CGFloat(hex & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let red = CGFloat((hex >> 16) & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
    }

    convenience public init(hexString: String) throws {
        let withoutHash: String
        if hexString.hasPrefix("#") {
            withoutHash = String(hexString[hexString.index(hexString.startIndex, offsetBy: 1)...])
        }
        else {
            withoutHash = hexString
        }

        let finalHexString: String
        switch withoutHash.count {
            case 2:
                finalHexString = "#" + withoutHash.repeating(nTimes: 3)
            case 3:
                finalHexString = "#" + withoutHash.repeating(nTimes: 2)
            case 6:
                finalHexString = "#" + withoutHash
            default:
                throw UIColor.error("creating color from hex string", because: "it is an invalid length (only 2, 3, or 6 is valid)")
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
