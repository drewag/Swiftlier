//
//  LocalUserReportableError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension ErrorGenerating {
    public static func error(_ doing: String, because: String) -> ReportableError {
        let reason = ErrorReason(because)
        return self.error(doing, because: reason)
    }

    public static func error(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return ConcreteReportableError(from: self, by: .system, doing: doing, because: reason)
    }

    public static func error(_ doing: String, from: Error) -> ReportableError {
        switch from {
        case let reportable as ReportableError:
            return reportable
        case let nsError as NSError where nsError.domain == "NSURLErrorDomain":
            switch nsError.code {
            case -1009:
                return self.error(doing, because: NetworkResponseErrorReason(kind: .noInternet, customMessage: nil))
            case -999:
                return self.error(doing, because: NetworkResponseErrorReason(kind: .untrusted, customMessage: nil))
            default:
                break
            }
        default:
            break
        }

        return self.error(doing, because: from.localizedDescription)
    }

    public static func userError(_ doing: String, because: String) -> ReportableError {
        let reason = ErrorReason(because)
        return self.userError(doing, because: reason)
    }

    public static func userError(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return ConcreteReportableError(from: self, by: .user, doing: doing, because: reason)
    }

    public func error(_ doing: String, because: String) -> ReportableError {
        return Self.error(doing, because: because)
    }

    public func error(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return Self.error(doing, because: reason)
    }

    public func error(_ doing: String, from: Error) -> ReportableError {
        return Self.error(doing, from: from)
    }

    public func userError(_ doing: String, because: String) -> ReportableError {
        return Self.userError(doing, because: because)
    }

    public func userError(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return Self.userError(doing, because: reason)
    }
}
