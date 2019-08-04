//
//  String+String_HelpersTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import Swiftlier

final class String_EnhancementsTests: XCTestCase {
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
        XCTAssertEqual("".numberOfCommonSuffixCharacters(with: "efcd"), 0)
        XCTAssertEqual("abcd".numberOfCommonSuffixCharacters(with: ""), 0)
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

    func testTitleCased() {
        XCTAssertEqual("a character at an orchard walked by and laughed but then a clown cried".titleCased, "A Character at an Orchard Walked by and Laughed but Then a Clown Cried")
        XCTAssertEqual("I did not go in on the party nor for the present of the group or friends".titleCased, "I Did Not Go in on the Party nor for the Present of the Group or Friends")
        XCTAssertEqual("You are smart yet mean so you should grow up".titleCased, "You Are Smart yet Mean so You Should Grow up")
    }

    func testRandomOfLength() {
        var string = String(randomOfLength: 0)
        XCTAssertEqual(string.count, 0)

        string = String(randomOfLength: 5)
        XCTAssertEqual(string.count, 5)
        XCTAssertFalse(string.contains(where: { character in
            let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return !allowedChars.contains(where: {$0 == character})
        }))
    }
}
