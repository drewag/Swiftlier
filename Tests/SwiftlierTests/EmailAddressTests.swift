//
//  EmailAddressTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/22/17.
//
//

import XCTest
import Swiftlier

final class EmailAddressTests: XCTestCase, LinuxEnforcedTestCase {
    func testNilString() {
        XCTAssertThrowsError(try EmailAddress(string: nil))
    }

    func testEmptyString() {
        XCTAssertThrowsError(try EmailAddress(string: ""))
    }

    func testInvalidStrings() {
        XCTAssertThrowsError(try EmailAddress(string: "@example.com"))
        XCTAssertThrowsError(try EmailAddress(string: "user@example"))
        XCTAssertThrowsError(try EmailAddress(string: "user@"))
        XCTAssertThrowsError(try EmailAddress(string: "userexample.com"))
    }

    func testValidStrings() throws {
        var email = try EmailAddress(string: "uSer@examPle.cOm")
        XCTAssertEqual(email.string, "user@example.com")

        email = try EmailAddress(string: "usEr+Hello@Example.com")
        XCTAssertEqual(email.string, "user+hello@example.com")

        email = try EmailAddress(string: "user-hellO@eXample.com")
        XCTAssertEqual(email.string, "user-hello@example.com")

        email = try EmailAddress(string: "Us.er@exam.Ple.COm")
        XCTAssertEqual(email.string, "us.er@exam.ple.com")
    }

    func testNilUserString() {
        XCTAssertThrowsError(try EmailAddress(userString: nil, for: "testing"))
    }

    func testEmptyUserString() {
        XCTAssertThrowsError(try EmailAddress(userString: "", for: "testing"))
    }

    func testInvalidUserStrings() {
        XCTAssertThrowsError(try EmailAddress(userString: "@example.com", for: "testing"))
        XCTAssertThrowsError(try EmailAddress(userString: "user@example", for: "testing"))
        XCTAssertThrowsError(try EmailAddress(userString: "user@", for: "testing"))
        XCTAssertThrowsError(try EmailAddress(userString: "userexample.com", for: "testing"))
    }

    func testValidUserStrings() throws {
        var email = try EmailAddress(userString: "uSer@examPle.cOm", for: "testing")
        XCTAssertEqual(email.string, "user@example.com")

        email = try EmailAddress(userString: "usEr+Hello@Example.com", for: "testing")
        XCTAssertEqual(email.string, "user+hello@example.com")

        email = try EmailAddress(userString: "user-hellO@eXample.com", for: "testing")
        XCTAssertEqual(email.string, "user-hello@example.com")

        email = try EmailAddress(userString: "Us.er@exam.Ple.COm", for: "testing")
        XCTAssertEqual(email.string, "us.er@exam.ple.com")
    }

    static var allTests: [(String, (EmailAddressTests) -> () throws -> Void)] {
        return [
            ("testNilString", testNilString),
            ("testEmptyString", testEmptyString),
            ("testInvalidStrings", testInvalidStrings),
            ("testValidStrings", testValidStrings),
            ("testNilUserString", testNilUserString),
            ("testEmptyUserString", testEmptyUserString),
            ("testInvalidUserStrings", testInvalidUserStrings),
            ("testValidUserStrings", testValidUserStrings),
        ]
    }
}
