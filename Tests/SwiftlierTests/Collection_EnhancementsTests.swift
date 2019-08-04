//
//  Array_SortingTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Collection_EnhancementsTests: XCTestCase {
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

    func testUnioned() {
        let array1 = [1,2,3,5,8,13]
        let array2 = [13,11,9,7,5,3,1]

        var unioned = Array(array1.unioned(with: array2))
        XCTAssertEqual(unioned.count, 4)
        XCTAssertEqual(unioned[0], 1)
        XCTAssertEqual(unioned[1], 3)
        XCTAssertEqual(unioned[2], 5)
        XCTAssertEqual(unioned[3], 13)

        unioned = Array(array2.unioned(with: array1))
        XCTAssertEqual(unioned.count, 4)
        XCTAssertEqual(unioned[0], 13)
        XCTAssertEqual(unioned[1], 5)
        XCTAssertEqual(unioned[2], 3)
        XCTAssertEqual(unioned[3], 1)

        unioned = Array(array1.unioned(with: array1))
        XCTAssertEqual(unioned.count, 6)
        XCTAssertEqual(unioned[0], 1)
        XCTAssertEqual(unioned[1], 2)
        XCTAssertEqual(unioned[2], 3)
        XCTAssertEqual(unioned[3], 5)
        XCTAssertEqual(unioned[4], 8)
        XCTAssertEqual(unioned[5], 13)

    }

    func testEnumeratedByTwos() {
        let array = ["one","two","three","four","five"]
        let byTwos = Array(array.enumerateByTwos())

        XCTAssertEqual(byTwos.count, 4)
        XCTAssertEqual(byTwos[0].0, "one")
        XCTAssertEqual(byTwos[0].1, "two")

        XCTAssertEqual(byTwos[1].0, "two")
        XCTAssertEqual(byTwos[1].1, "three")

        XCTAssertEqual(byTwos[2].0, "three")
        XCTAssertEqual(byTwos[2].1, "four")

        XCTAssertEqual(byTwos[3].0, "four")
        XCTAssertEqual(byTwos[3].1, "five")
    }
}
