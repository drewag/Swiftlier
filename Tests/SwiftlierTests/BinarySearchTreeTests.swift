//
//  BinarySearchTreeTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 6/1/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class BinarySearchTreeTests: XCTestCase {
    var tree: BinarySearchTree<Int> {
        return BinarySearchTree(values: [4, 2, 4, 1, 4, 8, 9, 3, 1, 7, 9, 6, 5])
    }

    func testIterating() {
        XCTAssertEqual(Array(BinarySearchTree<Int>()), [])
        XCTAssertEqual(Array(BinarySearchTree<Int>(values: [1])), [1])

        let all = Array(self.tree)
        XCTAssertEqual(all.count, 13)
        XCTAssertEqual(all[0], 1)
        XCTAssertEqual(all[1], 1)
        XCTAssertEqual(all[2], 2)
        XCTAssertEqual(all[3], 3)
        XCTAssertEqual(all[4], 4)
        XCTAssertEqual(all[5], 4)
        XCTAssertEqual(all[6], 4)
        XCTAssertEqual(all[7], 5)
        XCTAssertEqual(all[8], 6)
        XCTAssertEqual(all[9], 7)
        XCTAssertEqual(all[10], 8)
        XCTAssertEqual(all[11], 9)
        XCTAssertEqual(all[12], 9)
    }

    func testInsert() {
        let tree = BinarySearchTree<Int>()
        XCTAssertEqual(tree.count, 0)
        XCTAssertEqual(tree.min, nil)
        XCTAssertEqual(tree.max, nil)

        tree.insert(4)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(Array(tree), [4])
        XCTAssertEqual(tree.min, 4)
        XCTAssertEqual(tree.max, 4)

        tree.insert(2)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(Array(tree), [2,4])
        XCTAssertEqual(tree.min, 2)
        XCTAssertEqual(tree.max, 4)

        tree.insert(4)
        XCTAssertEqual(tree.count, 3)
        XCTAssertEqual(Array(tree), [2,4,4])
        XCTAssertEqual(tree.min, 2)
        XCTAssertEqual(tree.max, 4)

        tree.insert(1)
        XCTAssertEqual(tree.count, 4)
        XCTAssertEqual(Array(tree), [1,2,4,4])
        XCTAssertEqual(tree.min, 1)
        XCTAssertEqual(tree.max, 4)

        tree.insert(9)
        XCTAssertEqual(tree.count, 5)
        XCTAssertEqual(Array(tree), [1,2,4,4,9])
        XCTAssertEqual(tree.min, 1)
        XCTAssertEqual(tree.max, 9)

        tree.insert(0)
        XCTAssertEqual(tree.count, 6)
        XCTAssertEqual(Array(tree), [0,1,2,4,4,9])
        XCTAssertEqual(tree.min, 0)
        XCTAssertEqual(tree.max, 9)
    }

    func testElementsBetween() {
        let tree = self.tree
        XCTAssertEqual(tree.elements(between: 0, and: 10), [1,1,2,3,4,4,4,5,6,7,8,9,9])
        XCTAssertEqual(tree.elements(between: 2, and: 9), [3,4,4,4,5,6,7,8])
        XCTAssertEqual(tree.elements(between: 3, and: 7), [4,4,4,5,6])
        XCTAssertEqual(tree.elements(between: 4, and: 6), [5])
        XCTAssertEqual(tree.elements(between: 5, and: 6), [])
        XCTAssertEqual(tree.elements(between: 7, and: 6), [])
        XCTAssertEqual(tree.elements(between: -5, and: -1), [])
    }
}
