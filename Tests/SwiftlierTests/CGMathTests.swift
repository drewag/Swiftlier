//
//  CGMathTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS) || os(macOS)
import XCTest
import Swiftlier

final class CGMathTests: XCTestCase, LinuxEnforcedTestCase {
    func testAngleTo() {
        XCTAssertEqual(CGPoint(x: 1, y: 0).angle(to: CGPoint(x: 2, y: 1)).degrees, 45)
        XCTAssertEqual(CGPoint(x: 1, y: 0).angle(to: CGPoint(x: -2, y: 3)).degrees, 135)
    }

    func testCenterBetween() {
        XCTAssertEqual(CGPoint(x: 1, y: 0).centerBetween(CGPoint(x: 2, y: 1)), CGPoint(x: 1.5, y: 0.5))
        XCTAssertEqual(CGPoint(x: 1, y: 0).centerBetween(CGPoint(x: -3, y: 3)), CGPoint(x: -1, y: 1.5))
    }

    func testDistanceTo() {
        XCTAssertEqual(CGPoint(x: 1, y: 0).distance(to: CGPoint(x: 4, y: 4)), 5)
        XCTAssertEqual(CGPoint(x: 1, y: 0).distance(to: CGPoint(x: -3, y: 3)), 5)
    }

    func testAddingPoints() {
        XCTAssertEqual(CGPoint(x: 1, y: 0) + CGPoint(x: 2, y: 1), CGPoint(x: 3, y: 1))
        XCTAssertEqual(CGPoint(x: 1, y: 0) + CGPoint(x: -3, y: 3), CGPoint(x: -2, y: 3))
    }

    func testAddingPointsInPlace() {
        var point = CGPoint(x: 1, y: 0)
        point += CGPoint(x: 2, y: 1)
        XCTAssertEqual(point, CGPoint(x: 3, y: 1))

        point = CGPoint(x: 1, y: 0)
        point += CGPoint(x: -3, y: 3)
        XCTAssertEqual(point, CGPoint(x: -2, y: 3))
    }

    func testSubtractingPoints() {
        var point = CGPoint(x: 1, y: 0)
        point -= CGPoint(x: 2, y: 1)
        XCTAssertEqual(point, CGPoint(x: -1, y: -1))

        point = CGPoint(x: 1, y: 0)
        point -= CGPoint(x: -3, y: 3)
        XCTAssertEqual(point, CGPoint(x: 4, y: -3))
    }

    func testSubtractingPointsInPlace() {
        XCTAssertEqual(CGPoint(x: 1, y: 0) - CGPoint(x: 2, y: 1), CGPoint(x: -1, y: -1))
        XCTAssertEqual(CGPoint(x: 1, y: 0) - CGPoint(x: -3, y: 3), CGPoint(x: 4, y: -3))
    }

    func testMultiplyingPoints() {
        XCTAssertEqual(CGPoint(x: 1, y: 0) * CGPoint(x: 2, y: 1), CGPoint(x: 2, y: 0))
        XCTAssertEqual(CGPoint(x: 1, y: 2) * CGPoint(x: -3, y: 3), CGPoint(x: -3, y: 6))
    }

    func testMultiplyingPointsInPlace() {
        var point = CGPoint(x: 1, y: 0)
        point *= CGPoint(x: 2, y: 1)
        XCTAssertEqual(point, CGPoint(x: 2, y: 0))

        point = CGPoint(x: 1, y: 2)
        point *= CGPoint(x: -3, y: 3)
        XCTAssertEqual(point, CGPoint(x: -3, y: 6))
    }

    func testMultiplyingPoint() {
        XCTAssertEqual(CGPoint(x: 1, y: 5) * 2, CGPoint(x: 2, y: 10))
        XCTAssertEqual(CGPoint(x: 1, y: 2) * -4, CGPoint(x: -4, y: -8))
    }

    func testDividingPoint() {
        XCTAssertEqual(CGPoint(x: 1, y: 5) / 2, CGPoint(x: 0.5, y: 2.5))
        XCTAssertEqual(CGPoint(x: 1, y: 2) / -4, CGPoint(x: -0.25, y: -0.5))
    }

    static var allTests: [(String, (CGMathTests) -> () throws -> Void)] {
        return [
            ("testAngleTo", testAngleTo),
            ("testCenterBetween", testCenterBetween),
            ("testDistanceTo", testDistanceTo),
            ("testAddingPoints", testAddingPoints),
            ("testAddingPointsInPlace", testAddingPointsInPlace),
            ("testSubtractingPoints", testSubtractingPoints),
            ("testSubtractingPointsInPlace", testSubtractingPointsInPlace),
            ("testMultiplyingPoints", testMultiplyingPoints),
            ("testMultiplyingPoint", testMultiplyingPoint),
            ("testMultiplyingPointsInPlace", testMultiplyingPointsInPlace),
            ("testDividingPoint", testDividingPoint),
        ]
    }
}
#endif
