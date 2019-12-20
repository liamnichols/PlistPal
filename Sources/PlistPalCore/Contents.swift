public enum Contents {
    case array([Any])
    case dictionary([String: Any])

    public var value: Any {
        switch self {
        case .array(let value):
            return value
        case .dictionary(let value):
            return value
        }
    }

    internal init(value: Any) throws {
        if let value = value as? [String: Any] {
            self = .dictionary(value)
        } else if let value = value as? [Any] {
            self = .array(value)
        } else {
            throw PropertyListError(code: .unsupportedType)
        }
    }
}
