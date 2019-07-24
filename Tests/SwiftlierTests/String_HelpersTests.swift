//
//  String+String_HelpersTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import Swiftlier

final class String_HelpersTests: XCTestCase {
    func testRepeat() {
        XCTAssertEqual("Hello".repeating(nTimes: 3), "HelloHelloHello")
        XCTAssertEqual("Hello".repeating(nTimes: 4, separator: " "), "Hello Hello Hello Hello")
    }

    func testIndexAt() {
        let string = "Hello World"
        let target = string.firstIndex(of: "W")
        XCTAssertEqual(string.index(at: 6), target)
    }

    func testOffsetCharactersByCount() {
        XCTAssertEqual("abcd".offsetCharacters(by: 1), "bcde")
        XCTAssertEqual("abcd".offsetCharacters(by: 3), "defg")
        XCTAssertEqual("cdef".offsetCharacters(by: -2), "abcd")
    }

    func testNumberOfCommonSuffixCharacters() {
        XCTAssertEqual("abcd".numberOfCommonSuffixCharacters(with: "efcd"), 2)
        XCTAssertEqual("abd".numberOfCommonSuffixCharacters(with: "efcd"), 1)
        XCTAssertEqual("abd".numberOfCommonSuffixCharacters(with: "abc"), 0)
        XCTAssertEqual("astring".numberOfCommonSuffixCharacters(with: "string"), 6)
    }

    func testTrimmingWhitespaceOnEnds() {
        XCTAssertEqual("abcd".trimmingWhitespaceOnEnds, "abcd")
        XCTAssertEqual(" abcd  ".trimmingWhitespaceOnEnds, "abcd")
        XCTAssertEqual("\t \nabcd \n\n ".trimmingWhitespaceOnEnds, "abcd")
        XCTAssertEqual("\t \na\t\nb cd \n\n ".trimmingWhitespaceOnEnds, "a\t\nb cd")
    }
}
