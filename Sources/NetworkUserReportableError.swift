//
//  NetworkUserReportableError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct NetworkResponseErrorReason {
    public static let unauthorized = ErrorReason("you are not authorized")
    public static let noInternet = ErrorReason("you are not connected to the internet")
    public static let notFound = ErrorReason("the requested endpoint could not be found")
    public static let gone = ErrorReason("this app is out of date. Please update to the latest version.")
    public static let untrusted = ErrorReason("the web server can no longer be trusted. Please update to the latest version of this app.")
    public static let invalid = ErrorReason("the request was invalid")
    public static let unknown = ErrorReason("there was an unknown error")
}

public struct NetworkError: ReportableError {
    public let perpetrator: ErrorPerpitrator
    public let doing: String
    public let reason: AnyErrorReason
    public let source: ErrorGenerating.Type
    public let status: HTTPStatus

    struct Keys {
        class status: CoderKey<Int> {}
    }

    public init(from source: ErrorGenerating.Type, by: ErrorPerpitrator, doing: String, because: AnyErrorReason, status: HTTPStatus) {
        self.source = source
        self.perpetrator = by
        self.doing = doing
        self.reason = because
        self.status = status
    }

    public init(from error: ReportableError, status: HTTPStatus) {
        self.source = error.source
        self.perpetrator = error.perpetrator
        self.doing = error.doing
        self.reason = error.reason
        self.status = status
    }

    public func encode(_ encoder: Encoder) {
        self.encodeStandard(encoder)
        encoder.encode(self.status.rawValue, forKey: Keys.status.self)
    }
}

extension ErrorGenerating {
    public static func error(_ doing: String, from response: URLResponse?, and data: Data?) -> NetworkError? {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 404:
                return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason.notFound), status: HTTPStatus(from: response))
            case 401:
                return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason.unauthorized), status: HTTPStatus(from: response))
            case 410:
                return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason.gone), status: HTTPStatus(from: response))
            case let x where x >= 400 && x < 500:
                return self.error(doing, fromNetworkData: data, for: response)
                    ?? NetworkError(from: self.error(doing, because: NetworkResponseErrorReason.invalid), status: HTTPStatus(from: response))
            case let x where x >= 500 && x < 600:
                return self.error(doing, fromNetworkData: data, for: response)
                    ?? NetworkError(from: self.error(doing, because: NetworkResponseErrorReason.unknown), status: HTTPStatus(from: response))
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }

    public func error(_ doing: String, from response: URLResponse?, and data: Data?) -> NetworkError? {
        return type(of: self).error(doing, from: response, and: data)
    }

    private static func error(_ doing: String, fromNetworkData data: Data?, for response: HTTPURLResponse) -> NetworkError? {
        guard let data = data else {
            return nil
        }

        let encoding = String.Encoding.utf8
        if let json = try? JSON(data: data)
            , let message = json["because"]?.string
        {
            let reason = ErrorReasonWithExtraInfo(because: message, extraInfo: json)
            if json["perpitrator"]?.string == "user" {
                return NetworkError(from: self.userError(json["doing"]?.string ?? doing, because: reason), status: HTTPStatus(from: response))
            }
            else {
                return NetworkError(from: self.error(json["doing"]?.string ?? doing, because: reason), status: HTTPStatus(from: response))
            }
        }
        else {
            let string = String(data: data, encoding: encoding) ?? ""
            return NetworkError(from: self.error(doing, because: ErrorReason(string)), status: HTTPStatus(from: response))
        }
    }
}
