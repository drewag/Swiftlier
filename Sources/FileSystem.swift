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
    public static let `default` = FileSystem()

    #if os(iOS)
    public var documentsDirectory: DirectoryPath {
        let url = try! self.manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return try! self.createDirectoryIfNotExists(at: url)
    }

    public var cachesDirectory: DirectoryPath {
        let url = try! self.manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return try! self.createDirectoryIfNotExists(at: url)
    }

    public var libraryDirectory: DirectoryPath {
        let url = try! self.manager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return try! self.createDirectoryIfNotExists(at: url)
    }
    #endif

    public var workingDirectory: DirectoryPath {
        let path = self.path(from: URL(fileURLWithPath: ""))
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
        #if os(Linux)
            var isDirectory = false
        #else
            var isDirectory = ObjCBool(false)
        #endif
        guard FileManager.default.fileExists(atPath: url.relativePath, isDirectory: &isDirectory) else {
            return .none
        }
        #if os(Linux)
            return isDirectory ? .directory : .file
        #else
            return isDirectory.boolValue ? .directory : .file
        #endif
    }

    func contentsOfDirectory(at url: URL) throws -> [ExistingPath] {
        switch self.itemKind(at: url) {
        case .file:
            throw self.error("loading Contents of Directory", because: "'\(url.relativePath)' is a file")
        case .none:
            throw self.error("loading Contents of Directory", because: "a directory at '\(url.relativePath)' does not exist")
        case .directory:
            break
        }

        guard let enumerator = self.manager.enumerator(at: url, includingPropertiesForKeys: nil) else {
            throw self.error("loading Contents of Directory", because: "a directory at '\(url.relativePath)' does not exist")
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
            throw self.error("creating file", because: "a file at '\(url.relativePath)' already exists")
        case (.directory, _):
            throw self.error("creating file", because: "'\(url.relativePath)' is already a directory")
        case (.file, true):
            try self.manager.removeItem(at: url)
            fallthrough
        default:
            let data = data ?? Data()
            try data.write(to: url, options: options)

            guard let filePath = self.path(from: url) as? FilePath else {
                throw self.error("creating File", because: "the new file could not be found")
            }
            return filePath
        }
    }

    func createLink(at: URL, to: URL, canOverwrite: Bool) throws -> FilePath {
        switch (self.itemKind(at: at), canOverwrite) {
        case (.file, false):
            throw self.error("creating link", because: "a file at '\(at.relativePath)' already exists")
        case (.directory, false):
            throw self.error("creating link", because: "'\(at.relativePath)' is already a directory")
        case (.file, true), (.directory, true):
            try self.manager.removeItem(at: at)
            fallthrough
        default:
            switch self.itemKind(at: to) {
            case .file:
                try self.manager.createSymbolicLink(at: at, withDestinationURL: to)
            case .none:
                throw self.error("creating link", because: "the destination '\(to.relativePath)' does not exist")
            case .directory:
                throw self.error("creating link", because: "the destination '\(to.relativePath)' is a directory")
            }

            guard let filePath = self.path(from: at) as? FilePath else {
                throw self.error("creating link", because: "the new link could not be found")
            }
            return filePath
        }
    }

    func moveItem(at: URL, to: URL, canOverwrite: Bool) throws -> ExistingPath {
        switch self.itemKind(at: at) {
        case .file, .directory:
            switch (self.itemKind(at: to), canOverwrite) {
            case (.file, false):
                throw self.error("moving item", because: "a file at '\(to.relativePath)' already exists")
            case (.directory, false):
                throw self.error("moving item", because: "a directory at '\(to.relativePath)' already exists")
            case (.file, true), (.directory, true):
                try self.manager.removeItem(at: to)
                fallthrough
            default:
                try self.manager.moveItem(at: at, to: to)
            }

            guard let existingPath = self.path(from: to) as? ExistingPath else {
                throw self.error("moving item", because: "the item at the new location could not be found")
            }
            return existingPath
        case .none:
            throw self.error("moving item", because: "an item at '\(at.relativePath)' does not exist")
        }
    }

    func copyFile(at: URL, to: URL, canOverwrite: Bool) throws -> ExistingPath {
        switch self.itemKind(at: at) {
        case .directory:
            throw self.error("copying file", because: "'\(at.relativePath)' is a directory")
        case .none:
            throw self.error("copying file", because: "an item at '\(at.relativePath)' does not exist")
        case .file:
            switch (self.itemKind(at: to), canOverwrite) {
            case (.file, false):
                throw self.error("copying file", because: "a file at '\(to.relativePath)' already exists")
            case (.directory, _):
                throw self.error("copying item", because: "'\(to.relativePath)' is a directory")
            case (.file, true):
                try self.manager.removeItem(at: to)
                fallthrough
            default:
                #if os(Linux)
                    let source = try FileHandle(forReadingFrom: at)
                    try Data().write(to: to)
                    let destination = try FileHandle(forWritingTo: to)

                    var data: Data
                    repeat {
                        data = source.readData(ofLength: 16000)
                        destination.write(data)
                    } while !data.isEmpty
                #else
                    try self.manager.copyItem(at: at, to: to)
                #endif
            }

            guard let existingPath = self.path(from: to) as? ExistingPath else {
                throw self.error("moving item", because: "the item at the new location could not be found")
            }
            return existingPath
        }
    }

    func createDirectoryIfNotExists(at url: URL) throws -> DirectoryPath {
        switch self.itemKind(at: url) {
        case .none:
            try self.manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        case .file:
            throw self.error("creating directory", because: "a file already exists at '\(url.relativePath)'")
        case .directory:
            break
        }

        guard let directoryPath = self.path(from: url) as? DirectoryPath else {
            throw self.error("creating directory", because: "the new directory could not be found")
        }
        return directoryPath
    }

    func deleteItem(at url: URL) throws -> NonExistingPath {
        switch self.itemKind(at: url) {
        case .none:
            throw self.error("deleting item", because: "an item does not exist at '\(url.relativePath)'")
        case .file, .directory:
            try self.manager.removeItem(at: url)
        }

        guard let nonExistingPath = self.path(from: url) as? NonExistingPath else {
            throw self.error("deleting item", because: "the item still exists after deleting")
        }
        return nonExistingPath
    }

    func lastModified(at url: URL) throws -> Date {
        #if os(Linux)
            var st = stat()
            stat(url.relativePath, &st)
            let ts = st.st_mtim
            let double = Double(ts.tv_nsec) * 1.0E-9 + Double(ts.tv_sec)
            guard double > 0 else {
                throw self.error("getting last modified", because: "\(url.relativePath) is not a file")
            }
            return Date(timeIntervalSince1970: double)
        #else
            let attributes = try self.manager.attributesOfItem(atPath: url.relativePath)
            return attributes[.modificationDate] as? Date ?? Date()
        #endif
    }

    func size(at url: URL) throws -> Int {
        #if os(Linux)
            switch try self.itemKind(at: url) {
            case .directory:
                return 0
            case .none:
                throw self.error("getting size", because: "a file does not exist at \(url.relativePath)")
            case .file:
                var st = stat()
                stat(url.relativePath, &st)
                return st.st_size
            }
        #else
            let attributes = try self.manager.attributesOfItem(atPath: url.relativePath)
            return attributes[.size] as? Int ?? 0
        #endif
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
