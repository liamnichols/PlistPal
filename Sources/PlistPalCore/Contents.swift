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

// MARK: - Expansion

import Foundation

public extension Contents {
    mutating func expandVariables(using values: [String: String]) {
        self = expandingVariables(using: values)
    }

    func expandingVariables(using values: [String: String]) -> Contents {
        // Create the expander with the input variables
        let expander = VariableExpander(values: values)

        // Based on the contents type, map the values through the expander
        switch self {
        case .array(let array):
            return .array(array.map { expandVariables(in: $0, using: expander) })
        case .dictionary(let dictionary):
            return .dictionary(dictionary.mapValues { expandVariables(in: $0, using: expander) })
        }
    }

    private func expandVariables(in object: Any, using expander: VariableExpander) -> Any {
        switch object {
        case let string as String:
            return expander.expand(string)

        case let array as [Any]:
            return array.map { expandVariables(in: $0, using: expander) }

        case let dictionary as [String: Any]:
            return dictionary.mapValues { expandVariables(in: $0, using: expander) }

        case _:
            return object
        }
    }
}
