enum ArgumentError: Swift.Error, CustomStringConvertible {
    case missingArgument(String)

    var description: String {
        switch self {
        case .missingArgument(let name):
            return "Missing argument named '\(name)'."
        }
    }
}
