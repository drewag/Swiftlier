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

final class PathTests: XCTestCase {
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

    func testWithExtension() {
        XCTAssertEqual(try self.base.subdirectory("sub").file("name.txt")
            .with(extension: "other").url.relativePath, "./tmp/sub/name.other")
        XCTAssertEqual(try self.base.subdirectory("sub")
            .with(extension: "other").url.relativePath, "./tmp/sub.other")
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
        try "test".data(using: .utf8)?.write(to: fromFileUrl)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        // Move to non-existent path
        XCTAssertEqual(try file.copy(into: self.base, named: "other.txt", canOverwrite: false).description, "File(./tmp/other.txt)")
        /*
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
        XCTAssertEqual(try self.string(at: toFileUrl), "second")*/
    }

    func testCopyFileToDifferentDirectoryWithSameName() throws {
        /*let _ = try self.base.subdirectory("sub1")
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
        */
    }

    func testCopyFileToDifferentDirectoryWithDifferentName() throws {
        /*
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
        */
    }

    func testCopyFileDirectlyToPath() throws {
        /*let fromFileUrl = URL(fileURLWithPath: "tmp/file.txt")
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
        */
    }

    func testLastModified() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")
        try "test".data(using: .utf8)?.write(to: url)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertEqual(try file.lastModified().timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 5)

        try FileManager.default.removeItem(at: url)

        XCTAssertThrowsError(try file.lastModified())
    }

    func testSize() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")
        try "test".data(using: .utf8)?.write(to: url)

        guard let file = try self.base.file("file.txt").file else {
            XCTFail("Failed to find file")
            return
        }

        XCTAssertEqual(try file.size(), 4)

        try "".data(using: .utf8)?.write(to: url)
        XCTAssertEqual(try file.size(), 0)

        try "123456".data(using: .utf8)?.write(to: url)
        XCTAssertEqual(try file.size(), 6)

        try FileManager.default.removeItem(at: url)

        XCTAssertThrowsError(try file.size())
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

    func testHandleForReadingAndWriting() throws {
        let url = URL(fileURLWithPath: "tmp/file.txt")

        let filePath = try self.base.addFile(named: "file.txt", canOverwrite: true)

        guard let file = filePath.file else {
            XCTFail("Failed to find file")
            return
        }

        let handle = try file.handleForReadingAndWriting()
        handle.write("contents".data(using: .utf8)!)

        XCTAssertEqual(try file.string(), "contents")
        handle.seek(toFileOffset: 0)
        XCTAssertEqual("contents", String(data: handle.readDataToEndOfFile(), encoding: .utf8)!)

        try FileManager.default.removeItem(at: url)
        XCTAssertThrowsError(try file.handleForReadingAndWriting())
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
        /*
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
        */
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

    func testFileAtSubPath() throws {
        let directoryUrl = URL(fileURLWithPath: "tmp/sub1/sub2")

        let file = try self.base.file(atSubPath: "sub1/sub2/file.txt")
        XCTAssertEqual(file.description, "None(./tmp/sub1/sub2/file.txt)")

        let directory = FileSystem.default.path(from: directoryUrl)
        XCTAssertEqual(directory.description, "Directory(tmp/sub1/sub2)")
    }

    func testSubPathByAppending() throws {
        let directoryUrl = URL(fileURLWithPath: "tmp/sub1/sub2")

        let file = self.base.subPath(byAppending: "sub1/sub2/file.txt")
        XCTAssertEqual(file.description, "None(./tmp/sub1/sub2/file.txt)")

        let directory = FileSystem.default.path(from: directoryUrl)
        XCTAssertEqual(directory.description, "None(tmp/sub1/sub2)")
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
}

extension FileManager {
    func fileExists(at: URL) -> Bool {
        return self.fileExists(atPath: at.relativePath)
    }
}
