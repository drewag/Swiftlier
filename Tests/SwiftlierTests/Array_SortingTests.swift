//
//  Array_SortingTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Array_SortingTests: XCTestCase, LinuxEnforcedTestCase {
    func testInsertAssumingAlreadySorted() {
        var values: [Int] = []

        func sort(lhs: Int, rhs: Int) -> Bool {
            return lhs < rhs
        }

        XCTAssertEqual(values.insert(5, assumingAlreadySortedBy: sort), 0)
        XCTAssertEqual(values.count, 1)
        XCTAssertEqual(values[0], 5)

        XCTAssertEqual(values.insert(4, assumingAlreadySortedBy: sort), 0)
        XCTAssertEqual(values.count, 2)
        XCTAssertEqual(values[0], 4)

        XCTAssertEqual(values.insert(5, assumingAlreadySortedBy: sort), 1)
        XCTAssertEqual(values.count, 3)
        XCTAssertEqual(values[1], 5)

        XCTAssertEqual(values.insert(6, assumingAlreadySortedBy: sort), 3)
        XCTAssertEqual(values.count, 4)
        XCTAssertEqual(values[3], 6)
    }

    static var allTests: [(String, (Array_SortingTests) -> () throws -> Void)] {
        return [
            ("testInsertAssumingAlreadySorted", testInsertAssumingAlreadySorted),
        ]
    }
}
