import XCTest
@testable import PlistPalCore

final class PropertyListTests: XCTestCase {
    //
    private let fileManager = FileManager.default

    func testInitWithFileURL_XML() throws {
        // Given an XML Plist file exists on disk
        let data = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>TITLE</key>
            <string>This is a normal string</string>
            <key>APP_ID</key>
            <string>$(APP_ID)</string>
        </dict>
        </plist>
        """.data(using: .utf8)!
        let fileURL = try createFile(with: data, filename: "xml.plist")

        // When initialising an instance of PropertyList from the given fileURL
        let plist = try PropertyList(fileURL: fileURL)

        // Then the plist should be correctly loaded
        XCTAssertEqual(plist.format, .xml)
        XCTAssertEqual(plist.contents.value as? [String: String], [
            "TITLE": "This is a normal string",
            "APP_ID": "$(APP_ID)"
        ])
    }

    func testInitWithFileURL_OpenStep() throws {
        // Given an OpenStep plist exists on disk
        let data = """
        /* Ignore This */
        "TITLE" = "This is a normal string";

        /* And This */
        "APP_ID" = "$(APP_ID)";
        """.data(using: .utf8)!
        let fileURL = try createFile(with: data, filename: "openstep.plist")

        // When initialising an instance of PropertyList from the given fileURL
        let plist = try PropertyList(fileURL: fileURL)

        // Then the plist should be correctly loaded
        XCTAssertEqual(plist.format, .openStep)
        XCTAssertEqual(plist.contents.value as? [String: String], [
            "TITLE": "This is a normal string",
            "APP_ID": "$(APP_ID)"
        ])
    }

    func testInitWithFileURL_Binary() throws {
        // Given an Binary plist exists on disk
        let data = Data([
            0x62, 0x70, 0x6C, 0x69, 0x73, 0x74, 0x30, 0x30, 0xD2, 0x01, 0x02, 0x03, 0x04, 0x55, 0x54, 0x49,
            0x54, 0x4C, 0x45, 0x56, 0x41, 0x50, 0x50, 0x5F, 0x49, 0x44, 0x5F, 0x10, 0x17, 0x54, 0x68, 0x69,
            0x73, 0x20, 0x69, 0x73, 0x20, 0x61, 0x20, 0x6E, 0x6F, 0x72, 0x6D, 0x61, 0x6C, 0x20, 0x73, 0x74,
            0x72, 0x69, 0x6E, 0x67, 0x59, 0x24, 0x28, 0x41, 0x50, 0x50, 0x5F, 0x49, 0x44, 0x29, 0x08, 0x0D,
            0x13, 0x1A, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x3E
        ])
        let fileURL = try createFile(with: data, filename: "binary.plist")

        // When initialising an instance of PropertyList from the given fileURL
        let plist = try PropertyList(fileURL: fileURL)

        // Then the plist should be correctly loaded
        XCTAssertEqual(plist.format, .binary)
        XCTAssertEqual(plist.contents.value as? [String: String], [
            "TITLE": "This is a normal string",
            "APP_ID": "$(APP_ID)"
        ])
    }

    func testInitWithFileURL_NoFile() throws {
        // Given a fileURL exists without an associated file
        let fileURL = try getTemporaryDirectory().appendingPathComponent("missing.plist", isDirectory: false)
        XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))

        // When initialising an instance of PropertyList from the given fileURL
        XCTAssertThrowsError(try PropertyList(fileURL: fileURL)) { error in
            // Then the thrown error should be a `.fileNotFound` error
            XCTAssertEqual((error as? PropertyListError)?.code, .fileNotFound)
        }
    }

    func testInitWithFileURL_InvalidFormat() throws {
        // Given a text file exists on disk
        let data = """
        This is a normal string
        """.data(using: .utf8)!
        let fileURL = try createFile(with: data, filename: "invalid.txt")

        // When initialising an instance of PropertyList from the given fileURL
        XCTAssertThrowsError(try PropertyList(fileURL: fileURL)) { error in
            // Then the thrown error should be a `.invalidFormat` error
            XCTAssertEqual((error as? PropertyListError)?.code, .invalidFormat)
        }
    }

    func testWrite() throws {
        // Given a property list exists with valid data
        let plist = PropertyList(contents: .array(["1", "2", "3"]), format: .xml)

        // When writing the plist to a given file
        let fileURL = try getTemporaryDirectory().appendingPathComponent("xml.plist", isDirectory: false)
        try plist.write(to: fileURL)

        // Then the contents of that file URL should match a valid xml plist file
        XCTAssertEqual(
            try String(contentsOf: fileURL),
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <array>
            \t<string>1</string>
            \t<string>2</string>
            \t<string>3</string>
            </array>
            </plist>

            """
        )
    }

    func testWrite_formatNotSupported() throws {
        // Given a PropertyList exists with a format set to .openStep
        let plist = PropertyList(contents: .array(["A", "B", "C"]), format: .openStep)

        // When trying to write the plist to disk
        let fileURL = try getTemporaryDirectory().appendingPathComponent("openstep.plist", isDirectory: false)
        XCTAssertThrowsError(try plist.write(to: fileURL)) { error in

            // Then the thrown error should be a `.formatNotSupported` error
            XCTAssertEqual((error as? PropertyListError)?.code, .formatNotSupported)
        }
    }

    func testWrite_invalidContents() throws {
        // Given a PropertyList exists with invalid contents (i.e an NSObject that can't be serialized)
        let plist = PropertyList(contents: .dictionary(["object": NSObject()]), format: .xml)

        // When trying to write the plist to disk
        let fileURL = try getTemporaryDirectory().appendingPathComponent("xml.plist", isDirectory: false)
        XCTAssertThrowsError(try plist.write(to: fileURL)) { error in

            // Then the thrown error should be a `.invalidContents` error
            XCTAssertEqual((error as? PropertyListError)?.code, .invalidContents)
        }
    }

    // MARK: - Helpers

    private func createFile(with data: Data, filename: String) throws -> URL {
        // Get the temporary directory to store the file
        let url = try getTemporaryDirectory()
            .appendingPathComponent(filename, isDirectory: false)

        // Write the data to disk and return the url
        try data.write(to: url)
        return url
    }

    private func getTemporaryDirectory() throws -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent("PlistPal.PropertyListTests", isDirectory: true)

        // If the temporary directory already exists, just return it
        if fileManager.fileExists(atPath: url.path) {
            return url
        }

        // Otherwise try and create it
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

        // And be sure to cleanup after the test
        addTeardownBlock {
            try? self.fileManager.removeItem(at: url)
        }

        return url
    }

    // MARK: - Linux Support

    static var allTests = [
        ("testInitWithFileURL_XML", testInitWithFileURL_XML),
        ("testInitWithFileURL_OpenStep", testInitWithFileURL_OpenStep),
        ("testInitWithFileURL_Binary", testInitWithFileURL_Binary),
        ("testInitWithFileURL_NoFile", testInitWithFileURL_NoFile),
        ("testInitWithFileURL_InvalidFormat", testInitWithFileURL_InvalidFormat)
    ]
}
