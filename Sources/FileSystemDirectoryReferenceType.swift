//
//  FileSystemDirectoryReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: DirectoryReferenceType {
    public func contents() -> [ExistingReferenceType] {
        return try! self.fileSystem.contentsOfDirectory(at: self.path)
    }
}
