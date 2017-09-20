//
//  UIView_ConstraintsTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/15/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import XCTest
import Swiftlier

final class UIView_ConstraintsTests: XCTestCase, LinuxEnforcedTestCase {
    let container = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 300))
    let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    override func setUp() {
        super.setUp()

        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(view1)
        container.addSubview(view2)
    }

    override func tearDown() {
        container.removeFromSuperview()
        view1.removeFromSuperview()
        view2.removeFromSuperview()

        super.tearDown()
    }

    func testConstrainToFullWidth() {
        view1.constrainToFullWidth(of: container, insetBy: 10)

        container.layoutIfNeeded()

        XCTAssertEqual(view1.frame.minX, 10)
        XCTAssertEqual(view1.frame.maxX, 390)
    }

    func testConstrainToFullHeight() {
        view1.constrainToFullHeight(of: container, insetBy: 10)

        container.layoutIfNeeded()

        XCTAssertEqual(view1.frame.minY, 10)
        XCTAssertEqual(view1.frame.maxY, 290)
    }

    func testConstrainToFill() {
        view1.constrainToFill(container, insetBy: CGPoint(x: 10, y: 5))

        container.layoutIfNeeded()

        XCTAssertEqual(view1.frame.minX, 10)
        XCTAssertEqual(view1.frame.maxX, 390)
        XCTAssertEqual(view1.frame.minY, 5)
        XCTAssertEqual(view1.frame.maxY, 295)
    }

    func testConstrainToCenter() {
        view1.constrainToCenter(of: container, offsetBy: CGPoint(x: 10, y: 20))

        container.layoutIfNeeded()

        XCTAssertEqual(view1.frame.midX, 210)
        XCTAssertEqual(view1.frame.midY, 170)
    }

    func testConstrainToOtherView() {
        container.constrain(.left, of: view1, plus: 10)

        container.layoutIfNeeded()

        XCTAssertEqual(view1.frame.minX, 10)
    }

    func testConstrainToOtherViewWithAttribute() {
        container.constrain(.left, of: view1)
        container.constrain(.right, of: view2)
        NSLayoutConstraint(.right, of: view1, to: .left, of: view2, plus: -10)
        NSLayoutConstraint(.width, of: view1, to: .width, of: view2)

        container.layoutIfNeeded()

        XCTAssertEqual(view1.frame.minX, 0)
        XCTAssertEqual(view1.frame.maxX, 195)
        XCTAssertEqual(view2.frame.minX, 205)
        XCTAssertEqual(view2.frame.maxX, 400)
    }

    func testConstrainToConstant() {
        view1.constrain(.width, to: 45)

        container.layoutIfNeeded()
        XCTAssertEqual(view1.frame.width, 45)
    }

    static var allTests: [(String, (UIView_ConstraintsTests) -> () throws -> Void)] {
        return [
            ("testConstrainToFullWidth", testConstrainToFullWidth),
            ("testConstrainToFullHeight", testConstrainToFullHeight),
            ("testConstrainToFill", testConstrainToFill),
            ("testConstrainToCenter", testConstrainToCenter),
            ("testConstrainToOtherView", testConstrainToOtherView),
            ("testConstrainToOtherViewWithAttribute", testConstrainToOtherViewWithAttribute),
            ("testConstrainToConstant", testConstrainToConstant),
        ]
    }
}
#endif
