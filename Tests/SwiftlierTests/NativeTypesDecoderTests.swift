//
//  NativeTypesDecoderTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 10/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class NativeTypesDecoderTests: XCTestCase {
    func testDecodableFromRaw() throws {
        let raw: [String:Any] = [
            "string": "some",
            "int": 4,
        ]
        let codable: TestCodable = try NativeTypesDecoder.decodable(from: raw)
        XCTAssertEqual(codable.string, "some")
        XCTAssertEqual(codable.int, 4)
    }
}


