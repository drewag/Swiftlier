//
//  CircleBorderView.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/30/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

open class CircleBorderView: UIView {
    @IBInspectable public var borderColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }

    var color: UIColor!

    override open func awakeFromNib() {
        super.awakeFromNib()

        self.color = self.backgroundColor ?? UIColor.clear
        self.backgroundColor = UIColor.clear
    }

    open override func draw(_ rect: CGRect) {
        let lineSize = 1 / UIScreen.main.scale
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }

        let radius = min(rect.width, rect.height) - lineSize
        let circleRect = CGRect(
            x: (rect.width - radius) / 2,
            y: (rect.height - radius) / 2,
            width: radius,
            height: radius
        )
        ctx.addEllipse(in: circleRect)
        ctx.setLineWidth(lineSize)
        ctx.setFillColor(self.color.cgColor)
        ctx.setStrokeColor(self.borderColor.cgColor)
        ctx.drawPath(using: .fillStroke)
    }
}
#endif
