//
//  NSLayoutContraint+Factory.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/14/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    public class func fullWidthConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options: NSLayoutFormatOptions.DirectionLeftToRight,
            metrics: nil,
            views:["view": view]
        )
    }

    public class func fullHeightConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options: NSLayoutFormatOptions.DirectionLeftToRight,
            metrics: nil,
            views:["view": view]
        )
    }

    public class func fillConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return self.fullWidthConstraintsWithView(view) + self.fullHeightConstraintsWithView(view)
    }

    public class func centerConstraintsWithView(view1: UIView, inView view2: UIView, withOffset offset: CGPoint) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: view1, attribute: .CenterX, relatedBy: .Equal, toItem: view2, attribute: .CenterX, multiplier: 1, constant: offset.x),
            NSLayoutConstraint(item: view1, attribute: .CenterY, relatedBy: .Equal, toItem: view2, attribute: .CenterY, multiplier: 1, constant: offset.y),
        ]
    }

    public convenience init(sameWidthForView view1: UIView, andView view2: UIView, difference: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Width,
            multiplier: 1,
            constant: difference
        )
    }

    public convenience init(sameHeightForView view1: UIView, andView view2: UIView, difference: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Height,
            multiplier: 1,
            constant: difference
        )
    }

    public convenience init(rightOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view2,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: view1,
            attribute: .Right,
            multiplier: 1,
            constant: distance
        )
    }

    public convenience init(rightOfView view1: UIView, toLeftOfView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Left,
            multiplier: 1,
            constant: distance
        )
    }

    public convenience init(leftOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Left,
            multiplier: 1,
            constant: distance
        )
    }

    public convenience init(topOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view2,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: view1,
            attribute: .Top,
            multiplier: 1,
            constant: distance
        )
    }

    public convenience init(leftOfView view1: UIView, toRightOfView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Right,
            multiplier: 1,
            constant: distance
        )
    }

    public convenience init(bottomOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Bottom,
            multiplier: 1,
            constant: distance
        )
    }

    public convenience init(verticalCenterOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
        self.init(
            item: view1,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .CenterY,
            multiplier: 1,
            constant: distance
        )
    }
}
