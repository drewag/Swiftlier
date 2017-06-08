//
//  NetworkUserReportableError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public class NetworkResponseErrorReason: AnyErrorReason {
    public enum Kind {
        case unauthorized
        case noInternet
        case notFound
        case gone
        case untrusted
        case invalid
        case unknown
    }

    public let kind: Kind
    let customMessage: String?

    public init(kind: Kind, customMessage: String? = nil) {
        self.customMessage = customMessage
        self.kind = kind
    }

    public var because: String {
        if let customMessage = customMessage {
            return customMessage
        }

        switch self.kind {
        case .gone:
            return "this app is out of date. Please update to the latest version."
        case .invalid:
            return "the request was invalid"
        case .noInternet:
            return "you are not connected to the internet"
        case .notFound:
            return "the requested endpoint could not be found"
        case .unauthorized:
            return "you are not authorized"
        case .unknown:
            return "there was an unknown error"
        case .untrusted:
            return "the web server can no longer be trusted. Please update to the latest version of this app."
        }
    }
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
            let parsed = self.parseErrorBody(from: data)
            let customMessage = parsed?.because
            switch response.statusCode {
            case 404:
                return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .notFound, customMessage: customMessage)), status: HTTPStatus(from: response))
            case 401:
                return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .unauthorized, customMessage: customMessage)), status: HTTPStatus(from: response))
            case 410:
                return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .gone, customMessage: customMessage)), status: HTTPStatus(from: response))
            case let x where x >= 400 && x < 500:
                return self.error(doing, fromNetworkData: data, for: response)
                    ?? NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .invalid, customMessage: customMessage)), status: HTTPStatus(from: response))
            case let x where x >= 500 && x < 600:
                return self.error(doing, fromNetworkData: data, for: response)
                    ?? NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .unknown, customMessage: customMessage)), status: HTTPStatus(from: response))
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
        guard let parsed = self.parseErrorBody(from: data) else {
            return nil
        }

        let reason = ErrorReasonWithExtraInfo(because: parsed.because, extraInfo: parsed.json)
        let error = ConcreteReportableError(from: self, by: parsed.perpitrator, doing: parsed.doing, because: reason)
        return NetworkError(from: error, status: HTTPStatus(from: response))
    }

    fileprivate static func parseErrorBody(from data: Data?) -> (doing: String, because: String, json: JSON?, perpitrator: ErrorPerpitrator)? {
        guard let data = data else {
            return nil
        }

        let encoding = String.Encoding.utf8
        if let json = try? JSON(data: data)
            , let message = json["because"]?.string
        {
            return (doing: json["doing"]?.string ?? "unknown", because: message, json: json, perpitrator: ErrorPerpitrator(rawValue: json["perpitrator"]?.string ?? "") ?? .system)        }
        else {
            return (doing: "unknown", because: String(data: data, encoding: encoding) ?? "of an unknown reason", json: nil, perpitrator: .system)
        }
    }
}
