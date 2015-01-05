//
//  WeakWrapper.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/4/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

class WeakWrapper {
    weak var value: AnyObject?
    init(_ value: AnyObject) {
        self.value = value
    }
}