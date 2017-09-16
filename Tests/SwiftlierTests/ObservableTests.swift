//
//  ObservableTests.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/27/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import Swiftlier

final class ObservableTests: XCTestCase, LinuxEnforcedTestCase {
    func testSubscribing() {
        let observable = Observable<String>("Old Value")
        var called = false
        observable.addChangedValueObserver(self) { oldValue, newValue in
            XCTAssertEqual(oldValue, "Old Value")
            XCTAssertEqual(newValue, "New Value")
            called = true
        }
        observable.current = "New Value"
        XCTAssertTrue(called)
    }

    func testUnsubscribing() {
        let observable = Observable<String>("Old Value")
        var called = false
        observable.addNewValueObserver(self) { _ in
            called = true
        }
        observable.removeObserver(self)
        observable.current = "New Value"
        XCTAssertFalse(called)
    }

    func testTriggerImmediately() {
        let observable = Observable<String>("Current Value")
        var called = false
        observable.addChangeObserver(self, options: ObservationOptions.initial) { oldValue, newValue in
            XCTAssertNil(oldValue)
            XCTAssertEqual(newValue, "Current Value")
            called = true
        }
        XCTAssertTrue(called)
    }

    func testAutomaticUnsubscribing() {
        class SomeClass {
        }
        var observable = Observable<String>("Current Value")
        var called = false
        func scope() {
            let observer = SomeClass()
            observable.addNewValueObserver(observer) { _ in
                called = true
            }
        }
        scope()
        observable.current = "New Value"
        XCTAssertFalse(called)
    }
    
    func testCallOnceOption() {
        let observable = Observable<String>("Current Value")
        var called = false
        observable.addNewValueObserver(self, options: .onlyOnce) { newValue in
            XCTAssertEqual(newValue, "Second Value")
            called = true
        }
        XCTAssertFalse(called)
        
        observable.current = "Second Value"
        XCTAssertTrue(called)
        
        called = false
        observable.current = "Third Value"
        XCTAssertFalse(called)
    }
    
    func testCallOnceOptionWithInitial() {
        let observable = Observable<String>("Current Value")
        var called = false
        observable.addNewValueObserver(self, options: [.initial, .onlyOnce]) { _ in
            called = true
        }
        XCTAssertTrue(called)
        
        observable.current = "Second Value"
        XCTAssertTrue(called)
        
        called = false
        observable.current = "Third Value"
        XCTAssertFalse(called)
    }

    static var allTests: [(String, (ObservableTests) -> () throws -> Void)] {
        return [
            ("testSubscribing", testSubscribing),
            ("testUnsubscribing", testUnsubscribing),
            ("testTriggerImmediately", testTriggerImmediately),
            ("testAutomaticUnsubscribing", testAutomaticUnsubscribing),
            ("testCallOnceOption", testCallOnceOption),
            ("testCallOnceOptionWithInitial", testCallOnceOptionWithInitial),
        ]
    }
}
