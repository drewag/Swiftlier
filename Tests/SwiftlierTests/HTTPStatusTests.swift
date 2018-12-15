//
//  HTTPStatusTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 9/26/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class HTTPStatusTests: XCTestCase {
    func testInitFromRawValues() {
        XCTAssertEqual(HTTPStatus(rawValue: 200), .ok)
        XCTAssertEqual(HTTPStatus(rawValue: 201), .created)
        XCTAssertEqual(HTTPStatus(rawValue: 202), .accepted)
        XCTAssertEqual(HTTPStatus(rawValue: 203), .nonAuthoritativeInformation)
        XCTAssertEqual(HTTPStatus(rawValue: 204), .noContent)
        XCTAssertEqual(HTTPStatus(rawValue: 205), .resetContent)
        XCTAssertEqual(HTTPStatus(rawValue: 206), .partialContent)

        XCTAssertEqual(HTTPStatus(rawValue: 300), .multipleChoices)
        XCTAssertEqual(HTTPStatus(rawValue: 301), .movedPermanently)
        XCTAssertEqual(HTTPStatus(rawValue: 302), .found)
        XCTAssertEqual(HTTPStatus(rawValue: 303), .seeOther)
        XCTAssertEqual(HTTPStatus(rawValue: 304), .notModified)
        XCTAssertEqual(HTTPStatus(rawValue: 305), .useProxy)
        XCTAssertEqual(HTTPStatus(rawValue: 307), .temporaryRedirect)

        XCTAssertEqual(HTTPStatus(rawValue: 400), .badRequest)
        XCTAssertEqual(HTTPStatus(rawValue: 401), .unauthorized)
        XCTAssertEqual(HTTPStatus(rawValue: 402), .paymentRequired)
        XCTAssertEqual(HTTPStatus(rawValue: 403), .forbidden)
        XCTAssertEqual(HTTPStatus(rawValue: 404), .notFound)
        XCTAssertEqual(HTTPStatus(rawValue: 405), .methodNotAllowed)
        XCTAssertEqual(HTTPStatus(rawValue: 406), .notAcceptable)
        XCTAssertEqual(HTTPStatus(rawValue: 407), .proxyAuthenticationRequired)
        XCTAssertEqual(HTTPStatus(rawValue: 408), .requestTimeout)
        XCTAssertEqual(HTTPStatus(rawValue: 409), .conflict)
        XCTAssertEqual(HTTPStatus(rawValue: 410), .gone)
        XCTAssertEqual(HTTPStatus(rawValue: 411), .lengthRequired)
        XCTAssertEqual(HTTPStatus(rawValue: 412), .preconditionFailed)
        XCTAssertEqual(HTTPStatus(rawValue: 413), .requestEntityTooLarge)
        XCTAssertEqual(HTTPStatus(rawValue: 414), .requestURITooLong)
        XCTAssertEqual(HTTPStatus(rawValue: 415), .unsupportedMediaType)
        XCTAssertEqual(HTTPStatus(rawValue: 416), .requestedRangeNotSatisfiable)
        XCTAssertEqual(HTTPStatus(rawValue: 417), .expectationFailed)

        XCTAssertEqual(HTTPStatus(rawValue: 500), .internalServerError)
        XCTAssertEqual(HTTPStatus(rawValue: 501), .notImplemented)
        XCTAssertEqual(HTTPStatus(rawValue: 502), .badGateway)
        XCTAssertEqual(HTTPStatus(rawValue: 503), .serviceUnavailable)
        XCTAssertEqual(HTTPStatus(rawValue: 504), .gatewayTimeout)
        XCTAssertEqual(HTTPStatus(rawValue: 505), .httpVersionNotSupported)
    }

    func testRawValues() {
        XCTAssertEqual(HTTPStatus.ok.rawValue, 200)
        XCTAssertEqual(HTTPStatus.created.rawValue, 201)
        XCTAssertEqual(HTTPStatus.accepted.rawValue, 202)
        XCTAssertEqual(HTTPStatus.nonAuthoritativeInformation.rawValue, 203)
        XCTAssertEqual(HTTPStatus.noContent.rawValue, 204)
        XCTAssertEqual(HTTPStatus.resetContent.rawValue, 205)
        XCTAssertEqual(HTTPStatus.partialContent.rawValue, 206)

        XCTAssertEqual(HTTPStatus.multipleChoices.rawValue, 300)
        XCTAssertEqual(HTTPStatus.movedPermanently.rawValue, 301)
        XCTAssertEqual(HTTPStatus.found.rawValue, 302)
        XCTAssertEqual(HTTPStatus.seeOther.rawValue, 303)
        XCTAssertEqual(HTTPStatus.notModified.rawValue, 304)
        XCTAssertEqual(HTTPStatus.useProxy.rawValue, 305)
        XCTAssertEqual(HTTPStatus.temporaryRedirect.rawValue, 307)

        XCTAssertEqual(HTTPStatus.badRequest.rawValue, 400)
        XCTAssertEqual(HTTPStatus.unauthorized.rawValue, 401)
        XCTAssertEqual(HTTPStatus.paymentRequired.rawValue, 402)
        XCTAssertEqual(HTTPStatus.forbidden.rawValue, 403)
        XCTAssertEqual(HTTPStatus.notFound.rawValue, 404)
        XCTAssertEqual(HTTPStatus.methodNotAllowed.rawValue, 405)
        XCTAssertEqual(HTTPStatus.notAcceptable.rawValue, 406)
        XCTAssertEqual(HTTPStatus.proxyAuthenticationRequired.rawValue, 407)
        XCTAssertEqual(HTTPStatus.requestTimeout.rawValue, 408)
        XCTAssertEqual(HTTPStatus.conflict.rawValue, 409)
        XCTAssertEqual(HTTPStatus.gone.rawValue, 410)
        XCTAssertEqual(HTTPStatus.lengthRequired.rawValue, 411)
        XCTAssertEqual(HTTPStatus.preconditionFailed.rawValue, 412)
        XCTAssertEqual(HTTPStatus.requestEntityTooLarge.rawValue, 413)
        XCTAssertEqual(HTTPStatus.requestURITooLong.rawValue, 414)
        XCTAssertEqual(HTTPStatus.unsupportedMediaType.rawValue, 415)
        XCTAssertEqual(HTTPStatus.requestedRangeNotSatisfiable.rawValue, 416)
        XCTAssertEqual(HTTPStatus.expectationFailed.rawValue, 417)

        XCTAssertEqual(HTTPStatus.internalServerError.rawValue, 500)
        XCTAssertEqual(HTTPStatus.notImplemented.rawValue, 501)
        XCTAssertEqual(HTTPStatus.badGateway.rawValue, 502)
        XCTAssertEqual(HTTPStatus.serviceUnavailable.rawValue, 503)
        XCTAssertEqual(HTTPStatus.gatewayTimeout.rawValue, 504)
        XCTAssertEqual(HTTPStatus.httpVersionNotSupported.rawValue, 505)

        XCTAssertEqual(HTTPStatus.other(5813).rawValue, 5813)
    }

    func testDescription() {
        XCTAssertEqual(HTTPStatus.ok.description, "OK")
        XCTAssertEqual(HTTPStatus.created.description, "CREATED")
        XCTAssertEqual(HTTPStatus.accepted.description, "ACCEPTED")
        XCTAssertEqual(HTTPStatus.nonAuthoritativeInformation.description, "NON-AUTHORITATIVE INFORMATION")
        XCTAssertEqual(HTTPStatus.noContent.description, "NO CONTENT")
        XCTAssertEqual(HTTPStatus.resetContent.description, "RESET CONTENT")
        XCTAssertEqual(HTTPStatus.partialContent.description, "PARTIAL CONTENT")

        XCTAssertEqual(HTTPStatus.multipleChoices.description, "MULTIPLE CHOICES")
        XCTAssertEqual(HTTPStatus.movedPermanently.description, "MOVED PERMANENTLY")
        XCTAssertEqual(HTTPStatus.found.description, "FOUND")
        XCTAssertEqual(HTTPStatus.seeOther.description, "SEE OTHER")
        XCTAssertEqual(HTTPStatus.notModified.description, "NOT MODIFIED")
        XCTAssertEqual(HTTPStatus.useProxy.description, "USE PROXY")
        XCTAssertEqual(HTTPStatus.temporaryRedirect.description, "TEMPORARY REDIRECT")

        XCTAssertEqual(HTTPStatus.badRequest.description, "BAD REQUEST")
        XCTAssertEqual(HTTPStatus.unauthorized.description, "UNAUTHORIZED")
        XCTAssertEqual(HTTPStatus.paymentRequired.description, "PAYMENT REQUIRED")
        XCTAssertEqual(HTTPStatus.forbidden.description, "FORBIDDEN")
        XCTAssertEqual(HTTPStatus.notFound.description, "NOT FOUND")
        XCTAssertEqual(HTTPStatus.methodNotAllowed.description, "METHOD NOT ALLOWED")
        XCTAssertEqual(HTTPStatus.notAcceptable.description, "NOT ACCEPTABLE")
        XCTAssertEqual(HTTPStatus.proxyAuthenticationRequired.description, "PROXY AUTHENTICATION REQUIRED")
        XCTAssertEqual(HTTPStatus.requestTimeout.description, "REQUEST TIMEOUT")
        XCTAssertEqual(HTTPStatus.conflict.description, "CONFLICT")
        XCTAssertEqual(HTTPStatus.gone.description, "GONE")
        XCTAssertEqual(HTTPStatus.lengthRequired.description, "LENGTH REQUIRED")
        XCTAssertEqual(HTTPStatus.preconditionFailed.description, "PRECONDITION FAILED")
        XCTAssertEqual(HTTPStatus.requestEntityTooLarge.description, "REQUEST ENTITY TOO LARGE")
        XCTAssertEqual(HTTPStatus.requestURITooLong.description, "REQUEST URI TOO LONG")
        XCTAssertEqual(HTTPStatus.unsupportedMediaType.description, "UNSUPPORTED MEDIA TYPE")
        XCTAssertEqual(HTTPStatus.requestedRangeNotSatisfiable.description, "REQUESTED RANGE NOT SATISFIABLE")
        XCTAssertEqual(HTTPStatus.expectationFailed.description, "EXPECTATION FAILED")

        XCTAssertEqual(HTTPStatus.internalServerError.description, "INTERNAL ERROR")
        XCTAssertEqual(HTTPStatus.notImplemented.description, "NOT IMPLEMENTED")
        XCTAssertEqual(HTTPStatus.badGateway.description, "BAD GATEWAY")
        XCTAssertEqual(HTTPStatus.serviceUnavailable.description, "SERVICE UNAVAILABLE")
        XCTAssertEqual(HTTPStatus.gatewayTimeout.description, "GATEWAY TIMEOUT")
        XCTAssertEqual(HTTPStatus.httpVersionNotSupported.description, "HTTP VERSION NOT SUPPORTED")

        XCTAssertEqual(HTTPStatus.other(153).description, "OTHER(153)")
    }
}




