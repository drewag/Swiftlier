//
//  LimitedQueueTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 7/19/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

class LimitedQueueTests: XCTestCase {
    func testPush() {
        var queue = LimitedQueue<Int>(limit: 3)
        queue.push(1)
        queue.push(2)
        queue.push(3)
        queue.push(4)

        XCTAssertEqual(queue.elements.count, 3)
        XCTAssertEqual(queue.elements[0], 2)
        XCTAssertEqual(queue.elements[1], 3)
        XCTAssertEqual(queue.elements[2], 4)
    }

    func testRemoveAll() {
        var queue = LimitedQueue<Int>(limit: 3)
        queue.push(1)
        queue.push(2)
        queue.push(3)
        queue.removeAll()
        XCTAssertEqual(queue.elements.count, 0)
    }
}
