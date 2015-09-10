//
//  MultiCallbackTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/5/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

class MultiCallbackTests: XCTestCase {
    var callback = MultiCallback<String>()
    
    func testAddingObservers() {
        var triggeredString = ""
        callback.addObserver(self) { param in
            triggeredString = param
        }
        XCTAssertEqual(triggeredString, "")
        
        callback.triggerWithArguments("Trigger 1")
        XCTAssertEqual(triggeredString, "Trigger 1")
    }
    
    func testRemovingObservers() {
        var triggeredString = ""
        callback.addObserver(self) { param in
            triggeredString = param
        }
        XCTAssertEqual(triggeredString, "")
        
        callback.removeObserver(self)
        callback.triggerWithArguments("Trigger 1")
        XCTAssertEqual(triggeredString, "")
    }
    
    func testWithMultipleObservers() {
        var triggeredString = ""
        callback.addObserver(self) { param in
            triggeredString = param
        }
        var triggeredString2 = ""
        callback.addObserver(self) { param in
            triggeredString2 = param
        }
        XCTAssertEqual(triggeredString, "")
        XCTAssertEqual(triggeredString2, "")
        
        callback.triggerWithArguments("Trigger 1")
        XCTAssertEqual(triggeredString, "Trigger 1")
        XCTAssertEqual(triggeredString2, "Trigger 1")
        
        callback.removeObserver(self)
        
        callback.triggerWithArguments("Trigger 2")
        XCTAssertEqual(triggeredString, "Trigger 1")
        XCTAssertEqual(triggeredString2, "Trigger 1")
    }
}
