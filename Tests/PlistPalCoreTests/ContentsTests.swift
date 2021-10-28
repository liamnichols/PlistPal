import XCTest
@testable import PlistPalCore

struct MockVariableExpander: VariableExpanderProtocol {
    func expandVariables(in string: String) -> String {
        "EXPANDED"
    }
}

final class ContentsTests: XCTestCase {
    func testExpandingVariables_topLevelArray() {
        let contents = Contents.array(["1", "2", "3", "4"])
        let expanded = contents.expandingVariables(using: MockVariableExpander())
        XCTAssertEqual(expanded.value as? [String], ["EXPANDED", "EXPANDED", "EXPANDED", "EXPANDED"])
    }

    func testExpandingVariables_topLevelDictionary() {
        let contents = Contents.dictionary([
            "1": "one",
            "2": "two",
            "3": "three",
            "4": "four"
        ])

        let expanded = contents.expandingVariables(using: MockVariableExpander())

        XCTAssertEqual(expanded.value as? [String: String], [
            "1": "EXPANDED",
            "2": "EXPANDED",
            "3": "EXPANDED",
            "4": "EXPANDED"
        ])
    }

    func testExpandingVariables_nestedContainer() {
        let contents = Contents.dictionary([
            "array": [
                [
                    "key": "value"
                ]
            ]
        ])

        let expanded = contents.expandingVariables(using: MockVariableExpander())

        XCTAssertEqual(expanded.value as? [String: [[String: String]]], [
            "array": [
                [
                    "key": "EXPANDED"
                ]
            ]
        ])
    }

    func testExpandingVariables_doesNotTouchNonStrings() {
        let contents = Contents.dictionary([
            "one": 1,
            "two": 2,
            "three": 3
        ])

        let expanded = contents.expandingVariables(using: MockVariableExpander())

        XCTAssertEqual(expanded.value as? [String: Int], [
            "one": 1,
            "two": 2,
            "three": 3
        ])
    }

    // MARK: - Linux Support

    static var allTests = [
        ("testExpandingVariables_topLevelArray", testExpandingVariables_topLevelArray),
        ("testExpandingVariables_topLevelDictionary", testExpandingVariables_topLevelDictionary),
        ("testExpandingVariables_nestedContainer", testExpandingVariables_nestedContainer),
        ("testExpandingVariables_doesNotTouchNonStrings", testExpandingVariables_doesNotTouchNonStrings)
    ]
}
