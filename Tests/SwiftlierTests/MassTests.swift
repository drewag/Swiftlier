//
//  MassTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 7/9/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class MassTests: XCTestCase, LinuxEnforcedTestCase {
    func testUnitDisplay() {
        XCTAssertEqual(Mass.Unit.grams.description, "g")
        XCTAssertEqual(Mass.Unit.kilograms.description, "kg")
        XCTAssertEqual(Mass.Unit.ounces.description, "oz")
        XCTAssertEqual(Mass.Unit.pounds.description, "lb")
        XCTAssertEqual(Mass.Unit.stones.description, "st")
    }

    func testGramsConversions() {
        XCTAssertEqual(Mass(5, in: .grams).grams, 5)
        XCTAssertEqual(Mass(5, in: .grams).in(.grams), 5)

        XCTAssertEqual(Mass(5, in: .kilograms).grams, 0.005)
        XCTAssertEqual(Mass(5, in: .kilograms).in(.grams), 0.005)

        XCTAssertEqualWithAccuracy(Mass(5, in: .ounces).grams, 141.748, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .ounces).in(.grams), 141.748, accuracy: 0.001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .pounds).grams, 2267.96, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(Mass(5, in: .pounds).in(.grams), 2267.96, accuracy: 0.1)

        XCTAssertEqualWithAccuracy(Mass(5, in: .stones).grams, 31752.1, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(Mass(5, in: .stones).in(.grams), 31752.1, accuracy: 0.1)
    }

    func testKilogramsConversions() {
        XCTAssertEqual(Mass(5, in: .grams).kilograms, 0.005)
        XCTAssertEqual(Mass(5, in: .grams).in(.kilograms), 0.005)

        XCTAssertEqual(Mass(5, in: .kilograms).kilograms, 5)
        XCTAssertEqual(Mass(5, in: .kilograms).in(.kilograms), 5)

        XCTAssertEqualWithAccuracy(Mass(5, in: .ounces).kilograms, 0.141748, accuracy: 0.000001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .ounces).in(.kilograms), 0.141748, accuracy: 0.000001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .pounds).kilograms, 2.26796, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .pounds).in(.kilograms), 2.26796, accuracy: 0.0001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .stones).kilograms, 31.7515, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .stones).in(.kilograms), 31.7515, accuracy: 0.001)
    }

    func testOuncesConversions() {
        XCTAssertEqualWithAccuracy(Mass(5, in: .grams).ounces, 0.17637, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .grams).in(.ounces), 0.17637, accuracy: 0.0001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .kilograms).ounces, 176.37, accuracy: 0.01)
        XCTAssertEqualWithAccuracy(Mass(5, in: .kilograms).in(.ounces), 176.37, accuracy: 0.01)

        XCTAssertEqual(Mass(5, in: .ounces).ounces, 5)
        XCTAssertEqual(Mass(5, in: .ounces).in(.ounces), 5)

        XCTAssertEqual(Mass(5, in: .pounds).ounces, 80)
        XCTAssertEqual(Mass(5, in: .pounds).in(.ounces), 80)

        XCTAssertEqual(Mass(5, in: .stones).ounces, 1120)
        XCTAssertEqual(Mass(5, in: .stones).in(.ounces), 1120)
    }

    func testPoundsConversions() {
        XCTAssertEqualWithAccuracy(Mass(5, in: .grams).pounds, 0.0110231, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .grams).in(.pounds), 0.0110231, accuracy: 0.0001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .kilograms).pounds, 11.0231, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .kilograms).in(.pounds), 11.0231, accuracy: 0.001)

        XCTAssertEqual(Mass(5, in: .ounces).pounds, 0.3125)
        XCTAssertEqual(Mass(5, in: .ounces).in(.pounds), 0.3125)

        XCTAssertEqual(Mass(5, in: .pounds).pounds, 5)
        XCTAssertEqual(Mass(5, in: .pounds).in(.pounds), 5)

        XCTAssertEqual(Mass(5, in: .stones).pounds, 70)
        XCTAssertEqual(Mass(5, in: .stones).in(.pounds), 70)
    }

    func testStonesConversions() {
        XCTAssertEqualWithAccuracy(Mass(5, in: .grams).stones, 0.000787365, accuracy: 0.000001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .grams).in(.stones), 0.000787365, accuracy: 0.000001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .kilograms).stones, 0.787365, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .kilograms).in(.stones), 0.787365, accuracy: 0.0001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .ounces).stones, 0.02232142857, accuracy: 0.000001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .ounces).in(.stones), 0.02232142857, accuracy: 0.000001)

        XCTAssertEqualWithAccuracy(Mass(5, in: .pounds).stones, 0.3571428571, accuracy: 0.000001)
        XCTAssertEqualWithAccuracy(Mass(5, in: .pounds).in(.stones), 0.3571428571, accuracy: 0.000001)

        XCTAssertEqual(Mass(5, in: .stones).stones, 5)
        XCTAssertEqual(Mass(5, in: .stones).in(.stones), 5)
    }

    static var allTests: [(String, (MassTests) -> () throws -> Void)] {
        return [
            ("testUnitDisplay", testUnitDisplay),
            ("testGramsConversions", testGramsConversions),
            ("testKilogramsConversions", testKilogramsConversions),
            ("testOuncesConversions", testOuncesConversions),
            ("testPoundsConversions", testPoundsConversions),
            ("testStonesConversions", testStonesConversions),
        ]
    }
}
