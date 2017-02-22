//
//  UIBarButtonItem+BlockTarget.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/21/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit
import ObjectiveC

private var ActionBlockKey: UInt8 = 0

class ActionBlockTarget: NSObject {
    let block: () -> ()

    init(block: @escaping () -> ()) {
        self.block = block
    }

    func handleBlockCall() {
        block()
    }
}

extension UIBarButtonItem {
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, target: @escaping () -> ()) {
        let target = ActionBlockTarget(block: target)
        self.init(barButtonSystemItem: systemItem, target: target, action: #selector(ActionBlockTarget.handleBlockCall))
        objc_setAssociatedObject(self, &ActionBlockKey, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
#endif
