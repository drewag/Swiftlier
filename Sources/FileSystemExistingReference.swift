//
//  FileSystemExistingReference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReference where Self: ExistingReference {
    public func delete() -> UnknownReference {
        self.fileSystem.deleteItem(at: self.path)
        return try! self.fileSystem.reference(forPath: self.path) as! UnknownReference
    }

    public func copyAndOverwriteTo(reference: Reference) -> ExistingReference {
        self.fileSystem.copyAndOverwrite(from: self.path, to: reference.fullPath())
        return try! self.fileSystem.reference(forPath: reference.fullPath()) as! ExistingReference
    }

    public func moveAndOverwriteTo(reference: Reference) -> ExistingReference {
        self.fileSystem.moveAndOverwrite(from: self.path, to: reference.fullPath())
        return try! self.fileSystem.reference(forPath: reference.fullPath()) as! ExistingReference
    }
}
