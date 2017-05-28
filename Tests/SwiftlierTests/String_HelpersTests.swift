//
//  String+String_HelpersTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import Swiftlier

final class String_HelpersTests: XCTestCase, LinuxEnforcedTestCase {
    func testRepeat() {
        XCTAssertEqual("Hello".repeating(nTimes: 3), "HelloHelloHello")
        XCTAssertEqual("Hello".repeating(nTimes: 4, separator: " "), "Hello Hello Hello Hello")
    }

    func testSubstringFromIndex() {
        let string = "Hello World"
        XCTAssertEqual(string.substring(from: 1), "ello World")
    }

    func testSubstringToIndex() {
        let string = "Hello World"
        XCTAssertEqual(string.substring(to: 1), "H")
    }

    func testOffsetCharactersByCount() {
        XCTAssertEqual("abcd".offsetCharacters(by: 1), "bcde")
        XCTAssertEqual("abcd".offsetCharacters(by: 3), "defg")
        XCTAssertEqual("cdef".offsetCharacters(by: -2), "abcd")
    }

    static var allTests: [(String, (String_HelpersTests) -> () throws -> Void)] {
        return [
            ("testRepeat", testRepeat),
            ("testSubstringFromIndex", testSubstringFromIndex),
            ("testSubstringToIndex", testSubstringToIndex),
            ("testOffsetCharactersByCount", testOffsetCharactersByCount),
        ]
    }
}
