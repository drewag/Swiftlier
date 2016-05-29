//
//  RoundedBorderButton.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/29/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import UIKit

@IBDesignable class RoundedBorderButton: UIButton {
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            self.update()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            self.update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.update()
    }
}

private extension RoundedBorderButton {
    func update() {
        self.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        self.layer.borderColor = self.borderColor.CGColor
        self.layer.cornerRadius = self.cornerRadius
    }
}