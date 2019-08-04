//
//  CodingTarget.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/29/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

/// The reason an instance is being encoded or decoded
public enum CodingPurpose {
    /// To create a new instance
    case create

    /// To update an existing instance
    case update

    /// To replace an existing object
    case replace
}

/// The location an instance is being encoded to or from
public enum CodingLocation {
    /// Local storage
    case local

    /// Remote storage
    case remote
}

/// Keys for coding user info dictionaries
public struct CodingOptions {
    public static let codingPurpose = CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!
    public static let codingLocation = CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!
}

extension Encoder {
    /// The purpose of the encoding
    public var purpose: CodingPurpose {
        return self.userInfo.purpose ?? .create
    }

    /// The destination of the encoded data
    public var destination: CodingLocation {
        return self.userInfo.location ?? .local
    }
}

extension Decoder {
    /// The purpose of the decoding
    public var purpose: CodingPurpose {
        return self.userInfo.purpose ?? .create
    }

    /// Where the encoded data came from
    public var source: CodingLocation {
        return self.userInfo.location ?? .local
    }
}

extension Dictionary where Key == CodingUserInfoKey, Value == Any {
    /// Set the purpose if one has not already been set
    public mutating func set(purposeDefault purpose: CodingPurpose) {
        if self.purpose == nil {
            self.purpose = purpose
        }
    }

    /// The purpose of this coding
    public var purpose: CodingPurpose? {
        get {
            return self[CodingOptions.codingPurpose] as? CodingPurpose
        }

        set {
            self[CodingOptions.codingPurpose] = newValue
        }
    }

    /// Set the location if one has not already been set
    public mutating func set(locationDefault location: CodingLocation) {
        if self.location == nil {
            self.location = location
        }
    }

    /// The location of this coding
    public var location: CodingLocation? {
        get{
            return self[CodingOptions.codingLocation] as? CodingLocation
        }

        set {
            self[CodingOptions.codingLocation] = newValue
        }
    }
}

