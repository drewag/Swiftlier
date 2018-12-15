//
//  AlwaysEqualTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/30/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

struct Something: AlwaysEqual {
    let prop: String
}

final class AlwaysEqualTests: XCTestCase {
    func testAlwaysEqual() {
        XCTAssertEqual(Something(prop: "lhs"), Something(prop: "right"))
    }
}
