//
//  FileSystem.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public protocol FileSystemReference {
    var path: String {get}
    var fileSystem: FileSystem {get}
}

public struct FileSystem: ErrorGenerating {
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

    public func reference(forPath path: String) throws -> Reference {
        try self.validate(path: path)
        if self.isDirectory(at: path) {
            return Directory(path: path, fileSystem: self)
        }
        else if !self.isNotFile(at: path) {
            return File(path: path, fileSystem: self)
        }
        return NotFoundPath(path: path, fileSystem: self)
    }

    func createFile(at path: String, with data: Data) {
        let url = URL(fileURLWithPath: path)
        let directory = url.deletingLastPathComponent()
        try! self.manager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        try! data.write(to: url)
    }

    func createLink(from: String, to: String) {
        let from = URL(fileURLWithPath: from)
        let to = URL(fileURLWithPath: to)
        try! self.manager.createSymbolicLink(at: from, withDestinationURL: to)
    }

    func createDirectory(at path: String) {
        let url = URL(fileURLWithPath: path)
        try! self.manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    func copyAndOverwrite(from: String, to: String) {
        let from = URL(fileURLWithPath: from)
        let to = URL(fileURLWithPath: to)
        let _ = try? self.manager.removeItem(at: to)
        try! self.manager.copyItem(at: from, to: to)
    }

    func moveAndOverwrite(from: String, to: String) {
        let from = URL(fileURLWithPath: from)
        let to = URL(fileURLWithPath: to)
        let _ = try? self.manager.removeItem(at: to)
        try! self.manager.moveItem(at: from, to: to)
    }

    func deleteItem(at path: String) {
        let url = URL(fileURLWithPath: path)
        try! self.manager.removeItem(at: url)
    }

    func contentsOfDirectory(at path: String) throws -> [ExistingReference] {
        let url = URL(fileURLWithPath: path)
        if let enumerator = self.manager.enumerator(at: url, includingPropertiesForKeys: nil) {
            var contents = [ExistingReference]()
            while let fileOrDirectory = enumerator.nextObject() as? URL {
                enumerator.skipDescendants()
                contents.append(try! self.reference(forPath: fileOrDirectory.relativePath) as! ExistingReference)
            }
            return contents
        }
        else {
            throw self.error("loading contents of directory at \(path)", because: ReferenceErrorReason.notFound)
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
            guard self.isNotFile(at: url.relativePath) else {
                throw self.error("creating reference to \(path)", because: ReferenceErrorReason.invalidPath)
            }
            url = url.appendingPathComponent(component)
        }
    }
}

private extension FileSystem {
    func isDirectory(at path: String) -> Bool {
        #if os(Linux)
        var isDirectory = false
        #else
        var isDirectory = ObjCBool(false)
        #endif
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return false
        }
        #if os(Linux)
        return isDirectory
        #else
        return isDirectory.boolValue
        #endif

    }

    func isNotFile(at path: String) -> Bool {
        #if os(Linux)
        var isDirectory = false
        #else
        var isDirectory = ObjCBool(false)
        #endif
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return true
        }
        #if os(Linux)
        return isDirectory
        #else
        return isDirectory.boolValue
        #endif
    }
}

public struct Directory: FileSystemReference, DirectoryReference, ExistingReference, ExtendableReference {
    public let path: String
    public let fileSystem: FileSystem

    public func fullPath() -> String {
        return self.path
    }
}

public struct File: FileSystemReference, ResourceReference, ExistingReference, ExtendableReference {
    public let path: String
    public let fileSystem: FileSystem

    public func fullPath() -> String {
        return self.path
    }

    public func lastModified() -> Date {
        #if os(Linux)
            var st = stat()
            stat(self.path, &st)
            let ts = st.st_mtim
            let double = Double(ts.tv_nsec) * 1.0E-9 + Double(ts.tv_sec)
            return Date(timeIntervalSince1970: double)
        #else
            guard let attributes = try? self.fileSystem.manager.attributesOfItem(atPath: self.path) else {
                return Date()
            }
            return attributes[.modificationDate] as? Date ?? Date()
        #endif
    }
}

public struct NotFoundPath: FileSystemReference, UnknownReference, ExtendableReference {
    public let path: String
    public let fileSystem: FileSystem

    public func fullPath() -> String {
        return self.path
    }

    public func createLink(to: ResourceReference) -> ResourceReference {
        self.fileSystem.createLink(from: self.fullPath(), to: to.fullPath())
        return to.refresh() as! ResourceReference
    }
}

extension FileSystemReference {
    public func refresh() -> Reference {
        return try! self.fileSystem.reference(forPath: self.path)
    }

    public func validateIsPossible() throws {
        try self.fileSystem.validate(path: self.path)
    }
}
