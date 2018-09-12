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

    @IBInspectable public var roundTopLeft: Bool = true
    @IBInspectable public var roundTopRight: Bool = true
    @IBInspectable public var roundBottomLeft: Bool = true
    @IBInspectable public var roundBottomRight: Bool = true

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

        if #available(iOS 11.0, *) {
            var corners = CACornerMask()
            if self.roundTopLeft {
                corners.insert(.layerMinXMinYCorner)
            }
            if self.roundTopRight {
                corners.insert(.layerMaxXMinYCorner)
            }
            if self.roundBottomLeft {
                corners.insert(.layerMinXMaxYCorner)
            }
            if self.roundBottomRight {
                corners.insert(.layerMaxXMaxYCorner)
            }
            self.layer.maskedCorners = corners
        }
    }
}
#endif
