import XCTest
@testable import PlistPalCore

final class VariableExpanderTests: XCTestCase {

    var expander: VariableExpander!

    override func setUp() {
        super.setUp()

        expander = VariableExpander(values: [
            "SOME_NUMBERS": "0123456789",
            "THE_ALPHABET": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            "SCHEME": "https",
            "HOSTNAME": "api.example.com",
            "API_PATH": "v2",
            "API_KEY": "0469c53fb48a73b12a0e75e22fc52e5e38fe7849b8b5ac6b2a403eea0d27eb2f",
            "EMPTY": ""
        ])
    }

    func testExpand() {
        XCTAssertEqual(
            expander.expandVariables(in: "Nothing to expand"),
            "Nothing to expand"
        )

        XCTAssertEqual(
            expander.expandVariables(in: "${THE_ALPHABET}"),
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        )

        XCTAssertEqual(
            expander.expandVariables(in: "${NON_EXISTENT_KEY}"),
            ""
        )

        XCTAssertEqual(
            expander.expandVariables(in: "${EMPTY}"),
            ""
        )

        XCTAssertEqual(
            expander.expandVariables(in: "${SCHEME}://${HOSTNAME}/${API_PATH}/some/endpoint"),
            "https://api.example.com/v2/some/endpoint"
        )

        XCTAssertEqual(
            expander.expandVariables(in: "https://api.example.com/test?api_key=${API_KEY}"),
            "https://api.example.com/test?api_key=0469c53fb48a73b12a0e75e22fc52e5e38fe7849b8b5ac6b2a403eea0d27eb2f"
        )
    }
}
