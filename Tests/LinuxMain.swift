import XCTest
@testable import SwiftlierTests

XCTMain([
     testCase(EventCenterTests.allTests),
     testCase(Dictionary_MergingTests.allTests),
     testCase(MultiCallbackTests.allTests),
     testCase(String_HelpersTests.allTests),
     testCase(ObservableTests.allTests),
     testCase(PathTests.allTests),
     testCase(Path_CodingTests.allTests),
     testCase(EmailAddressTests.allTests),
     testCase(PersistenceServiceTests.allTests),
     testCase(AgeTests.allTests),
     testCase(AlwaysEqualTests.allTests),
     testCase(AngleTests.allTests),
     testCase(Array_SortingTests.allTests),
     testCase(Bool_FormattingTests.allTests),
     testCase(Data_Base64Tests.allTests),
     testCase(Data_ProcessingTests.allTests),
     testCase(DayTests.allTests),
])
