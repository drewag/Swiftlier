//
//  AnySwiftlierError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/30/19.
//

import Foundation

/// A type-erased error which wraps an arbitrary error instance. This should be
/// useful for generic contexts.
public struct AnySwiftlierError: SwiftlierError {
    /// Underlying error
    public let error: SwiftlierError

    public var title: String {
        return self.error.title
    }

    public var alertMessage: String {
        return self.error.alertMessage
    }

    public var details: String? {
        return self.error.details
    }

    public var isInternal: Bool {
        return self.error.isInternal
    }

    public var description: String {
        return self.error.description
    }

    public var backtrace: [String]? {
        return self.error.backtrace
    }

    public init(_ error: SwiftlierError) {
        self.error = error
    }
}

public typealias SwiftlierResult<Success> = Result<Success, AnySwiftlierError>
