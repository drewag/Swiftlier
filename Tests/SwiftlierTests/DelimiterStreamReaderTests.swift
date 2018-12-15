//
//  DelimiterStreamReaderTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 2/13/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class DelimiterStreamReaderTests: XCTestCase {
    var tempFile: Path {
        return try! FileSystem.default.workingDirectory.subdirectory("tmp").file("stream.txt")
    }

    func testTabsFromData() {
        let source = "one\ttwo\t\tthree".data(using: .utf8)!
        let reader = DelimeterStreamReader(data: source, delimeter: "\t")
        let components = Array(reader)
        XCTAssertEqual(components.count, 4)
        if components.count == 4 {
            XCTAssertEqual(components[0], "one")
            XCTAssertEqual(components[1], "two")
            XCTAssertEqual(components[2], "")
            XCTAssertEqual(components[3], "three")
        }
    }

    func testNewLinesFromData() {
        let source = "one\ntwo\n\nthree".data(using: .utf8)!
        let reader = DelimeterStreamReader(data: source)
        let components = Array(reader)
        XCTAssertEqual(components.count, 4)
        if components.count == 4 {
            XCTAssertEqual(components[0], "one")
            XCTAssertEqual(components[1], "two")
            XCTAssertEqual(components[2], "")
            XCTAssertEqual(components[3], "three")
        }
    }

    func testTabsFromFile() throws {
        let source = "one\ttwo\t\tthree".data(using: .utf8)!
        let fileHandle = try self.tempFile.createFile(containing: source, canOverwrite: true).handleForReading()
        let reader = DelimeterStreamReader(fileHandle: fileHandle, delimeter: "\t")
        let components = Array(reader)
        XCTAssertEqual(components.count, 4)
        if components.count == 4 {
            XCTAssertEqual(components[0], "one")
            XCTAssertEqual(components[1], "two")
            XCTAssertEqual(components[2], "")
            XCTAssertEqual(components[3], "three")
        }
    }

    func testNewLinesFromFile() throws {
        let source = "one\ntwo\n\nthree".data(using: .utf8)!
        let fileHandle = try self.tempFile.createFile(containing: source, canOverwrite: true).handleForReading()
        let reader = DelimeterStreamReader(fileHandle: fileHandle)
        let components = Array(reader)
        XCTAssertEqual(components.count, 4)
        if components.count == 4 {
            XCTAssertEqual(components[0], "one")
            XCTAssertEqual(components[1], "two")
            XCTAssertEqual(components[2], "")
            XCTAssertEqual(components[3], "three")
        }
    }
}

