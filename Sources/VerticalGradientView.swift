//
//  VerticalGradientView.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 6/6/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import UIKit

@IBDesignable public class VerticalGradientView: UIView {
    @IBInspectable public var startColor: UIColor = UIColor.red {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var endColor: UIColor = UIColor.blue {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
//        context?.setBlendMode(.sourceAtop)

        let colors = [startColor.cgColor, endColor.cgColor]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]

        let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        )!

        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: rect.height)
        context!.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: CGGradientDrawingOptions()
        )
    }
}
