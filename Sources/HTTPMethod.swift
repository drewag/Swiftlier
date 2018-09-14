//
//  HTTPMethod.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 10/10/17.
//

public enum HTTPMethod: String {
    case any = "ANY"

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case options = "OPTIONS"
    case patch = "PATCH"
}

extension HTTPMethod {
    public func matches(_ other: HTTPMethod) -> Bool {
        switch self {
        case .any:
            return true
        case .get:
            switch other {
            case .get, .any:
                return true
            default:
                return false
            }
        case .post:
            switch other {
            case .post, .any:
                return true
            default:
                return false
            }
        case .put:
            switch other {
            case .put, .any:
                return true
            default:
                return false
            }
        case .delete:
            switch other {
            case .delete, .any:
                return true
            default:
                return false
            }
        case .options:
            switch other {
            case .options, .any:
                return true
            default:
                return false
            }
        case .patch:
            switch other {
            case .patch, .any:
                return true
            default:
                return false
            }
        }
    }
}

