import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ContentsTsts.allTests),
        testCase(PropertyListTests.allTests),
        testCase(VariableExpanderTests.allTests),
    ]
}
#endif
