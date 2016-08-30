//
//  ShadowView.swift
//  HDS Work Order
//
//  Created by Andrew J Wagner on 3/23/16.
//  Copyright © 2016 Housing Data Systems. All rights reserved.
//

import UIKit

@IBDesignable public class ShadowView: UIView {
    @IBInspectable public var shadowColor: UIColor = UIColor.blackColor() {
        didSet {
            self.update()
        }
    }

    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            self.update()
        }
    }

    @IBInspectable public var shadowOffsetX: CGFloat = 0 {
        didSet {
            self.update()
        }
    }

    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            self.update()
        }
    }

    @IBInspectable public var shadowRadius: CGFloat = 5 {
        didSet {
            self.update()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        self.update()
    }
}

private extension ShadowView {
    func update() {
        self.layer.shadowColor = self.shadowColor.CGColor
        self.layer.shadowOffset = CGSize(width: self.shadowOffsetX, height: self.shadowOffsetY)
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowRadius = self.shadowRadius
    }
}