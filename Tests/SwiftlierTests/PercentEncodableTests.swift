//
//  PercentEncodableTests.swift
//  SwiftlierTests
//
//  Created by Andrew Wagner on 8/4/19.
//

import XCTest

class PercentEncodableTests: XCTestCase {
    func testURLEncodedDictionary() {
        let encodable = [
            "key_1_!@#$%=": "value_1_!@#$%=",
            "key_2_!@#$%=": "value_2_!@#$%=",
        ]
        let dict = encodable.percentEncoded
        XCTAssertEqual(dict?.count, 2)
        XCTAssertEqual(dict?["key%5F1%5F%21%40%23%24%25%3D"], "value%5F1%5F%21%40%23%24%25%3D")
        XCTAssertEqual(dict?["key%5F2%5F%21%40%23%24%25%3D"], "value%5F2%5F%21%40%23%24%25%3D")
    }

    func testURLEncodedString() {
        let encodable = [
            "key_1_!@#$%=": "value_1_!@#$%=",
        ]

        XCTAssertEqual(encodable.URLEncodedString, "key%5F1%5F%21%40%23%24%25%3D=value%5F1%5F%21%40%23%24%25%3D")
    }

    func testURLEncodedData() {
        let encodable = [
            "key_1_!@#$%=": "value_1_!@#$%=",
        ]

        let data = encodable.URLEncodedData!
        XCTAssertEqual(String(data: data, encoding: .utf8), "key%5F1%5F%21%40%23%24%25%3D=value%5F1%5F%21%40%23%24%25%3D")
    }
}
