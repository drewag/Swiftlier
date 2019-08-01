//
//  DayTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 6/7/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class DayTests: XCTestCase {
    func testDayFromDate() {
        let date = "2019-07-30".railsDate!
        let day = date.day
        XCTAssertEqual(day.year, 2019)
        XCTAssertEqual(day.month, 7)
        XCTAssertEqual(day.day, 30)
    }

    func testComparison() {
        XCTAssertTrue(Day(year: 2000, month: 6, day: 15) == Day(year: 2000, month: 6, day: 15))
        XCTAssertFalse(Day(year: 2000, month: 6, day: 15) < Day(year: 2000, month: 6, day: 15))
        XCTAssertFalse(Day(year: 2000, month: 6, day: 15) > Day(year: 2000, month: 6, day: 15))

        XCTAssertTrue(Day(year: 2000, month: 6, day: 14) < Day(year: 2000, month: 6, day: 15))
        XCTAssertFalse(Day(year: 2000, month: 7, day: 14) < Day(year: 2000, month: 6, day: 15))
        XCTAssertFalse(Day(year: 2001, month: 6, day: 14) < Day(year: 2000, month: 6, day: 15))

        XCTAssertTrue(Day(year: 2000, month: 6, day: 16) > Day(year: 2000, month: 6, day: 15))
        XCTAssertFalse(Day(year: 2000, month: 5, day: 16) > Day(year: 2000, month: 6, day: 15))
        XCTAssertFalse(Day(year: 1999, month: 6, day: 16) > Day(year: 2000, month: 6, day: 15))
    }

    func testDescription() {
        XCTAssertEqual(Day(year: 2019, month: 10, day: 1).description, "2019-10-01")
        XCTAssertEqual(Day(year: 2019, month: 1, day: 10).description, "2019-01-10")
    }

    func testInitFromString() throws {
        Date.startFakingNow(from: Date(timeIntervalSince1970: 1561093232))

        var day = try Day("2019-10-01")
        XCTAssertEqual(day.year, 2019)
        XCTAssertEqual(day.month, 10)
        XCTAssertEqual(day.day, 1)

        day = try Day("10/01/2019")
        XCTAssertEqual(day.year, 2019)
        XCTAssertEqual(day.month, 10)
        XCTAssertEqual(day.day, 1)

        day = try Day("10/01/19")
        XCTAssertEqual(day.year, 2019)
        XCTAssertEqual(day.month, 10)
        XCTAssertEqual(day.day, 1)

        day = try Day("10/01/99")
        XCTAssertEqual(day.year, 1999)
        XCTAssertEqual(day.month, 10)
        XCTAssertEqual(day.day, 1)

        day = try Day("10/01")
        XCTAssertEqual(day.year, 2019)
        XCTAssertEqual(day.month, 10)
        XCTAssertEqual(day.day, 1)
    }
}
