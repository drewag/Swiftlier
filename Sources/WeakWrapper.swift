//
//  WeakWrapper.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/4/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

public class WeakWrapper<Value: AnyObject> {
    weak public var value: Value?
    public init(_ value: Value) {
        self.value = value
    }
}
