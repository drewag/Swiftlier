//
//  Array+SwiftPlusPlus.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/1/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

extension Array {
    func containsObjectPassingTest(test: (object: T) -> Bool) -> Bool {
        for object in self {
            if test(object: object) {
                return true
            }
        }
        return false
    }

    func indexOfObjectPassingTest(test: (object: T) -> Bool) -> Int? {
        var index : Int = 0
        for object in self {
            if test(object: object) {
                return index
            }
            index++
        }
        return nil
    }
    
    var lastObject : T?
    {
    get {
        if self.count > 0 {
            return self[self.count - 1]
        }
        return nil
    }
    }
}