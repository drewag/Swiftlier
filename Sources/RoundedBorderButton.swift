//
//  RoundedBorderButton.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 5/29/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

@IBDesignable
public class RoundedBorderButton: UIButton {

    @IBInspectable
    public  var borderColor: UIColor = UIColor.clear {
        didSet {
            self.update()
        }
    }

    @IBInspectable
    public var borderSize: CGFloat = 1 / UIScreen.main.scale {
        didSet {
            self.update()
        }
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 10 {
        didSet {
            self.update()
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        self.update()
    }
}

private extension RoundedBorderButton {
    func update() {
        self.layer.borderWidth = self.borderSize
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = self.cornerRadius
    }
}
#endif
