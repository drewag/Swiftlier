//
//  ThinLayoutConstraint.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/29/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

class ThinLayoutConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        self.constant = 1 / UIScreen.main.scale
    }
}
#endif
