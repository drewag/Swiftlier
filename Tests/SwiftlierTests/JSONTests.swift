//
//  JSONTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 10/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class JSONTests: XCTestCase, LinuxEnforcedTestCase {
    func testInitFromData() throws {
        let jsonString = """
            {
                "array": ["value1","value2","value3"],
                "dict": {"key":"value"},
                "string": "value",
                "integer": 20,
                "decimal": 0.3,
                "boolean": true,
                "null": null
            }
            """
        let data = jsonString.data(using: .utf8)!
        let json = try JSON(data: data)
        XCTAssertEqual(json["array"]?.array?.count, 3)
        XCTAssertEqual(json["array"]?[0]?.string, "value1")
        XCTAssertEqual(json["array"]?[1]?.string, "value2")
        XCTAssertEqual(json["array"]?[2]?.string, "value3")
        XCTAssertEqual(json["dict"]?.dictionary?.count, 1)
        XCTAssertEqual(json["dict"]?["key"]?.string, "value")
        XCTAssertEqual(json["integer"]?.int, 20)
        XCTAssertEqual(json["decimal"]?.double, 0.3)
        XCTAssertEqual(json["boolean"]?.bool, true)
        XCTAssertTrue(json["null"]?.object is NSNull)
    }

    func testInitFromObject() throws {
        let json = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        XCTAssertEqual(json["array"]?.array?.count, 3)
        XCTAssertEqual(json["array"]?[0]?.string, "value1")
        XCTAssertEqual(json["array"]?[1]?.string, "value2")
        XCTAssertEqual(json["array"]?[2]?.string, "value3")
        XCTAssertEqual(json["dict"]?.dictionary?.count, 1)
        XCTAssertEqual(json["dict"]?["key"]?.string, "value")
        XCTAssertEqual(json["integer"]?.int, 20)
        XCTAssertEqual(json["decimal"]?.double, 0.3)
        XCTAssertEqual(json["boolean"]?.bool, true)
        XCTAssertTrue(json["null"]?.object is NSNull)
    }

    func testData() throws {
        let original = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let data = try original.data()
        let json = try JSON(data: data)
        XCTAssertEqual(json["array"]?.array?.count, 3)
        XCTAssertEqual(json["array"]?[0]?.string, "value1")
        XCTAssertEqual(json["array"]?[1]?.string, "value2")
        XCTAssertEqual(json["array"]?[2]?.string, "value3")
        XCTAssertEqual(json["dict"]?.dictionary?.count, 1)
        XCTAssertEqual(json["dict"]?["key"]?.string, "value")
        XCTAssertEqual(json["integer"]?.int, 20)
        XCTAssertEqual(json["decimal"]?.double, 0.3)
        XCTAssertEqual(json["boolean"]?.bool, true)
        XCTAssertTrue(json["null"]?.object is NSNull)
    }

    static var allTests: [(String, (JSONTests) -> () throws -> Void)] {
        return [
            ("testInitFromData", testInitFromData),
            ("testInitFromObject", testInitFromObject),
            ("testData", testData),
        ]
    }
}


