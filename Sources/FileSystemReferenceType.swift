//
//  FileSystemReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: ReferenceType {
    public var name: String {
        return (self.path as NSString).lastPathComponent
    }
}
