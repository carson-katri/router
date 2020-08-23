import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EncoderTests.allTests),
        testCase(EvaluatorTests.allTests),
        testCase(GeneralTests.allTests),
    ]
}
#endif
