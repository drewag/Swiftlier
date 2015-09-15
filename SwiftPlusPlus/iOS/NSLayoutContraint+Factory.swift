//
//  NSLayoutContraint+Factory.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/14/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    class func fullWidthConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options: NSLayoutFormatOptions.DirectionLeftToRight,
            metrics: nil,
            views:["view": view]
        )
    }

    class func fullHeightConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options: NSLayoutFormatOptions.DirectionLeftToRight,
            metrics: nil,
            views:["view": view]
        )
    }

    class func fillConstraintsWithView(view: UIView) -> [NSLayoutConstraint] {
        return self.fullWidthConstraintsWithView(view) + self.fullHeightConstraintsWithView(view)
    }

    convenience init(sameWidthForView view1: UIView, andView view2: UIView) {
        self.init(
            item: view1,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view2,
            attribute: .Width,
            multiplier: 1,
            constant: 0
        )
    }

    convenience init(rightOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
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

    convenience init(leftOfView view1: UIView, toView view2: UIView, distance: CGFloat = 0) {
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
}