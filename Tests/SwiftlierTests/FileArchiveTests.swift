//
//  FileArchiveTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/27/17.
//
//

import XCTest
import Foundation
import Swiftlier

func encode(_ data: Data) throws -> Data {
    return data.base64.data(using: .utf8)!
}

func decode(_ data: Data) throws -> Data {
    let string = String(data: data, encoding: .utf8)!
    return Data(base64Encoded: string)!
}

final class FileArchiveTests: XCTestCase, LinuxEnforcedTestCase {
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

    func testAddEncodable() throws {
        let encodable = TestCodable(string: "some", int: 2)
        let file = try self.base.addFile(named: "archive.plist", containingEncodable: encodable, canOverwrite: false, encrypt: encode)

        var decoded: TestCodable = try file.decodable(decrypt: decode)
        XCTAssertEqual(decoded.string, "some")
        XCTAssertEqual(decoded.int, 2)

        XCTAssertThrowsError(try self.base.addFile(named: "archive.plist", containingEncodable: encodable, canOverwrite: false, encrypt: encode))

        let encodable2 = TestCodable(string: "other", int: 3)
        try self.base.addFile(named: "archive.plist", containingEncodable: encodable2, canOverwrite: true, encrypt: encode)
        decoded = try file.decodable(decrypt: decode)
        XCTAssertEqual(decoded.string, "other")
        XCTAssertEqual(decoded.int, 3)
    }

    func testCreateEncodable() throws {
        let encodable = TestCodable(string: "some", int: 2)
        guard let file = try self.base.file("archive.plist").nonExisting else {
            XCTFail()
            return
        }
        let archive = try file.createFile(containingEncodable: encodable, canOverwrite: false, encrypt: encode)

        var decoded: TestCodable = try archive.decodable(decrypt: decode)
        XCTAssertEqual(decoded.string, "some")
        XCTAssertEqual(decoded.int, 2)

        XCTAssertThrowsError(try file.createFile(containingEncodable: encodable, canOverwrite: false, encrypt: encode))

        let encodable2 = TestCodable(string: "other", int: 3)
        try file.createFile(containingEncodable: encodable2, canOverwrite: true, encrypt: encode)
        decoded = try archive.decodable(decrypt: decode)
        XCTAssertEqual(decoded.string, "other")
        XCTAssertEqual(decoded.int, 3)
    }

    func testAddEncodableArray() throws {
        let encodable = [TestCodable(string: "one", int: 1), TestCodable(string: "two", int: 2)]
        let file = try self.base.addFile(named: "archive.plist", containingEncodableArray: encodable, canOverwrite: false, encrypt: encode)

        var decoded: [TestCodable] = try file.decodableArray(decrypt: decode)
        XCTAssertEqual(decoded.count, 2)
        XCTAssertEqual(decoded[0].string, "one")
        XCTAssertEqual(decoded[0].int, 1)
        XCTAssertEqual(decoded[1].string, "two")
        XCTAssertEqual(decoded[1].int, 2)

        XCTAssertThrowsError(try self.base.addFile(named: "archive.plist", containingEncodableArray: encodable, canOverwrite: false, encrypt: encode))

        let encodable2 = [TestCodable(string: "three", int: 3)]
        try self.base.addFile(named: "archive.plist", containingEncodableArray: encodable2, canOverwrite: true, encrypt: encode)
        decoded = try file.decodableArray(decrypt: decode)
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded[0].string, "three")
        XCTAssertEqual(decoded[0].int, 3)
    }

    func testCreateEncodableArray() throws {
        let encodable = [TestCodable(string: "one", int: 1), TestCodable(string: "two", int: 2)]
        guard let file = try self.base.file("archive.plist").nonExisting else {
            XCTFail()
            return
        }
        let archive = try file.createFile(containingEncodableArray: encodable, canOverwrite: false, encrypt: encode)

        var decoded: [TestCodable] = try archive.decodableArray(decrypt: decode)
        XCTAssertEqual(decoded.count, 2)
        XCTAssertEqual(decoded[0].string, "one")
        XCTAssertEqual(decoded[0].int, 1)
        XCTAssertEqual(decoded[1].string, "two")
        XCTAssertEqual(decoded[1].int, 2)
        XCTAssertThrowsError(try file.createFile(containingEncodableArray: encodable, canOverwrite: false, encrypt: encode))

        let encodable2 = [TestCodable(string: "three", int: 3)]
        try file.createFile(containingEncodableArray: encodable2, canOverwrite: true, encrypt: encode)
        decoded = try archive.decodableArray(decrypt: decode)
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded[0].string, "three")
        XCTAssertEqual(decoded[0].int, 3)
    }

    func testAddEncodableDictionary() throws {
        let encodable = ["one":TestCodable(string: "one", int: 1), "two":TestCodable(string: "two", int: 2)]
        let file = try self.base.addFile(named: "archive.plist", containingEncodableDict: encodable, canOverwrite: false, encrypt: encode)

        var decoded: [String:TestCodable] = try file.decodableDict(decrypt: decode)
        XCTAssertEqual(decoded.count, 2)
        XCTAssertEqual(decoded["one"]?.string, "one")
        XCTAssertEqual(decoded["one"]?.int, 1)
        XCTAssertEqual(decoded["two"]?.string, "two")
        XCTAssertEqual(decoded["two"]?.int, 2)

        XCTAssertThrowsError(try self.base.addFile(named: "archive.plist", containingEncodableDict: encodable, canOverwrite: false, encrypt: encode))

        let encodable2 = ["three":TestCodable(string: "three", int: 3)]
        try self.base.addFile(named: "archive.plist", containingEncodableDict: encodable2, canOverwrite: true, encrypt: encode)
        decoded = try file.decodableDict(decrypt: decode)
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded["three"]?.string, "three")
        XCTAssertEqual(decoded["three"]?.int, 3)
    }

    func testCreateEncodableDictionary() throws {
        let encodable = ["one":TestCodable(string: "one", int: 1), "two":TestCodable(string: "two", int: 2)]
        guard let file = try self.base.file("archive.plist").nonExisting else {
            XCTFail()
            return
        }
        let archive = try file.createFile(containingEncodableDict: encodable, canOverwrite: false, encrypt: encode)

        var decoded: [String:TestCodable] = try archive.decodableDict(decrypt: decode)
        XCTAssertEqual(decoded.count, 2)
        XCTAssertEqual(decoded["one"]?.string, "one")
        XCTAssertEqual(decoded["one"]?.int, 1)
        XCTAssertEqual(decoded["two"]?.string, "two")
        XCTAssertEqual(decoded["two"]?.int, 2)
        XCTAssertThrowsError(try file.createFile(containingEncodableDict: encodable, canOverwrite: false, encrypt: encode))

        let encodable2 = ["three":TestCodable(string: "three", int: 3)]
        try file.createFile(containingEncodableDict: encodable2, canOverwrite: true, encrypt: encode)
        decoded = try archive.decodableDict(decrypt: decode)
        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded["three"]?.string, "three")
        XCTAssertEqual(decoded["three"]?.int, 3)
    }

    static var allTests: [(String, (FileArchiveTests) -> () throws -> Void)] {
        return [
            ("testAddEncodable", testAddEncodable),
            ("testCreateEncodable", testCreateEncodable),
            ("testAddEncodableArray", testAddEncodableArray),
            ("testCreateEncodableArray", testCreateEncodableArray),
            ("testAddEncodableDictionary", testAddEncodableDictionary),
            ("testCreateEncodableDictionary", testCreateEncodableDictionary),
        ]
    }
}
