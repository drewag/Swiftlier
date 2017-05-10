//
//  Data_ProcessingTests.swift
//  SwiftlieriOS
//
//  Created by Andrew Wagner on 5/9/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import XCTest
import Swiftlier

final class Data_ProcessingTests: XCTestCase, LinuxEnforcedTestCase {
    func testsRangesOf() {
        let sourceString = "SEPoneSEPtwoSEPthreeSEP"
        let data = sourceString.data(using: .utf8)!
        let separator = "SEP".data(using: .utf8)!

        var ranges = data.ranges(of: separator)
        XCTAssertEqual(ranges.count, 4)

        XCTAssertEqual(ranges[0].lowerBound, data.startIndex)
        XCTAssertEqual(ranges[0].upperBound, data.index(3, offsetBy: 0))

        XCTAssertEqual(ranges[1].lowerBound, data.index(6, offsetBy: 0))
        XCTAssertEqual(ranges[1].upperBound, data.index(9, offsetBy: 0))

        XCTAssertEqual(ranges[2].lowerBound, data.index(12, offsetBy: 0))
        XCTAssertEqual(ranges[2].upperBound, data.index(15, offsetBy: 0))

        XCTAssertEqual(ranges[3].lowerBound, data.index(20, offsetBy: 0))
        XCTAssertEqual(ranges[3].upperBound, data.index(23, offsetBy: 0))

        ranges = data.ranges(of: "SEPP".data(using: .utf8)!)
        XCTAssertEqual(ranges.count, 0)

        ranges = data.ranges(of: Data())
        XCTAssertEqual(ranges.count, 0)

        let subRange: Range<Data.Index> = 2 ..< 22
        ranges = data.ranges(of: separator, in: subRange)
        XCTAssertEqual(ranges.count, 2)

        XCTAssertEqual(ranges[0].lowerBound, data.index(6, offsetBy: 0))
        XCTAssertEqual(ranges[0].upperBound, data.index(9, offsetBy: 0))

        XCTAssertEqual(ranges[1].lowerBound, data.index(12, offsetBy: 0))
        XCTAssertEqual(ranges[1].upperBound, data.index(15, offsetBy: 0))
    }

    func testRangesSeparatedBy() {
        let sourceString = "SEPoneSEPtwoSEPthreeSEP"
        let data = sourceString.data(using: .utf8)!
        let separator = "SEP".data(using: .utf8)!

        var ranges = data.ranges(separatedBy: separator)
        XCTAssertEqual(ranges.count, 3)
        XCTAssertEqual(String(data: data.subdata(in: ranges[0]), encoding: .utf8), "one")
        XCTAssertEqual(String(data: data.subdata(in: ranges[1]), encoding: .utf8), "two")
        XCTAssertEqual(String(data: data.subdata(in: ranges[2]), encoding: .utf8), "three")

        ranges = data.ranges(separatedBy: "SEPP".data(using: .utf8)!)
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(String(data: data.subdata(in: ranges[0]), encoding: .utf8), "SEPoneSEPtwoSEPthreeSEP")

        ranges = data.ranges(separatedBy: Data())
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(String(data: data.subdata(in: ranges[0]), encoding: .utf8), "SEPoneSEPtwoSEPthreeSEP")


        let subRange: Range<Data.Index> = 2 ..< 22
        ranges = data.ranges(separatedBy: separator, in: subRange)
        XCTAssertEqual(ranges.count, 3)
        XCTAssertEqual(String(data: data.subdata(in: ranges[0]), encoding: .utf8), "Pone")
        XCTAssertEqual(String(data: data.subdata(in: ranges[1]), encoding: .utf8), "two")
        XCTAssertEqual(String(data: data.subdata(in: ranges[2]), encoding: .utf8), "threeSE")
    }

    static var allTests: [(String, (Data_ProcessingTests) -> () throws -> Void)] {
        return [
            ("testsRangesOf", testsRangesOf),
            ("testRangesSeparatedBy", testRangesSeparatedBy),
        ]
    }
}
