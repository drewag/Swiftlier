//
//  CodingKeysTests.swift
//  SwiftlierTests
//
//  Created by Andrew Wagner on 8/4/19.
//

import XCTest
import Swiftlier

class CodingKeysTests: XCTestCase {
    func testDictionary() {
        var dict: [CodingUserInfoKey:Any] = [
            CodingUserInfoKey(rawValue: "KEY")!: "VALUE"
        ]

        dict.purpose = .create
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!] as? CodingPurpose, .create)
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertEqual(dict.purpose, .create)
        XCTAssertNil(dict.location)

        dict.purpose = .update
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!] as? CodingPurpose, .update)
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertEqual(dict.purpose, .update)
        XCTAssertNil(dict.location)

        dict.purpose = .replace
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!] as? CodingPurpose, .replace)
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertEqual(dict.purpose, .replace)
        XCTAssertNil(dict.location)

        dict.purpose = nil
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!])
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertNil(dict.purpose)
        XCTAssertNil(dict.location)

        dict.location = .local
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!] as? CodingLocation, .local)
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertNil(dict.purpose)
        XCTAssertEqual(dict.location, .local)

        dict.location = .remote
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!] as? CodingLocation, .remote)
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertNil(dict.purpose)
        XCTAssertEqual(dict.location, .remote)

        dict.location = nil
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingPurpose")!])
        XCTAssertNil(dict[CodingUserInfoKey(rawValue: "swiftlier.codingLocation")!])
        XCTAssertEqual(dict[CodingUserInfoKey(rawValue: "KEY")!] as? String, "VALUE")
        XCTAssertNil(dict.purpose)
        XCTAssertNil(dict.location)
    }

    func testEncoder() {
        var encoder = TestEncoder()

        XCTAssertEqual(encoder.purpose, .create)
        XCTAssertEqual(encoder.destination, .local)

        encoder.userInfo.purpose = .create
        XCTAssertEqual(encoder.purpose, .create)
        XCTAssertEqual(encoder.destination, .local)

        encoder.userInfo.purpose = .update
        XCTAssertEqual(encoder.purpose, .update)
        XCTAssertEqual(encoder.destination, .local)

        encoder.userInfo.purpose = .replace
        XCTAssertEqual(encoder.purpose, .replace)
        XCTAssertEqual(encoder.destination, .local)

        encoder.userInfo.purpose = nil
        XCTAssertEqual(encoder.purpose, .create)
        XCTAssertEqual(encoder.destination, .local)

        encoder.userInfo.location = .local
        XCTAssertEqual(encoder.purpose, .create)
        XCTAssertEqual(encoder.destination, .local)

        encoder.userInfo.location = .remote
        XCTAssertEqual(encoder.purpose, .create)
        XCTAssertEqual(encoder.destination, .remote)

        encoder.userInfo.location = nil
        XCTAssertEqual(encoder.purpose, .create)
        XCTAssertEqual(encoder.destination, .local)
    }

    func testDecoder() {
        var decoder = TestDecoder()

        XCTAssertEqual(decoder.purpose, .create)
        XCTAssertEqual(decoder.source, .local)

        decoder.userInfo.purpose = .create
        XCTAssertEqual(decoder.purpose, .create)
        XCTAssertEqual(decoder.source, .local)

        decoder.userInfo.purpose = .update
        XCTAssertEqual(decoder.purpose, .update)
        XCTAssertEqual(decoder.source, .local)

        decoder.userInfo.purpose = .replace
        XCTAssertEqual(decoder.purpose, .replace)
        XCTAssertEqual(decoder.source, .local)

        decoder.userInfo.purpose = nil
        XCTAssertEqual(decoder.purpose, .create)
        XCTAssertEqual(decoder.source, .local)

        decoder.userInfo.location = .local
        XCTAssertEqual(decoder.purpose, .create)
        XCTAssertEqual(decoder.source, .local)

        decoder.userInfo.location = .remote
        XCTAssertEqual(decoder.purpose, .create)
        XCTAssertEqual(decoder.source, .remote)

        decoder.userInfo.location = nil
        XCTAssertEqual(decoder.purpose, .create)
        XCTAssertEqual(decoder.source, .local)
    }
}

struct TestEncoder: Encoder {
    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        fatalError()
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }
}

struct TestDecoder: Decoder {
    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        fatalError()
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}
