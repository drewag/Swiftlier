//
//  LocalUserReportableError.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct LocalUserReportableError: UserReportableError {
    public enum Reason {
        case `internal`
        case user
    }

    let source: String
    let operation: String
    let message: String
    let reason: Reason
    public let otherInfo: [String : String]? = nil

    public init(source: String, operation: String, message: String, reason: Reason) {
        self.source = source
        self.operation = operation
        self.message = message
        self.reason = reason
    }

    public init(source: String, operation: String, error: Error, reason: Reason = .internal) {
        if let error = error as? LocalUserReportableError {
            self.source = error.source
            self.operation = error.operation
            self.message = error.message
            self.reason = error.reason
        }
        else {
            self.source = source
            self.operation = operation
            self.message = "\(error)"
            self.reason = reason
        }
    }

    public var alertTitle: String {
        switch self.reason {
        case .user:
            return "Problem \(self.operation)"
        case .internal:
            return "Internal Error"
        }
    }

    public var alertMessage: String {
        switch self.reason {
        case .internal:
            return "Please try again. If the problem persists please contact support with the following description: \(self.message)"
        case .user:
            return message
        }
    }
}
