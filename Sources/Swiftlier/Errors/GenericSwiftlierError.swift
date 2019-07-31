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

    public var description: String {
        return "\(self.title): \(self.alertMessage)"
    }

    public init(title: String, alertMessage: String, details: String?, isInternal: Bool, backtrace: [String]? = Thread.callStackSymbols) {
        self.title = title
        self.alertMessage = alertMessage
        self.details = details
        self.isInternal = isInternal
        self.backtrace = backtrace
    }

    public init<E: SwiftlierError>(_ error: E, backtrace: [String]? = Thread.callStackSymbols) {
        self.title = error.title
        self.alertMessage = error.alertMessage
        self.details = error.details
        self.isInternal = error.isInternal
        self.backtrace = backtrace
    }

    public init(while operation: String, reason: String, details: String? = nil, backtrace: [String]? = Thread.callStackSymbols) {
        self.title = "Error \(operation.titleCased)"
        self.alertMessage = "Internal Error. Please try again. If the problem persists please contact support with the following description: \(reason)"
        self.details = details
        self.isInternal = true
        self.backtrace = backtrace
    }

    public init(userErrorWhile operation: String, reason: String, details: String? = nil, backtrace: [String]? = Thread.callStackSymbols) {
        self.title = "Error \(operation.titleCased)"
        self.alertMessage = reason
        self.details = details
        self.isInternal = false
        self.backtrace = backtrace
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
    }
}

extension GenericSwiftlierError {
    enum CodingKeys: String, CodingKey {
        // Core
        case title, alertMessage, details, isInternal, backtrace

        // ReportableError backwards compatability
        case doing, because, perpitrator
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
    }
}
