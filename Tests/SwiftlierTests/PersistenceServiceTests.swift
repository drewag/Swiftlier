//
//  PersistenceServiceTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/27/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Foundation
import Swiftlier

final class PersistenceServiceTests: XCTestCase, LinuxEnforcedTestCase {
    var base: DirectoryPath {
        return try! FileSystem.default.workingDirectory.subdirectory("tmp")
    }

    override func setUp() {
        if let nonExistent = self.base as? NonExistingPath {
            let _ = try? nonExistent.createDirectory()
        }
    }

    override func tearDown() {
        let _ = try? self.base.delete()

        self.checkTestIncludedForLinux()
        super.tearDown()
    }

    func testEmpty() throws {
        let service = try PersistenceService<TestCodable>(to: self.base)
        XCTAssertEqual(service.values.count, 0)
    }

    func testWithValues() throws {
        let service = try PersistenceService<TestCodable>(to: self.base)
        service.values.append(TestCodable(string: "one", int: 1))
        service.values.append(TestCodable(string: "two", int: 2))
        XCTAssertNoThrow(try service.save())

        try service.reload()

        XCTAssertEqual(service.values.count, 2)
        XCTAssertEqual(service.values[0].string, "one")
        XCTAssertEqual(service.values[0].int, 1)
        XCTAssertEqual(service.values[1].string, "two")
        XCTAssertEqual(service.values[1].int, 2)

        let service2 = try PersistenceService<TestCodable>(to: self.base)
        XCTAssertEqual(service2.values.count, 2)
        XCTAssertEqual(service2.values[0].string, "one")
        XCTAssertEqual(service2.values[0].int, 1)
        XCTAssertEqual(service2.values[1].string, "two")
        XCTAssertEqual(service2.values[1].int, 2)
    }

    static var allTests: [(String, (PersistenceServiceTests) -> () throws -> Void)] {
        return [
            ("testEmpty", testEmpty),
            ("testWithValues", testWithValues),
        ]
    }
}
