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

    func testBeginningOfDay() {
        XCTAssertEqual("2017-06-17T18:09:04.6".localIso8601DateTime!.beginningOfDay.localIso8601DateTime, "2017-06-17T00:00:00.0")
        XCTAssertEqual("2017-06-17T06:00:00.0".localIso8601DateTime!.beginningOfDay.localIso8601DateTime, "2017-06-17T00:00:00.0")
        XCTAssertEqual("2017-06-17T23:59:59.9".localIso8601DateTime!.beginningOfDay.localIso8601DateTime, "2017-06-17T00:00:00.0")
    }

    func testBeginningOfWeek() {
        XCTAssertEqual("2017-06-11T18:09:04.6".localIso8601DateTime!.beginningOfWeek.localIso8601DateTime, "2017-06-11T00:00:00.0")
        XCTAssertEqual("2017-06-14T18:09:04.6".localIso8601DateTime!.beginningOfWeek.localIso8601DateTime, "2017-06-11T00:00:00.0")
        XCTAssertEqual("2017-06-17T18:09:04.6".localIso8601DateTime!.beginningOfWeek.localIso8601DateTime, "2017-06-11T00:00:00.0")

        XCTAssertEqual("2017-06-01T18:09:04.6".localIso8601DateTime!.beginningOfWeek.localIso8601DateTime, "2017-05-28T00:00:00.0")

        XCTAssertEqual("2016-01-01T18:09:04.6".localIso8601DateTime!.beginningOfWeek.localIso8601DateTime, "2015-12-27T00:00:00.0")
        XCTAssertEqual("2017-01-01T18:09:04.6".localIso8601DateTime!.beginningOfWeek.localIso8601DateTime, "2017-01-01T00:00:00.0")
    }

    func testBeginningOfMonth() {
        XCTAssertEqual("2017-06-01T18:09:04.6".localIso8601DateTime!.beginningOfMonth.localIso8601DateTime, "2017-06-01T00:00:00.0")
        XCTAssertEqual("2017-06-17T18:09:04.6".localIso8601DateTime!.beginningOfMonth.localIso8601DateTime, "2017-06-01T00:00:00.0")
        XCTAssertEqual("2017-06-30T18:09:04.6".localIso8601DateTime!.beginningOfMonth.localIso8601DateTime, "2017-06-01T00:00:00.0")
        XCTAssertEqual("2017-04-28T18:09:04.6".localIso8601DateTime!.beginningOfMonth.localIso8601DateTime, "2017-04-01T00:00:00.0")
    }

    func testBeginningOfNextDay() {
        XCTAssertEqual("2017-06-17T18:09:04.6".localIso8601DateTime!.beginningOfNextDay.localIso8601DateTime, "2017-06-18T00:00:00.0")
        XCTAssertEqual("2017-06-17T06:00:00.0".localIso8601DateTime!.beginningOfNextDay.localIso8601DateTime, "2017-06-18T00:00:00.0")
        XCTAssertEqual("2017-06-17T23:59:59.9".localIso8601DateTime!.beginningOfNextDay.localIso8601DateTime, "2017-06-18T00:00:00.0")
    }

    func testBeginningOfNextWeek() {
        XCTAssertEqual("2017-06-11T18:09:04.6".localIso8601DateTime!.beginningOfNextWeek.localIso8601DateTime, "2017-06-18T00:00:00.0")
        XCTAssertEqual("2017-06-14T18:09:04.6".localIso8601DateTime!.beginningOfNextWeek.localIso8601DateTime, "2017-06-18T00:00:00.0")
        XCTAssertEqual("2017-06-17T18:09:04.6".localIso8601DateTime!.beginningOfNextWeek.localIso8601DateTime, "2017-06-18T00:00:00.0")

        XCTAssertEqual("2017-05-31T18:09:04.6".localIso8601DateTime!.beginningOfNextWeek.localIso8601DateTime, "2017-06-04T00:00:00.0")

        XCTAssertEqual("2017-01-01T18:09:04.6".localIso8601DateTime!.beginningOfNextWeek.localIso8601DateTime, "2017-01-08T00:00:00.0")
    }

    func testBeginningOfNextMonth() {
        XCTAssertEqual("2017-06-01T18:09:04.6".localIso8601DateTime!.beginningOfNextMonth.localIso8601DateTime, "2017-07-01T00:00:00.0")
        XCTAssertEqual("2017-06-17T18:09:04.6".localIso8601DateTime!.beginningOfNextMonth.localIso8601DateTime, "2017-07-01T00:00:00.0")
        XCTAssertEqual("2017-06-30T18:09:04.6".localIso8601DateTime!.beginningOfNextMonth.localIso8601DateTime, "2017-07-01T00:00:00.0")
        XCTAssertEqual("2017-04-28T18:09:04.6".localIso8601DateTime!.beginningOfNextMonth.localIso8601DateTime, "2017-05-01T00:00:00.0")
    }

    static var allTests: [(String, (Date_HelpersTests) -> () throws -> Void)] {
        return [
            ("testIsToday", testIsToday),
            ("testIsTomorrow", testIsTomorrow),
            ("testIsThisWeek", testIsThisWeek),
            ("testIsThisYear", testIsThisYear),
            ("testIsInFuture", testIsInFuture),
            ("testIsInPast", testIsInPast),
            ("testBeginningOfDay", testBeginningOfDay),
            ("testBeginningOfWeek", testBeginningOfWeek),
            ("testBeginningOfMonth", testBeginningOfMonth),
            ("testBeginningOfNextDay", testBeginningOfNextDay),
            ("testBeginningOfNextWeek", testBeginningOfNextWeek),
            ("testBeginningOfNextMonth", testBeginningOfNextMonth),
        ]
    }
}
