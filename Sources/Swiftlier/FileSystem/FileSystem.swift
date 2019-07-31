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

public struct FileSystem {
    public static let `default` = FileSystem()

    public var workingDirectory: DirectoryPath {
        let path = self.path(from: URL(fileURLWithPath: ""))
        return path as! DirectoryPath
    }

    public var rootDirectory: DirectoryPath {
        let path = self.path(from: URL(fileURLWithPath: "/"))
        return path as! DirectoryPath
    }

    enum ItemKind {
        case none
        case file
        case directory
    }

    let manager = FileManager.default

    public func path(from url: URL, resolvingSymLinks: Bool = false) -> Path {
        switch self.itemKind(at: url) {
        case .directory:
            return ConcreteDirectoryPath(url: url)
        case .file:
            if resolvingSymLinks
                , let newPath = try? self.manager.destinationOfSymbolicLink(atPath: url.relativePath)
            {
                return self.path(from: URL(fileURLWithPath: newPath), resolvingSymLinks: resolvingSymLinks)
            }
            return ConcreteFilePath(url: url)
        case .none:
            return ConcreteNonExistentPath(url: url)
        }
    }

    func itemKind(at url: URL) -> ItemKind {
        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: url.relativePath, isDirectory: &isDirectory) else {
            return .none
        }
        return isDirectory.boolValue ? .directory : .file
    }

    func contentsOfDirectory(at url: URL) throws -> [ExistingPath] {
        switch self.itemKind(at: url) {
        case .file:
            throw GenericSwiftlierError(while: "loading contents of directory", reason: "A file was found instead.", details: "Path was '\(url.relativePath)'")
        case .none:
            throw GenericSwiftlierError(while: "loading contents of directory", reason: "No directory was found.", details: "Path was '\(url.relativePath)'")
        case .directory:
            break
        }

        guard let enumerator = self.manager.enumerator(at: url.resolvingSymlinksInPath(), includingPropertiesForKeys: nil) else {
            throw GenericSwiftlierError(while: "loading contents of directory", reason: "No directory was found.", details: "Path was '\(url.relativePath)'")
        }

        var contents = [ExistingPath]()
        while let possible = enumerator.nextObject() as? URL {
            enumerator.skipDescendants()
            guard let existing = self.path(from: possible) as? ExistingPath else {
                continue
            }
            contents.append(existing)
        }
        return contents
    }

    func createFile(at url: URL, with data: Data?, canOverwrite: Bool, options: NSData.WritingOptions) throws -> FilePath {
        switch (self.itemKind(at: url), canOverwrite) {
        case (.file, false):
            throw GenericSwiftlierError(while: "creating file", reason: "A file already exists.", details: "Path was '\(url.relativePath)'")
        case (.directory, _):
            throw GenericSwiftlierError(while: "creating file", reason: "A directory already exists there.", details: "Path was '\(url.relativePath)'")
        case (.file, true):
            try self.manager.removeItem(at: url)
            fallthrough
        default:
            let data = data ?? Data()
            try data.write(to: url, options: options)

            guard let filePath = self.path(from: url) as? FilePath else {
                throw GenericSwiftlierError(while: "creating file", reason: "The newly created file could not be found.", details: "Path was '\(url.relativePath)'")
            }
            return filePath
        }
    }

    func createLink(at: URL, to: URL, canOverwrite: Bool) throws -> FilePath {
        switch (self.itemKind(at: at), canOverwrite) {
        case (.file, false):
            throw GenericSwiftlierError(while: "creating link", reason: "A file already exists there.", details: "Path was '\(at.relativePath)'")
        case (.directory, false):
            throw GenericSwiftlierError(while: "creating link", reason: "A directory already exists there.", details: "Path was '\(at.relativePath)'")
        case (.file, true), (.directory, true):
            try self.manager.removeItem(at: at)
            fallthrough
        default:
            switch self.itemKind(at: to) {
            case .file:
                try self.manager.createSymbolicLink(at: at, withDestinationURL: to)
            case .none:
                throw GenericSwiftlierError(while: "creating link", reason: "The destination does not exist.", details: "Path was '\(to.relativePath)'")
            case .directory:
                throw GenericSwiftlierError(while: "creating link", reason: "The destination is a directory.", details: "Path was '\(to.relativePath)'")
            }

            guard let filePath = self.path(from: at) as? FilePath else {
                throw GenericSwiftlierError(while: "creating link", reason: "The newly created link could not be found", details: "Path was '\(at.relativePath)'")
            }
            return filePath
        }
    }

    func moveItem(at: URL, to: URL, canOverwrite: Bool) throws -> ExistingPath {
        switch self.itemKind(at: at) {
        case .file, .directory:
            switch (self.itemKind(at: to), canOverwrite) {
            case (.file, false):
                throw GenericSwiftlierError(while: "moving item", reason: "A file already exists there.", details: "Path was '\(to.relativePath)'")
            case (.directory, false):
                throw GenericSwiftlierError(while: "moving item", reason: "A directory already exists there.", details: "Path was '\(to.relativePath)'")
            case (.file, true), (.directory, true):
                try self.manager.removeItem(at: to)
                fallthrough
            default:
                try self.manager.moveItem(at: at, to: to)
            }

            guard let existingPath = self.path(from: to) as? ExistingPath else {
                throw GenericSwiftlierError(while: "moving item", reason: "The item at the new location could not be found.", details: "Path was '\(to.relativePath)'")
            }
            return existingPath
        case .none:
            throw GenericSwiftlierError(while: "moving item", reason: "An item does not exist there.", details: "Path was '\(at.relativePath)'")
        }
    }

    func copyFile(at: URL, to: URL, canOverwrite: Bool) throws -> ExistingPath {
        switch self.itemKind(at: at) {
        case .directory:
            throw GenericSwiftlierError(while: "copying file", reason: "It is a directory.", details: "Path was '\(at.relativePath)'")
        case .none:
            throw GenericSwiftlierError(while: "copying file", reason: "It does not exist.", details: "Path was '\(at.relativePath)'")
        case .file:
            switch (self.itemKind(at: to), canOverwrite) {
            case (.file, false):
                throw GenericSwiftlierError(while: "copying file", reason: "A file at the destination already exists.", details: "Destination was '\(to.relativePath)'")
            case (.directory, _):
                throw GenericSwiftlierError(while: "copying file", reason: "The destination is a directory.", details: "Destination was '\(to.relativePath)'")
            case (.file, true):
                try self.manager.removeItem(at: to)
                fallthrough
            default:
                try self.manager.copyItem(at: at, to: to)
            }

            guard let existingPath = self.path(from: to) as? ExistingPath else {
                throw GenericSwiftlierError(while: "copying file", reason: "The copy could not be found.", details: "Path was '\(at.relativePath)'")
            }
            return existingPath
        }
    }

    func createDirectoryIfNotExists(at url: URL) throws -> DirectoryPath {
        switch self.itemKind(at: url) {
        case .none:
            try self.manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        case .file:
            throw GenericSwiftlierError(while: "creating directory", reason: "It is already a file.", details: "Path was '\(url.relativePath)'")
        case .directory:
            break
        }

        guard let directoryPath = self.path(from: url) as? DirectoryPath else {
            throw GenericSwiftlierError(while: "creating directory", reason: "The newly created directory could not be found.", details: "Path was '\(url.relativePath)'")
        }
        return directoryPath
    }

    func deleteItem(at url: URL) throws -> NonExistingPath {
        switch self.itemKind(at: url) {
        case .none:
            throw GenericSwiftlierError(while: "deleting item", reason: "It does not exist.", details: "Path was '\(url.relativePath)'")
        case .file, .directory:
            try self.manager.removeItem(at: url)
        }

        guard let nonExistingPath = self.path(from: url) as? NonExistingPath else {
            throw GenericSwiftlierError(while: "deleting item", reason: "It still exists after being deleted.", details: "Path was '\(url.relativePath)'")
        }
        return nonExistingPath
    }

    func lastModified(at url: URL) throws -> Date {
        let attributes = try self.manager.attributesOfItem(atPath: url.relativePath)
        return attributes[.modificationDate] as? Date ?? Date.now
    }

    func size(at url: URL) throws -> Int {
        let attributes = try self.manager.attributesOfItem(atPath: url.relativePath)
        return attributes[.size] as? Int ?? 0
    }
}

struct ConcreteFilePath: FilePath {
    static func build(_ url: URL) -> Path {
        return FileSystem.default.path(from: url)
    }

    let url: URL
}

struct ConcreteDirectoryPath: DirectoryPath {
    static func build(_ url: URL) -> Path {
        return FileSystem.default.path(from: url)
    }

    let url: URL
}

struct ConcreteNonExistentPath: NonExistingPath {
    static func build(_ url: URL) -> Path {
        return FileSystem.default.path(from: url)
    }

    let url: URL
}
