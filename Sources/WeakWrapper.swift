//
//  WeakWrapper.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/4/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

public class WeakWrapper {
    weak public var value: AnyObject?
    public init(_ value: AnyObject) {
        self.value = value
    }
}
