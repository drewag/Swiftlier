//
//  CoderKey.swift
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

public class CoderKey<Value: RawEncodableType> {
    public class var customKey: String? { return nil }
}

public class OptionalCoderKey<Value: RawEncodableType> {
    public class var customKey: String? { return nil }
}

public class NestedCoderKey<Value: EncodableType> {
    public class var customKey: String? { return nil }
}

public class OptionalNestedCoderKey<Value: EncodableType> {
    public class var customKey: String? { return nil }
}

extension CoderKey {
    static var path: [String] {
        return self.customKey?.componentsSeparatedByString(".")
            ?? [String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!]
    }
}

extension OptionalCoderKey {
    static var path: [String] {
        return self.customKey?.componentsSeparatedByString(".")
            ?? [String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!]
    }
}

extension NestedCoderKey {
    static var path: [String] {
        return self.customKey?.componentsSeparatedByString(".")
            ?? [String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!]
    }
}

extension OptionalNestedCoderKey {
    static var path: [String] {
        return self.customKey?.componentsSeparatedByString(".")
            ?? [String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!]
    }
}
