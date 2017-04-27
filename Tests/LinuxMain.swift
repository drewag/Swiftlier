import XCTest
@testable import SwiftlierTests

XCTMain([
     testCase(EventCenterTests.allTests),
     testCase(Dictionary_MergingTests.allTests),
     testCase(MultiCallbackTests.allTests),
     testCase(String_HelpersTests.allTests),
     testCase(ObservableTests.allTests),
     testCase(PathTests.allTests),
     testCase(EmailAddressTests.allTests),
     testCase(FileArchiveTests.allTests),
])
