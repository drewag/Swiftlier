//
//  HTTPStatus.swift
//  SwiftPlusPlusiOS
//
//  Created by Andrew J Wagner on 4/22/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public enum HTTPStatus: RawRepresentable {
    // Successful
    case ok
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent

    // Redirection
    case multipleChoices
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case temporaryRedirect

    // Client Error
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case requestEntityTooLarge
    case requestURITooLong
    case unsupportedMediaType
    case requestedRangeNotSatisfiable
    case expectationFailed

    // Server Error
    case internalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported

    case other(Int)

    public init(from response: HTTPURLResponse) {
        self = HTTPStatus(rawValue: response.statusCode)
            ?? .other(response.statusCode)
    }

    public init?(rawValue: Int) {
        switch rawValue {
        case 200:
            self = .ok
        case 201:
            self = .created
        case 202:
            self = .accepted
        case 203:
            self = .nonAuthoritativeInformation
        case 204:
            self = .noContent
        case 205:
            self = .resetContent
        case 206:
            self = .partialContent

        case 300:
            self = .multipleChoices
        case 301:
            self = .movedPermanently
        case 302:
            self = .found
        case 303:
            self = .seeOther
        case 304:
            self = .notModified
        case 305:
            self = .useProxy
        case 307:
            self = .temporaryRedirect

        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 402:
            self = .paymentRequired
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 405:
            self = .methodNotAllowed
        case 406:
            self = .notAcceptable
        case 407:
            self = .proxyAuthenticationRequired
        case 408:
            self = .requestTimeout
        case 409:
            self = .conflict
        case 410:
            self = .gone
        case 411:
            self = .lengthRequired
        case 412:
            self = .preconditionFailed
        case 413:
            self = .requestEntityTooLarge
        case 414:
            self = .requestURITooLong
        case 415:
            self = .unsupportedMediaType
        case 416:
            self = .requestedRangeNotSatisfiable
        case 417:
            self = .expectationFailed

        case 500:
            self = .internalServerError
        case 500:
            self = .notImplemented
        case 500:
            self = .badGateway
        case 500:
            self = .serviceUnavailable
        case 500:
            self = .gatewayTimeout
        case 500:
            self = .httpVersionNotSupported
        default:
            self = .other(rawValue)
        }
    }

    public var rawValue: Int {
        switch self {
        case .ok:
            return 200
        case .created:
            return 201
        case .accepted:
            return 202
        case .nonAuthoritativeInformation:
            return 203
        case .noContent:
            return 204
        case .resetContent:
            return 205
        case .partialContent:
            return 206

        case .multipleChoices:
            return 300
        case .movedPermanently:
            return 301
        case .found:
            return 302
        case .seeOther:
            return 303
        case .notModified:
            return 304
        case .useProxy:
            return 305
        case .temporaryRedirect:
            return 307

        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .paymentRequired:
            return 402
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .methodNotAllowed:
            return 405
        case .notAcceptable:
            return 406
        case .proxyAuthenticationRequired:
            return 407
        case .requestTimeout:
            return 408
        case .conflict:
            return 409
        case .gone:
            return 410
        case .lengthRequired:
            return 411
        case .preconditionFailed:
            return 412
        case .requestEntityTooLarge:
            return 413
        case .requestURITooLong:
            return 414
        case .unsupportedMediaType:
            return 415
        case .requestedRangeNotSatisfiable:
            return 416
        case .expectationFailed:
            return 417

        case .internalServerError:
            return 500
        case .notImplemented:
            return 501
        case .badGateway:
            return 502
        case .serviceUnavailable:
            return 503
        case .gatewayTimeout:
            return 504
        case .httpVersionNotSupported:
            return 505

        case .other(let other):
            return other
        }
    }
}

extension HTTPStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ok:
            return "OK"
        case .created:
            return "CREATED"
        case .accepted:
            return "ACCEPTED"
        case .nonAuthoritativeInformation:
            return "NON-AUTHORITATIVE INFORMATION"
        case .noContent:
            return "NO CONTENT"
        case .resetContent:
            return "RESET CONTENT"
        case .partialContent:
            return "PARTIAL CONTENT"

        case .multipleChoices:
            return "MULTIPLE CHOICES"
        case .movedPermanently:
            return "MOVED PERMANENTLY"
        case .found:
            return "FOUND"
        case .seeOther:
            return "SEE OTHER"
        case .notModified:
            return "NOT MODIFIED"
        case .useProxy:
            return "USE PROXY"
        case .temporaryRedirect:
            return "TEMPORARY REDIRECT"

        case .badRequest:
            return "BAD REQUEST"
        case .unauthorized:
            return "UNAUTHORIZED"
        case .paymentRequired:
            return "PAYMENT REQUIRED"
        case .forbidden:
            return "FORBIDDEN"
        case .notFound:
            return "NOT FOUND"
        case .methodNotAllowed:
            return "METHOD NOT ALLOWED"
        case .notAcceptable:
            return "NOT ACCEPTABLE"
        case .proxyAuthenticationRequired:
            return "PROXY AUTHENTICATION REQUIRED"
        case .requestTimeout:
            return "REQUEST TIMEOUT"
        case .conflict:
            return "CONFLICT"
        case .gone:
            return "GONE"
        case .lengthRequired:
            return "LENGTH REQUIRED"
        case .preconditionFailed:
            return "PRECONDITION FAILED"
        case .requestEntityTooLarge:
            return "REQUEST ENTITY TOO LARGE"
        case .requestURITooLong:
            return "REQUEST URI TOO LONG"
        case .unsupportedMediaType:
            return "UNSUPPORTED MEDIA TYPE"
        case .requestedRangeNotSatisfiable:
            return "REQUESTED RANGE NOT SATISFIABLE"
        case .expectationFailed:
            return "EXPECTATION FAILED"

        case .internalServerError:
            return "INTERNAL ERROR"
        case .notImplemented:
            return "NOT IMPLEMENTED"
        case .badGateway:
            return "BAD GATEWAY"
        case .serviceUnavailable:
            return "SERVICE UNAVAILABLE"
        case .gatewayTimeout:
            return "GATEWAY TIMEOUT"
        case .httpVersionNotSupported:
            return "HTTP VERSION NOT SUPPORTED"

        case .other(let other):
            return "OTHER(\(other))"
        }
    }
}
