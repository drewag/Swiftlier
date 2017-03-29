//
//  FileSystemResourceReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReferenceType where Self: ResourceReferenceType {
    public func contents() -> Data {
        return try! Data(contentsOf: URL(fileURLWithPath: self.path))
    }

    public func asURL() -> URL {
        return URL(fileURLWithPath: self.path)
    }
}
