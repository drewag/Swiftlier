//
//  URL_HelpersTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 8/4/19.
//

import XCTest
import Swiftlier

class URL_EnhancementsTests: XCTestCase {
    func testAppendingPathComponent() {
        let url = URL(string: "https://drewag.me/some/path")!
        XCTAssertEqual((url / "component").absoluteString, "https://drewag.me/some/path/component")
    }

    func testDeletingQuery() {
        var url = URL(string: "https://drewag.me/some/path?a=b&c=d")!
        XCTAssertEqual(url.deletingQuery.absoluteString, "https://drewag.me/some/path")

        url = URL(string: "https://drewag.me/some/path")!
        XCTAssertEqual(url.deletingQuery.absoluteString, "https://drewag.me/some/path")
    }

    func testHTTPS() {
        var url = URL(string: "http://drewag.me/some/path?a=b&c=d")!
        XCTAssertEqual(url.https.absoluteString, "https://drewag.me/some/path?a=b&c=d")

        url = URL(string: "https://drewag.me/some/path?a=b&c=d")!
        XCTAssertEqual(url.https.absoluteString, "https://drewag.me/some/path?a=b&c=d")
    }

    func testPathComponentsDifferentFromURL() {
        let url1 = URL(string: "http://drewag.me/one/two/three")!
        var url2 = URL(string: "http://drewag.me/one/other/three")!

        XCTAssertEqual(url1.pathComponents(differentFrom: url2), ["two","three"])

        url2 = URL(string: "http://drewag.me/one/two/three?a=b")!
        XCTAssertEqual(url1.pathComponents(differentFrom: url2), [])

        url2 = URL(string: "http://drewag.me/other/two/three?a=b")!
        XCTAssertEqual(url1.pathComponents(differentFrom: url2), ["one","two","three"])
    }
}
