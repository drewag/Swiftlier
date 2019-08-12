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

        XCTAssertThrowsError(try Day("2000-1-1-"))
        XCTAssertThrowsError(try Day("10/01/12/"))
        XCTAssertThrowsError(try Day("10/01/0"))
        XCTAssertThrowsError(try Day("a/01/01"))
        XCTAssertThrowsError(try Day("01/a/01"))
        XCTAssertThrowsError(try Day("01/01/a"))
        XCTAssertThrowsError(try Day("a/01"))
        XCTAssertThrowsError(try Day("01/a"))
        XCTAssertThrowsError(try Day("a-1-1"))
        XCTAssertThrowsError(try Day("2000-a-1"))
        XCTAssertThrowsError(try Day("2000-1-a"))
        XCTAssertThrowsError(try Day("2000-13-1"))
        XCTAssertThrowsError(try Day("2000-0-1"))

        // Invalid days
        XCTAssertThrowsError(try Day("2000-1-32"))
        XCTAssertThrowsError(try Day("2000-2-30"))
        XCTAssertThrowsError(try Day("2001-2-29"))
        XCTAssertThrowsError(try Day("2000-3-32"))
        XCTAssertThrowsError(try Day("2000-4-31"))
        XCTAssertThrowsError(try Day("2000-5-32"))
        XCTAssertThrowsError(try Day("2000-6-31"))
        XCTAssertThrowsError(try Day("2000-7-32"))
        XCTAssertThrowsError(try Day("2000-8-32"))
        XCTAssertThrowsError(try Day("2000-9-31"))
        XCTAssertThrowsError(try Day("2000-10-32"))
        XCTAssertThrowsError(try Day("2000-11-31"))
        XCTAssertThrowsError(try Day("2000-12-32"))
    }

    func testDayOfWeek() {
        XCTAssertEqual(Day(year: 2482, month: 12, day: 16).dayOfWeek, .wednesday)
        XCTAssertEqual(Day(year: 2482, month: 12, day: 17).dayOfWeek, .thursday)
        XCTAssertEqual(Day(year: 2482, month: 12, day: 18).dayOfWeek, .friday)
        XCTAssertEqual(Day(year: 2482, month: 12, day: 19).dayOfWeek, .saturday)
        XCTAssertEqual(Day(year: 2482, month: 12, day: 20).dayOfWeek, .sunday)
        XCTAssertEqual(Day(year: 2482, month: 12, day: 21).dayOfWeek, .monday)
        XCTAssertEqual(Day(year: 2482, month: 12, day: 22).dayOfWeek, .tuesday)


        // Test Different Centuries
        XCTAssertEqual(Day(year: 2353, month: 8, day: 14).dayOfWeek, .friday)
        XCTAssertEqual(Day(year: 2222, month: 4, day: 20).dayOfWeek, .saturday)
        XCTAssertEqual(Day(year: 2111, month: 5, day: 1).dayOfWeek, .friday)

        // Test Leap Year
        XCTAssertEqual(Day(year: 2000, month: 1, day: 1).dayOfWeek, .saturday)
        XCTAssertEqual(Day(year: 2000, month: 2, day: 1).dayOfWeek, .tuesday)
    }

    func testCentury() {
        XCTAssertEqual(Day(year: 2343, month: 1, day: 1).century, 23)
        XCTAssertEqual(Day(year: 102, month: 1, day: 1).century, 1)
    }

    func testIsLeapYear() {
        XCTAssertTrue(Day(year: 2000, month: 1, day: 1).isLeapYear)
        XCTAssertFalse(Day(year: 2001, month: 1, day: 1).isLeapYear)
        XCTAssertFalse(Day(year: 2002, month: 1, day: 1).isLeapYear)
        XCTAssertFalse(Day(year: 2003, month: 1, day: 1).isLeapYear)
        XCTAssertTrue(Day(year: 2004, month: 1, day: 1).isLeapYear)
    }

    func testCoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try encoder.encode([Day(year: 2482, month: 12, day: 18)])
        XCTAssertEqual(String(data: data, encoding: .utf8), #"["2482-12-18"]"#)
        let day = try decoder.decode([Day].self, from: data)[0]
        XCTAssertEqual(day.year, 2482)
        XCTAssertEqual(day.month, 12)
        XCTAssertEqual(day.day, 18)
    }
}
