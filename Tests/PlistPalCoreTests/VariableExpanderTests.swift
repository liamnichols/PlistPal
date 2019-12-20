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
            expander.expand("Nothing to expand"),
            "Nothing to expand"
        )

        XCTAssertEqual(
            expander.expand("${THE_ALPHABET}"),
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        )

        XCTAssertEqual(
            expander.expand("${NON_EXISTENT_KEY}"),
            ""
        )

        XCTAssertEqual(
            expander.expand("${EMPTY}"),
            ""
        )

        XCTAssertEqual(
            expander.expand("${SCHEME}://${HOSTNAME}/${API_PATH}/some/endpoint"),
            "https://api.example.com/v2/some/endpoint"
        )

        XCTAssertEqual(
            expander.expand("https://api.example.com/test?api_key=${API_KEY}"),
            "https://api.example.com/test?api_key=0469c53fb48a73b12a0e75e22fc52e5e38fe7849b8b5ac6b2a403eea0d27eb2f"
        )
    }
}
