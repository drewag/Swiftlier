//
//  UIView+Drawing.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 10/24/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    public func scaledRound(_ value: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return round(value * scale) / scale
    }

    public func scaledFloor(_ value: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return floor(value * scale) / scale
    }

    public func scaledCeil(_ value: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return ceil(value * scale) / scale
    }
}

extension CGContext {
    public func draw(text: String, at: CGPoint, alignment: NSTextAlignment, size: CGFloat = 12, color: UIColor = .black, weight: UIFont.Weight = .regular, rotation: CGFloat = 0) {
        let labelAttributes: [NSAttributedStringKey:Any] = [
            .font:UIFont.systemFont(ofSize: size, weight: weight),
            .foregroundColor: color,
        ]
        let size = (text as NSString).size(withAttributes: labelAttributes)
        let rotationPoint: CGPoint
        let x: CGFloat
        switch alignment {
        case .center:
            x = at.x
            rotationPoint = CGPoint(x: -size.width / 2, y: -size.height / 2)
        case .left, .natural, .justified:
            x = at.x - size.width / 2
            rotationPoint = CGPoint(x: size.width / 2, y: -size.height / 2)
        case .right:
            x = at.x - size.width * 1.5
            rotationPoint = CGPoint(x: size.width / 2, y: -size.height / 2)
        }
        self.saveGState()
        self.translateBy(x: x, y: at.y)
        self.rotate(by: rotation)
        (text as NSString).draw(at: rotationPoint, withAttributes: labelAttributes)
        self.restoreGState()
    }
}
#endif
