//
//  Path.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/18/17.
//
//

import Foundation
#if os(iOS)
    import UIKit
#endif

// Protocol Definitions

public protocol Path: ErrorGenerating, CustomStringConvertible {
    static func build(_ url: URL) -> Path
    var url: URL {get}
}

public protocol ExistingPath: Path {}
public protocol NonExistingPath: Path {}
public protocol DirectoryPath: ExistingPath {}
public protocol FilePath: ExistingPath {}

// Protocol Extensions

extension Path {
    static func build(_ path: String) -> Path {
        return self.build(URL(fileURLWithPath: path))
    }

    public var basename: String {
        return self.url.lastPathComponent
    }

    public var name: String {
        return self.url.deletingPathExtension().lastPathComponent
    }

    public var `extension`: String {
        return self.url.pathExtension
    }

    public var directory: DirectoryPath? {
        return self.refresh() as? DirectoryPath
    }

    public var nonExisting: NonExistingPath? {
        return self.refresh() as? NonExistingPath
    }

    public var file: FilePath? {
        return self.refresh() as? FilePath
    }

    public var existing: ExistingPath? {
        return self.refresh() as? ExistingPath
    }

    public var withoutLastComponent: Path {
        let newUrl = self.url.deletingLastPathComponent()
        return type(of: self).build(newUrl)
    }

    public var description: String {
        switch FileSystem.default.itemKind(at: self.url) {
        case .directory:
            return "Directory(\(self.url.relativePath))"
        case .file:
            return "File(\(self.url.relativePath))"
        case .none:
            return "None(\(self.url.relativePath))"
        }
    }
}

extension ExistingPath {
    @discardableResult
    public func delete() throws -> NonExistingPath {
        return try FileSystem.default.deleteItem(at: self.url)
    }

    public func move(into: DirectoryPath, named: String? = nil, canOverwrite: Bool) throws -> Self {
        let named = named ?? self.basename
        let to = into.url.appendingPathComponent(named)
        guard let sameType = try FileSystem.default.moveItem(at: self.url, to: to, canOverwrite: canOverwrite) as? Self else {
            throw self.error("moving item", because: "an item of the wrong type was found after moving")
        }
        return sameType
    }

    public func move(to: Path, canOverwrite: Bool) throws -> Self {
        guard let sameType = try FileSystem.default.moveItem(at: self.url, to: to.url, canOverwrite: canOverwrite) as? Self else {
            throw self.error("moving item", because: "an item of the wrong type was found after moving")
        }
        return sameType
    }
}

extension FilePath {
    public func lastModified() throws -> Date {
        return try FileSystem.default.lastModified(at: self.url)
    }

    public func size() throws -> Int {
        return try FileSystem.default.size(at: self.url)
    }

    public func contents() throws -> Data {
        return try self.handleForReading().readDataToEndOfFile()
    }

    public func string(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.contents(), encoding: encoding)
    }

    #if os(iOS)
    public func image() throws -> UIImage? {
        let data = try self.contents()
        return UIImage(data: data)
    }
    #endif

    public func handleForReading() throws -> FileHandle {
        do {
            return try FileHandle(forReadingFrom: self.url)
        }
        catch {
            throw self.error("opening file", because: "the file no longer exists")
        }
    }

    public func handleForWriting() throws -> FileHandle {
        do {
            return try FileHandle(forWritingTo: self.url)
        }
        catch {
            throw self.error("opening file", because: "the file no longer exists")
        }
    }

    public func copy(into: DirectoryPath, named: String? = nil, canOverwrite: Bool) throws -> FilePath {
        let named = named ?? self.basename
        let to = into.url.appendingPathComponent(named)
        guard let sameType = try FileSystem.default.copyFile(at: self.url, to: to, canOverwrite: canOverwrite) as? FilePath else {
            throw self.error("copying file", because: "a directory was found after copying")
        }
        return sameType
    }

    public func copy(to: Path, canOverwrite: Bool) throws -> FilePath {
        guard let sameType = try FileSystem.default.copyFile(at: self.url, to: to.url, canOverwrite: canOverwrite) as? Self else {
            throw self.error("copying file", because: "a directory was found after copying")
        }
        return sameType
    }

    public func resolvingSymLink() -> Path {
        return FileSystem.default.path(from: self.url, resolvingSymLinks: true)
    }

    public func isIdentical(to: FilePath) throws -> Bool {
        let lFileHandle = try self.handleForReading()
        let rFileHandle = try to.handleForReading()

        var lData: Data
        var rData: Data
        repeat {
            lData = lFileHandle.readData(ofLength: 16000)
            rData = rFileHandle.readData(ofLength: 16000)

            guard lData == rData else {
                return false
            }
        } while !lData.isEmpty

        return true
    }
}

extension DirectoryPath {
    public func contents() throws -> [ExistingPath] {
        return try FileSystem.default.contentsOfDirectory(at: self.url)
    }

    public func addFile(named: String, containing data: Data? = nil, canOverwrite: Bool) throws -> FilePath {
        let newUrl = self.url.appendingPathComponent(named)
        return try FileSystem.default.createFile(at: newUrl, with: data, canOverwrite: canOverwrite)
    }

    public func addLink(named: String, to: FilePath, canOverwrite: Bool) throws -> FilePath {
        let newUrl = self.url.appendingPathComponent(named)
        return try FileSystem.default.createLink(at: newUrl, to: to.url, canOverwrite: canOverwrite)
    }

    public func subdirectory(_ named: String) throws -> DirectoryPath {
        let newUrl = self.url.appendingPathComponent(named)
        return try FileSystem.default.createDirectoryIfNotExists(at: newUrl)
    }

    public func file(_ named: String) throws -> Path {
        let newUrl = self.url.appendingPathComponent(named)
        switch FileSystem.default.itemKind(at: newUrl) {
        case .file, .none:
            return FileSystem.default.path(from: newUrl)
        case .directory:
            throw self.error("Getting File", because: "a directory already exists at \(newUrl.relativePath)")
        }
    }
}

extension Path {
    public func createFile(containing data: Data? = nil, canOverwrite: Bool) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addFile(named: name, containing: data, canOverwrite: canOverwrite)
    }

    public func createDirectory() throws -> DirectoryPath {
        let name = self.basename

        switch FileSystem.default.itemKind(at: self.url) {
        case .directory:
            throw self.error("creating directory", because: "a directory already exists at \(self.url.relativePath)")
        case .file:
            throw self.error("creating directory", because: "a file already exists at \(self.url.relativePath)")
        case .none:
            break
        }

        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.subdirectory(name)
    }

    public func createLink(to: FilePath, canOverwrite: Bool) throws -> FilePath {
        let name = self.basename
        let parentDirectory = try FileSystem.default.createDirectoryIfNotExists(at: self.withoutLastComponent.url)
        return try parentDirectory.addLink(named: name, to: to, canOverwrite: canOverwrite)
    }

    func refresh() -> Path {
        return type(of: self).build(self.url)
    }
}
