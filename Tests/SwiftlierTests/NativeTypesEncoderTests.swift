//
//  NativeTypesEncoderTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 10/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class NativeTypesEncoderTests: XCTestCase {
    func testObjectFromEncodable() throws {
        let codable = TestCodable(string: "some", int: 4)
        let object = try NativeTypesEncoder.object(from: codable)
        let dict = object as? [String:Any]
        XCTAssertEqual(dict?["string"] as? String, "some")
        XCTAssertEqual(dict?["int"] as? Int, 4)
    }
}

