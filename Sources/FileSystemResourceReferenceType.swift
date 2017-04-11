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
        let attributes = try! self.fileSystem.manager.attributesOfItem(atPath: self.path)
        let path: String
        switch attributes[.type] as! FileAttributeType {
        case FileAttributeType.typeSymbolicLink:
            path = try! self.fileSystem.manager.destinationOfSymbolicLink(atPath: self.path)
        default:
            path = self.path
        }
        return FileHandle(forReadingAtPath: path)!
    }

    public func fileHandleForWriting() -> FileHandle {
        return FileHandle(forWritingAtPath: self.path)!
    }

    public func asURL() -> URL {
        return URL(fileURLWithPath: self.path)
    }
}
