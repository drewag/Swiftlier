//
//  CustomGradientView.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/11/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

open class CustomGradientView: UIView {
    @IBInspectable public var startXPercent: CGFloat = 0
    @IBInspectable public var startYPercent: CGFloat = 0
    @IBInspectable public var endXPercent: CGFloat = 1
    @IBInspectable public var endYPercent: CGFloat = 1

    @IBInspectable
    public var startColor: UIColor = UIColor.red {
        didSet {
            self.refresh()
        }
    }

    @IBInspectable
    public var endColor: UIColor = UIColor.blue {
        didSet {
            self.refresh()
        }
    }

    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

    private var colors: [CGColor] {
        return [startColor.cgColor, endColor.cgColor]
    }

    open override func awakeFromNib() {
        self.refresh()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        self.refresh()

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

private extension CustomGradientView {
    func refresh()  {
        self.gradientLayer.colors = self.colors
    }
}
#endif
