//
//  UIView+Layout.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/14/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension UIView {
    func addFillingSubview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.bounds
        self.addSubview(view)
        self.addConstraints(NSLayoutConstraint.fillConstraintsWithView(view))
    }
}