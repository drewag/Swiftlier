//
//  CoderKeyType.swift
//  AtomicObjectFiles
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag, LLC. All rights reserved.
//

import Foundation

public protocol RawEncodableType {
    init()
    var asObject: AnyObject { get }
}
extension String: RawEncodableType { public var asObject: AnyObject { return self } }
extension Bool: RawEncodableType { public var asObject: AnyObject { return self } }
extension Int: RawEncodableType { public var asObject: AnyObject { return self } }
extension Double: RawEncodableType { public var asObject: AnyObject { return self } }
extension Float: RawEncodableType { public var asObject: AnyObject { return self } }
extension NSData: RawEncodableType { public var asObject: AnyObject { return self } }
extension NSDate: RawEncodableType { public var asObject: AnyObject { return self } }

public protocol CoderKeyType {
    typealias ValueType: RawEncodableType
}

public protocol OptionalCoderKeyType {
    typealias ValueType: RawEncodableType
}

public protocol NestedCoderKeyType {
    typealias ValueType: EncodableType
}

extension CoderKeyType {
    static func toString() -> String {
        return String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!
    }
}

extension OptionalCoderKeyType {
    static func toString() -> String {
        return String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!
    }
}

extension NestedCoderKeyType {
    static func toString() -> String {
        return String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!
    }
}
