//
//  FileSystemExistingReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: ExistingReferenceType {
    public func delete() {
        self.fileSystem.deleteItem(at: self.path)
    }

    public func copyAndOverwriteTo(reference: ReferenceType) {
        self.fileSystem.copyAndOverwrite(from: self.path, to: reference.fullPath())
    }

    public func moveAndOverwriteTo(reference: ReferenceType) {
        self.fileSystem.moveAndOverwrite(from: self.path, to: reference.fullPath())
    }
}
