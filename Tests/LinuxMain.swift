import XCTest
@testable import SwiftPlusPlusTests

XCTMain([
     testCase(EventCenterTests.allTests),
     testCase(Dictionary_SwiftPlusPlusTest.allTests),
     testCase(MultiCallbackTests.allTests),
     testCase(String_SwiftPlusPlusTests.allTests),
     testCase(ObservableTests.allTests),
     testCase(PathTests.allTests),
])
