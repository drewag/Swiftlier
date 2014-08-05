//
//  Array+SwiftPlusPlus.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/1/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

extension Array {
    /**
        :param: test function to test if an elemnt passes
        
        :returns: true if any element passes the given test
    */
    func containsObjectPassingTest(test: (object: T) -> Bool) -> Bool {
        for object in self {
            if test(object: object) {
                return true
            }
        }
        return false
    }

    /**
        :param: test function to test if an element passes

        :returns: the index of a passing element or nil if none match
    */
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
}