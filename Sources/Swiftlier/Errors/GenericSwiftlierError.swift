//
//  GenericSwiftlierError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/30/19.
//

import Foundation

/// Basic codable implementation of SwiftlierError
public struct GenericSwiftlierError: SwiftlierError {
    public let title: String
    public let alertMessage: String
    public let details: String?
    public let isInternal: Bool
    public let backtrace: [String]?
    public let extraInfo: [String:String]

    public var description: String {
        return "\(self.title): \(self.alertMessage)"
    }

    public init(title: String, alertMessage: String, details: String?, isInternal: Bool, backtrace: [String]? = Thread.callStackSymbols, extraInfo: [String:String] = [:]) {
        self.title = title
        self.alertMessage = alertMessage
        self.details = details
        self.isInternal = isInternal
        self.backtrace = backtrace
        self.extraInfo = extraInfo
    }

    public init<E: SwiftlierError>(_ error: E) {
        self.title = error.title
        self.alertMessage = error.alertMessage
        self.details = error.details
        self.isInternal = error.isInternal
        self.backtrace = error.backtrace
        self.extraInfo = error.getExtraInfo()
    }

    public init(while operation: String, reason: String, details: String? = nil, backtrace: [String]? = Thread.callStackSymbols, extraInfo: [String:String] = [:]) {
        self.title = "Error \(operation.titleCased)"
        self.alertMessage = "Internal Error. Please try again. If the problem persists please contact support with the following description: \(reason)"
        self.details = details
        self.isInternal = true
        self.backtrace = backtrace
        self.extraInfo = extraInfo
    }

    public init(userErrorWhile operation: String, reason: String, details: String? = nil, backtrace: [String]? = Thread.callStackSymbols, extraInfo: [String:String] = [:]) {
        self.title = "Error \(operation.titleCased)"
        self.alertMessage = reason
        self.details = details
        self.isInternal = false
        self.backtrace = backtrace
        self.extraInfo = extraInfo
    }

    public init(_ doing: String, because: String, byUser: Bool = false) {
        self.title = "Error \(doing.titleCased)"
        if byUser {
            self.isInternal = false
            self.alertMessage = because
        }
        else {
            self.alertMessage = "Internal Error. Please try again. If the problem persists please contact support with the following description: \(because)"
            self.isInternal = true
        }
        self.details = nil
        self.backtrace = Thread.callStackSymbols
        self.extraInfo = [:]
    }

    public func getExtraInfo() -> [String : String] {
        return self.extraInfo
    }
}

extension GenericSwiftlierError: Codable {
    enum CodingKeys: String, CodingKey {
        // Core
        case title, alertMessage, details, isInternal, backtrace, extraInfo

        // ReportableError backwards compatability
        case doing, because, perpitrator
    }

    struct VariableKey: CodingKey {
        let stringValue: String
        let intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let title = try container.decodeIfPresent(String.self, forKey: .title) {
            // Current Swiftlier Error
            self.title = title
            self.alertMessage = try container.decode(String.self, forKey: .alertMessage)
            self.isInternal = try container.decode(Bool.self, forKey: .isInternal)
            self.details = try container.decodeIfPresent(String.self, forKey: .details)
        }
        else {
            // ReportableError backwards capatability
            let perpetrator = try container.decode(String.self, forKey: .perpitrator)
            let doing = try container.decode(String.self, forKey: .doing)
            let reason = try container.decode(String.self, forKey: .because)

            self.title = "Error \(doing.capitalized)"
            if perpetrator == "system" {
                self.alertMessage = "Internal Error. Please try again. If the problem persists please contact support with the following description: \(reason)"
                self.isInternal = true
            }
            else {
                self.alertMessage = reason
                self.isInternal = false
            }
            self.details = nil
        }

        self.backtrace = try container.decodeIfPresent([String].self, forKey: .backtrace)
        self.extraInfo = try container.decodeIfPresent([String:String].self, forKey: .extraInfo) ?? [:]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.title, forKey: .title)
        try container.encode(self.alertMessage, forKey: .alertMessage)
        try container.encode(self.details, forKey: .details)
        try container.encode(self.isInternal, forKey: .isInternal)
        try container.encode(self.backtrace, forKey: .backtrace)
        try container.encode(self.extraInfo, forKey: .extraInfo)

        // Backwards compatability
        try container.encode("Making Request", forKey: .doing)
        try container.encode(self.alertMessage, forKey: .because)
        try container.encode(self.isInternal ? "system" : "user", forKey: .perpitrator)
        var variableContainer = encoder.container(keyedBy: VariableKey.self)
        for (key, value) in self.extraInfo {
            guard let key = VariableKey(stringValue: key) else {
                continue
            }
            try variableContainer.encode(value, forKey: key)
        }
    }
}
