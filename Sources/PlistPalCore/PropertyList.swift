import Foundation

public struct PropertyList {
    public typealias Format = PropertyListSerialization.PropertyListFormat

    /// The contents of the property list.
    var contents: Contents

    /// The format of the property list.
    var format: Format

    public init(contents: Contents = .dictionary([:]), format: Format = .xml) {
        self.contents = contents
        self.format = format
    }
}

public extension PropertyList {
    init(fileURL: URL) throws {
        do {
            let data = try Data(contentsOf: fileURL)
            var format: Format = .xml
            let value = try PropertyListSerialization.propertyList(from: data, format: &format)

            self.init(
                contents: try Contents(value: value),
                format: format
            )

        // Error handling
        } catch let error as PropertyListError {
            throw error
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            throw PropertyListError(code: .fileNotFound, underlyingError: error)
        } catch let error as CocoaError where error.code == .propertyListReadCorrupt {
            throw PropertyListError(code: .invalidFormat, underlyingError: error)
        } catch let error {
            throw PropertyListError(code: .unknown, underlyingError: error)
        }
    }

    func write(to fileURL: URL, options: Data.WritingOptions = []) throws {
        do {
            // Throw an error if we try to write openStep since it is not supported by PropertyListSerialization
            guard format != .openStep else {
                throw PropertyListError(code: .formatNotSupported)
            }

            // Ensure that the contents are valid for the given format before we write
            guard PropertyListSerialization.propertyList(contents.value, isValidFor: format) else {
                throw PropertyListError(code: .invalidContents)
            }

            // Serialize the contents into plist data for the given format
            let data = try PropertyListSerialization.data(fromPropertyList: contents.value, format: format, options: .min)

            // Write the data out to file
            try data.write(to: fileURL, options: options)

        // Error handling
        } catch let error as PropertyListError {
            throw error
        } catch let error {
            throw PropertyListError(code: .unknown, underlyingError: error)
        }
    }
}
