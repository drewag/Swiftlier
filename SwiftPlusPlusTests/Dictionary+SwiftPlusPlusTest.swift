//
//  Dictionary+SwiftPlusPlusTest.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class Dictionary_SwiftPlusPlusTest: XCTestCase {
    func testMerge() {
        var dict1 = ["Apples": 2, "Oranges": 3]
        var dict2 = ["Apples": 3, "Cantaloupe": 1]
        var result = dict1.merge(with: dict2, by: +)

        XCTAssertEqualObjects(result, ["Oranges": 3, "Cantaloupe": 1, "Apples": 5])
    }

    func testMap() {
        var dict : Dictionary<String, Int> = ["One": 0, "Two": 1, "Three": 2]
        dict.map { (key, value) -> Int in
            return value + 1
        }

        XCTAssertEqualObjects(dict["One"], 1)
        XCTAssertEqualObjects(dict["Two"], 2)
        XCTAssertEqualObjects(dict["Three"], 2)
    }
}
