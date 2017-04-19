//
//  EventCenterTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/5/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class TestStringEvent: EventType {
    typealias CallbackParam = String
}

class TestIntEvent: EventType {
    typealias CallbackParam = Int
}

class TestOptionalEvent: EventType {
    typealias CallbackParam = String?
}
            

class EventCenterTests: XCTestCase {
    let eventCenter = EventCenter()
    
    func testObserving() {
        var triggeredString = ""
        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 1")
        eventCenter.addObserver(self, forEvent: TestStringEvent.self) { param in
            triggeredString = param
        }
        XCTAssertEqual(triggeredString, "")
        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 2")
        XCTAssertEqual(triggeredString, "Trigger 2")
    }
    
    func testRemovingObserverForEvent() {
        var triggeredString = ""
        eventCenter.addObserver(self, forEvent: TestStringEvent.self) { param in
            triggeredString = param
        }
        eventCenter.removeObserver(self, forEvent: TestStringEvent.self)
        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 2")
        XCTAssertEqual(triggeredString, "")
    }
    
    func testRemovingObserverForAllEvents() {
        var triggeredString = ""
        var triggeredInt = 0
        eventCenter.addObserver(self, forEvent: TestStringEvent.self) { param in
            triggeredString = param
        }
        eventCenter.addObserver(self, forEvent: TestIntEvent.self) { param in
            triggeredInt = param
        }
        eventCenter.removeObserverForAllEvents(self)
        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 2")
        eventCenter.triggerEvent(TestIntEvent.self, params: 1)
        XCTAssertEqual(triggeredString, "")
        XCTAssertEqual(triggeredInt, 0)
    }
    
    func testMultipleEvents() {
        var triggeredString = ""
        var triggeredInt = 0
        eventCenter.addObserver(self, forEvent: TestStringEvent.self) { param in
            triggeredString = param
        }
        eventCenter.addObserver(self, forEvent: TestIntEvent.self) { param in
            triggeredInt = param
        }

        XCTAssertEqual(triggeredString, "")
        XCTAssertEqual(triggeredInt, 0)

        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 1")
        XCTAssertEqual(triggeredString, "Trigger 1")
        XCTAssertEqual(triggeredInt, 0)

        eventCenter.triggerEvent(TestIntEvent.self, params: 1)
        XCTAssertEqual(triggeredString, "Trigger 1")
        XCTAssertEqual(triggeredInt, 1)
        
        eventCenter.removeObserver(self, forEvent: TestStringEvent.self)
        
        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 2")
        XCTAssertEqual(triggeredString, "Trigger 1")
        XCTAssertEqual(triggeredInt, 1)
        
        eventCenter.triggerEvent(TestIntEvent.self, params: 2)
        XCTAssertEqual(triggeredString, "Trigger 1")
        XCTAssertEqual(triggeredInt, 2)
    }
    
    func testWithOperationQueue() {
        var triggeredString = ""
        let expectation = self.expectation(description: "Was Triggered")
        eventCenter.addObserver(self, forEvent: TestStringEvent.self, inQueue: OperationQueue.main) { param in
            triggeredString = param
            XCTAssertEqual(param, "Trigger 1")
            expectation.fulfill()
        }
        XCTAssertEqual(triggeredString, "")
        
        eventCenter.triggerEvent(TestStringEvent.self, params: "Trigger 1")
        XCTAssertEqual(triggeredString, "")
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testOptionalEvent() {
        var triggeredString: String? = ""
        eventCenter.triggerEvent(TestOptionalEvent.self, params: "Trigger 1")
        eventCenter.addObserver(self, forEvent: TestOptionalEvent.self) { param in
            triggeredString = param
        }
        XCTAssertEqual(triggeredString, "")
        eventCenter.triggerEvent(TestOptionalEvent.self, params: "Trigger 2")
        XCTAssertEqual(triggeredString, "Trigger 2")

        eventCenter.triggerEvent(TestOptionalEvent.self, params: nil)
        XCTAssertNil(triggeredString)
    }
}
