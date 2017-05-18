//
//  Date_HelpersTests.swift
//  SwiftlieriOS
//
//  Created by Andrew Wagner on 5/17/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Date_HelpersTests: XCTestCase, LinuxEnforcedTestCase {
    func testIsToday() {
        XCTAssertTrue(Date().isToday)
        XCTAssertFalse(Date(timeIntervalSinceNow: -60 * 60 * 24).isToday)
        XCTAssertFalse(Date(timeIntervalSinceNow: 60 * 60 * 24).isToday)
    }

    func testIsTomorrow() {
        XCTAssertFalse(Date().isTomorrow)
        XCTAssertTrue(Date(timeIntervalSinceNow: 60 * 60 * 24).isTomorrow)
        XCTAssertFalse(Date(timeIntervalSinceNow: 2 * 60 * 60 * 24).isTomorrow)
    }

    func testIsThisWeek() {
        XCTAssertTrue(Date().isThisWeek)
        XCTAssertFalse(Date(timeIntervalSinceNow: -7 * 60 * 60 * 24).isThisWeek)
        XCTAssertFalse(Date(timeIntervalSinceNow: 7 * 60 * 60 * 24).isThisWeek)
    }

    func testIsThisYear() {
        XCTAssertTrue(Date().isThisYear)
        XCTAssertFalse(Date(timeIntervalSinceNow: -365 * 60 * 60 * 24).isThisYear)
        XCTAssertFalse(Date(timeIntervalSinceNow: 365 * 60 * 60 * 24).isThisYear)
    }

    func testIsInFuture() {
        XCTAssertTrue(Date(timeIntervalSinceNow: 5).isInFuture)
        XCTAssertFalse(Date(timeIntervalSinceNow: -5).isInFuture)
    }

    func testIsInPast() {
        XCTAssertTrue(Date(timeIntervalSinceNow: -5).isInPast)
        XCTAssertFalse(Date(timeIntervalSinceNow: 5).isInPast)
    }

    static var allTests: [(String, (Date_HelpersTests) -> () throws -> Void)] {
        return [
            ("testIsToday", testIsToday),
            ("testIsTomorrow", testIsTomorrow),
            ("testIsThisWeek", testIsThisWeek),
            ("testIsThisYear", testIsThisYear),
            ("testIsInFuture", testIsInFuture),
            ("testIsInPast", testIsInPast),
        ]
    }
}
