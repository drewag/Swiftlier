//
//  FileSystemExistingReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: ExistingReferenceType {
    public func delete() -> UnknownReferenceType {
        self.fileSystem.deleteItem(at: self.path)
        return try! self.fileSystem.reference(forPath: self.path) as! UnknownReferenceType
    }

    public func copyAndOverwriteTo(reference: ReferenceType) -> ExistingReferenceType {
        self.fileSystem.copyAndOverwrite(from: self.path, to: reference.fullPath())
        return try! self.fileSystem.reference(forPath: reference.fullPath()) as! ExistingReferenceType
    }

    public func moveAndOverwriteTo(reference: ReferenceType) -> ExistingReferenceType {
        self.fileSystem.moveAndOverwrite(from: self.path, to: reference.fullPath())
        return try! self.fileSystem.reference(forPath: reference.fullPath()) as! ExistingReferenceType
    }
}
