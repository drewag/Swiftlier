//
//  SyncableValue.swift
//  SwiftPlusPlus
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

public struct Syncable<Value: CodableType>: AnySyncable, DecodableType {
    public fileprivate(set) var value: Value
    public fileprivate(set) var remoteValue: Value? = nil

    fileprivate var status: SyncableStatus

    public init(_ value: Value) {
        self.value = value
        self.status = .remote(Date())
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
            self.lastRemoteChanged = Date()
        case .local:
            self.value = value
            self.lastLocalChanged = Date()
        }
    }

    public func converted<OtherValue: EncodableType>(by: (Value) -> (OtherValue)) -> Syncable<OtherValue> where OtherValue: DecodableType {
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

    public init(decoder: DecoderType) throws {
        switch decoder.mode {
        case .saveLocally:
            self.value = try decoder.decode(ValueKey.self)
            self.remoteValue = try decoder.decode(RemoteValueKey.self)
            switch (try decoder.decode(LastLocalChangedKey.self), try decoder.decode(LastRemoteChangedKey.self)) {
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
            let value: Value = try decoder.decodeAsEntireValue()
            self.value = value
            self.remoteValue = value
            self.status = .remote(Date())
        }
    }
}

public struct SyncableOptional<Value: CodableType>: AnySyncable, DecodableType {
    public fileprivate(set) var value: Value?
    public fileprivate(set) var remoteValue: Value? = nil

    fileprivate var status: SyncableStatus

    public init(_ value: Value?) {
        self.value = value
        self.status = .remote(Date())
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
            self.lastRemoteChanged = Date()
        case .local:
            self.value = value
            self.lastLocalChanged = Date()
        }
    }

    public func converted<OtherValue: EncodableType>(by: (Value) -> (OtherValue?)) -> SyncableOptional<OtherValue> where OtherValue: DecodableType {
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

    public init(decoder: DecoderType) throws {
        switch decoder.mode {
        case .saveLocally:
            self.value = try decoder.decode(OptionalValueKey.self)
            self.remoteValue = try decoder.decode(RemoteValueKey.self)
            switch (try decoder.decode(LastLocalChangedKey.self), try decoder.decode(LastRemoteChangedKey.self)) {
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
            let value: Value = try decoder.decodeAsEntireValue()
            self.value = value
            self.remoteValue = value
            self.status = .remote(Date())
        }
    }
}

class ValueKey<Value: EncodableType>: CoderKey<Value> {}
class OptionalValueKey<Value: EncodableType>: OptionalCoderKey<Value> {}
class RemoteValueKey<Value: EncodableType>: OptionalCoderKey<Value> {}
class LastLocalChangedKey: OptionalCoderKey<Date> {}
class LastRemoteChangedKey: OptionalCoderKey<Date> {}

extension Syncable: EncodableType {
    public func encode(_ encoder: EncoderType) {
        switch encoder.mode {
        case .saveLocally:
            encoder.encode(self.value, forKey: ValueKey.self)
            encoder.encode(self.remoteValue, forKey: RemoteValueKey.self)
            encoder.encode(self.lastLocalChanged, forKey: LastLocalChangedKey.self)
            encoder.encode(self.lastRemoteChanged, forKey: LastRemoteChangedKey.self)
        case .update:
            if self.isDifferentLocally {
                encoder.encodeAsEntireValue(self.value)
            }
            else {
                encoder.cancelEncoding()
            }
        case .create:
            encoder.encodeAsEntireValue(self.value)
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

extension SyncableOptional: EncodableType {
    public func encode(_ encoder: EncoderType) {
        switch encoder.mode {
        case .saveLocally:
            encoder.encode(self.value, forKey: OptionalValueKey.self)
            encoder.encode(self.remoteValue, forKey: RemoteValueKey.self)
            encoder.encode(self.lastLocalChanged, forKey: LastLocalChangedKey.self)
            encoder.encode(self.lastRemoteChanged, forKey: LastRemoteChangedKey.self)
        case .update:
            if self.isDifferentLocally {
                encoder.encodeAsEntireValue(self.value)
            }
            else {
                encoder.cancelEncoding()
            }
        case .create:
            encoder.encodeAsEntireValue(self.value)
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

