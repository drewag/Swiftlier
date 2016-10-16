//
//  ColorTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import XCTest
import SwiftPlusPlus

class ColorTests: XCTestCase {
    func testWithHex() {
        XCTAssertEqual(UIColor(hex: 0xFFFFFF), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(UIColor(hex: 0xFF0000), UIColor.red)
        XCTAssertEqual(UIColor(hex: 0xFF), UIColor.blue)
    }

    func testWithHexString() {
        XCTAssertEqual(try! UIColor(hexString: "#FFFFFF"), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        XCTAssertEqual(try! UIColor(hexString: "#FF0000"), UIColor.red)
        XCTAssertEqual(try! UIColor(hexString: "#CC"), UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
        XCTAssertEqual(try! UIColor(hexString: "#CCC"), UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))

//        XCTAssertThrowsError(try UIColor(hexString: "#F"))
//        XCTAssertThrowsError(try UIColor(hexString: "#FFFF"))
//        XCTAssertThrowsError(try UIColor(hexString: "#FFFFF"))
//        XCTAssertThrowsError(try UIColor(hexString: "#FFFFFFF"))
//        XCTAssertThrowsError(try UIColor(hexString: "FF"))
//        XCTAssertThrowsError(try UIColor(hexString: "FFF"))
//        XCTAssertThrowsError(try UIColor(hexString: "FFFFFF"))
    }
}
#endif
