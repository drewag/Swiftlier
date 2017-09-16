//
//  UIView+Layout.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/14/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    public func addFillingSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.bounds
        self.addSubview(view)
        view.constrainToFill(self)
    }

    public func addCenteredView(_ view: UIView, withOffset offset: CGPoint) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.constrainToCenter(of: self)
    }

    @available(*, deprecated, message: "Use UIView constraint extension instead")
    public func addConstraint(forWidth width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(width: width, of: self))
    }

    @available(*, deprecated, message: "Use UIView constraint extension instead")
    public func addConstraint(forHeight height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(height: height, of: self))
    }
}
#endif
