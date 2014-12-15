//
//  NSFileManager+Directories.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 12/15/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

extension NSFileManager {
    public var documentsDirectoryPath: String {
        let URL = self.URLForDirectory(
            .DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: true,
            error: nil
        )
        return URL!.relativePath!
    }

    public var cachesDirectoryPath: String {
        let URL = self.URLForDirectory(
            .CachesDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: true,
            error: nil
        )
        return URL!.relativePath!
    }
}