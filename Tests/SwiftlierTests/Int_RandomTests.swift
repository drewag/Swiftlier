//
//  Int_RandomTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Int_RandomTests: XCTestCase, LinuxEnforcedTestCase {
    func testRandomInOpenRange() {
        for _ in 0 ..< 50 {
            XCTAssertTrue((5 ..< 10).contains(Int(randomIn: 5 ..< 10)))
        }
    }

    func testRandomInClosedRange() {
        for _ in 0 ..< 50 {
            XCTAssertTrue((5 ... 10).contains(Int(randomIn: 5 ... 10)))
        }
    }

    func testRandomOfLength() {
        for _ in 0 ..< 1000 {
            XCTAssertTrue((10 ... 99).contains(Int(randomOfLength: 2)))
        }
    }

    static var allTests: [(String, (Int_RandomTests) -> () throws -> Void)] {
        return [
            ("testRandomInOpenRange", testRandomInOpenRange),
            ("testRandomInClosedRange", testRandomInClosedRange),
            ("testRandomOfLength", testRandomOfLength),
        ]
    }
}


