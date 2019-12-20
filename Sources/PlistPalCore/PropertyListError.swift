public struct PropertyListError: Error {
    public enum Code: Int {
        /// A file at a specified path could not be located.
        case fileNotFound

        /// The contents of a file was not a valid plist format.
        case invalidFormat

        /// The type of data deserialised is not supported.
        case unsupportedType

        /// The specified format is not supported for the given contents
        case formatNotSupported

        /// The contents is not valid for writing to the given format.
        case invalidContents

        /// An unknown error was caught. Refer to `underlyingError` for more information.
        case unknown
    }

    public let code: Code

    public let underlyingError: Error?

    public init(code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}

import Foundation

extension PropertyListError: CustomStringConvertible {
    public var description: String {
        switch (code, underlyingError) {
        case (.fileNotFound, let error as CocoaError):
            return "The file could not be found '\(error.filePath ?? "")'."
        case (.fileNotFound, _):
            return "The file could not be found."

        case (.invalidFormat, _):
            return "The plist is using an unsupported format."

        case (.unsupportedType, _):
            return "The top-level data is not of a supported type."

        case (.formatNotSupported, _):
            return "The specified format is not supported for the given contents."

        case (.invalidContents, _):
            return "The contents is not valid for writing to the given format."

        case (.unknown, let error?):
            return error.localizedDescription
        case (.unknown, .none):
            return "Unknown error."
        }
    }
}
