//
//  UserReportableError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public enum ErrorPerpitrator: String, Codable {
    case user
    case system
    case temporaryEnvironment
}

public protocol AnyErrorReason: class {
    var because: String {get}
}

public final class ErrorReason: AnyErrorReason {
    public let because: String

    public init(_ because: String) {
        self.because = because
    }
}

open class ErrorReasonWithExtraInfo<Params>: AnyErrorReason {
    public let because: String
    public let extraInfo: Params

    init(because: String, extraInfo: Params) {
        self.because = because
        self.extraInfo = extraInfo
    }
}

public protocol ReportableErrorConvertible {
    var reportableError: ReportableError {get}
}

public struct ReportableError: Error, CustomStringConvertible, Encodable {
    enum CodingKeys: String, CodingKey {
        case message, doing, because, perpitrator, backtrace
    }

    public let perpetrator: ErrorPerpitrator
    public let doing: String
    public let reason: AnyErrorReason
    public let backtrace: [String]?

    public init(_ doing: String, because: AnyErrorReason, by: ErrorPerpitrator = .system, backtrace: [String]? = Thread.callStackSymbols) {
        self.perpetrator = by
        self.doing = doing
        self.reason = because
        self.backtrace = backtrace
    }

    public init(_ doing: String, because: String, by: ErrorPerpitrator = .system, backtrace: [String]? = Thread.callStackSymbols) {
        self.init(doing, because: ErrorReason(because), by: by, backtrace: backtrace)
    }

    public init(_ doing: String, from error: Error) {
        switch error {
        case let reportable as ReportableError:
            self = reportable
        case let convertible as ReportableErrorConvertible:
            self = convertible.reportableError
        case let error as DecodingError:
            switch error {
            case .dataCorrupted(let context):
                let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                self.init(doing, because: "the value at \(path) is corrupted. More information: `\(context.debugDescription)`")
            case .keyNotFound(let key, let context):
                if context.codingPath.isEmpty {
                    self.init(doing, because: "the key for \(key.stringValue) was not found. More information: `\(context.debugDescription)`")
                }
                else {
                    let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                    self.init(doing, because: "the key at \(path) for \(key.stringValue) was not found. More information: `\(context.debugDescription)`")
                }
            case .valueNotFound(let type, let context):
                if context.codingPath.isEmpty {
                    self.init(doing, because: "the value for \(type) was not found. More information: `\(context.debugDescription)`")
                }
                else {
                    let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                    self.init(doing, because: "the value at \(path) for \(type) was not found. More information: `\(context.debugDescription)`")
                }
            case .typeMismatch(let type, let context):
                let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                self.init(doing, because: "the value at \(path) is not an \(type). More information: `\(context.debugDescription)`")
            @unknown default:
                self.init(doing, because: "uknown decoding error '\(error)'")
            }
        case let error as EncodingError:
            switch error {
            case .invalidValue(let value, let context):
                let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                self.init(doing, because: "the value (\(value)) at \(path) is invalid. More information: `\(context.debugDescription)`")
            @unknown default:
                self.init(doing, because: "uknown encoding error '\(error)'")
            }
        case let error as NSError:
            self.init(doing, because: error.localizedDescription)
        default:
            break
        }

        self.init(doing, because: "\(error)")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.description, forKey: .message)
        try container.encode(self.doing, forKey: .doing)
        try container.encode(self.reason.because, forKey: .because)
        try container.encode(self.perpetrator, forKey: .perpitrator)
        try container.encode(self.backtrace, forKey: .backtrace)
    }
}

public enum ReportableResult<Value> {
    case success(Value)
    case error(ReportableError)
}

extension ReportableError {
    public var alertDescription: (title: String, message: String) {
        var because = self.reason.because
        if because.first != nil {
            let first = because.removeFirst()
            because = "\(first)".capitalized + because
        }
        switch self.perpetrator {
        case .user:
            return (
                title: "Error \(self.doing.capitalized)",
                message: because
            )
        case .system:
            return (
                title: "Error \(self.doing.capitalized)",
                message: "Internal Error. Please try again. If the problem persists please contact support with the following description: Because \(self.reason.because)"
            )
        case .temporaryEnvironment:
            return (
                title: "Temporary Error \(self.doing.capitalized)",
                message: "\(because). Please try again."
            )
        }
    }

    public var description: String {
        switch self.perpetrator {
        case .user:
            return "Error \(self.doing.lowercased()) because \(self.reason.because)"
        case .system:
            return "Error \(self.doing.lowercased()) because of an internal error. Please try again. If the problem persists please contact support with the following description: Because \(self.reason.because)"
        case .temporaryEnvironment:
            return "Temporary Error \(self.doing.lowercased()) because \(self.reason.because). Please try again."
        }
    }

    public func doing(_ doing: String) -> ReportableError {
        return ReportableError(
            doing,
            because: self.reason,
            by: self.perpetrator,
            backtrace: self.backtrace
        )
    }

    public var byUser: ReportableError {
        return ReportableError(
            self.doing,
            because: self.reason,
            by: .user,
            backtrace: self.backtrace
        )
    }

    public func isBecause(of reasons: [AnyErrorReason]) -> Bool {
        return reasons.contains(where: {$0 === self.reason})
    }

    public func isBecause(of reasons: AnyErrorReason ...) -> Bool {
        return self.isBecause(of: reasons)
    }

    public func byUserIfBecauseOf(_ reasons: [AnyErrorReason]) -> ReportableError {
        if self.isBecause(of: reasons) {
            return self.byUser
        }
        else {
            return self
        }
    }

    public func byUserIfBecauseOf(_ reasons: AnyErrorReason ...) -> ReportableError {
        return self.byUserIfBecauseOf(reasons)
    }
}

extension ReportableError: LocalizedError {
    public var errorDescription: String? {
        return self.description
    }
}

extension ReportableError {
    public static func executeWhileReattributingErrors<Returning>(
        withReasons reasons: [AnyErrorReason],
        to perpitrator: ErrorPerpitrator,
        andRephrasingAs doing: String? = nil,
        execute: () throws -> Returning
        ) throws -> Returning
    {
        do {
            return try execute()
        }
        catch let error as ReportableError {
            if reasons.contains(where: {$0 === error.reason}) {
                throw ReportableError(
                    doing ?? error.doing,
                    because: error.reason,
                    by: error.perpetrator,
                    backtrace: error.backtrace
                )
            }
            throw error
        }
    }

    public static func executeWhileRephrasingErrors<Returning>(as doing: String, execute: () throws -> Returning) throws -> Returning {
        do {
            return try execute()
        }
        catch let error as ReportableError {
            throw ReportableError(
                doing,
                because: error.reason,
                by: error.perpetrator,
                backtrace: error.backtrace
            )
        }
    }

    public func executeWhileReattributingErrors<Returning>(
        withReasons reasons: [AnyErrorReason],
        to perpitrator: ErrorPerpitrator,
        execute: () throws -> Returning
        ) throws -> Returning
    {
        return try type(of: self).executeWhileReattributingErrors(withReasons: reasons, to: perpitrator, execute: execute)
    }

    public func executeWhileRephrasingErrors<Returning>(as doing: String, execute: () throws -> Returning) throws -> Returning {
        return try type(of: self).executeWhileRephrasingErrors(as: doing, execute: execute)
    }
}
