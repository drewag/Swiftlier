//
//  Reference.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#endif
import Foundation

public struct ReferenceErrorReason {
    public static let alreadyExists = ErrorReason("the reference already exists")
    public static let notFound = ErrorReason("the reference could not be found")
    public static let notADirectory = ErrorReason("the reference is not a directory")
    public static let notAResource = ErrorReason("the reference is not a resource")
    public static let notExtendable = ErrorReason("the resource is not extendable")
    public static let invalidPath = ErrorReason("the reference has an invalid path treating a file as a directory")

    public static var all: [ErrorReason] = [
        ReferenceErrorReason.alreadyExists,
        ReferenceErrorReason.notFound,
        ReferenceErrorReason.notADirectory,
        ReferenceErrorReason.notAResource,
        ReferenceErrorReason.notExtendable,
        ReferenceErrorReason.invalidPath
    ]
}

public protocol Reference: ErrorGenerating {
    var name: String {get}
    func fullPath() -> String
    func refresh() -> Reference
    func validateIsPossible() throws
}

extension Reference {
    public func fileUrl() -> URL {
        return URL(fileURLWithPath: self.fullPath())
    }

    public var `extension`: String {
        return URL(fileURLWithPath: self.fullPath()).pathExtension
    }
}

public protocol ExtendableReference: Reference {
    func append(component: String) throws -> Reference
}

public protocol UnknownReference: ExtendableReference {
    func createFile(content: Data) -> ResourceReference
    func createDirectory() -> DirectoryReference
    func createLink(to: ResourceReference) -> ResourceReference
}

public protocol ExistingReference: Reference {
    func delete() -> UnknownReference
    func copyAndOverwriteTo(reference: Reference) -> ExistingReference
    func moveAndOverwriteTo(reference: Reference) -> ExistingReference
}

public protocol DirectoryReference: ExtendableReference, ExistingReference {
    func contents() -> [ExistingReference]
}

public protocol ResourceReference: ExistingReference {
    func fileHandleForReading() -> FileHandle
    func fileHandleForWriting() -> FileHandle
    func asURL() -> URL
    func lastModified() -> Date
    func resolvingSymLinks() -> Reference
}

public func /(lhs: ExtendableReference, rhs: String) throws -> Reference {
    return try lhs.append(component: rhs)
}

public func /(lhs: Reference, rhs: String) throws -> Reference {
    return try lhs.append(component: rhs)
}

extension UnknownReference {
    public func createFile(content: String) -> ResourceReference {
        return self.createFile(content: content.data(using: .utf8)!)
    }
}

extension ResourceReference {
    public func contents() -> Data {
        return self.fileHandleForReading().readDataToEndOfFile()
    }

    public func string() -> String? {
        let data: Data = self.contents()
        return String(data: data, encoding: .utf8)
    }

    public func dictionary() -> [String:AnyObject]? {
        let data: Data = self.contents()
        do {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String:AnyObject]
        }
        catch {
            return nil
        }
    }

    public func overwriteFile(content: Data) throws -> ResourceReference {
        return self.delete().createFile(content: content)
    }

    public func overwriteFile(content: String) throws -> ResourceReference {
        return self.delete().createFile(content: content)
    }

    public func isIdentical(to: ResourceReference) throws -> Bool {
        let lFileHandle = self.fileHandleForReading()
        let rFileHandle = to.fileHandleForReading()

        var lData: Data
        var rData: Data
        repeat {
            lData = lFileHandle.readData(ofLength: 16000)
            rData = rFileHandle.readData(ofLength: 16000)

            guard lData == rData else {
                return false
            }
        } while !lData.isEmpty

        return true
    }

    public var nameWithoutExtension: String {
        return URL(fileURLWithPath: self.fullPath()).deletingPathExtension().lastPathComponent
    }
}

extension Reference {
    public var exists: Bool {
        if let _ = self as? UnknownReference {
            return false
        }
        else {
            return true
        }
    }

    public func createFile(content: Data) throws -> ResourceReference {
        if let unkownSelf = self as? UnknownReference {
            return unkownSelf.createFile(content: content)
        }
        else {
            throw self.error("creating file", because: ReferenceErrorReason.alreadyExists)
        }
    }

    public func createFile(content: String) throws -> ResourceReference {
        return try self.createFile(content: content.data(using: .utf8)!)
    }

    public func overwriteFile(content: Data) throws -> ResourceReference {
        if let unkownSelf = self as? UnknownReference {
            return unkownSelf.createFile(content: content)
        }
        else if let resource = self as? ResourceReference {
            return try resource.overwriteFile(content: content)
        }
        else {
            throw self.error("overwriting file", because: ReferenceErrorReason.notAResource)
        }
    }

    public func overwriteFile(content: String) throws -> ResourceReference {
        return try self.overwriteFile(content: content.data(using: .utf8)!)
    }

    public func createLink(to: ResourceReference) throws -> ResourceReference {
        if let unknownSelf = self as? UnknownReference {
            return unknownSelf.createLink(to: to)
        }
        else {
            throw self.error("creating symbolic link at \(self) from \(to)", because: ReferenceErrorReason.notAResource)
        }
    }

    public func overwriteLink(to: ResourceReference) throws -> ResourceReference {
        if let unknownSelf = self as? UnknownReference {
            return unknownSelf.createLink(to: to)
        }
        else if let existing = self as? ExistingReference {
            return existing.delete().createLink(to: to)
        }
        else {
            throw self.error("overwriting link at \(self) from \(to)", because: ReferenceErrorReason.notAResource)
        }
    }

    public func createDirectory() throws -> DirectoryReference {
        if let unkownSelf = self as? UnknownReference {
            return unkownSelf.createDirectory()
        }
        else {
            throw self.error("creating directory", because: ReferenceErrorReason.alreadyExists)
        }
    }

    public func append(component: String) throws -> Reference {
        if let extendableSelf = self as? ExtendableReference {
            let result = try extendableSelf.append(component: component)
            try result.validateIsPossible()
            return result
        }
        else {
            throw self.error("appending component to '\(self)'", because: ReferenceErrorReason.notExtendable)
        }
    }

    @discardableResult
    public func delete() throws -> UnknownReference {
        if let existingSelf = self as? ExistingReference {
            return existingSelf.delete()
        }
        else {
            throw self.error("deleting resource at \(self)", because: ReferenceErrorReason.notFound)
        }
    }

    public func subReferences() throws -> [ExistingReference] {
        if let directorySelf = self as? DirectoryReference {
            return directorySelf.contents()
        }
        else {
            throw self.error("loading contents of directory at \(self)", because: ReferenceErrorReason.notADirectory)
        }
    }

    public func data() throws -> Data {
        if let resourceSelf = self as? ResourceReference {
            return resourceSelf.contents()
        }
        else {
            throw self.error("loading data from \(self)", because: ReferenceErrorReason.notAResource)
        }
    }

    public func string() throws -> String? {
        if let resourceSelf = self as? ResourceReference {
            return resourceSelf.string()
        }
        else {
            throw self.error("loading string from \(self)", because: ReferenceErrorReason.notAResource)
        }
    }

    public func dictionary() throws -> [String:AnyObject]? {
        if let resourceSelf = self as? ResourceReference {
            return resourceSelf.dictionary()
        }
        else {
            throw self.error("loading dictionary from \(self)", because: ReferenceErrorReason.notAResource)
        }
    }

    public func url() throws -> URL {
        if let resourceSelf = self as? ResourceReference {
            return resourceSelf.asURL()
        }
        else {
            throw self.error("loading url from \(self)", because: ReferenceErrorReason.notAResource)
        }
    }

    #if os(iOS)
    public func image() -> UIImage? {
        do {
            let data = try self.data()
            return UIImage(data: data)
        }
        catch {
            return nil
        }
    }
    #endif
}
