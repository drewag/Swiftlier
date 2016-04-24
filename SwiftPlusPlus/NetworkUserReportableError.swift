//
//  NetworkUserReportableError.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct NetworkUserReportableError: UserReportableError {
    public enum Type {
        case Unauthorized
        case NoInternet
        case Internal(message: String)
        case User(message: String)
    }

    let source: String
    public let operation: String
    public let type: Type

    public init(source: String, operation: String, type: Type) {
        self.source = source
        self.operation = operation
        self.type = type
    }

    public init(source: String, operation: String, error: NSError) {
        self.source = source
        self.operation = operation
        if error.domain == "NSURLErrorDomain" && error.code == -1009 {
            self.type = .NoInternet
        }
        else {
            self.type = .Internal(message: error.localizedDescription)
        }
    }

    public init?(source: String, operation: String, response: NSHTTPURLResponse?, data: NSData?) {
        self.source = source
        self.operation = operation
        if let response = response {
            switch response.statusCode ?? 0 {
            case 404:
                self.type = .Internal(message: "Endpoint not found")
            case 401:
                self.type = .Unauthorized
            case let x where x >= 400 && x < 500:
                if let data = data {
                    let encoding: NSStringEncoding
                    if let encodingName = response.textEncodingName {
                        encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName))
                    }
                    else {
                        encoding = NSUTF8StringEncoding
                    }
                    let string = String(data: data, encoding: encoding)
                    self.type = .User(message: string ?? "")
                }
                else {
                    self.type = .User(message: "Invalid request")
                }
            case let x where x >= 500 && x < 600:
                if let data = data {
                    self.type = .Internal(message: String(data: data as NSData, usingEncoding: response.textEncodingName))
                }
                else {
                    self.type = .Internal(message: "Unknown error")
                }
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }

    public var alertTitle: String {
        switch self.type {
        case .User:
            return "Problem \(self.operation)"
        case .Internal:
            return "Internal Error"
        case .NoInternet:
            return "No Interent Connection"
        case .Unauthorized:
            return "Unauthorized"
        }
    }

    public var alertMessage: String {
        switch self.type {
        case .Internal(let message):
            return "Please try again. If the problem persists please contact support with the following description: \(message)"
        case .User(let message):
            return message
        case .NoInternet:
            return "Please make sure you are connected to the internet and try again"
        case .Unauthorized:
            return "You have been signed out. Please sign in again."
        }
    }
}