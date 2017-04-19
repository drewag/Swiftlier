//
//  Zip.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/17/17.
//
//

#if os(Linux) || os(macOS)
import Foundation

public struct Zip: ErrorGenerating {
    let reference: ResourceReference

    private static var temporaryDirectory: Reference {
        return try! FileSystem.main.reference(forPath: "tmp/unzipped")
    }

    private static var temporaryZip: Reference {
        return try! FileSystem.main.reference(forPath: "tmp/to-unzip.zip")
    }

    public init(reference: ResourceReference) {
        self.reference = reference
    }

    public init(data: Data) throws {
        self.reference = try Zip.temporaryZip.overwriteFile(content: data)
    }

    public func unzip(to: Reference, keepingPaths: Bool, excluding: [String] = ["__MACOSX/*"]) throws -> DirectoryReference {
        guard let destination = to as? UnknownReference else {
            throw self.error("unzipping", because: "the destination '\(to.fullPath())' already exists")
        }

        var command = "unzip"
        if !keepingPaths {
            command += " -j"
        }
        command += " \"\(reference.fullPath())\" -d \"\(destination.fullPath())\""
        for exclude in excluding {
            command += " -x '\(exclude)'"
        }

        try ShellCommand(command).execute()
        guard let directory = to.refresh() as? DirectoryReference else {
            throw self.error("unzipping", because: "the destination zip directory could not be found")
        }
        return directory

    }

    public func unzipToTemporaryDirectory(keepingPaths: Bool, excluding: [String] = ["__MACOSX/*"]) throws -> DirectoryReference {
        let _ = try? Zip.temporaryDirectory.delete()
        return try self.unzip(to: Zip.temporaryDirectory, keepingPaths: keepingPaths, excluding: excluding)
    }
}
#endif
