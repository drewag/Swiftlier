//
//  UIColor+Factory.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(hex : Int) {
        let blue = CGFloat(hex & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let red = CGFloat((hex >> 16) & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
    }

    convenience init?(var hexString: String) {
        if !hexString.hasPrefix("#") {
            return nil
        }

        let length = hexString.characters.count
        switch length {
            case 3:
                hexString = "#" + hexString.substringFromIndex(1).stringByRepeatingNTimes(3)
            case 4:
                hexString = "#" + hexString.substringFromIndex(1).stringByRepeatingNTimes(2)
            case 7:
                break
            default:
                return nil
        }

        var rgbValue: UInt32 = 0
        let scanner = NSScanner(string: hexString)
        scanner.scanLocation = 1 // bypass '#' character
        scanner.scanHexInt(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha:1.0)
    }

    func darkerByPercent(percent: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: max(brightness - percent, 0), alpha: alpha)
    }
}