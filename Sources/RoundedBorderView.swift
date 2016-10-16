//
//  RoundedBorderView.swift
//  HDS Work Order
//
//  Created by Andrew J Wagner on 3/19/16.
//  Copyright © 2016 Housing Data Systems. All rights reserved.
//

#if os(iOS)
import UIKit

@IBDesignable open class RoundedBorderView: UIView {
    @IBInspectable public var borderColor: UIColor = UIColor.black {
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

    override open func awakeFromNib() {
        super.awakeFromNib()

        self.update()
    }
}

private extension RoundedBorderView {
    func update() {
        self.layer.borderWidth = 1 / UIScreen.main.scale
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize()
    }
}
#endif
