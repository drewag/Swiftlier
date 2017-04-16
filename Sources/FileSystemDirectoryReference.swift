//
//  FileSystemDirectoryReference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReference where Self: DirectoryReference {
    public func contents() -> [ExistingReference] {
        return try! self.fileSystem.contentsOfDirectory(at: self.path)
    }
}
