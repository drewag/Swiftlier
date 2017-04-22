//
//  NetworkUserReportableError.swift
//  SwiftPlusPlus
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

extension ErrorGenerating {
    public static func error(_ doing: String, from response: URLResponse?, and data: Data?) -> ReportableError? {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 404:
                return self.error(doing, because: NetworkResponseErrorReason.notFound)
            case 401:
                return self.error(doing, because: NetworkResponseErrorReason.unauthorized)
            case 410:
                return self.error(doing, because: NetworkResponseErrorReason.gone)
            case let x where x >= 400 && x < 500:
                return self.error(doing, fromNetworkData: data, for: response)
                    ?? self.error(doing, because: NetworkResponseErrorReason.invalid)
            case let x where x >= 500 && x < 600:
                return self.error(doing, fromNetworkData: data, for: response)
                    ?? self.error(doing, because: NetworkResponseErrorReason.unknown)
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }

    public func error(_ doing: String, from response: URLResponse?, and data: Data?) -> ReportableError? {
        return type(of: self).error(doing, from: response, and: data)
    }

    private static func error(_ doing: String, fromNetworkData data: Data?, for response: HTTPURLResponse) -> ReportableError? {
        guard let data = data else {
            return nil
        }

        let encoding = String.Encoding.utf8
        if let json = try? JSON(data: data)
            , let message = json["because"]?.string
        {
            let reason = ErrorReasonWithExtraInfo(because: message, extraInfo: json)
            if json["perpitrator"]?.string == "user" {
                return self.userError(doing, because: reason)
            }
            else {
                return self.error(doing, because: reason)
            }
        }
        else {
            let string = String(data: data, encoding: encoding) ?? ""
            return self.error(doing, because: ErrorReason(string))
        }
    }
}
