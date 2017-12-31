//
//  SyncableValue.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 12/20/16.
//  Copyright © 2016 Drewag. All rights reserved.
//

import Foundation

public protocol AnySyncable {
    var isDifferentLocally: Bool {get}
}

public enum SyncChangeSource { case local, remote }
private enum SyncableStatus {
    case both(local: Date, remote: Date)
    case local(Date)
    case remote(Date)
}

public struct Syncable<Value: Codable>: AnySyncable, Decodable {
    public fileprivate(set) var value: Value
    public fileprivate(set) var remoteValue: Value? = nil

    fileprivate var status: SyncableStatus

    public init(_ value: Value) {
        self.value = value
        self.status = .remote(Date.now)
    }

    public var lastChanged: Date {  
        switch self.status {
        case .local(let date):
            return date
        case .remote(let date):
            return date
        case let .both(local, remote):
            if local.timeIntervalSince(remote) > 0 {
                return local
            }
            else {
                return remote
            }
        }
    }

    public var isDifferentLocally: Bool {
        switch self.status {
        case .remote:
            return false
        case .local:
            return true
        case let .both(local, remote):
            return local.timeIntervalSince(remote) > 0
        }
    }

    public mutating func update(to value: Value, from source: SyncChangeSource) {
        switch source {
        case .remote:
            self.remoteValue = value
            self.value = value
            self.lastRemoteChanged = Date.now
        case .local:
            self.value = value
            self.lastLocalChanged = Date.now
        }
    }

    public func converted<OtherValue>(by: (Value) -> (OtherValue)) -> Syncable<OtherValue> {
        let convertedValue = by(self.value)
        var converted = Syncable<OtherValue>(convertedValue)
        if let remoteValue = self.remoteValue {
            converted.remoteValue = by(remoteValue)
        }
        converted.status = self.status
        return converted
    }

    public mutating func sync(to other: Syncable<Value>) {
        guard other.lastChanged.timeIntervalSince(self.lastChanged) > 0 else {
            return
        }

        self.value = other.value
        self.lastLocalChanged = other.lastLocalChanged
        if let otherRemote = other.remoteValue {
            if let _ = self.remoteValue {
                if (other.lastRemoteChanged ?? .distantPast).timeIntervalSince(self.lastRemoteChanged ?? .distantPast) > 0 {
                    self.remoteValue = otherRemote
                    self.lastRemoteChanged = other.lastRemoteChanged
                }
            }
            else {
                self.remoteValue = otherRemote
                self.lastRemoteChanged = other.lastRemoteChanged
            }
        }
    }

    public init(from decoder: Decoder) throws {
        switch decoder.source {
        case .local:
            let container = try decoder.container(keyedBy: SyncableCodingKeys.self)
            self.value = try container.decode(Value.self, forKey: .value)
            self.remoteValue = try container.decodeIfPresent(Value.self, forKey: .remoteValue)
            switch (try container.decodeIfPresent(String.self, forKey: .lastLocalChanged)?.iso8601DateTime, try container.decodeIfPresent(String.self, forKey: .lastRemoteChanged)?.iso8601DateTime) {
            case (nil, nil):
                fatalError()
            case (.some(let local), nil):
                self.status = .local(local)
            case (nil, .some(let remote)):
                self.status = .remote(remote)
            case (.some(let local), .some(let remote)):
                self.status = .both(local: local, remote: remote)
            }
        case .remote:
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Value.self)
            self.value = value
            self.remoteValue = value
            self.status = .remote(Date.now)
        }
    }
}

public struct SyncableOptional<Value: Codable>: AnySyncable, Decodable {
    public fileprivate(set) var value: Value?
    public fileprivate(set) var remoteValue: Value? = nil

    fileprivate var status: SyncableStatus

    public init(_ value: Value?) {
        self.value = value
        self.status = .remote(Date.now)
    }

    public var lastChanged: Date {
        switch self.status {
        case .local(let date):
            return date
        case .remote(let date):
            return date
        case let .both(local, remote):
            if local.timeIntervalSince(remote) > 0 {
                return local
            }
            else {
                return remote
            }
        }
    }

    public var isDifferentLocally: Bool {
        switch self.status {
        case .remote:
            return false
        case .local:
            return true
        case let .both(local, remote):
            return local.timeIntervalSince(remote) > 0
        }
    }

    public mutating func update(to value: Value?, from source: SyncChangeSource) {
        switch source {
        case .remote:
            self.remoteValue = value
            self.value = value
            self.lastRemoteChanged = Date.now
        case .local:
            self.value = value
            self.lastLocalChanged = Date.now
        }
    }

    public func converted<OtherValue>(by: (Value) -> (OtherValue?)) -> SyncableOptional<OtherValue> {
        var convertedValue: OtherValue? = nil
        if let value = self.value {
            convertedValue = by(value)
        }

        var converted = SyncableOptional<OtherValue>(convertedValue)
        if let remoteValue = self.remoteValue {
            converted.remoteValue = by(remoteValue)
        }
        converted.status = self.status
        return converted
    }

    public mutating func sync(to other: SyncableOptional<Value>) {
        guard other.lastChanged.timeIntervalSince(self.lastChanged) > 0 else {
            return
        }

        self.value = other.value
        self.lastLocalChanged = other.lastLocalChanged
        if let otherRemote = other.remoteValue {
            if let _ = self.remoteValue {
                if (other.lastRemoteChanged ?? .distantPast).timeIntervalSince(self.lastRemoteChanged ?? .distantPast) > 0 {
                    self.remoteValue = otherRemote
                    self.lastRemoteChanged = other.lastRemoteChanged
                }
            }
            else {
                self.remoteValue = otherRemote
                self.lastRemoteChanged = other.lastRemoteChanged
            }
        }
    }

    public init(from decoder: Decoder) throws {
        switch decoder.source {
        case .local:
            let container = try decoder.container(keyedBy: SyncableCodingKeys.self)
            self.value = try container.decodeIfPresent(Value.self, forKey: .optionalValue)
            self.remoteValue = try container.decodeIfPresent(Value.self, forKey: .remoteValue)
            switch (try container.decodeIfPresent(String.self, forKey: .lastLocalChanged)?.iso8601DateTime, try container.decodeIfPresent(String.self, forKey: .lastRemoteChanged)?.iso8601DateTime) {
            case (nil, nil):
                fatalError()
            case (.some(let local), nil):
                self.status = .local(local)
            case (nil, .some(let remote)):
                self.status = .remote(remote)
            case (.some(let local), .some(let remote)):
                self.status = .both(local: local, remote: remote)
            }
        case .remote:
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Value.self)
            self.value = value
            self.remoteValue = value
            self.status = .remote(Date.now)
        }
    }
}

enum SyncableCodingKeys: String, CodingKey {
    case value = "ValueKey", optionalValue = "OptionalValueKey"
    case remoteValue = "RemoteValueKey", lastLocalChanged = "LastLocalChangeKey"
    case lastRemoteChanged = "LastRemoteChangedKey"
}

extension Syncable: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch encoder.destination {
        case .local:
            var container = encoder.container(keyedBy: SyncableCodingKeys.self)
            try container.encode(self.value, forKey: .value)
            try container.encode(self.remoteValue, forKey: .remoteValue)
            try container.encode(self.lastLocalChanged?.iso8601DateTime, forKey: .lastLocalChanged)
            try container.encode(self.lastRemoteChanged?.iso8601DateTime, forKey: .lastRemoteChanged)
        case .remote:
            switch encoder.purpose {
            case .update:
                if self.isDifferentLocally {
                    var container = encoder.singleValueContainer()
                    try container.encode(self.value)
                }
            case .create, .replace:
                var container = encoder.singleValueContainer()
                try container.encode(self.value)
            }
        }
    }
}

fileprivate extension Syncable {
    fileprivate var lastLocalChanged: Date? {
        set {
            switch self.status {
            case .both(local: _, remote: let remote):
                if let local = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .remote(remote)
                }
            case .remote(let remote):
                if let local = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .remote(remote)
                }
            case .local:
                if let local = newValue {
                    self.status = .local(local)
                }
            }
        }

        get {
            switch self.status {
            case .both(local: let local, remote: _):
                return local
            case .local(let local):
                return local
            case .remote:
                return nil
            }
        }
    }

    fileprivate var lastRemoteChanged: Date? {
        set {
            switch self.status {
            case .both(local: let local, remote: _):
                if let remote = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .local(local)
                }
            case .local(let local):
                if let remote = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .local(local)
                }
            case .remote:
                if let remote = newValue {
                    self.status = .remote(remote)
                }
            }
        }

        get {
            switch self.status {
            case .both(_, let remote):
                return remote
            case .remote(let remote):
                return remote
            case .local:
                return nil
            }
        }
    }
}

extension SyncableOptional: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch encoder.destination {
        case .local:
            var container = encoder.container(keyedBy: SyncableCodingKeys.self)
            try container.encode(self.value, forKey: .optionalValue)
            try container.encode(self.remoteValue, forKey: .remoteValue)
            try container.encode(self.lastLocalChanged?.iso8601DateTime, forKey: .lastLocalChanged)
            try container.encode(self.lastRemoteChanged?.iso8601DateTime, forKey: .lastRemoteChanged)
        case .remote:
            switch encoder.purpose {
            case .update:
                if self.isDifferentLocally {
                    var container = encoder.singleValueContainer()
                    try container.encode(self.value)
                }
            case .create, .replace:
                var container = encoder.singleValueContainer()
                try container.encode(self.value)
            }
        }
    }
}

fileprivate extension SyncableOptional {
    fileprivate var lastLocalChanged: Date? {
        set {
            switch self.status {
            case .both(local: _, remote: let remote):
                if let local = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .remote(remote)
                }
            case .remote(let remote):
                if let local = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .remote(remote)
                }
            case .local:
                if let local = newValue {
                    self.status = .local(local)
                }
            }
        }

        get {
            switch self.status {
            case .both(local: let local, remote: _):
                return local
            case .local(let local):
                return local
            case .remote:
                return nil
            }
        }
    }

    fileprivate var lastRemoteChanged: Date? {
        set {
            switch self.status {
            case .both(local: let local, remote: _):
                if let remote = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .local(local)
                }
            case .local(let local):
                if let remote = newValue {
                    self.status = .both(local: local, remote: remote)
                }
                else {
                    self.status = .local(local)
                }
            case .remote:
                if let remote = newValue {
                    self.status = .remote(remote)
                }
            }
        }

        get {
            switch self.status {
            case .both(_, let remote):
                return remote
            case .remote(let remote):
                return remote
            case .local:
                return nil
            }
        }
    }
}

