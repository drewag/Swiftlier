//
//  FileSystemUnkownReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: UnknownReferenceType {
    public func createFile(content: Data) -> ResourceReferenceType {
        self.fileSystem.createFile(at: self.path, with: content)
        return File(path: self.path, fileSystem: self.fileSystem)
    }

    public func createDirectory() -> DirectoryReferenceType {
        self.fileSystem.createDirectory(at: self.path)
        return Directory(path: self.path, fileSystem: self.fileSystem)
    }
}
