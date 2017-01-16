//
//  FileService.swift
//  drewag.me
//
//  Created by Andrew Wagner on 1/15/17.
//
//

import Foundation

public class FileService {
    fileprivate let fileManager = FileManager.default

    public static let `default` = FileService()

    public func fileExists(at url: URL) -> Bool {
        return self.fileManager.fileExists(atPath: url.relativePath)
    }

    public func contentsOfDirectory(at url: URL, skipHiddenFiles: Bool = false) -> [URL] {
        #if os(Linux)
            return CommandLine.execute("ls \"\(url.relativePath)\"")
                .components(separatedBy: "\n")
                .filter({!$0.isEmpty})
                .map({url.appendingPathComponent($0)})
        #else
            do {
                return try self.fileManager.contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: nil,
                    options: skipHiddenFiles ? .skipsHiddenFiles : FileManager.DirectoryEnumerationOptions()
                )
            }
            catch {
                return []
            }
        #endif
    }

    public func removeItem(at url: URL) {
        do { try self.fileManager.removeItem(atPath: url.relativePath) } catch {}
    }

    public func createDirectory(at url: URL) {
        #if os(Linux)
            let _ = CommandLine.execute("mkdir -p \"\(url.relativePath)\"")
        #else
            do { try self.fileManager.createDirectory(atPath: url.relativePath, withIntermediateDirectories: true, attributes: nil) } catch {}
        #endif
    }

    public func moveItem(from: URL, to: URL) throws {
        try self.fileManager.moveItem(at: from, to: to)
    }

    public func copyItem(from: URL, to: URL) throws {
        #if os(Linux)
            let _ = CommandLine.execute("cp -R \"\(from.relativePath)\" \"\(to.relativePath)\"")
        #else
            try self.fileManager.copyItem(at: from, to: to)
        #endif
    }

    public func jsonObject(at url: URL) throws -> Any {
        #if os(Linux)
            let string = CommandLine.execute("cat \"\(url.relativePath)\"")
            let data = string.data(using: .utf8) ?? Data()
        #else
            let data = try Data(contentsOf: url)
        #endif
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}
