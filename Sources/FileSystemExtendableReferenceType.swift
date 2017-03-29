//
//  FileSystemExtendableReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: ExtendableReferenceType {
    public func append(component: String) -> ReferenceType {
        let newPath = (self.path as NSString).appendingPathComponent(component)
        return self.fileSystem.reference(forPath: newPath)
    }
}
