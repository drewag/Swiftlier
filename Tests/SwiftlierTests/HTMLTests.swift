//
//  HTMLTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class HTMLTests: XCTestCase, LinuxEnforcedTestCase {
    func testDescription() {
        let html: HTML = "<h1>title</h1>"
        XCTAssertEqual(html.description, "<h1>title</h1>")
    }

    static var allTests: [(String, (HTMLTests) -> () throws -> Void)] {
        return [
            ("testDescription", testDescription),
        ]
    }
}



