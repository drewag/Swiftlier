//
//  HeartRateFormatterTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class HeartRateFormatterTests: XCTestCase {
    func testStringForObject() {
        let formatter = HeartRateFormatter()

        XCTAssertEqual(formatter.string(for: 12), "12 bpm")
        XCTAssertEqual(formatter.string(for: 3.7), "3.7 bpm")
        XCTAssertEqual(formatter.string(for: "some"), "some bpm")
    }
}

