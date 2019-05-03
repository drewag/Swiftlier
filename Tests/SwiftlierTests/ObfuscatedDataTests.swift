//
//  ObfuscatedDataTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 5/3/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class ObfuscatedDataTests: XCTestCase {
    func testSecureRandomData() {
        let data = Data(secRandomOfCount: 10)
        XCTAssertEqual(data?.count ?? 0, 10)
    }

    func testObfuscateWithoutPlain() throws {
        let rawData = "MydataMydataMydataMydataMydataMydata".data(using: .utf8)!
        let secret = "MySecretMySecret".data(using: .utf8)!
        let obscured1 = try ObfuscatedData(clear: rawData, keepPlain: nil, secret: secret)
        XCTAssertFalse(obscured1.obfuscated.isEmpty)
        XCTAssertNil(String(data: obscured1.obfuscated, encoding: .utf8))

        let obscured2 = try ObfuscatedData(obfuscated: obscured1.obfuscated, keptPlainCount: 0)
        XCTAssertEqual(obscured2.keptPlain, Data())
        let revealed = obscured2.reveal(withSecret: secret)
        XCTAssertEqual(String(data: revealed, encoding: .utf8), "MydataMydataMydataMydataMydataMydata")

        let incorrect = obscured2.reveal(withSecret: "aaaa".data(using: .utf8)!)
        XCTAssertNil(String(data: incorrect, encoding: .utf8))
    }

    func testObfuscateWithPlain() throws {
        let rawData = "MydataMydataMydataMydataMydataMydata".data(using: .utf8)!
        let secret = "MySecretMySecret".data(using: .utf8)!
        let plain = "MyPlain".data(using: .utf8)!
        let obscured1 = try ObfuscatedData(clear: rawData, keepPlain: plain, secret: secret)
        XCTAssertFalse(obscured1.obfuscated.isEmpty)
        XCTAssertNil(String(data: obscured1.obfuscated, encoding: .utf8))

        let obscured2 = try ObfuscatedData(obfuscated: obscured1.obfuscated, keptPlainCount: plain.count)
        XCTAssertEqual(obscured2.keptPlain, plain)
        let revealed = obscured2.reveal(withSecret: secret)
        XCTAssertEqual(String(data: revealed, encoding: .utf8), "MydataMydataMydataMydataMydataMydata")

        let incorrect = obscured2.reveal(withSecret: "aaaa".data(using: .utf8)!)
        XCTAssertNil(String(data: incorrect, encoding: .utf8))
    }

    func testTooShortData() throws {
        var tooShort = "AAAAAAAAAAAAAAA".data(using: .utf8)!
        XCTAssertThrowsError(try ObfuscatedData(obfuscated: tooShort, keptPlainCount: 0))

        tooShort = "AAAAAAAAAAAAAAAAAA".data(using: .utf8)!
        XCTAssertThrowsError(try ObfuscatedData(obfuscated: tooShort, keptPlainCount: 3))
    }
}
