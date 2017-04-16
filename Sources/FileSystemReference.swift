//
//  FileSystemReference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/31/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

extension FileSystemReference where Self: Reference {
    public var name: String {
        return URL(fileURLWithPath: self.path).lastPathComponent
    }
}
