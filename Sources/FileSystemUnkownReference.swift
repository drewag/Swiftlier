//
//  FileSystemUnkownReference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReference where Self: UnknownReference {
    public func createFile(content: Data) -> ResourceReference {
        self.fileSystem.createFile(at: self.path, with: content)
        return File(path: self.path, fileSystem: self.fileSystem)
    }

    public func createDirectory() -> DirectoryReference {
        self.fileSystem.createDirectory(at: self.path)
        return Directory(path: self.path, fileSystem: self.fileSystem)
    }
}
