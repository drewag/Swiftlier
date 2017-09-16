//
//  NSLayoutContraint+Factory.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/14/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

extension NSLayoutConstraint {
    @discardableResult
    public convenience init(_ attribute: NSLayoutAttribute, of view1: UIView, to otherAttribute: NSLayoutAttribute, of view2: UIView, relatedBy: NSLayoutRelation = .equal, multiplier: CGFloat = 1, plus: CGFloat = 0, active: Bool = true) {
        self.init(
            item: view1,
            attribute: attribute,
            relatedBy: relatedBy,
            toItem: view2,
            attribute: otherAttribute,
            multiplier: multiplier,
            constant: plus
        )
        self.isActive = active
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public class func fullWidth(with view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
            options: NSLayoutFormatOptions.directionLeftToRight,
            metrics: nil,
            views:["view": view]
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public class func fullHeight(with view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
            options: NSLayoutFormatOptions.directionLeftToRight,
            metrics: nil,
            views:["view": view]
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public class func fill(with view: UIView) -> [NSLayoutConstraint] {
        return self.fullWidth(with: view) + self.fullHeight(with: view)
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public class func center(with view1: UIView, in view2: UIView, withOffset offset: CGPoint) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: view1, attribute: .centerX, relatedBy: .equal, toItem: view2, attribute: .centerX, multiplier: 1, constant: offset.x),
            NSLayoutConstraint(item: view1, attribute: .centerY, relatedBy: .equal, toItem: view2, attribute: .centerY, multiplier: 1, constant: offset.y),
        ]
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(sameWidthFor view1: UIView, and view2: UIView, difference: CGFloat = 0, multiplier: CGFloat = 1) {
        self.init(
            item: view1,
            attribute: .width,
            relatedBy: .equal,
            toItem: view2,
            attribute: .width,
            multiplier: multiplier,
            constant: difference
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(sameHeightFor view1: UIView, and view2: UIView, difference: CGFloat = 0, multiplier: CGFloat = 1) {
        self.init(
            item: view1,
            attribute: .height,
            relatedBy: .equal,
            toItem: view2,
            attribute: .height,
            multiplier: multiplier,
            constant: difference
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(rightOf view1: UIView, to view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view2,
            attribute: .right,
            relatedBy: .equal,
            toItem: view1,
            attribute: .right,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(rightOf view1: UIView, toLeftOf view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .right,
            relatedBy: .equal,
            toItem: view2,
            attribute: .left,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(leftOf view1: UIView, to view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .left,
            relatedBy: .equal,
            toItem: view2,
            attribute: .left,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(topOf view1: UIView, to view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view2,
            attribute: .top,
            relatedBy: .equal,
            toItem: view1,
            attribute: .top,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(leftOf view1: UIView, toRightOf view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .left,
            relatedBy: .equal,
            toItem: view2,
            attribute: .right,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(bottomOf view1: UIView, to view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view2,
            attribute: .bottom,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(bottomOf view1: UIView, toTopOf view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view2,
            attribute: .top,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(verticalCenterOf view1: UIView, to view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view2,
            attribute: .centerY,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(horizontalCenterOf view1: UIView, to view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view2,
            attribute: .centerX,
            multiplier: 1,
            constant: distance
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(width: CGFloat, of view: UIView, multiplier: CGFloat = 1) {
        self.init(
            item: view,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: multiplier,
            constant: width
        )
    }

    @available(*, deprecated, message: "Use init(:of:to:) or UIView extension instead")
    public convenience init(height: CGFloat, of view: UIView, multiplier: CGFloat = 1) {
        self.init(
            item: view,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: multiplier,
            constant: height
        )
    }
}
#endif
