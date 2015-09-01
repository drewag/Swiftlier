//
//  String+SwiftPlusPlusTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class String_SwiftPlusPlusTests: XCTestCase {
    func testRepeat() {
        XCTAssertEqual("Hello".`repeat`(3), "HelloHelloHello")
    }

    func testSubstringFromIndex() {
        let string = "Hello World"
        XCTAssertEqual(string.substringFromIndex(1), "ello World")
    }

    func testSubstringToIndex() {
        let string = "Hello World"
        XCTAssertEqual(string.substringToIndex(1), "H")
    }
}
