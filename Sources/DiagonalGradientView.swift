//
//  DiagonalGradientView.swift
//  OnBeat
//
//  Created by Andrew J Wagner on 4/23/16.
//  Copyright © 2016 Chronos Interactive. All rights reserved.
//

import UIKit

@IBDesignable
public class DiagonalGradientView: UIView {
    @IBInspectable
    public var startColor: UIColor = UIColor.red {
        didSet {
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    public var endColor: UIColor = UIColor.blue {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

    private var colors: [CGColor] {
        return [startColor.cgColor, endColor.cgColor]
    }

    public override func awakeFromNib() {
        self.gradientLayer.colors = self.colors
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }

    public func animate(toStart startColor: UIColor?, andEnd endColor: UIColor?, withDuration duration: TimeInterval) {
        let fromColors = self.gradientLayer.presentation()?.colors ?? self.colors
        let toColors = [startColor?.cgColor ?? self.startColor.cgColor, endColor?.cgColor ?? self.endColor.cgColor]
        self.gradientLayer.colors = toColors

        let animation = CABasicAnimation(keyPath: "colors")

        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.isCumulative = true

        self.gradientLayer.add(animation, forKey: "animateColors")
    }
}
