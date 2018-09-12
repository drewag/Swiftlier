//
//  CustomGradientView.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/11/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

public class CustomGradientView: UIView {
    @IBInspectable var startXPercent: CGFloat = 0
    @IBInspectable var startYPercent: CGFloat = 0
    @IBInspectable var endXPercent: CGFloat = 0
    @IBInspectable var endYPercent: CGFloat = 0

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
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.gradientLayer.startPoint = CGPoint(
            x: self.startXPercent,
            y: self.startYPercent
        )
        self.gradientLayer.endPoint = CGPoint(
            x: self.endXPercent,
            y: self.endYPercent
        )
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
#endif
