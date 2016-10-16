//
//  UIView+Layout.swift
//  SwiftPlusPlus
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
        self.addConstraints(NSLayoutConstraint.fill(with: view))
    }

    public func addCenteredView(_ view: UIView, withOffset offset: CGPoint) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints(NSLayoutConstraint.center(with: view, in: self, withOffset: offset))
    }
}
#endif
