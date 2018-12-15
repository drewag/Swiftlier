//
//  Data_Base64Tests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/3/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Data_Base64Tests: XCTestCase {
    let allCharactersSetence = "So?<p>This 4, 5, 6, 7, 8, 9, z, {, |, } tests Base64 encoder. Show me: @, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, [, \\, ], ^, _, `, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s."

    func testDataBase64() {
        XCTAssertEqual("".data(using: .utf8)?.base64, "")
        XCTAssertEqual("f".data(using: .utf8)?.base64, "Zg==")
        XCTAssertEqual("fo".data(using: .utf8)?.base64, "Zm8=")
        XCTAssertEqual("foo".data(using: .utf8)?.base64, "Zm9v")
        XCTAssertEqual("foob".data(using: .utf8)?.base64, "Zm9vYg==")
        XCTAssertEqual("fooba".data(using: .utf8)?.base64, "Zm9vYmE=")
        XCTAssertEqual("foobar".data(using: .utf8)?.base64, "Zm9vYmFy")

        let originalData = allCharactersSetence.data(using: .utf8)
        XCTAssertEqual(originalData?.base64, "U28/PHA+VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==")
        XCTAssertEqual(Data(base64Encoded: originalData?.base64 ?? ""), originalData)
    }

    func testDataBase64ForUrl() {
        XCTAssertEqual("".data(using: .utf8)?.base64ForUrl, "")
        XCTAssertEqual("f".data(using: .utf8)?.base64ForUrl, "Zg==")
        XCTAssertEqual("fo".data(using: .utf8)?.base64ForUrl, "Zm8=")
        XCTAssertEqual("foo".data(using: .utf8)?.base64ForUrl, "Zm9v")
        XCTAssertEqual("foob".data(using: .utf8)?.base64ForUrl, "Zm9vYg==")
        XCTAssertEqual("fooba".data(using: .utf8)?.base64ForUrl, "Zm9vYmE=")
        XCTAssertEqual("foobar".data(using: .utf8)?.base64ForUrl, "Zm9vYmFy")

        XCTAssertEqual(allCharactersSetence.data(using: .utf8)?.base64ForUrl, "U28_PHA-VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==")
    }

    func testByteArrayBase64() {
        XCTAssertEqual([UInt8]("".data(using: .utf8)!).base64, "")
        XCTAssertEqual([UInt8]("f".data(using: .utf8)!).base64, "Zg==")
        XCTAssertEqual([UInt8]("fo".data(using: .utf8)!).base64, "Zm8=")
        XCTAssertEqual([UInt8]("foo".data(using: .utf8)!).base64, "Zm9v")
        XCTAssertEqual([UInt8]("foob".data(using: .utf8)!).base64, "Zm9vYg==")
        XCTAssertEqual([UInt8]("fooba".data(using: .utf8)!).base64, "Zm9vYmE=")
        XCTAssertEqual([UInt8]("foobar".data(using: .utf8)!).base64, "Zm9vYmFy")

        XCTAssertEqual([UInt8](allCharactersSetence.data(using: .utf8)!).base64, "U28/PHA+VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==")
    }

    func testByteArrayBase64ForUrl() {
        XCTAssertEqual([UInt8]("".data(using: .utf8)!).base64ForUrl, "")
        XCTAssertEqual([UInt8]("f".data(using: .utf8)!).base64ForUrl, "Zg==")
        XCTAssertEqual([UInt8]("fo".data(using: .utf8)!).base64ForUrl, "Zm8=")
        XCTAssertEqual([UInt8]("foo".data(using: .utf8)!).base64ForUrl, "Zm9v")
        XCTAssertEqual([UInt8]("foob".data(using: .utf8)!).base64ForUrl, "Zm9vYg==")
        XCTAssertEqual([UInt8]("fooba".data(using: .utf8)!).base64ForUrl, "Zm9vYmE=")
        XCTAssertEqual([UInt8]("foobar".data(using: .utf8)!).base64ForUrl, "Zm9vYmFy")

        XCTAssertEqual([UInt8](allCharactersSetence.data(using: .utf8)!).base64ForUrl, "U28_PHA-VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==")
    }
}
