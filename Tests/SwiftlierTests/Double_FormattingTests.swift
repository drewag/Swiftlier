//
//  Double_FormattingTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Double_FormattingTests: XCTestCase {
    func testAsPercent() {
        XCTAssertEqual(0.3.asPercent, "30%")
        XCTAssertEqual(0.316.asPercent, "32%")
        XCTAssertEqual(1.4.asPercent, "140%")
        XCTAssertEqual(0.004.asPercent, "0%")
    }
}

