//
//  JSONTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 10/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class JSONTests: XCTestCase {
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

    func testDecode() throws {
        let jsonString = """
            {
                "string": "some",
                "int": 4
            }
            """
        let data = jsonString.data(using: .utf8)!
        let json = try JSON(data: data)
        let codable: TestCodable = try json.decode()
        XCTAssertEqual(codable.string, "some")
        XCTAssertEqual(codable.int, 4)
    }

    func testEncode() throws {
        let codable = TestCodable(string: "some", int: 4)
        let json = try JSON(encodable: codable)
        XCTAssertEqual(json["string"]?.string, "some")
        XCTAssertEqual(json["int"]?.int, 4)
    }

    func testEquatable() throws {
        let one = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let two = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentArray = JSON(object: [
            "array": ["value1","different","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentDictValue = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"different"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentDictKey = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["different":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentString = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "different",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentInteger = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 21,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentDecimal = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.31,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentBool = JSON(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": false,
            "null": NSNull(),
        ])
        XCTAssertEqual(one, two)
        XCTAssertNotEqual(one, differentArray)
        XCTAssertNotEqual(one, differentDictValue)
        XCTAssertNotEqual(one, differentDictKey)
        XCTAssertNotEqual(one, differentString)
        XCTAssertNotEqual(one, differentInteger)
        XCTAssertNotEqual(one, differentDecimal)
        XCTAssertNotEqual(one, differentBool)
    }
}


