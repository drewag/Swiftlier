//
//  ObservableTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/27/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class ObservableTests: XCTestCase {
    func testSubscribing() {
        let observable = Observable<String>("Old Value")
        var called = false
        observable.addChangeObserver(self) { oldValue, newValue in
            XCTAssertEqual(oldValue, "Old Value")
            XCTAssertEqual(newValue, "New Value")
            called = true
        }
        observable.value = "New Value"
        XCTAssertTrue(called)
    }

    func testUnsubscribing() {
        let observable = Observable<String>("Old Value")
        var called = false
        observable.addNewObserver(self) { _ in
            called = true
        }
        observable.removeObserver(self)
        observable.value = "New Value"
        XCTAssertFalse(called)
    }

    func testTriggerImmediately() {
        let observable = Observable<String>("Current Value")
        var called = false
        observable.addChangeObserver(self, options: ObservationOptions.Initial) { oldValue, newValue in
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
            observable.addNewObserver(observer) { _ in
                called = true
            }
        }
        scope()
        observable.value = "New Value"
        XCTAssertFalse(called)
    }
    
    func testCallOnceOption() {
        let observable = Observable<String>("Current Value")
        var called = false
        observable.addNewObserver(self, options: ObservationOptions.OnlyOnce) { newValue in
            XCTAssertEqual(newValue, "Second Value")
            called = true
        }
        XCTAssertFalse(called)
        
        observable.value = "Second Value"
        XCTAssertTrue(called)
        
        called = false
        observable.value = "Third Value"
        XCTAssertFalse(called)
    }
    
    func testCallOnceOptionWithInitial() {
        let observable = Observable<String>("Current Value")
        var called = false
        observable.addNewObserver(self, options: ObservationOptions.Initial | ObservationOptions.OnlyOnce) { _ in
            called = true
        }
        XCTAssertTrue(called)
        
        observable.value = "Second Value"
        XCTAssertTrue(called)
        
        called = false
        observable.value = "Third Value"
        XCTAssertFalse(called)
    }
}
