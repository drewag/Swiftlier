//
//  SwiftlierError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/30/19.
//

import Foundation

public protocol SwiftlierError: LocalizedError, CustomStringConvertible, CustomDebugStringConvertible {
    /// Short name for the error (good for alert tiels)
    var title: String {get}

    /// Message to be displayed in an alert
    var alertMessage: String {get}

    /// Detailed description of the reason for the error
    var details: String? {get}

    /// False if this error was caused by the end user
    ///
    /// If true, the message will include a request to report the bug if
    /// it continues to occur.
    var isInternal: Bool {get}

    /// Backtrace for where this error occured
    var backtrace: [String]? {get}

    /// Provide any extra information about the error
    func getExtraInfo() -> [String:String]
}

extension SwiftlierError {
    public var errorDescription: String? {
        return self.description
    }

    public var debugDescription: String {
        let basic = self.description

        guard let details = self.details else {
            return basic
        }

        return "\(basic)\n\(details)"
    }

    public func getExtraInfo() -> [String:String] {
        return [:]
    }
}
