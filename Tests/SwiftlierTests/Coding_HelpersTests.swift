//
//  Coding_HelpersTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/30/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Coding_HelpersTests: XCTestCase {
    func testCopyUsingCoding() throws {
        let reference = TestReferenceCodable(string: "some", int: 4)
        let copy = try reference.copyUsingEncoding()
        XCTAssertFalse(copy === reference)
        XCTAssertEqual(copy.string, "some")
        XCTAssertEqual(copy.int, 4)
    }
}

