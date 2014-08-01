//
//  Array+SwiftPlusPlusTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/1/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import UIKit
import XCTest

class Array_SwiftPlusPlusTests: XCTestCase {
    let array = ["first", "second", "third"]

    func testContainsOBjectPassingTest() {
        XCTAssertTrue(array.containsObjectPassingTest({$0 == "second"}))
        XCTAssertFalse(array.containsObjectPassingTest({$0 == "other"}))
    }

    func testIndexOfObjectPassingTest() {
        XCTAssertEqual(array.indexOfObjectPassingTest({$0 == "second"})!, 1)
        XCTAssertNil(array.indexOfObjectPassingTest({$0 == "other"}))
    }

    func testLastObject() {
        XCTAssertEqual(array.lastObject!, "third")

        var emptyArray = []
        XCTAssertNil(emptyArray.lastObject)
    }
}
