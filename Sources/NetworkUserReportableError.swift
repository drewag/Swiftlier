//
//  NetworkUserReportableError.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct NetworkUserReportableError: UserReportableError {
    public enum Reason {
        case unauthorized
        case noInternet
        case notFound
        case `internal`(message: String)
        case user(message: String)
    }

    let source: String
    public let operation: String
    public let reason: Reason
    public let otherInfo: [String : String]?

    public init(source: String, operation: String, reason: Reason) {
        self.source = source
        self.operation = operation
        self.reason = reason
        self.otherInfo = nil
    }

    public init(source: String, operation: String, error: NSError) {
        self.source = source
        self.operation = operation
        self.otherInfo = nil
        if error.domain == "NSURLErrorDomain" && error.code == -1009 {
            self.reason = .noInternet
        }
        else {
            self.reason = .internal(message: error.localizedDescription)
        }
    }

    #if os(iOS)
    public init?(source: String, operation: String, response: HTTPURLResponse?, data: Data?) {
        self.source = source
        self.operation = operation
        if let response = response {
            switch response.statusCode {
            case 404:
                self.reason = .notFound
                self.otherInfo = nil
            case 401:
                self.reason = .unauthorized
                self.otherInfo = nil
            case let x where x >= 400 && x < 500:
                if let data = data {
                    (self.reason, self.otherInfo) = NetworkUserReportableError.typeAndOtherInfo(fromData: data, andResponse: response)
                }
                else {
                    self.reason = .user(message: "Invalid request")
                    self.otherInfo = nil
                }
            case let x where x >= 500 && x < 600:
                if let data = data {
                    (self.reason, self.otherInfo) = NetworkUserReportableError.typeAndOtherInfo(fromData: data, andResponse: response)
                }
                else {
                    self.reason = .internal(message: "Unknown error")
                    self.otherInfo = nil
                }
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }
    #endif

    public var alertTitle: String {
        switch self.reason {
        case .user:
            return "Problem \(self.operation)"
        case .internal:
            return "Internal Error"
        case .noInternet:
            return "No Interent Connection"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "Endpoint not found"
        }
    }

    public var alertMessage: String {
        switch self.reason {
        case .internal(let message):
            return "Please try again. If the problem persists please contact support with the following description: \(message)"
        case .user(let message):
            return message
        case .noInternet:
            return "Please make sure you are connected to the internet and try again"
        case .unauthorized:
            return "You have been signed out. Please sign in again."
        case .notFound:
            return "Please try again. If the problem persists please contact support"
        }
    }
}

private extension NetworkUserReportableError {
    #if os(iOS)
    static func typeAndOtherInfo(fromData data: Data, andResponse response: HTTPURLResponse) -> (reason: Reason, otherInfo: [String:String]?){
        let encoding: String.Encoding
        if let encodingName = response.textEncodingName {
            encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString!)))
        }
        else {
            encoding = String.Encoding.utf8
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            , let dict = json as? [String:String]
            , let message = dict["message"]
        {
            return (reason: .user(message: message), otherInfo: dict)
        }
        else {
            let string = String(data: data, encoding: encoding)
            return (reason: .user(message: string ?? ""), otherInfo: nil)
        }
    }
    #endif
}
