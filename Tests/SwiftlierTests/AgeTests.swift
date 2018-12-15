//
//  AgeTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/29/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class AgeTests: XCTestCase {
    func testYears() {
        XCTAssertEqual(Age(date: Date()).years, 0)
        XCTAssertEqual(Age(date: Date(timeIntervalSinceNow: -6 * 366 * 24 * 60 * 60)).years, 6)
        XCTAssertEqual(Age(date: Date(timeIntervalSinceNow: -123 * 366 * 24 * 60 * 60)).years, 123)
    }
}
