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
