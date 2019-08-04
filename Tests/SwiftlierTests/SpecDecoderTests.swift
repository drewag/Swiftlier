//
//  SpecDecoderTests.swift
//  SwiftlierTests
//
//  Created by Andrew J Wagner on 8/4/19.
//

import XCTest
import Swiftlier

class SpecDecoderTests: XCTestCase {
    func testDecode() throws {
        let string = try SpecDecoder.spec(forType: SpecDecodable.self)
        let data = string.data(using: .utf8)!
        let json = try JSON(data: data)
        XCTAssertEqual(json["boolean"]?.string, "bool")

        XCTAssertEqual(json["integer"]?.string, "int")
        XCTAssertEqual(json["integer8"]?.string, "int8")
        XCTAssertEqual(json["integer16"]?.string, "int16")
        XCTAssertEqual(json["integer32"]?.string, "int32")
        XCTAssertEqual(json["integer64"]?.string, "int64")

        XCTAssertEqual(json["unsingedInteger"]?.string, "uint")
        XCTAssertEqual(json["unsingedInteger8"]?.string, "uint8")
        XCTAssertEqual(json["unsingedInteger16"]?.string, "uint16")
        XCTAssertEqual(json["unsingedInteger32"]?.string, "uint32")
        XCTAssertEqual(json["unsingedInteger64"]?.string, "uint64")

        XCTAssertEqual(json["floatingPoint"]?.string, "float")
        XCTAssertEqual(json["doublePoint"]?.string, "double")

        XCTAssertEqual(json["someString"]?.string, "string")
        XCTAssertEqual(json["someDate"]?.string, "date")
        XCTAssertEqual(json["someData"]?.string, "data")

        // Optionals
        XCTAssertEqual(json["optionalBoolean"]?.string, "bool?")

        XCTAssertEqual(json["optionalInteger"]?.string, "int?")
        XCTAssertEqual(json["optionalInteger8"]?.string, "int8?")
        XCTAssertEqual(json["optionalInteger16"]?.string, "int16?")
        XCTAssertEqual(json["optionalInteger32"]?.string, "int32?")
        XCTAssertEqual(json["optionalInteger64"]?.string, "int64?")

        XCTAssertEqual(json["optionalUnsingedInteger"]?.string, "uint?")
        XCTAssertEqual(json["optionalUnsingedInteger8"]?.string, "uint8?")
        XCTAssertEqual(json["optionalUnsingedInteger16"]?.string, "uint16?")
        XCTAssertEqual(json["optionalUnsingedInteger32"]?.string, "uint32?")
        XCTAssertEqual(json["optionalUnsingedInteger64"]?.string, "uint64?")

        XCTAssertEqual(json["optionalFloatingPoint"]?.string, "float?")
        XCTAssertEqual(json["optionalDoublePoint"]?.string, "double?")

        XCTAssertEqual(json["optionalSomeString"]?.string, "string?")
        XCTAssertEqual(json["optionalSomeDate"]?.string, "date?")
        XCTAssertEqual(json["optionalSomeData"]?.string, "data?")
    }
}

struct SpecDecodable: Decodable {
    let boolean: Bool

    let integer: Int
    let integer8: Int8
    let integer16: Int16
    let integer32: Int32
    let integer64: Int64

    let unsingedInteger: UInt
    let unsingedInteger8: UInt8
    let unsingedInteger16: UInt16
    let unsingedInteger32: UInt32
    let unsingedInteger64: UInt64

    let floatingPoint: Float
    let doublePoint: Double

    let someString: String
    let someDate: Date
    let someData: Data

    // Optionals
    let optionalBoolean: Bool?

    let optionalInteger: Int?
    let optionalInteger8: Int8?
    let optionalInteger16: Int16?
    let optionalInteger32: Int32?
    let optionalInteger64: Int64?

    let optionalUnsingedInteger: UInt?
    let optionalUnsingedInteger8: UInt8?
    let optionalUnsingedInteger16: UInt16?
    let optionalUnsingedInteger32: UInt32?
    let optionalUnsingedInteger64: UInt64?

    let optionalFloatingPoint: Float?
    let optionalDoublePoint: Double?

    let optionalSomeString: String?
    let optionalSomeDate: Date?
    let optionalSomeData: Data?
}
