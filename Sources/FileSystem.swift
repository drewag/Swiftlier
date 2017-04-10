//
//  FileSystem.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public protocol FileSystemReferenceType {
    var path: String {get}
    var fileSystem: FileSystem {get}
}

public struct FileSystem {
    public static let main = FileSystem()

    let manager = FileManager.default

    public var documentsDirectory: Directory {
        let url = self.manager.documentsDirectoryURL
        let _ = try? self.manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return Directory(path: url.relativePath, fileSystem: self)
    }

    public var cachesDirectory: Directory {
        let url = self.manager.cachesDirectoryURL
        let _ = try? self.manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return Directory(path: url.relativePath, fileSystem: self)
    }

    public func reference(forPath path: String) throws -> ReferenceType {
        try self.validate(path: path)
        do {
            if try self.isDirectory(at: path) {
                return Directory(path: path, fileSystem: self)
            }
            else {
                return File(path: path, fileSystem: self)
            }
        }
        catch {}

        return NotFoundPath(path: path, fileSystem: self)
    }

    func createFile(at path: String, with data: Data) {
        let directory = URL(fileURLWithPath: path).deletingLastPathComponent().relativePath
        try! self.manager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        let _ = self.manager.createFile(atPath: path, contents: data, attributes: nil)
    }

    func createDirectory(at path: String) {
        try! self.manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }

    func copyAndOverwrite(from: String, to: String) {
        self.deleteItem(at: to)
        try! self.manager.copyItem(atPath: from, toPath: to)
    }

    func moveAndOverwrite(from: String, to: String) {
        self.deleteItem(at: to)
        try! self.manager.moveItem(atPath: from, toPath: to)
    }

    func deleteItem(at path: String) {
        try! self.manager.removeItem(atPath: path)
    }

    func contentsOfDirectory(at path: String) throws -> [ExistingReferenceType] {
        if let enumerator = self.manager.enumerator(atPath: path) {
            var contents = [ExistingReferenceType]()
            while let fileOrDirectory = enumerator.nextObject() as? String {
                enumerator.skipDescendants()
                let fullPath = URL(fileURLWithPath: path).appendingPathComponent(fileOrDirectory).relativePath
                contents.append(try! self.reference(forPath: fullPath) as! ExistingReferenceType)
            }
            return contents
        }
        else {
            throw ReferenceError.NotFound
        }
    }

    func validate(path: String) throws {
        var components = URL(fileURLWithPath: path).pathComponents
        guard components.count > 0 else {
            return
        }
        let first = components.removeFirst()
        var url = URL(fileURLWithPath: first)

        for component in components {
            guard try self.isDirectory(at: url.relativePath) else {
                throw ReferenceError.InvalidPath
            }
            url = url.appendingPathComponent(component)
        }
    }
}

private extension FileSystem {
    func isDirectory(at path: String) throws -> Bool {
        let attributes = try self.manager.attributesOfItem(atPath: path)
        if let attribute = attributes[.type] as? FileAttributeType, attribute == .typeDirectory {
            return true
        }
        else {
            return false
        }
    }
}

public struct Directory: FileSystemReferenceType, DirectoryReferenceType, ExistingReferenceType, ExtendableReferenceType {
    public let path: String
    public let fileSystem: FileSystem

    public func fullPath() -> String {
        return self.path
    }
}

public struct File: FileSystemReferenceType, ResourceReferenceType, ExistingReferenceType, ExtendableReferenceType {
    public let path: String
    public let fileSystem: FileSystem

    public func fullPath() -> String {
        return self.path
    }
}

public struct NotFoundPath: FileSystemReferenceType, UnknownReferenceType, ExtendableReferenceType {
    public let path: String
    public let fileSystem: FileSystem

    public func fullPath() -> String {
        return self.path
    }
}

extension FileSystemReferenceType {
    public func refresh() -> ReferenceType {
        return try! self.fileSystem.reference(forPath: self.path)
    }

    public func validateIsPossible() throws {
        try self.fileSystem.validate(path: self.path)
    }
}
