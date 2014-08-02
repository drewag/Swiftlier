//
//  ObservableTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/27/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import UIKit
import XCTest

class ObservableTests: XCTestCase {
    func testSubscribing() {
        var observable = Observable<String>("Old Value")
        var called = false
        observable.addObserverForOwner(self, triggerImmediately: false) {
            (change: Change<String>) in
            XCTAssertEqual((change as Update<String>).oldValue, "Old Value")
            XCTAssertEqual(change.newValue, "New Value")
            called = true
        }
        observable.value = "New Value"
        XCTAssertTrue(called)
    }

    func testUnsubscribing() {
        var observable = Observable<String>("Old Value")
        var called = false
        observable.addObserverForOwner(self, triggerImmediately: false) {
            (change: Change<String>) in
            called = true
        }
        observable.removeObserversForOwner(self)
        observable.value = "New Value"
        XCTAssertFalse(called)
    }

    func testTriggerImmediately() {
        var observable = Observable<String>("Current Value")
        var called = false
        observable.addObserverForOwner(self, triggerImmediately: true) {
            (change: Change<String>) in
            XCTAssertNil(change as? Update<String>)
            XCTAssertEqual(change.newValue, "Current Value")
            called = true
        }
        XCTAssertTrue(called)
    }
}
