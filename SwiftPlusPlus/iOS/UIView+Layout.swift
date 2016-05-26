//
//  UIView+Layout.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/14/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension UIView {
    public func addFillingSubview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.bounds
        self.addSubview(view)
        self.addConstraints(NSLayoutConstraint.fillConstraintsWithView(view))
    }

    public func addCenteredView(view: UIView, withOffset offset: CGPoint) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints(NSLayoutConstraint.centerConstraintsWithView(view, inView: self, withOffset: offset))
    }
}