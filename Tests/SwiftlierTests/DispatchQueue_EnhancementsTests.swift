//
//  DispatchQueue_EnhancementsTests.swift
//  SwiftlierTests
//
//  Created by Andrew Wagner on 8/4/19.
//

import XCTest

class DispatchQueue_EnhancementsTests: XCTestCase {
    func testAsyncAfter() {
        let start = Date()
        var end: Date?
        let semephore = DispatchSemaphore(value: 0)
        DispatchQueue(label: "background", qos: .background).asyncAfter(seconds: 2, execute: {
            end = Date()
            semephore.signal()
        })
        XCTAssertNil(end)
        XCTAssertEqual(semephore.wait(timeout: DispatchTime.now() + 5), .success)
        XCTAssertGreaterThan((end ?? .distantPast).timeIntervalSince(start), 2)
    }
}
