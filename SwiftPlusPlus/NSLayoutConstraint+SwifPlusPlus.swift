//
//  NSLayoutConstraint+SwifPlusPlus.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/11/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    @available(iOS 8.0, *)
    public func setMultiplier(multiplier:CGFloat) {
        NSLayoutConstraint.deactivateConstraints([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = self.priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.active = self.active

        NSLayoutConstraint.activateConstraints([newConstraint])
    }
}
