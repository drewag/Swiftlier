//
//  CSVStreamReaderTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 2/13/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class CSVStreamReaderTests: XCTestCase {
    var tempFile: Path {
        return try! FileSystem.default.workingDirectory.subdirectory("tmp").file("stream.txt")
    }

    func testSimpleFromData() {
        let source = "Front,Back\nCard 1,Back 1\nCard 2,Back 2\nCard 3,Back 3\n".data(using: .utf8)!
        let reader = CSVStreamReader(data: source)
        let components = Array(reader)
        XCTAssertEqual(components.count, 4)
        if components.count == 4 {
            XCTAssertEqual(components[0], ["Front","Back"])
            XCTAssertEqual(components[1], ["Card 1","Back 1"])
            XCTAssertEqual(components[2], ["Card 2","Back 2"])
            XCTAssertEqual(components[3], ["Card 3","Back 3"])
        }
    }

    func testComplexFromData() {
        let source = "Front,Back\r\nCard 1,Back 1\r\n\"\"\"Card 2\",\"Back 2\"\"\"\r\nCard 3,Bac\"k 3\r\n\"Card 4\r\nWith new line\",Back 4\r\nCard 5,\"Back 5 trailing\r\n\"\r\n".data(using: .utf8)!
        let reader = CSVStreamReader(data: source)
        let components = Array(reader)
        XCTAssertEqual(components.count, 6)
        if components.count == 6 {
            XCTAssertEqual(components[0], ["Front","Back"])
            XCTAssertEqual(components[1], ["Card 1","Back 1"])
            XCTAssertEqual(components[2], ["\"Card 2","Back 2\""])
            XCTAssertEqual(components[3], ["Card 3","Bac\"k 3"])
            XCTAssertEqual(components[4], ["Card 4\r\nWith new line","Back 4"])
            XCTAssertEqual(components[5], ["Card 5","Back 5 trailing\r\n"])
        }
    }

    func testSimpleFromFile() throws {
        let source = "Front,Back\nCard 1,Back 1\nCard 2,Back 2\nCard 3,Back 3\n".data(using: .utf8)!
        let fileHandle = try self.tempFile.createFile(containing: source, canOverwrite: true).handleForReading()
        let reader = CSVStreamReader(fileHandle: fileHandle)
        let components = Array(reader)
        XCTAssertEqual(components.count, 4)
        if components.count == 4 {
            XCTAssertEqual(components[0], ["Front","Back"])
            XCTAssertEqual(components[1], ["Card 1","Back 1"])
            XCTAssertEqual(components[2], ["Card 2","Back 2"])
            XCTAssertEqual(components[3], ["Card 3","Back 3"])
        }
    }

    func testComplexFromFile() throws {
        let source = "Front,Back\r\nCard 1,Back 1\r\n\"\"\"Card 2\",\"Back 2\"\"\"\r\nCard 3,Bac\"k 3\r\n\"Card 4\r\nWith new line\",Back 4\r\nCard 5,\"Back 5 trailing\r\n\"\r\n".data(using: .utf8)!
        let fileHandle = try self.tempFile.createFile(containing: source, canOverwrite: true).handleForReading()
        let reader = CSVStreamReader(fileHandle: fileHandle)
        let components = Array(reader)
        XCTAssertEqual(components.count,6)
        if components.count == 6 {
            XCTAssertEqual(components[0], ["Front","Back"])
            XCTAssertEqual(components[1], ["Card 1","Back 1"])
            XCTAssertEqual(components[2], ["\"Card 2","Back 2\""])
            XCTAssertEqual(components[3], ["Card 3","Bac\"k 3"])
            XCTAssertEqual(components[4], ["Card 4\r\nWith new line","Back 4"])
            XCTAssertEqual(components[5], ["Card 5","Back 5 trailing\r\n"])
        }
    }
}
