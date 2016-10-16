//
//  Array+SwiftPlusPlusTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/1/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class Array_SwiftPlusPlusTests: XCTestCase {
    let array = ["first", "second", "third"]

    func testContainsOBjectPassingTest() {
        XCTAssertTrue(array.containsValue(passing: {$0 == "second"}))
        XCTAssertFalse(array.containsValue(passing: {$0 == "other"}))
    }

    func testIndexOfObjectPassingTest() {
        XCTAssertEqual(array.indexOfValue(passing: {$0 == "second"})!, 1)
        XCTAssertNil(array.indexOfValue(passing: {$0 == "other"}))
    }
}
