//
//  NSFileManager+Directories.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 12/15/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

extension NSFileManager {
    public var documentsDirectoryURL: NSURL {
        let URL = try? self.URLForDirectory(
            .DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: true)
        return URL!
    }

    public var cachesDirectoryURL: NSURL {
        let URL = try? self.URLForDirectory(
            .CachesDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: true)
        return URL!
    }

    public var documentsDirectoryPath: String {
        return self.documentsDirectoryURL.relativePath!
    }

    public var cachesDirectoryPath: String {
        return self.cachesDirectoryURL.relativePath!
    }
}