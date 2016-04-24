//
//  LocalUserReportableError.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct LocalUserReportableError: UserReportableError {
    public enum Type {
        case Internal
        case User
    }

    let source: String
    let operation: String
    let message: String
    let type: Type

    public init(source: String, operation: String, message: String, type: Type) {
        self.source = source
        self.operation = operation
        self.message = message
        self.type = type
    }

    public var alertTitle: String {
        switch self.type {
        case .User:
            return "Problem \(self.operation)"
        case .Internal:
            return "Internal Error"
        }
    }

    public var alertMessage: String {
        switch self.type {
        case .Internal:
            return "Please try again. If the problem persists please contact support with the following description: \(self.message)"
        case .User:
            return message
        }
    }
}