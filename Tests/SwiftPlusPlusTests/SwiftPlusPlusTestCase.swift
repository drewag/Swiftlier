//
//  SwiftPlusPlusTestCase.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/18/17.
//
//

import XCTest

protocol AnyLinuxEnforcedTestCase {
    func validateIncludesTest(named: String)
}

protocol LinuxEnforcedTestCase: AnyLinuxEnforcedTestCase {
    static var allTests: [(String, (Self) -> () throws -> Void)] {get}
}

extension XCTestCase {
    override open func tearDown() {
        guard let enforced = self as? AnyLinuxEnforcedTestCase else {
            XCTFail("All test cases must implement LinuxEnforcedTestCase protocol")
            return
        }

        enforced.validateIncludesTest(named: invocation!.selector.description)

        super.tearDown()
    }
}

extension LinuxEnforcedTestCase {
    func validateIncludesTest(named: String) {
        let contains = type(of: self).allTests.contains(where: { test in
            return test.0 == named
        })

        XCTAssert(contains, "Test '\(named)' is missing from the allTests array")

    }
}
