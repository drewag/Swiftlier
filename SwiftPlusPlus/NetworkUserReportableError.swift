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
        case NotFound
        case Gone
        case Internal(message: String)
        case User(message: String)
    }

    let source: String
    public let operation: String
    public let type: Type
    public let otherInfo: [String : String]?

    public init(source: String, operation: String, type: Type) {
        self.source = source
        self.operation = operation
        self.type = type
        self.otherInfo = nil
    }

    public init(source: String, operation: String, error: NSError) {
        self.source = source
        self.operation = operation
        self.otherInfo = nil
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
                self.type = .NotFound
                self.otherInfo = nil
            case 401:
                self.type = .Unauthorized
                self.otherInfo = nil
            case 410:
                self.type = .Gone
                self.otherInfo = nil
            case let x where x >= 400 && x < 500:
                if let data = data {
                    (self.type, self.otherInfo) = NetworkUserReportableError.typeAndOtherInfo(fromData: data, andResponse: response)
                }
                else {
                    self.type = .User(message: "Invalid request")
                    self.otherInfo = nil
                }
            case let x where x >= 500 && x < 600:
                if let data = data {
                    (self.type, self.otherInfo) = NetworkUserReportableError.typeAndOtherInfo(fromData: data, andResponse: response)
                }
                else {
                    self.type = .Internal(message: "Unknown error")
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
        case .NotFound:
            return "Endpoint not found"
        case .Gone:
            return "App Out of Date"
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
        case .NotFound:
            return "Please try again. If the problem persists please contact support"
        case .Gone:
            return "This app is out of date. Please update to the latest version."
        }
    }
}

private extension NetworkUserReportableError {
    static func typeAndOtherInfo(fromData data: NSData, andResponse response: NSHTTPURLResponse) -> (type: Type, otherInfo: [String:String]?){
        let encoding: NSStringEncoding
        if let encodingName = response.textEncodingName {
            encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName))
        }
        else {
            encoding = NSUTF8StringEncoding
        }
        if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            , let dict = json as? [String:String]
            , let message = dict["message"]
        {
            return (type: .User(message: message ?? ""), otherInfo: dict)
        }
        else {
            let string = String(data: data, encoding: encoding)
            return (type: .User(message: string ?? ""), otherInfo: nil)
        }
    }
}
