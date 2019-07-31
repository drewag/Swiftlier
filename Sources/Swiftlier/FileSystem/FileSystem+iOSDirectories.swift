//
//  UIImage+Editing.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 5/25/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

extension FileSystem {
    public var documentsDirectory: DirectoryPath {
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let path = self.path(from: url)
        return try! path.directory ?? path.createDirectory()
    }

    public var cachesDirectory: DirectoryPath {
        let url = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let path = self.path(from: url)
        return try! path.directory ?? path.createDirectory()
    }

    public var libraryDirectory: DirectoryPath {
        let url = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let path = self.path(from: url)
        return try! path.directory ?? path.createDirectory()
    }
}
#endif
