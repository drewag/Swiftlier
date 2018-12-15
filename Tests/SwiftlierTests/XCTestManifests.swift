import XCTest

extension AgeTests {
    static let __allTests = [
        ("testYears", testYears),
    ]
}

extension AlwaysEqualTests {
    static let __allTests = [
        ("testAlwaysEqual", testAlwaysEqual),
    ]
}

extension AngleTests {
    static let __allTests = [
        ("testAdd", testAdd),
        ("testAddInPlace", testAddInPlace),
        ("testCosine", testCosine),
        ("testDegrees", testDegrees),
        ("testDivideByValue", testDivideByValue),
        ("testDivideByValueInPlace", testDivideByValueInPlace),
        ("testEquals", testEquals),
        ("testGreaterThan", testGreaterThan),
        ("testGreaterThanOrEqual", testGreaterThanOrEqual),
        ("testLessThan", testLessThan),
        ("testLessThanOrEqual", testLessThanOrEqual),
        ("testMultiplyByValue", testMultiplyByValue),
        ("testMultiplyByValueInPlace", testMultiplyByValueInPlace),
        ("testPi", testPi),
        ("testRadians", testRadians),
        ("testSine", testSine),
        ("testSubtract", testSubtract),
        ("testSubtractInPlace", testSubtractInPlace),
        ("testZero", testZero),
    ]
}

extension Array_SortingTests {
    static let __allTests = [
        ("testInsertAssumingAlreadySorted", testInsertAssumingAlreadySorted),
    ]
}

extension BinarySearchTreeTests {
    static let __allTests = [
        ("testElementsBetween", testElementsBetween),
        ("testInsert", testInsert),
        ("testIterating", testIterating),
    ]
}

extension Bool_FormattingTests {
    static let __allTests = [
        ("testInWords", testInWords),
    ]
}

extension CSVStreamReaderTests {
    static let __allTests = [
        ("testComplexFromData", testComplexFromData),
        ("testComplexFromFile", testComplexFromFile),
        ("testSimpleFromData", testSimpleFromData),
        ("testSimpleFromFile", testSimpleFromFile),
    ]
}

extension Coding_HelpersTests {
    static let __allTests = [
        ("testCopyUsingCoding", testCopyUsingCoding),
    ]
}

extension Data_Base64Tests {
    static let __allTests = [
        ("testByteArrayBase64", testByteArrayBase64),
        ("testByteArrayBase64ForUrl", testByteArrayBase64ForUrl),
        ("testDataBase64", testDataBase64),
        ("testDataBase64ForUrl", testDataBase64ForUrl),
    ]
}

extension Data_ProcessingTests {
    static let __allTests = [
        ("testRangesSeparatedBy", testRangesSeparatedBy),
        ("testsRangesOf", testsRangesOf),
    ]
}

extension Date_HelpersTests {
    static let __allTests = [
        ("testBeginningOfDay", testBeginningOfDay),
        ("testBeginningOfMonth", testBeginningOfMonth),
        ("testBeginningOfNextDay", testBeginningOfNextDay),
        ("testBeginningOfNextMonth", testBeginningOfNextMonth),
        ("testBeginningOfNextWeek", testBeginningOfNextWeek),
        ("testBeginningOfWeek", testBeginningOfWeek),
        ("testIsInFuture", testIsInFuture),
        ("testIsInPast", testIsInPast),
        ("testIsThisWeek", testIsThisWeek),
        ("testIsThisYear", testIsThisYear),
        ("testIsToday", testIsToday),
        ("testIsTomorrow", testIsTomorrow),
    ]
}

extension DayTests {
    static let __allTests = [
        ("testComparison", testComparison),
        ("testDayFromDate", testDayFromDate),
    ]
}

extension DelimiterStreamReaderTests {
    static let __allTests = [
        ("testNewLinesFromData", testNewLinesFromData),
        ("testNewLinesFromFile", testNewLinesFromFile),
        ("testTabsFromData", testTabsFromData),
        ("testTabsFromFile", testTabsFromFile),
    ]
}

extension Dictionary_MergingTests {
    static let __allTests = [
        ("testMerge", testMerge),
    ]
}

extension Double_FormattingTests {
    static let __allTests = [
        ("testAsPercent", testAsPercent),
    ]
}

extension EmailAddressTests {
    static let __allTests = [
        ("testEmptyString", testEmptyString),
        ("testEmptyUserString", testEmptyUserString),
        ("testInvalidStrings", testInvalidStrings),
        ("testInvalidUserStrings", testInvalidUserStrings),
        ("testNilString", testNilString),
        ("testNilUserString", testNilUserString),
        ("testValidStrings", testValidStrings),
        ("testValidUserStrings", testValidUserStrings),
    ]
}

extension Enum_ConvenienceTests {
    static let __allTests = [
        ("testCount", testCount),
    ]
}

extension EventCenterTests {
    static let __allTests = [
        ("testMultipleEvents", testMultipleEvents),
        ("testObserving", testObserving),
        ("testOptionalEvent", testOptionalEvent),
        ("testRemovingObserverForAllEvents", testRemovingObserverForAllEvents),
        ("testRemovingObserverForEvent", testRemovingObserverForEvent),
        ("testWithOperationQueue", testWithOperationQueue),
    ]
}

extension HTMLTests {
    static let __allTests = [
        ("testDescription", testDescription),
    ]
}

extension HTTPStatusTests {
    static let __allTests = [
        ("testDescription", testDescription),
        ("testInitFromRawValues", testInitFromRawValues),
        ("testRawValues", testRawValues),
    ]
}

extension HeartRateFormatterTests {
    static let __allTests = [
        ("testStringForObject", testStringForObject),
    ]
}

extension Int_RandomTests {
    static let __allTests = [
        ("testRandomInClosedRange", testRandomInClosedRange),
        ("testRandomInOpenRange", testRandomInOpenRange),
        ("testRandomOfLength", testRandomOfLength),
    ]
}

extension JSONTests {
    static let __allTests = [
        ("testData", testData),
        ("testDecode", testDecode),
        ("testEncode", testEncode),
        ("testEquatable", testEquatable),
        ("testInitFromData", testInitFromData),
        ("testInitFromObject", testInitFromObject),
    ]
}

extension MassTests {
    static let __allTests = [
        ("testGramsConversions", testGramsConversions),
        ("testKilogramsConversions", testKilogramsConversions),
        ("testOuncesConversions", testOuncesConversions),
        ("testPoundsConversions", testPoundsConversions),
        ("testStonesConversions", testStonesConversions),
        ("testUnitDisplay", testUnitDisplay),
    ]
}

extension MultiCallbackTests {
    static let __allTests = [
        ("testAddingObservers", testAddingObservers),
        ("testRemovingObservers", testRemovingObservers),
        ("testWithMultipleObservers", testWithMultipleObservers),
    ]
}

extension NativeTypesDecoderTests {
    static let __allTests = [
        ("testDecodableFromRaw", testDecodableFromRaw),
    ]
}

extension NativeTypesEncoderTests {
    static let __allTests = [
        ("testObjectFromEncodable", testObjectFromEncodable),
    ]
}

extension ObservableTests {
    static let __allTests = [
        ("testAutomaticUnsubscribing", testAutomaticUnsubscribing),
        ("testCallOnceOption", testCallOnceOption),
        ("testCallOnceOptionWithInitial", testCallOnceOptionWithInitial),
        ("testSubscribing", testSubscribing),
        ("testTriggerImmediately", testTriggerImmediately),
        ("testUnsubscribing", testUnsubscribing),
    ]
}

extension PatchyRangeTests {
    static let __allTests = [
        ("testAppendRange", testAppendRange),
    ]
}

extension PathTests {
    static let __allTests = [
        ("testAddFile", testAddFile),
        ("testAddLink", testAddLink),
        ("testBaseName", testBaseName),
        ("testCopyFileDirectlyToPath", testCopyFileDirectlyToPath),
        ("testCopyFileToDifferentDirectoryWithDifferentName", testCopyFileToDifferentDirectoryWithDifferentName),
        ("testCopyFileToDifferentDirectoryWithSameName", testCopyFileToDifferentDirectoryWithSameName),
        ("testCopyFileWithinDirectory", testCopyFileWithinDirectory),
        ("testCreateDirectory", testCreateDirectory),
        ("testCreateFile", testCreateFile),
        ("testCreateLink", testCreateLink),
        ("testDelete", testDelete),
        ("testDescription", testDescription),
        ("testDirectory", testDirectory),
        ("testDirectoryContents", testDirectoryContents),
        ("testExsiting", testExsiting),
        ("testExtension", testExtension),
        ("testFile", testFile),
        ("testFileAtSubPath", testFileAtSubPath),
        ("testFileContents", testFileContents),
        ("testFileNamed", testFileNamed),
        ("testHandleForReading", testHandleForReading),
        ("testHandleForReadingAndWriting", testHandleForReadingAndWriting),
        ("testHandleForWriting", testHandleForWriting),
        ("testIsIdenticalTo", testIsIdenticalTo),
        ("testLastModified", testLastModified),
        ("testMoveDirectoryDirectlyToPath", testMoveDirectoryDirectlyToPath),
        ("testMoveDirectoryToDifferentDirectoryWithDifferentName", testMoveDirectoryToDifferentDirectoryWithDifferentName),
        ("testMoveDirectoryToDifferentDirectoryWithSameName", testMoveDirectoryToDifferentDirectoryWithSameName),
        ("testMoveDirectoryWithinDirectory", testMoveDirectoryWithinDirectory),
        ("testMoveFileDirectlyToPath", testMoveFileDirectlyToPath),
        ("testMoveFileToDifferentDirectoryWithDifferentName", testMoveFileToDifferentDirectoryWithDifferentName),
        ("testMoveFileToDifferentDirectoryWithSameName", testMoveFileToDifferentDirectoryWithSameName),
        ("testMoveFileWithinDirectory", testMoveFileWithinDirectory),
        ("testName", testName),
        ("testNonExisting", testNonExisting),
        ("testResolveSymLink", testResolveSymLink),
        ("testSize", testSize),
        ("testString", testString),
        ("testSubdirectory", testSubdirectory),
        ("testSubPathByAppending", testSubPathByAppending),
        ("testWithExtension", testWithExtension),
        ("testWithoutLastComponent", testWithoutLastComponent),
    ]
}

extension Path_CodingTests {
    static let __allTests = [
        ("testAddEncodable", testAddEncodable),
        ("testAddEncodableArray", testAddEncodableArray),
        ("testAddEncodableDictionary", testAddEncodableDictionary),
        ("testCreateEncodable", testCreateEncodable),
        ("testCreateEncodableArray", testCreateEncodableArray),
        ("testCreateEncodableDictionary", testCreateEncodableDictionary),
    ]
}

extension PersistenceServiceTests {
    static let __allTests = [
        ("testEmpty", testEmpty),
        ("testWithValues", testWithValues),
    ]
}

extension String_HelpersTests {
    static let __allTests = [
        ("testIndexAt", testIndexAt),
        ("testNumberOfCommonSuffixCharacters", testNumberOfCommonSuffixCharacters),
        ("testOffsetCharactersByCount", testOffsetCharactersByCount),
        ("testRepeat", testRepeat),
        ("testTrimmingWhitespaceOnEnds", testTrimmingWhitespaceOnEnds),
    ]
}

extension XMLTests {
    static let __allTests = [
        ("testEquatable", testEquatable),
        ("testInitFromData", testInitFromData),
        ("testInitFromObject", testInitFromObject),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AgeTests.__allTests),
        testCase(AlwaysEqualTests.__allTests),
        testCase(AngleTests.__allTests),
        testCase(Array_SortingTests.__allTests),
        testCase(BinarySearchTreeTests.__allTests),
        testCase(Bool_FormattingTests.__allTests),
        testCase(CSVStreamReaderTests.__allTests),
        testCase(Coding_HelpersTests.__allTests),
        testCase(Data_Base64Tests.__allTests),
        testCase(Data_ProcessingTests.__allTests),
        testCase(Date_HelpersTests.__allTests),
        testCase(DayTests.__allTests),
        testCase(DelimiterStreamReaderTests.__allTests),
        testCase(Dictionary_MergingTests.__allTests),
        testCase(Double_FormattingTests.__allTests),
        testCase(EmailAddressTests.__allTests),
        testCase(Enum_ConvenienceTests.__allTests),
        testCase(EventCenterTests.__allTests),
        testCase(HTMLTests.__allTests),
        testCase(HTTPStatusTests.__allTests),
        testCase(HeartRateFormatterTests.__allTests),
        testCase(Int_RandomTests.__allTests),
        testCase(JSONTests.__allTests),
        testCase(MassTests.__allTests),
        testCase(MultiCallbackTests.__allTests),
        testCase(NativeTypesDecoderTests.__allTests),
        testCase(NativeTypesEncoderTests.__allTests),
        testCase(ObservableTests.__allTests),
        testCase(PatchyRangeTests.__allTests),
        testCase(PathTests.__allTests),
        testCase(Path_CodingTests.__allTests),
        testCase(PersistenceServiceTests.__allTests),
        testCase(String_HelpersTests.__allTests),
        testCase(XMLTests.__allTests),
    ]
}
#endif
