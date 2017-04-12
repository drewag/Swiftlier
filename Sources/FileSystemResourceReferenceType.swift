//
//  FileSystemResourceReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: ResourceReferenceType {
    public func fileHandleForReading() -> FileHandle {
        return FileHandle(forReadingAtPath: self.resolvingSymLinks().fullPath())!
    }

    public func fileHandleForWriting() -> FileHandle {
        return FileHandle(forWritingAtPath: self.path)!
    }

    public func asURL() -> URL {
        return URL(fileURLWithPath: self.path)
    }

    public func resolvingSymLinks() -> ReferenceType {
        let attributes = try! self.fileSystem.manager.attributesOfItem(atPath: self.path)
        switch attributes[.type] as! FileAttributeType {
        case FileAttributeType.typeSymbolicLink:
            let path = try! self.fileSystem.manager.destinationOfSymbolicLink(atPath: self.path)
            return try! self.fileSystem.reference(forPath: path)
        default:
            return self
        }
    }
}
