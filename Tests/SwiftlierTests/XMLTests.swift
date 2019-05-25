//
//  XMLTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 10/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class XMLTests: XCTestCase {
    func testInitFromData() throws {
        let xmlString =
            """
            <root>
                <array>value1</array>
                <array>value2</array>
                <array>value3</array>
                <dict>
                    <key>value</key>
                </dict>
                <empty></empty>
                <string>value</string>
                <integer>20</integer>
                <decimal>0.3</decimal>
                <boolean>true</boolean>
            </root>
            """
        let data = xmlString.data(using: .utf8)!
        let xml = try XML(data)
        print(xml)
        XCTAssertEqual(xml["root"]?["array"]?.array?.count, 3)
        XCTAssertEqual(xml["root"]?["array"]?[0]?.string, "value1")
        XCTAssertEqual(xml["root"]?["array"]?[1]?.string, "value2")
        XCTAssertEqual(xml["root"]?["array"]?[2]?.string, "value3")
        XCTAssertEqual(xml["root"]?["dict"]?.dictionary?.count, 1)
        XCTAssertEqual(xml["root"]?["dict"]?["key"]?.string, "value")
        XCTAssertEqual(xml["root"]?["integer"]?.int, 20)
        XCTAssertEqual(xml["root"]?["decimal"]?.double, 0.3)
    }

    func testInitFromObject() throws {
        let xml = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        XCTAssertEqual(xml["array"]?.array?.count, 3)
        XCTAssertEqual(xml["array"]?[0]?.string, "value1")
        XCTAssertEqual(xml["array"]?[1]?.string, "value2")
        XCTAssertEqual(xml["array"]?[2]?.string, "value3")
        XCTAssertEqual(xml["dict"]?.dictionary?.count, 1)
        XCTAssertEqual(xml["dict"]?["key"]?.string, "value")
        XCTAssertEqual(xml["integer"]?.int, 20)
        XCTAssertEqual(xml["decimal"]?.double, 0.3)
        XCTAssertEqual(xml["boolean"]?.bool, true)
        XCTAssertTrue(xml["null"]?.object is NSNull)
    }

    func testEquatable() throws {
        let one = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let two = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentArray = XML(object: [
            "array": ["value1","different","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentDictValue = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"different"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentDictKey = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["different":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentString = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "different",
            "integer": 20,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentInteger = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 21,
            "decimal": 0.3,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentDecimal = XML(object: [
            "array": ["value1","value2","value3"],
            "dict": ["key":"value"],
            "string": "value",
            "integer": 20,
            "decimal": 0.31,
            "boolean": true,
            "null": NSNull(),
        ])
        let differentBool = XML(object: [
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
