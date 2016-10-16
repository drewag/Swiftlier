//
//  RoundedBorderButton.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/29/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

@IBDesignable class RoundedBorderButton: UIButton {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
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
        self.layer.borderWidth = 1 / UIScreen.main.scale
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = self.cornerRadius
    }
}
#endif
