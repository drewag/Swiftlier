//
//  Optional+SwiftPlusPlusTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 6/8/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class Optional_SwiftPlusPlusTests: XCTestCase {
    func testOrWithNil() {
        var optionalString : String?
        var result = optionalString.or("Default")
        XCTAssertEqualObjects(result, "Default")
    }

    func testOrWithValue() {
        var optionalString : String? = "Other"
        XCTAssertEqualObjects(optionalString.or("Default"), "Other")
    }
}
