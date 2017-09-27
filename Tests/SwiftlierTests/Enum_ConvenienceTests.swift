//
//  Enum_ConvenienceTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

private enum TestEnum: Int {
    case one
    case two
    case three
}

final class Enum_ConvenienceTests: XCTestCase, LinuxEnforcedTestCase {
    func testCount() {
        XCTAssertEqual(TestEnum.count, 3)
    }

    static var allTests: [(String, (Enum_ConvenienceTests) -> () throws -> Void)] {
        return [
            ("testCount", testCount),
        ]
    }
}


