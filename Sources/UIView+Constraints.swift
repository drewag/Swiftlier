//
//  UIView+Constraints.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/15/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    @discardableResult
    public func constrainToFullWidth(of container: UIView, insetBy inset: CGFloat = 0, active: Bool = true) -> [NSLayoutConstraint] {
        return [
            container.constrain(.left, of: self, plus: inset, active: active),
            container.constrain(.right, of: self, plus: -inset, active: active),
        ]
    }

    @discardableResult
    public func constrainToFullHeight(of container: UIView, insetBy inset: CGFloat = 0, active: Bool = true) -> [NSLayoutConstraint] {
        return [
            container.constrain(.top, of: self, plus: inset, active: active),
            container.constrain(.bottom, of: self, plus: -inset, active: active),
        ]
    }

    @discardableResult
    public func constrainToFill(_ container: UIView, insetBy inset: CGPoint = CGPoint(), active: Bool = true) -> [NSLayoutConstraint] {
        return self.constrainToFullWidth(of: container, insetBy: inset.x, active: active)
            + self.constrainToFullHeight(of: container, insetBy: inset.y, active: active)
    }

    @discardableResult
    public func constrainToCenter(of container: UIView, offsetBy offset: CGPoint = CGPoint(), active: Bool = true) -> [NSLayoutConstraint] {
        return [
            container.constrain(.centerX, of: self, plus: offset.x, active: active),
            container.constrain(.centerY, of: self, plus: offset.y, active: active),
        ]
    }

    @discardableResult
    public func constrain(_ attribute: NSLayoutAttribute, of view: UIView, relatedBy: NSLayoutRelation = .equal, multiplier: CGFloat = 1, plus: CGFloat = 0, active: Bool = true) -> NSLayoutConstraint {
        return NSLayoutConstraint(attribute, of: self, to: attribute, of: view, relatedBy: relatedBy, multiplier: multiplier, plus: -plus, active: active)
    }

    @discardableResult
    public func constrain(_ attributes: [NSLayoutAttribute], of view: UIView, relatedBy: NSLayoutRelation = .equal, multiplier: CGFloat = 1, plus: CGFloat = 0, active: Bool = true) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        for attribute in attributes {
            constraints.append(self.constrain(attribute, of: view, relatedBy: relatedBy, multiplier: multiplier, plus: plus, active: active))
        }

        return constraints
    }

    @discardableResult
    public func constrain(_ attribute: NSLayoutAttribute, to constant: CGFloat, relatedBy: NSLayoutRelation = .equal, multiplier: CGFloat = 1, active: Bool = true) -> NSLayoutConstraint {
        return type(of: self).finalize(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant), active: active)
    }
}

private extension UIView {
    static func finalize(_ constraints: [NSLayoutConstraint], active: Bool) -> [NSLayoutConstraint] {
        for constraint in constraints {
            constraint.isActive = active
        }
        return constraints
    }

    static func finalize(_ constraint: NSLayoutConstraint, active: Bool) -> NSLayoutConstraint {
        constraint.isActive = active
        return constraint
    }
}
#endif
