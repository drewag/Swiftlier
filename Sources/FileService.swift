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
    }

    public func removeItem(at url: URL) {
        do { try self.fileManager.removeItem(atPath: url.relativePath) } catch {}
    }

    public func createDirectory(at url: URL) {
        do { try self.fileManager.createDirectory(atPath: url.relativePath, withIntermediateDirectories: true, attributes: nil) } catch {}
    }

    public func moveItem(from: URL, to: URL) throws {
        try self.fileManager.moveItem(at: from, to: to)
    }

    public func copyItem(from: URL, to: URL) throws {
        try self.fileManager.copyItem(at: from, to: to)
    }
}
