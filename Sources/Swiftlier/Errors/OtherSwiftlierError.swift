//
//  OtherSwiftlierError.swift
//  Decree
//
//  Created by Andrew J Wagner on 7/30/19.
//

import Foundation

public struct OtherSwiftlierError: SwiftlierError {
    public let underlyingError: Error
    let operation: String
    public let backtrace: [String]?

    public init(_ error: Error, while operation: String, backtrace: [String]? = Thread.callStackSymbols) {
        self.underlyingError = error
        self.operation = operation
        self.backtrace = backtrace
    }

    public var title: String {
        return "Error \(self.operation)"
    }

    public var reason: String {
        return ""
    }

    public let isInternal: Bool = true

    public var alertMessage: String {
        switch self.underlyingError {
        case let error as DecodingError:
            return "Decoding error '\(error.localizedDescription)'"
        case let error as EncodingError:
            return "Encoding error '\(error.localizedDescription)'"
        default:
            return "\(self.underlyingError)"
        }
    }

    public var details: String? {
        switch self.underlyingError {
        case let error as DecodingError:
            return self.details(for: error)
        case let error as EncodingError:
            return self.details(for: error)
        default:
            let nsError = self.underlyingError as NSError
            var output = "\(nsError.domain) \(nsError.code)"

            if let reason = nsError.localizedFailureReason {
                output += "\nFailure Reason: \(reason)"
            }

            if let suggestion = nsError.localizedRecoverySuggestion {
                output += "\nRecovery Suggestion: \(suggestion)"
            }

            if !nsError.userInfo.isEmpty {
                output += "\nUser Info:"
                for (key, value) in nsError.userInfo {
                    output += "\n    \(key): \(value)"
                }
            }

            return output
        }
    }

    public var description: String {
        return "Error \(self.operation): \(self.alertMessage)"
    }
}

extension Error {
    public func swiftlierError(while operation: String) -> AnySwiftlierError {
        switch self {
        case let error as AnySwiftlierError:
            return error
        case let error as SwiftlierError:
            return AnySwiftlierError(error)
        default:
            let error = OtherSwiftlierError(self, while: operation)
            return AnySwiftlierError(error)
        }
    }
}

private extension OtherSwiftlierError {
    func details(for encodingError: EncodingError) -> String {
        var details = ""

        switch encodingError {
        case .invalidValue(let value, let context):
            details += "Invalid Value: \(value)"
            details += "\nKey Path: " + context.codingPath.map({$0.stringValue}).joined(separator: ".")
            details += "\nDebug Description: \(context.debugDescription)"
            if let error = context.underlyingError {
                details += "\nUnderyling Error: \(error)"
            }
        @unknown default:
            details += "Unrecognized Encoding Error"
            details += "Description: \(encodingError.localizedDescription)"
        }

        details += "\n\nDebugging: To see raw requests and responses, turn on logging with `Logger.shared.level = .info(filter: nil)`."
        return details
    }

    func details(for decodingError: DecodingError) -> String {
        var details = ""

        func add(_ context: DecodingError.Context) {
            details += "\nKey Path: " + context.codingPath.map({$0.stringValue}).joined(separator: ".")
            details += "\nDebug Description: \(context.debugDescription)"
            if let error = context.underlyingError {
                details += "\nUnderyling Error: \(error)"
            }
        }

        switch decodingError {
        case .dataCorrupted(let context):
            details += "Data Corrupted"
            add(context)
        case .keyNotFound(let key, let context):
            details += "Key not found for \(key.stringValue)"
            add(context)
        case .typeMismatch(let type, let context):
            details += "Type mismatch for \(type)"
            add(context)
        case .valueNotFound(let type, let context):
            details += "Value not found for \(type)"
            add(context)
        @unknown default:
            details += "Unrecognized Decoding Error"
            details += "Description: \(decodingError.localizedDescription)"
        }

        details += "\n\nDebugging: To see raw requests and responses, turn on logging with `Logger.shared.level = .info(filter: nil)`."
        return details
    }
}
