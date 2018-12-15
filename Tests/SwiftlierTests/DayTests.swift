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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.date(from: "Jun 7, 2017")!
        let day = date.day
        XCTAssertEqual(day.year, 2017)
        XCTAssertEqual(day.month, 6)
        XCTAssertEqual(day.day, 7)
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
}
