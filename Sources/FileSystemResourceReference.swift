//
//  FileSystemResourceReference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReference where Self: ResourceReference {
    public func fileHandleForReading() -> FileHandle {
        return FileHandle(forReadingAtPath: self.resolvingSymLinks().fullPath())!
    }

    public func fileHandleForWriting() -> FileHandle {
        return FileHandle(forWritingAtPath: self.path)!
    }

    public func asURL() -> URL {
        return URL(fileURLWithPath: self.path)
    }

    public func resolvingSymLinks() -> Reference {
        guard let newPath = try? self.fileSystem.manager.destinationOfSymbolicLink(atPath: self.path) else {
            return self
        }
        return try! self.fileSystem.reference(forPath: newPath)
    }
}
