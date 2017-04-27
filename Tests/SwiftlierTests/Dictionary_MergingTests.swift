//
//  Dictionary+MergingTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import Swiftlier

final class Dictionary_MergingTests: XCTestCase, LinuxEnforcedTestCase {
    func testMerge() {
        let dict1 = ["Apples": 2, "Oranges": 3]
        let dict2 = ["Apples": 3, "Cantaloupe": 1]
        var result = dict1.merge(with: dict2, by: +)

        XCTAssertEqual(result["Oranges"]!, 3)
        XCTAssertEqual(result["Cantaloupe"]!, 1)
        XCTAssertEqual(result["Oranges"]!, 3)
        XCTAssertEqual(result.count, 3)
    }

    static var allTests: [(String, (Dictionary_MergingTests) -> () throws -> Void)] {
        return [
            ("testMerge", testMerge),
        ]
    }
}
