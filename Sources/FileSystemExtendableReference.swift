//
//  FileSystemExtendableReference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReference where Self: ExtendableReference {
    public func append(component: String) throws -> Reference {
        let newPath = URL(fileURLWithPath: self.path).appendingPathComponent(component).relativePath
        return try self.fileSystem.reference(forPath: newPath)
    }
}
