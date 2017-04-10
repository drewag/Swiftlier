//
//  ReferenceType.swift
//  ResourceReferences
//
//  Created by Andrew J Wagner on 8/30/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public enum ReferenceError: UserReportableError {
    case AlreadyExists
    case NotFound
    case NotADirectory
    case NotAResource
    case NotExtendable
    case InvalidPath

    public var alertTitle: String {
        return "Error Referencing File"
    }

    public var alertMessage: String {
        switch self {
        case .AlreadyExists:
            return "already exists"
        case .NotFound:
            return "not found"
        case .NotADirectory:
            return "not a directory"
        case .NotAResource:
            return "not a resource"
        case .NotExtendable:
            return "not extendable"
        case .InvalidPath:
            return "invalid path"
        }
    }

    public var otherInfo: [String:String]? {
        return nil
    }
}

public protocol ReferenceType {
    var name: String {get}
    func fullPath() -> String
    func refresh() -> ReferenceType
    func validateIsPossible() throws
}

extension ReferenceType {
    public func fileUrl() -> URL {
        return URL(fileURLWithPath: self.fullPath())
    }
}

public protocol ExtendableReferenceType: ReferenceType {
    func append(component: String) throws -> ReferenceType
}

public protocol UnknownReferenceType: ExtendableReferenceType {
    func createFile(content: Data) -> ResourceReferenceType
    func createDirectory() -> DirectoryReferenceType
}

public protocol ExistingReferenceType: ReferenceType {
    func delete()
    func copyAndOverwriteTo(reference: ReferenceType)
    func moveAndOverwriteTo(reference: ReferenceType)
}

public protocol DirectoryReferenceType: ExtendableReferenceType, ExistingReferenceType {
    func contents() -> [ExistingReferenceType]
}

public protocol ResourceReferenceType: ExistingReferenceType {
    func contents() -> Data
    func asURL() -> URL
}

public func /(lhs: ExtendableReferenceType, rhs: String) throws -> ReferenceType {
    return try lhs.append(component: rhs)
}

public func /(lhs: ReferenceType, rhs: String) throws -> ReferenceType {
    return try lhs.append(component: rhs)
}

extension UnknownReferenceType {
    public func createFile(content: String) -> ResourceReferenceType {
        return self.createFile(content: content.data(using: .utf8)!)
    }
}

extension ResourceReferenceType {
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
}

extension ReferenceType {
    public var exists: Bool {
        if let _ = self as? UnknownReferenceType {
            return false
        }
        else {
            return true
        }
    }

    public func createFile(content: Data) throws -> ResourceReferenceType {
        if let unkownSelf = self as? UnknownReferenceType {
            return unkownSelf.createFile(content: content)
        }
        else {
            throw ReferenceError.AlreadyExists
        }
    }

    public func createFile(content: String) throws -> ResourceReferenceType {
        return try self.createFile(content: content.data(using: .utf8)!)
    }

    public func createDirectory() throws -> DirectoryReferenceType {
        if let unkownSelf = self as? UnknownReferenceType {
            return unkownSelf.createDirectory()
        }
        else {
            throw ReferenceError.AlreadyExists
        }
    }

    public func append(component: String) throws -> ReferenceType {
        if let extendableSelf = self as? ExtendableReferenceType {
            let result = try extendableSelf.append(component: component)
            try result.validateIsPossible()
            return result
        }
        else {
            throw ReferenceError.NotExtendable
        }
    }

    public func delete() throws {
        if let existingSelf = self as? ExistingReferenceType {
            existingSelf.delete()
        }
        else {
            throw ReferenceError.NotFound
        }
    }

    public func subReferences() throws -> [ExistingReferenceType] {
        if let directorySelf = self as? DirectoryReferenceType {
            return directorySelf.contents()
        }
        else {
            throw ReferenceError.NotADirectory
        }
    }

    public func data() throws -> Data {
        if let resourceSelf = self as? ResourceReferenceType {
            return resourceSelf.contents()
        }
        else {
            throw ReferenceError.NotAResource
        }
    }

    public func string() throws -> String? {
        if let resourceSelf = self as? ResourceReferenceType {
            return resourceSelf.string()
        }
        else {
            throw ReferenceError.NotAResource
        }
    }

    public func dictionary() throws -> [String:AnyObject]? {
        if let resourceSelf = self as? ResourceReferenceType {
            return resourceSelf.dictionary()
        }
        else {
            throw ReferenceError.NotAResource
        }
    }

    public func url() throws -> URL {
        if let resourceSelf = self as? ResourceReferenceType {
            return resourceSelf.asURL()
        }
        else {
            throw ReferenceError.NotAResource
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
