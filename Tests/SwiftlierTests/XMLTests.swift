//
//  XMLTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 10/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class XMLTests: XCTestCase, LinuxEnforcedTestCase {
    func testInitFromData() {
        let xmlString =
            """
            <root>
                <array>
                    <value>value1</value>
                    <value>value2</value>
                    <value>value3</value>
                </array>
                <dict>
                    <key>value</key>
                </dict>
                <string>value</string>
                <integer>20</integer>
                <decimal>0.3</decimal>
                <boolean>true</boolean>
            </root>
            """
        do {
            let data = xmlString.data(using: .utf8)!
            let xml = try XML(data: data)
            XCTAssertEqual(xml["root"]?["array"]?.array?.count, 3)
            XCTAssertEqual(xml["root"]?["array"]?[0]?.string, "value1")
            XCTAssertEqual(xml["root"]?["array"]?[1]?.string, "value2")
            XCTAssertEqual(xml["root"]?["array"]?[2]?.string, "value3")
            XCTAssertEqual(xml["root"]?["dict"]?.dictionary?.count, 1)
            XCTAssertEqual(xml["root"]?["dict"]?["key"]?.string, "value")
            XCTAssertEqual(xml["root"]?["integer"]?.int, 20)
            XCTAssertEqual(xml["root"]?["decimal"]?.double, 0.3)
        }
        catch {
            XCTFail("\(error)")
        }
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

    static var allTests: [(String, (XMLTests) -> () throws -> Void)] {
        return [
            ("testInitFromData", testInitFromData),
            ("testInitFromObject", testInitFromObject),
        ]
    }
}
