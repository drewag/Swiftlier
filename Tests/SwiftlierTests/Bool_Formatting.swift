//
//  Bool_Formatting.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Bool_FormattingTests: XCTestCase, LinuxEnforcedTestCase {
    func testInWords() {
        XCTAssertEqual(true.inWords, "Yes")
        XCTAssertEqual(false.inWords, "No")
    }

    static var allTests: [(String, (Bool_FormattingTests) -> () throws -> Void)] {
        return [
            ("testInWords", testInWords),
        ]
    }
}
