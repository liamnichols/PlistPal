import XCTest
@testable import PlistPalCore

final class ContentsTests: XCTestCase {
    func testExpandingVariables_topLevelArray() {
        let contents = Contents.array(["1", "2", "3", "${FOUR}"])

        let expanded = contents.expandingVariables(using: ["FOUR": "4"])

        XCTAssertEqual(expanded.value as? [String], ["1", "2", "3", "4"])
    }

    func testExpandingVariables_topLevelDictionary() {
        let contents = Contents.dictionary([
            "1": "one",
            "2": "two",
            "3": "three",
            "4": "${FOUR}"
        ])

        let expanded = contents.expandingVariables(using: ["FOUR": "four"])

        XCTAssertEqual(expanded.value as? [String: String], [
            "1": "one",
            "2": "two",
            "3": "three",
            "4": "four"
        ])
    }

    func testExpandingVariables_nestedContainer() {
        let contents = Contents.dictionary([
            "array": [
                [
                    "key": "${VALUE}"
                ]
            ]
        ])

        let expanded = contents.expandingVariables(using: ["VALUE": "value"])

        XCTAssertEqual(expanded.value as? [String: [[String: String]]], [
            "array": [
                [
                    "key": "value"
                ]
            ]
        ])
    }

    func testExpandingVariables_multiple() {
        let contents = Contents.dictionary([
            "environment": "${ENVIRONMENT}",
            "hostname": "${HOST_ONE}",
            "fallback_hostname": "${HOST_TWO}"
        ])

        let expanded = contents.expandingVariables(using: [
            "ENVIRONMENT": "production",
            "HOST_ONE": "api.example.com",
            "HOST_TWO": "fallbackapi.example.com"
        ])

        XCTAssertEqual(expanded.value as? [String: String], [
            "environment": "production",
            "hostname": "api.example.com",
            "fallback_hostname": "fallbackapi.example.com"
        ])
    }

    func testExpandingVariables_multipleInSameString() {
        let contents = Contents.dictionary([
            "api_hostname": "${API_SUBDOMAIN}.${PRIMARY_HOSTNAME}"
        ])

        let expanded = contents.expandingVariables(using: [
            "API_SUBDOMAIN": "api",
            "PRIMARY_HOSTNAME": "example.com"
        ])

        XCTAssertEqual(expanded.value as? [String: String], [
            "api_hostname": "api.example.com",
        ])
    }

    func testExpandingVariables_missingValue() {
        let contents = Contents.dictionary([
            "APIToken": "${API_TOKEN}"
        ])

        let expanded = contents.expandingVariables(using: [:])

        XCTAssertEqual(expanded.value as? [String: String], ["APIToken": ""])
    }
}
