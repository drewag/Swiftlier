//
//  NSFileManager+Directories.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 12/15/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import Foundation

extension FileManager {
    public var documentsDirectoryURL: URL {
        let URL = try? self.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        return URL!
    }

    public var cachesDirectoryURL: URL {
        let URL = try? self.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        return URL!
    }

    public var documentsDirectoryPath: String {
        return self.documentsDirectoryURL.relativePath
    }

    public var cachesDirectoryPath: String {
        return self.cachesDirectoryURL.relativePath
    }
}
