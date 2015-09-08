//
//  ColorTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class ColorTests: XCTestCase {
    func testWithHex() {
        XCTAssertEqual(UIColor(hex: 0xFFFFFF), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(UIColor(hex: 0xFF0000), UIColor.redColor())
        XCTAssertEqual(UIColor(hex: 0xFF), UIColor.blueColor())
    }

    func testWithHexString() {
        XCTAssertEqual(UIColor(hexString: "#FFFFFF"), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(UIColor(hexString: "#FF0000"), UIColor.redColor())
        XCTAssertEqual(UIColor(hexString: "#CC"), UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
        XCTAssertEqual(UIColor(hexString: "#CCC"), UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))

        XCTAssertNil(UIColor(hexString: "#F"))
        XCTAssertNil(UIColor(hexString: "#FFFF"))
        XCTAssertNil(UIColor(hexString: "#FFFFF"))
        XCTAssertNil(UIColor(hexString: "#FFFFFFF"))
        XCTAssertNil(UIColor(hexString: "FF"))
        XCTAssertNil(UIColor(hexString: "FFF"))
        XCTAssertNil(UIColor(hexString: "FFFFFF"))
    }
}
