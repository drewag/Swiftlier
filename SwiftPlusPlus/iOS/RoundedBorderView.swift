//
//  RoundedBorderView.swift
//  HDS Work Order
//
//  Created by Andrew J Wagner on 3/19/16.
//  Copyright © 2016 Housing Data Systems. All rights reserved.
//

import UIKit

@IBDesignable public class RoundedBorderView: UIView {
    @IBInspectable public var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.update()
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 10 {
        didSet {
            self.update()
        }
    }

    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            self.update()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        self.update()
    }
}

private extension RoundedBorderView {
    func update() {
        self.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        self.layer.borderColor = self.borderColor.CGColor
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize()
    }
}
