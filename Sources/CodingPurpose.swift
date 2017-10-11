//
//  CodingTarget.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/29/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public protocol UserInfoConvertible {
    var info: [CodingUserInfoKey:Any] {get}
}

public enum CodingPurpose: UserInfoConvertible {
    case create
    case update
    case replace

    public var info: [CodingUserInfoKey:Any] {
        return [
            CodingOptions.codingPurpose:self
        ]
    }
}

public enum CodingLocation: UserInfoConvertible {
    case local
    case remote

    public var info: [CodingUserInfoKey:Any] {
        return [
            CodingOptions.codingLocation:self
        ]
    }
}

public struct CodingOptions {
    public static let codingPurpose = CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!
    public static let codingLocation = CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!
}

extension Encoder {
    public var purpose: CodingPurpose {
        return self.userInfo.purpose ?? .create
    }

    public var destination: CodingLocation {
        return self.userInfo.location ?? .local
    }
}

extension Decoder {
    public var purpose: CodingPurpose {
        return self.userInfo.purpose ?? .create
    }

    public var source: CodingLocation {
        return self.userInfo.location ?? .local
    }
}

extension Dictionary where Key == CodingUserInfoKey, Value == Any {
    public mutating func set(purposeDefault purpose: CodingPurpose) {
        if self.purpose == nil {
            self.purpose = purpose
        }
    }

    public var purpose: CodingPurpose? {
        get {
            return self[CodingOptions.codingPurpose] as? CodingPurpose
        }

        set {
            self[CodingOptions.codingPurpose] = newValue
        }
    }

    public mutating func set(locationDefault location: CodingLocation) {
        if self.location == nil {
            self.location = location
        }
    }

    public var location: CodingLocation? {
        get{
            return self[CodingOptions.codingLocation] as? CodingLocation
        }

        set {
            self[CodingOptions.codingLocation] = newValue
        }
    }
}

