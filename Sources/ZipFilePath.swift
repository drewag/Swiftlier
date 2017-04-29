//
//  ZipFilePath.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/17/17.
//
//

#if os(Linux) || os(macOS)
import Foundation

extension FilePath {
    public func unzip(to: Path, keepingPaths: Bool, excluding: [String] = ["__MACOSX/*"]) throws -> DirectoryPath {
        return try ZipFilePath(path: self).unzip(to: to, keepingPaths: keepingPaths, excluding: excluding)
    }

    public func unzipToTemporaryDirectory(keepingPaths: Bool, excluding: [String] = ["__MACOSX/*"]) throws -> DirectoryPath {
        return try ZipFilePath(path: self).unzipToTemporaryDirectory(keepingPaths: keepingPaths, excluding: excluding)
    }
}

public struct ZipFilePath: ErrorGenerating {
    let path: Path

    private static func temporaryDirectory() throws -> DirectoryPath {
        return try FileSystem.default.workingDirectory.subdirectory("tmp")
    }

    private static func temporaryUnzipLocation() throws -> Path {
        return try self.temporaryDirectory().subdirectory("unzipped")
    }

    init(path: FilePath) {
        self.path = path
    }

    public init(data: Data) throws {
        self.path = try ZipFilePath.temporaryDirectory().addFile(named: "to-unzip.zip", containing: data, canOverwrite: true)
    }

    public func unzip(to: Path, keepingPaths: Bool, excluding: [String] = ["__MACOSX/*"]) throws -> DirectoryPath {
        guard let destination = to as? NonExistingPath else {
            throw self.error("unzipping", because: "the destination '\(to.url.relativePath)' already exists")
        }

        var command = "unzip"
        if !keepingPaths {
            command += " -j"
        }
        command += " \"\(self.path.url.relativePath)\" -d \"\(destination.url.relativePath)\""
        for exclude in excluding {
            command += " -x '\(exclude)'"
        }

        try ShellCommand(command).execute()
        guard let directory = to.refresh() as? DirectoryPath else {
            throw self.error("unzipping", because: "the destination zip directory could not be found")
        }
        return directory

    }

    public func unzipToTemporaryDirectory(keepingPaths: Bool, excluding: [String] = ["__MACOSX/*"]) throws -> DirectoryPath {
        let destination = try ZipFilePath.temporaryUnzipLocation()
        let _ = try? destination.directory?.delete()
        return try self.unzip(to: destination, keepingPaths: keepingPaths, excluding: excluding)
    }
}
#endif
