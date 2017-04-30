//
//  AngleTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/30/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class AngleTests: XCTestCase, LinuxEnforcedTestCase {
    func testPi() {
        XCTAssertEqualWithAccuracy(π.radians, 3.14159, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(π.degrees, 180, accuracy: 0.00001)
    }

    func testZero() {
        XCTAssertEqualWithAccuracy(Angle.zero.radians, 0, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(Angle.zero.degrees, 0, accuracy: 0.00001)
    }

    func testRadians() {
        XCTAssertEqualWithAccuracy(Angle(radians: .pi).radians, 3.14159, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(Angle(radians: .pi).degrees, 180, accuracy: 0.00001)
    }

    func testDegrees() {
        XCTAssertEqualWithAccuracy(Angle(degrees: 90).radians, 3.14159 / 2, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(Angle(degrees: 90).degrees, 90, accuracy: 0.001)
    }

    func testCosine() {
        XCTAssertEqualWithAccuracy(Angle(degrees: 90).cosine, 0, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(Angle(radians: .pi/2).cosine, 0, accuracy: 0.00001)
    }

    func testSine() {
        XCTAssertEqualWithAccuracy(Angle(degrees: 90).sine, 1, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(Angle(radians: .pi/2).sine, 1, accuracy: 0.00001)
    }

    func testEquals() {
        XCTAssertEqual(Angle(degrees: 90), Angle(degrees: 90))
        XCTAssertNotEqual(Angle(degrees: 90), Angle(degrees: 90.001))

        XCTAssertEqual(Angle(radians: 90), Angle(radians: 90))
        XCTAssertNotEqual(Angle(radians: 90), Angle(radians: 90.001))

        XCTAssertEqual(Angle(degrees: 90), Angle(radians: Float.pi/2))
        XCTAssertEqual(Angle(radians: Float.pi/2), Angle(degrees: 90))
        XCTAssertEqual(Angle(degrees: -45), Angle(radians: -Float.pi/4))
        XCTAssertEqual(Angle(radians: -Float.pi/4), Angle(degrees: -45))

        XCTAssertEqual(Angle(degrees: 360), Angle(degrees: 0))
        XCTAssertEqual(Angle(degrees: 0), Angle(degrees: 360))
        XCTAssertEqual(Angle(radians: 2 * Float.pi), Angle(radians: 0))
        XCTAssertEqual(Angle(radians: 0), Angle(radians: 2 * Float.pi))
    }

    func testLessThan() {
        XCTAssertFalse(Angle(degrees: 90) < Angle(degrees: 90))
        XCTAssertTrue(Angle(degrees: 90) < Angle(degrees: 90.0001))
        XCTAssertFalse(Angle(radians: 90) < Angle(radians: 90))
        XCTAssertTrue(Angle(radians: 90) < Angle(radians: 90.0001))

        XCTAssertFalse(Angle(degrees: 90) < Angle(radians: Float.pi/2))
        XCTAssertTrue(Angle(degrees: 90) < Angle(radians: Float.pi/2 + 0.0001))
        XCTAssertFalse(Angle(radians: Float.pi/2) < Angle(degrees: 90))
        XCTAssertTrue(Angle(radians: Float.pi/2) < Angle(degrees: 90.0001))
        XCTAssertFalse(Angle(degrees: -45) < Angle(radians: -Float.pi/4))
        XCTAssertTrue(Angle(degrees: -45) < Angle(radians: -Float.pi/4 + 0.0001))
        XCTAssertFalse(Angle(radians: -Float.pi/4) < Angle(degrees: -45))
        XCTAssertTrue(Angle(radians: -Float.pi/4) < Angle(degrees: -44.999))

        XCTAssertFalse(Angle(degrees: 360) < Angle(degrees: 0))
        XCTAssertFalse(Angle(degrees: 0) < Angle(degrees: 360))
        XCTAssertFalse(Angle(radians: 2 * Float.pi) < Angle(radians: 0))
        XCTAssertFalse(Angle(radians: 0) < Angle(radians: 2 * Float.pi))
    }

    func testLessThanOrEqual() {
        XCTAssertFalse(Angle(degrees: 90.0001) <= Angle(degrees: 90))
        XCTAssertTrue(Angle(degrees: 90) <= Angle(degrees: 90))
        XCTAssertFalse(Angle(radians: 90.0001) <= Angle(radians: 90))
        XCTAssertTrue(Angle(radians: 90) <= Angle(radians: 90))

        XCTAssertTrue(Angle(degrees: 90) <= Angle(radians: Float.pi/2))
        XCTAssertFalse(Angle(degrees: 90.0001) <= Angle(radians: Float.pi/2))
        XCTAssertTrue(Angle(radians: Float.pi/2) <= Angle(degrees: 90))
        XCTAssertFalse(Angle(radians: Float.pi/2 + 0.001) <= Angle(degrees: 90))
        XCTAssertTrue(Angle(degrees: -45) <= Angle(radians: -Float.pi/4))
        XCTAssertFalse(Angle(degrees: -44.999) <= Angle(radians: -Float.pi/4))
        XCTAssertTrue(Angle(radians: -Float.pi/4) <= Angle(degrees: -45))
        XCTAssertFalse(Angle(radians: -Float.pi/4 + 0.0001) <= Angle(degrees: -45))

        XCTAssertTrue(Angle(degrees: 360) <= Angle(degrees: 0))
        XCTAssertTrue(Angle(degrees: 0) <= Angle(degrees: 360))
        XCTAssertTrue(Angle(radians: 2 * Float.pi) <= Angle(radians: 0))
        XCTAssertTrue(Angle(radians: 0) <= Angle(radians: 2 * Float.pi))
    }

    func testGreaterThan() {
        XCTAssertFalse(Angle(degrees: 90) > Angle(degrees: 90))
        XCTAssertTrue(Angle(degrees: 90.0001) > Angle(degrees: 90))
        XCTAssertFalse(Angle(radians: 90) > Angle(radians: 90))
        XCTAssertTrue(Angle(radians: 90.0001) > Angle(radians: 90))

        XCTAssertFalse(Angle(degrees: 90) > Angle(radians: Float.pi/2))
        XCTAssertTrue(Angle(degrees: 90.0001) > Angle(radians: Float.pi/2))
        XCTAssertFalse(Angle(radians: Float.pi/2) > Angle(degrees: 90))
        XCTAssertTrue(Angle(radians: Float.pi/2 + 0.0001) > Angle(degrees: 90))
        XCTAssertFalse(Angle(degrees: -45) > Angle(radians: -Float.pi/4))
        XCTAssertTrue(Angle(degrees: -44.999) > Angle(radians: -Float.pi/4))
        XCTAssertFalse(Angle(radians: -Float.pi/4) > Angle(degrees: -45))
        XCTAssertTrue(Angle(radians: -Float.pi/4 + 0.0001) > Angle(degrees: -45))

        XCTAssertFalse(Angle(degrees: 360) > Angle(degrees: 0))
        XCTAssertFalse(Angle(degrees: 0) > Angle(degrees: 360))
        XCTAssertFalse(Angle(radians: 2 * Float.pi) > Angle(radians: 0))
        XCTAssertFalse(Angle(radians: 0) > Angle(radians: 2 * Float.pi))
    }

    func testGreaterThanOrEqual() {
        XCTAssertFalse(Angle(degrees: 90) >= Angle(degrees: 90.0001))
        XCTAssertTrue(Angle(degrees: 90) >= Angle(degrees: 90))
        XCTAssertFalse(Angle(radians: 90) >= Angle(radians: 90.0001))
        XCTAssertTrue(Angle(radians: 90) >= Angle(radians: 90))

        XCTAssertTrue(Angle(degrees: 90) >= Angle(radians: Float.pi/2))
        XCTAssertFalse(Angle(degrees: 90) >= Angle(radians: Float.pi/2 + 0.0001))
        XCTAssertTrue(Angle(radians: Float.pi/2) >= Angle(degrees: 90))
        XCTAssertFalse(Angle(radians: Float.pi/2) >= Angle(degrees: 90.0001))
        XCTAssertTrue(Angle(degrees: -45) >= Angle(radians: -Float.pi/4))
        XCTAssertFalse(Angle(degrees: -45) >= Angle(radians: -Float.pi/4 + 0.0001))
        XCTAssertTrue(Angle(radians: -Float.pi/4) >= Angle(degrees: -45))
        XCTAssertFalse(Angle(radians: -Float.pi/4) >= Angle(degrees: -44.999))

        XCTAssertTrue(Angle(degrees: 360) >= Angle(degrees: 0))
        XCTAssertTrue(Angle(degrees: 0) >= Angle(degrees: 360))
        XCTAssertTrue(Angle(radians: 2 * Float.pi) >= Angle(radians: 0))
        XCTAssertTrue(Angle(radians: 0) >= Angle(radians: 2 * Float.pi))
    }

    func testAdd() {
        XCTAssertEqual((Angle(degrees: 45) + Angle(degrees: 45)).degrees, 90)
        XCTAssertEqualWithAccuracy((Angle(degrees: 90) + Angle(radians: Float.pi/4)).degrees, 135, accuracy: 0.0001)
        XCTAssertEqual((Angle(radians: Float.pi/2) + Angle(radians: .pi/2)).radians, .pi)
        XCTAssertEqual((Angle(radians: Float.pi/2) + Angle(degrees: 45)).radians, 3 * .pi / 4)

        XCTAssertEqual((Angle(degrees: 90) + Angle(degrees: 720)).degrees, 90)
        XCTAssertEqualWithAccuracy((Angle(radians: Float.pi/2) + Angle(radians: 8 * .pi)).radians, .pi/2, accuracy: 0.0001)
    }

    func testAddInPlace() {
        var angle = Angle<Float>(degrees: 45)
        angle += Angle(degrees: 45)
        XCTAssertEqual(angle.degrees, 90)

        angle = Angle(degrees: 90)
        angle += Angle(radians: .pi/4)
        XCTAssertEqualWithAccuracy(angle.degrees, 135, accuracy: 0.0001)

        angle = Angle(radians: Float.pi/2)
        angle += Angle(radians: .pi/2)
        XCTAssertEqual(angle.radians, .pi)

        angle = Angle(radians: Float.pi/2)
        angle += Angle(degrees: 45)
        XCTAssertEqual(angle.radians, 3 * .pi / 4)

        angle = Angle(degrees: 90)
        angle += Angle(degrees: 720)
        XCTAssertEqual(angle.degrees, 90)

        angle = Angle(radians: Float.pi/2)
        angle += Angle(radians: 8 * .pi)
        XCTAssertEqualWithAccuracy(angle.radians, .pi/2, accuracy: 0.0001)
    }

    func testSubtract() {
        XCTAssertEqual((Angle(degrees: 90) - Angle(degrees: 45)).degrees, 45)
        XCTAssertEqualWithAccuracy((Angle(degrees: 135) - Angle(radians: Float.pi/4)).degrees, 90, accuracy: 0.0001)
        XCTAssertEqual((Angle(radians: Float.pi) - Angle(radians: .pi/2)).radians, .pi/2)
        XCTAssertEqualWithAccuracy((Angle(radians: 3 * Float.pi / 4) - Angle(degrees: 45)).radians, .pi/2, accuracy: 0.0001)

        XCTAssertEqual((Angle(degrees: -90) - Angle(degrees: 720)).degrees, -90)
        XCTAssertEqualWithAccuracy((Angle(radians: -Float.pi/2) - Angle(radians: 8 * .pi)).radians, -.pi/2, accuracy: 0.0001)
    }

    func testSubtractInPlace() {
        var angle = Angle<Float>(degrees: 90)
        angle -= Angle(degrees: 45)
        XCTAssertEqual(angle.degrees, 45)

        angle = Angle(degrees: 135)
        angle -= Angle(radians: .pi/4)
        XCTAssertEqualWithAccuracy(angle.degrees, 90, accuracy: 0.0001)

        angle = Angle(radians: Float.pi)
        angle -= Angle(degrees: 90)
        XCTAssertEqual(angle.radians, .pi/2)

        angle = Angle(radians: 3 * .pi / 4)
        angle -= Angle(radians: .pi/4)
        XCTAssertEqualWithAccuracy(angle.radians, .pi/2, accuracy: 0.0001)

        angle = Angle(degrees: -90)
        angle -= Angle(degrees: 720)
        XCTAssertEqual(angle.degrees, -90)

        angle = Angle(radians: -.pi/2)
        angle -= Angle(radians: 8 * .pi)
        XCTAssertEqualWithAccuracy(angle.radians, -.pi/2, accuracy: 0.0001)
    }

    func testMultiplyByValue() {
        XCTAssertEqual((Angle(degrees: 45) * 2).degrees, 90)
        XCTAssertEqual((Angle(radians: Float.pi / 4) * 2).degrees, 90)

        XCTAssertEqual((Angle(degrees: 45) * 20).degrees, 180)
        XCTAssertEqualWithAccuracy((Angle(radians: Float.pi / 4) * 20).degrees, 180, accuracy: 0.0001)
    }

    func testMultiplyByValueInPlace() {
        var angle = Angle<Float>(degrees: 45)
        angle *= 2
        XCTAssertEqual(angle.degrees, 90)

        angle = Angle(radians: Float.pi / 4)
        angle *= 2
        XCTAssertEqual(angle.degrees, 90)

        angle = Angle(degrees: 45)
        angle *= 20
        XCTAssertEqual(angle.degrees, 180)

        angle = Angle(radians: Float.pi / 4)
        angle *= 20
        XCTAssertEqualWithAccuracy(angle.degrees, 180, accuracy: 0.0001)
    }

    func testDivideByValue() {
        XCTAssertEqual((Angle(degrees: 45) / 0.5).degrees, 90)
        XCTAssertEqual((Angle(radians: Float.pi / 4) / 0.5).degrees, 90)

        XCTAssertEqual((Angle(degrees: 45) / 0.05).degrees, 180)
        XCTAssertEqualWithAccuracy((Angle(radians: Float.pi / 4) / 0.05).degrees, 180, accuracy: 0.0001)
    }

    func testDivideByValueInPlace() {
        var angle = Angle<Float>(degrees: 45)
        angle /= 0.5
        XCTAssertEqual(angle.degrees, 90)

        angle = Angle(radians: Float.pi / 4)
        angle /= 0.5
        XCTAssertEqual(angle.degrees, 90)

        angle = Angle(degrees: 45)
        angle /= 0.05
        XCTAssertEqual(angle.degrees, 180)

        angle = Angle(radians: Float.pi / 4)
        angle /= 0.05
        XCTAssertEqualWithAccuracy(angle.degrees, 180, accuracy: 0.0001)
    }

    static var allTests: [(String, (AngleTests) -> () throws -> Void)] {
        return [
            ("testPi", testPi),
            ("testZero", testZero),
            ("testRadians", testRadians),
            ("testDegrees", testDegrees),
            ("testCosine", testCosine),
            ("testSine", testSine),
            ("testEquals", testEquals),
            ("testLessThan", testLessThan),
            ("testLessThanOrEqual", testLessThanOrEqual),
            ("testGreaterThan", testGreaterThan),
            ("testGreaterThanOrEqual", testGreaterThanOrEqual),
            ("testAdd", testAdd),
            ("testAddInPlace", testAddInPlace),
            ("testSubtract", testSubtract),
            ("testSubtractInPlace", testSubtractInPlace),
            ("testMultiplyByValue", testMultiplyByValue),
            ("testMultiplyByValueInPlace", testMultiplyByValueInPlace),
            ("testDivideByValue", testDivideByValue),
            ("testDivideByValueInPlace", testDivideByValueInPlace),
        ]
    }
}
