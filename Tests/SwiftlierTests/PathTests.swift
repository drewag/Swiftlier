//
//  PathTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/19/17.
//
//

import XCTest
import Foundation
import Swiftlier

final class PathTests: XCTestCase, LinuxEnforcedTestCase {
    var base: DirectoryPath {
        return try! FileSystem.default.workingDirectory.subdirectory("tmp")
    }

    func string(at url: URL) throws -> String? {
        return try String(data: Data(contentsOf: url), encoding: .utf8)
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

    func testBaseName() {
        XCTAssertEqual(try self.base.file("name").basename, "name")
        XCTAssertEqual(try self.base.file("name.txt").basename, "name.txt")
        XCTAssertEqual(try self.base.subdirectory("sub").file("name.txt").basename, "name.txt")
    }

    func testName() {
        XCTAssertEqual(try self.base.file("name").name, "name")
        XCTAssertEqual(try self.base.file("name.txt").name, "name")
        XCTAssertEqual(try self.base.subdirectory("sub").file("name.txt").name, "name")
    }

    func testExtension() throws {
        XCTAssertEqual(try self.base.file("name").extension, "")
        XCTAssertEqual(try self.base.file("name.txt").extension, "txt")
        XCTAssertEqual(try self.base.subdirectory("sub").file("name.txt").extension, "txt")
        try self.base.subdirectory("sub").delete()
    }

    func testDirectory() throws {
        let toTest = try self.base.subdirectory("sub")
        XCTAssertNotNil(toTest.directory)

        try toTest.delete()
        XCTAssertNil(toTest.directory)

        let file = try self.base.addFile(named: "sub", canOverwrite: true)
        XCTAssertNil(toTest.directory)

        try file.delete()
    }

    func testNonExisting() throws {
        let toTest = try self.base.subdirectory("sub")
        XCTAssertNil(toTest.nonExisting)

        try toTest.delete()
        XCTAssertNotNil(toTest.nonExisting)

        let file = try self.base.addFile(named: "sub", canOverwrite: true)
        XCTAssertNil(toTest.nonExisting)

        try file.delete()
    }

    func testFile() throws {
        let toTest = try self.base.subdirectory("sub")
        XCTAssertNil(toTest.file)

        try toTest.delete()
        XCTAssertNil(toTest.file)

        let file = try self.base.addFile(named: "sub", canOverwrite: true)
        XCTAssertNotNil(toTest.file)

        try file.delete()
    }

    func testExsiting() throws {
        let toTest = try self.base.subdirectory("sub")
        XCTAssertNotNil(toTest.existing)

        try toTest.delete()
        XCTAssertNil(toTest.existing)

        let file = try self.base.addFile(named: "sub", canOverwrite: true)
        XCTAssertNotNil(toTest.existing)

        try file.delete()
    }

    func testWithoutLastComponent() {
        XCTAssertEqual(try self.base.subdirectory("sub").withoutLastComponent.url.relativePath, "./tmp")
        XCTAssertEqual(try self.base.subdirectory("sub").file("name.txt").withoutLastComponent.url.relativePath, "./tmp/sub")
    }

    func testDescription() throws {
        let toTest = try self.base.subdirectory("sub")
        XCTAssertEqual(toTest.description, "Directory(./tmp/sub)")

        try toTest.delete()
        XCTAssertEqual(toTest.description, "None(./tmp/sub)")

        let file = try self.base.addFile(named: "sub", canOverwrite: true)
        XCTAssertEqual(toTest.description, "File(./tmp/sub)")

        try file.delete()
    }

    func testDelete() throws {
        let fileUrl = URL(fileURLWithPath: "tmp/file.txt")
        try "test".data(using: .utf8)?.write(to: fileUrl)
        XCTAssertTrue(FileManager.default.fileExists(at: fileUrl))
        XCTAssertEqual(try (try self.base.file("file.txt") as! ExistingPath).delete().description, "None(./tmp/file.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fileUrl))

        let dirUrl = URL(fileURLWithPath: "tmp/sub")
        try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
        XCTAssertTrue(FileManager.default.fileExists(at: dirUrl))
        XCTAssertEqual(try self.base.subdirectory("sub").delete().description, "None(./tmp/sub)")
        XCTAssertFalse(FileManager.default.fileExists(at: dirUrl))
    }

    func testMoveFileWithinDirectory() throws {
        let fromFileUrl = URL(fileURLWithPath: "tmp/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/other.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.move(into: self.base, named: "other.txt", canOverwrite: false).description, "File(./tmp/other.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.move(into: self.base, named: "other.txt", canOverwrite: true).description, "File(./tmp/other.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.move(into: self.base, named: "other.txt", canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testMoveFileToDifferentDirectoryWithSameName() throws {
        let _ = try self.base.subdirectory("sub1")
        let toDirectory = try self.base.subdirectory("sub2")

        let fromFileUrl = URL(fileURLWithPath: "tmp/sub1/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/sub2/file.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.subdirectory("sub1").file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.move(into: toDirectory, canOverwrite: false).description, "File(./tmp/sub2/file.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.move(into: toDirectory, canOverwrite: true).description, "File(./tmp/sub2/file.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.move(into: toDirectory, canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testMoveFileToDifferentDirectoryWithDifferentName() throws {
        let _ = try self.base.subdirectory("sub1")
        let toDirectory = try self.base.subdirectory("sub2")

        let fromFileUrl = URL(fileURLWithPath: "tmp/sub1/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/sub2/other.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.subdirectory("sub1").file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.move(into: toDirectory, named: "other.txt", canOverwrite: false).description, "File(./tmp/sub2/other.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.move(into: toDirectory, named: "other.txt", canOverwrite: true).description, "File(./tmp/sub2/other.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.move(into: toDirectory, named: "other.txt", canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testMoveFileDirectlyToPath() throws {
        let fromFileUrl = URL(fileURLWithPath: "tmp/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/other.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        let toPath = try self.base.file("other.txt")

        // Move to non-existent path
        XCTAssertEqual(try file.move(to: toPath, canOverwrite: false).description, "File(./tmp/other.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.move(to: toPath, canOverwrite: true).description, "File(./tmp/other.txt)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.move(to: toPath, canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testMoveDirectoryWithinDirectory() throws {
        let fromDirectoryUrl = URL(fileURLWithPath: "tmp/dir")
        let toDirectoryUrl = URL(fileURLWithPath: "tmp/other")
        let fileWithinToDirectoryUrl = URL(fileURLWithPath: "tmp/other/file.txt")

        var directory = try self.base.subdirectory("dir")

        // Move to non-existent path
        XCTAssertEqual(try directory.move(into: self.base, named: "other", canOverwrite: false).description, "Directory(./tmp/other)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))

        // Move and overwrite
        directory = try self.base.subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        XCTAssertEqual(try directory.move(into: self.base, named: "other", canOverwrite: true).description, "Directory(./tmp/other)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertFalse(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        // Move and fail to overwrite
        directory = try self.base.subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertThrowsError(try directory.move(into: self.base, named: "other", canOverwrite: false))
        XCTAssertTrue(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))
    }

    func testMoveDirectoryToDifferentDirectoryWithSameName() throws {
        let _ = try self.base.subdirectory("sub1")
        let toDirectory = try self.base.subdirectory("sub2")


        let fromDirectoryUrl = URL(fileURLWithPath: "tmp/sub1/dir")
        let toDirectoryUrl = URL(fileURLWithPath: "tmp/sub2/dir")
        let fileWithinToDirectoryUrl = URL(fileURLWithPath: "tmp/sub2/dir/file.txt")

        var directory = try self.base.subdirectory("sub1").subdirectory("dir")

        // Move to non-existent path
        XCTAssertEqual(try directory.move(into: toDirectory, canOverwrite: false).description, "Directory(./tmp/sub2/dir)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))

        // Move and overwrite
        directory = try self.base.subdirectory("sub1").subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        XCTAssertEqual(try directory.move(into: toDirectory, canOverwrite: true).description, "Directory(./tmp/sub2/dir)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertFalse(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        // Move and fail to overwrite
        directory = try self.base.subdirectory("sub1").subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertThrowsError(try directory.move(into: toDirectory, canOverwrite: false))
        XCTAssertTrue(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))
    }

    func testMoveDirectoryToDifferentDirectoryWithDifferentName() throws {
        let _ = try self.base.subdirectory("sub1")
        let toDirectory = try self.base.subdirectory("sub2")

        let fromDirectoryUrl = URL(fileURLWithPath: "tmp/sub1/dir")
        let toDirectoryUrl = URL(fileURLWithPath: "tmp/sub2/other")
        let fileWithinToDirectoryUrl = URL(fileURLWithPath: "tmp/sub2/other/file.txt")

        var directory = try self.base.subdirectory("sub1").subdirectory("dir")

        // Move to non-existent path
        XCTAssertEqual(try directory.move(into: toDirectory, named: "other", canOverwrite: false).description, "Directory(./tmp/sub2/other)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))

        // Move and overwrite
        directory = try self.base.subdirectory("sub1").subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        XCTAssertEqual(try directory.move(into: toDirectory, named: "other", canOverwrite: true).description, "Directory(./tmp/sub2/other)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertFalse(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        // Move and fail to overwrite
        directory = try self.base.subdirectory("sub1").subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertThrowsError(try directory.move(into: toDirectory, named: "other", canOverwrite: false))
        XCTAssertTrue(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))
    }

    func testMoveDirectoryDirectlyToPath() throws {
        let fromDirectoryUrl = URL(fileURLWithPath: "tmp/dir")
        let toDirectoryUrl = URL(fileURLWithPath: "tmp/other")
        let fileWithinToDirectoryUrl = URL(fileURLWithPath: "tmp/other/file.txt")

        var directory = try self.base.subdirectory("dir")
        let toDirectory = try self.base.subdirectory("other")
        try toDirectory.delete()

        // Move to non-existent path
        XCTAssertEqual(try directory.move(to: toDirectory, canOverwrite: false).description, "Directory(./tmp/other)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))

        // Move and overwrite
        directory = try self.base.subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertEqual(try directory.move(to: toDirectory, canOverwrite: true).description, "Directory(./tmp/other)")
        XCTAssertFalse(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertFalse(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))

        // Move and fail to overwrite
        directory = try self.base.subdirectory("dir")
        try "text".data(using: .utf8)?.write(to: fileWithinToDirectoryUrl)
        XCTAssertThrowsError(try directory.move(to: toDirectory, canOverwrite: false))
        XCTAssertTrue(FileManager.default.fileExists(at: fromDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toDirectoryUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: fileWithinToDirectoryUrl))
    }

    func testCopyFileWithinDirectory() throws {
        let fromFileUrl = URL(fileURLWithPath: "tmp/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/other.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.copy(into: self.base, named: "other.txt", canOverwrite: false).description, "File(./tmp/other.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.copy(into: self.base, named: "other.txt", canOverwrite: true).description, "File(./tmp/other.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.copy(into: self.base, named: "other.txt", canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testCopyFileToDifferentDirectoryWithSameName() throws {
        let _ = try self.base.subdirectory("sub1")
        let toDirectory = try self.base.subdirectory("sub2")

        let fromFileUrl = URL(fileURLWithPath: "tmp/sub1/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/sub2/file.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.subdirectory("sub1").file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.copy(into: toDirectory, canOverwrite: false).description, "File(./tmp/sub2/file.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.copy(into: toDirectory, canOverwrite: true).description, "File(./tmp/sub2/file.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.copy(into: toDirectory, canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testCopyFileToDifferentDirectoryWithDifferentName() throws {
        let _ = try self.base.subdirectory("sub1")
        let toDirectory = try self.base.subdirectory("sub2")

        let fromFileUrl = URL(fileURLWithPath: "tmp/sub1/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/sub2/other.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.subdirectory("sub1").file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.copy(into: toDirectory, named: "other.txt", canOverwrite: false).description, "File(./tmp/sub2/other.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.copy(into: toDirectory, named: "other.txt", canOverwrite: true).description, "File(./tmp/sub2/other.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.copy(into: toDirectory, named: "other.txt", canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testCopyFileDirectlyToPath() throws {
        let fromFileUrl = URL(fileURLWithPath: "tmp/file.txt")
        let toFileUrl = URL(fileURLWithPath: "tmp/other.txt")
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        let toPath = try self.base.file("other.txt")

        // Move to non-existent path
        XCTAssertEqual(try file.copy(to: toPath, canOverwrite: false).description, "File(./tmp/other.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertTrue(FileManager.default.fileExists(at: toFileUrl))

        // Move and overwrite
        try "second".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertEqual(try self.string(at: toFileUrl), "test")
        XCTAssertEqual(try self.string(at: fromFileUrl), "second")
        XCTAssertEqual(try file.copy(to: toPath, canOverwrite: true).description, "File(./tmp/other.txt)")
        XCTAssertTrue(FileManager.default.fileExists(at: fromFileUrl))
        XCTAssertEqual(try self.string(at: toFileUrl), "second")

        // Move and fail to overwrite
        try "third".data(using: .utf8)?.write(to: fromFileUrl)
        XCTAssertThrowsError(try file.copy(to: toPath, canOverwrite: false))
        XCTAssertEqual(try self.string(at: fromFileUrl), "third")
        XCTAssertEqual(try self.string(at: toFileUrl), "second")
    }

    func testLastModified() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")
        try "test".data(using: .utf8)?.write(to: url)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertEqualWithAccuracy(try file.lastModified().timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 5)

        try FileManager.default.removeItem(at: url)

        XCTAssertThrowsError(try file.lastModified())
    }

    func testFileContents() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")
        guard let data = "test".data(using: .utf8) else {
            XCTFail("Failed to create data")
            return
        }
        try data.write(to: url)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertEqual(try file.contents(), data)

        try FileManager.default.removeItem(at: url)

        XCTAssertThrowsError(try file.contents())
    }

    func testString() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")
        try "tést".data(using: .utf8)?.write(to: url)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertEqual(try file.string(), "tést")

        try FileManager.default.removeItem(at: url)

        XCTAssertThrowsError(try file.string())

        try "test".data(using: .ascii)?.write(to: url)
        XCTAssertEqual(try file.string(encoding: .ascii), "test")
    }

    #if os(iOS)
        func testImage() throws {
            let base64Data = "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"
            guard let data = Data(base64Encoded: base64Data) else {
                XCTFail("Failed to parse base64 data")
                return
            }
            let url = URL(fileURLWithPath: "tmp/image.png")
            try data.write(to: url)

            guard let file = try self.base.file("image.png").file else {
                XCTFail("Could not find image file as path")
                return
            }
            XCTAssertNotNil(try file.image())
        }
    #endif

    func testHandleForReading() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")
        guard let data = "test".data(using: .utf8) else {
            XCTFail("Failed to create data")
            return
        }
        try data.write(to: url)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertEqual(try file.handleForReading().readDataToEndOfFile(), data)

        try FileManager.default.removeItem(at: url)

        XCTAssertThrowsError(try file.handleForReading())
    }

    func testHandleForWriting() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")

        let filePath = try self.base.addFile(named: "file.txt", canOverwrite: true)

        guard let file = filePath.file else {
            XCTFail("Failed to find file")
            return
        }

        let handle = try file.handleForWriting()
        handle.write("contents".data(using: .utf8)!)

        XCTAssertEqual(try file.string(), "contents")

        try FileManager.default.removeItem(at: url)
        XCTAssertThrowsError(try file.handleForWriting())
    }

    func testResolveSymLink() throws {
        let originalUrl = URL(fileURLWithPath: "tmp/orig.txt")
        try "content".data(using: .utf8)?.write(to: originalUrl)
        let linkUrl = URL(fileURLWithPath: "tmp/link.txt")
        try FileManager.default.createSymbolicLink(at: linkUrl, withDestinationURL: originalUrl)

        guard let file = try self.base.file("link.txt").file else {
            XCTFail("Failed to find link file")
            return
        }

        XCTAssertTrue(file.resolvingSymLink().description.hasSuffix("tmp/orig.txt)"))
        XCTAssertEqual(try file.string(), "content")

        guard let original = try self.base.file("orig.txt").file else {
            XCTFail("Failed to find original file")
            return
        }

        XCTAssertTrue(original.resolvingSymLink().description.hasSuffix("tmp/orig.txt)"))
        XCTAssertEqual(try original.string(), "content")
    }

    func testIsIdenticalTo() throws {
        let oneUrl = URL(fileURLWithPath: "tmp/one.txt")
        let twoUrl = URL(fileURLWithPath: "tmp/two.txt")
        let otherUrl = URL(fileURLWithPath: "tmp/other.txt")

        try "samecontent".data(using: .utf8)?.write(to: oneUrl)
        try "samecontent".data(using: .utf8)?.write(to: twoUrl)
        try "othercontent".data(using: .utf8)?.write(to: otherUrl)

        guard let one = try self.base.file("one.txt").file else {
            XCTFail("Failed to find first file")
            return
        }

        guard let two = try self.base.file("two.txt").file else {
            XCTFail("Failed to find second file")
            return
        }

        guard let other = try self.base.file("other.txt").file else {
            XCTFail("Failed to find other file")
            return
        }

        XCTAssertTrue(try one.isIdentical(to: two))
        XCTAssertTrue(try two.isIdentical(to: one))
        XCTAssertFalse(try one.isIdentical(to: other))
        XCTAssertFalse(try other.isIdentical(to: one))

        try two.delete()

        XCTAssertThrowsError(try one.isIdentical(to: two))
        XCTAssertThrowsError(try two.isIdentical(to: one))
    }

    func testDirectoryContents() throws {
        let oneUrl = URL(fileURLWithPath: "tmp/one.txt")
        let twoUrl = URL(fileURLWithPath: "tmp/two.txt")
        let subdirectoryUrl = URL(fileURLWithPath: "tmp/sub")

        try "content1".data(using: .utf8)?.write(to: oneUrl)
        try "content2".data(using: .utf8)?.write(to: twoUrl)

        let subdirectory = try self.base.subdirectory("sub")

        let contents = try self.base.contents()
        XCTAssertEqual(contents.count, 3)
        XCTAssertTrue(try contents.contains(where: { file in
            return try file.basename == "one.txt"
                && file.file?.string() == "content1"
        }))
        XCTAssertTrue(try contents.contains(where: { file in
            return try file.basename == "two.txt"
                && file.file?.string() == "content2"
        }))
        XCTAssertTrue(try contents.contains(where: { dir in
            return try dir.basename == "sub"
                && dir.directory?.contents().count == 0
        }))

        try FileManager.default.removeItem(at: subdirectoryUrl)
        XCTAssertThrowsError(try subdirectory.contents())
    }

    func testAddFile() throws {
        let empty = try self.base.addFile(named: "empty.txt", canOverwrite: false)
        XCTAssertTrue(try empty.contents().isEmpty)

        let nonEmpty = try self.base.addFile(named: "baseFile.txt", containing: "contents".data(using: .utf8), canOverwrite: false)
        XCTAssertEqual(try nonEmpty.string(), "contents")

        XCTAssertThrowsError(try self.base.addFile(named: "baseFile.txt", containing: "contents".data(using: .utf8), canOverwrite: false))

        XCTAssertEqual(try self.base.addFile(named: "baseFile.txt", containing: "other".data(using: .utf8), canOverwrite: true).string(), "other")
    }

    func testAddLink() throws {
        let original = try self.base.addFile(named: "file.txt", containing: "text".data(using: .utf8), canOverwrite: false)

        let link = try self.base.addLink(named: "link.txt", to: original, canOverwrite: false)
        XCTAssertTrue(link.resolvingSymLink().description.hasSuffix("tmp/file.txt)"))
        XCTAssertEqual(try link.string(), "text")

        XCTAssertThrowsError(try self.base.addLink(named: "link.txt", to: original, canOverwrite: false))
        let link2 = try self.base.addLink(named: "link.txt", to: original, canOverwrite: true)
        XCTAssertTrue(link2.resolvingSymLink().description.hasSuffix("tmp/file.txt)"))
        XCTAssertEqual(try link2.string(), "text")
    }

    func testSubdirectory() throws {
        let directoryUrl = URL(fileURLWithPath: "tmp/sub")
        XCTAssertEqual(try self.base.subdirectory("sub").description, "Directory(./tmp/sub)")
        XCTAssertTrue(FileManager.default.fileExists(at: directoryUrl))
        XCTAssertEqual(try self.base.subdirectory("sub").description, "Directory(./tmp/sub)")

        let _ = try self.base.addFile(named: "file.txt", canOverwrite: false)
        XCTAssertThrowsError(try self.base.subdirectory("file.txt"))
    }

    func testFileNamed() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")

        XCTAssertEqual(try self.base.file("file.txt").description, "None(./tmp/file.txt)")

        try "".data(using: .utf8)?.write(to: url)
        XCTAssertEqual(try self.base.file("file.txt").description, "File(./tmp/file.txt)")

        let directoryUrl = URL(fileURLWithPath: "tmp/sub")
        try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
        XCTAssertThrowsError(try self.base.file("sub"))
    }

    func testCreateFile() throws {
        guard let file = try self.base.file("file.txt").nonExisting else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertTrue(try file.createFile(canOverwrite: false).contents().isEmpty)
        XCTAssertThrowsError(try file.createFile(canOverwrite: false))
        XCTAssertThrowsError(try file.createFile(containing: Data(), canOverwrite: false))
        XCTAssertTrue(try file.createFile(canOverwrite: true).contents().isEmpty)
        XCTAssertEqual(try file.createFile(containing: "contents".data(using: .utf8), canOverwrite: true).string(), "contents")
    }

    func testCreateDirectory() throws {
        let directory = try self.base.subdirectory("sub").delete()
        XCTAssertEqual(try directory.createDirectory().description, "Directory(./tmp/sub)")
        XCTAssertThrowsError(try directory.createDirectory())
    }

    func testCreateLink() throws {
        let orig1 = try self.base.addFile(named: "orig1.txt", containing: "contents1".data(using: .utf8), canOverwrite: false)
        let orig2 = try self.base.addFile(named: "orig2.txt", containing: "contents2".data(using: .utf8), canOverwrite: false)


        guard let link = try self.base.file("link.txt").nonExisting else {
            XCTFail("Failed create non existent file to link")
            return
        }
        XCTAssertEqual(try link.createLink(to: orig1, canOverwrite: false).string(), "contents1")
        XCTAssertThrowsError(try link.createLink(to: orig1, canOverwrite: false))
        XCTAssertEqual(try link.createLink(to: orig2, canOverwrite: true).string(), "contents2")

        try orig1.delete()
        XCTAssertThrowsError(try link.createLink(to: orig1, canOverwrite: true))
    }

    static var allTests: [(String, (PathTests) -> () throws -> Void)] {
        return [
            ("testBaseName", testBaseName),
            ("testName", testName),
            ("testExtension", testExtension),
            ("testDirectory", testDirectory),
            ("testNonExisting", testNonExisting),
            ("testFile", testFile),
            ("testExsiting", testExsiting),
            ("testWithoutLastComponent", testWithoutLastComponent),
            ("testDescription", testDescription),
            ("testDelete", testDelete),
            ("testMoveFileWithinDirectory", testMoveFileWithinDirectory),
            ("testMoveFileToDifferentDirectoryWithSameName", testMoveFileToDifferentDirectoryWithSameName),
            ("testMoveFileToDifferentDirectoryWithDifferentName", testMoveFileToDifferentDirectoryWithDifferentName),
            ("testMoveFileDirectlyToPath", testMoveFileDirectlyToPath),
            ("testMoveDirectoryWithinDirectory", testMoveDirectoryWithinDirectory),
            ("testMoveDirectoryToDifferentDirectoryWithSameName", testMoveDirectoryToDifferentDirectoryWithSameName),
            ("testMoveDirectoryToDifferentDirectoryWithDifferentName", testMoveDirectoryToDifferentDirectoryWithDifferentName),
            ("testMoveDirectoryDirectlyToPath", testMoveDirectoryDirectlyToPath),
            ("testCopyFileWithinDirectory", testCopyFileWithinDirectory),
            ("testCopyFileToDifferentDirectoryWithSameName", testCopyFileToDifferentDirectoryWithSameName),
            ("testCopyFileToDifferentDirectoryWithDifferentName", testCopyFileToDifferentDirectoryWithDifferentName),
            ("testCopyFileDirectlyToPath", testCopyFileDirectlyToPath),
            ("testLastModified", testLastModified),
            ("testFileContents", testFileContents),
            ("testString", testString),
            ("testHandleForReading", testHandleForReading),
            ("testHandleForWriting", testHandleForWriting),
            ("testResolveSymLink", testResolveSymLink),
            ("testIsIdenticalTo", testIsIdenticalTo),
            ("testDirectoryContents", testDirectoryContents),
            ("testAddFile", testAddFile),
            ("testAddLink", testAddLink),
            ("testSubdirectory", testSubdirectory),
            ("testFileNamed", testFileNamed),
            ("testCreateFile", testCreateFile),
            ("testCreateDirectory", testCreateDirectory),
            ("testCreateLink", testCreateLink),
        ]
    }
}

extension FileManager {
    func fileExists(at: URL) -> Bool {
        return self.fileExists(atPath: at.relativePath)
    }
}
