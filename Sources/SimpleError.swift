//
//  SimpleError.swift
//  SwiftServe
//
//  Created by Andrew J Wagner on 6/20/19.
//

import Foundation

public struct SimpleError: Error, CustomStringConvertible {
    public let message: String
    public let moreInformation: String?

    public var description: String {
        return self.message
    }

    public init(message: String, moreInformation: String? = nil) {
        self.message = message
        self.moreInformation = moreInformation
    }
}

extension SimpleError: ReportableErrorConvertible, ErrorGenerating {
    public var reportableError: ReportableError {
        return self.error("performing SQL", because: self.description)
    }
}

extension SimpleError: LocalizedError {
    public var errorDescription: String? {
        return self.description
    }
}
