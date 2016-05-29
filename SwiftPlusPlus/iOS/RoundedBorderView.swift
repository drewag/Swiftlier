//
//  RoundedBorderView.swift
//  HDS Work Order
//
//  Created by Andrew J Wagner on 3/19/16.
//  Copyright © 2016 Housing Data Systems. All rights reserved.
//

import UIKit

@IBDesignable class RoundedBorderView: UIView {
    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
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

private extension RoundedBorderView {
    func update() {
        self.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        self.layer.borderColor = self.borderColor.CGColor
        self.layer.cornerRadius = self.cornerRadius
    }
}
