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
        case forbidden
        case noInternet
        case notFound
        case gone
        case untrusted
        case invalid
        case unknown
        case badGateway
    }

    public let kind: Kind
    public let customMessage: String?

    public init(kind: Kind, customMessage: String? = nil) {
        self.customMessage = customMessage
        self.kind = kind
    }

    public var because: String {
        if let customMessage = customMessage, !customMessage.isEmpty {
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
        case .unauthorized, .forbidden:
            return "you are not authorized"
        case .unknown:
            return "there was an unknown error"
        case .untrusted:
            return "the web server can no longer be trusted. Please update to the latest version of this app."
        case .badGateway:
            return "the web server appears to be down"
        }
    }
}

open class NetworkError: ReportableError {
    public let status: HTTPStatus

    enum NetworkCodingKeys: String, CodingKey {
        case status
    }

    public init(from source: ErrorGenerating.Type, by: ErrorPerpitrator, doing: String, because: AnyErrorReason, status: HTTPStatus, backtrace: [String]?) {
        self.status = status
        super.init(from: source, by: by, doing: doing, because: because, backtrace: backtrace)
    }

    public init(from error: ReportableError, status: HTTPStatus, backtrace: [String]?) {
        self.status = status
        super.init(from: error.source, by: error.perpetrator, doing: error.doing, because: error.reason, backtrace: backtrace)
    }

    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: NetworkCodingKeys.self)
        try container.encode(self.status.rawValue, forKey: .status)
    }
}

extension ErrorGenerating {
    public static func error(_ doing: String, from response: URLResponse?, and data: Data?) -> NetworkError? {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }
        return self.error(doing, from: data, status: HTTPStatus(rawValue: response.statusCode))
    }

    public static func error(_ doing: String, from data: Data?, status: HTTPStatus) -> NetworkError? {
        let parsed = self.parseErrorBody(from: data)
        let customMessage = parsed?.because
        let perpitrator = parsed?.perpitrator ?? .system
        switch status.rawValue {
        case 404:
            return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .notFound, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        case 401:
            return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .unauthorized, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        case 403:
            return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .forbidden, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        case 410:
            return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .gone, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        case 502:
            return NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .badGateway, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        case let x where x >= 400 && x < 500:
            return self.error(doing, fromNetworkData: data, status: status, backtrace: Thread.callStackSymbols)
                ?? NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .invalid, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        case let x where x >= 500 && x < 600:
            return self.error(doing, fromNetworkData: data, status: status, backtrace: Thread.callStackSymbols)
                ?? NetworkError(from: self.error(doing, because: NetworkResponseErrorReason(kind: .unknown, customMessage: customMessage), by: perpitrator), status: status, backtrace: Thread.callStackSymbols)
        default:
            return nil
        }
    }

    public func error(_ doing: String, from response: URLResponse?, and data: Data?) -> NetworkError? {
        return type(of: self).error(doing, from: response, and: data)
    }

    public func error(_ doing: String, from data: Data?, status: HTTPStatus) -> NetworkError? {
        return type(of: self).error(doing, from: data, status: status)
    }

    private static func error(_ doing: String, fromNetworkData data: Data?, status: HTTPStatus, backtrace: [String]?) -> NetworkError? {
        guard let parsed = self.parseErrorBody(from: data) else {
            return nil
        }

        let reason = ErrorReasonWithExtraInfo(because: parsed.because, extraInfo: parsed.json)
        let error = ReportableError(from: self, by: parsed.perpitrator, doing: parsed.doing, because: reason, backtrace: backtrace)
        return NetworkError(from: error, status: status, backtrace: backtrace)
    }

    fileprivate static func parseErrorBody(from data: Data?) -> (doing: String, because: String, json: JSON?, perpitrator: ErrorPerpitrator)? {
        guard let data = data else {
            return nil
        }

        let encoding = String.Encoding.utf8
        if let json = try? JSON(data: data)
            , let message = json["because"]?.string
        {
            return (doing: json["doing"]?.string ?? "unknown", because: message, json: json, perpitrator: ErrorPerpitrator(rawValue: json["perpitrator"]?.string ?? "") ?? .system)
        }
        else {
            return (doing: "unknown", because: String(data: data, encoding: encoding) ?? "of an unknown reason", json: nil, perpitrator: .system)
        }
    }
}
