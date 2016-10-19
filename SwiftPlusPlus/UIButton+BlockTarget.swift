//
//  UIButton+BlockTarget.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/19/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import UIKit
import ObjectiveC

var ActionBlockKey: UInt8 = 0

private class ActionBlockWrapper: NSObject {
    let block: () -> ()

    init(block: () -> ()) {
        self.block = block
    }
}

extension UIButton {
    public func addBlock(forControlEvents events: UIControlEvents = .TouchUpInside, block: () -> ()) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(handleBlockCall), forControlEvents: events)
    }

    public func handleBlockCall() {
        let wrapper =  objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block()
    }
}
