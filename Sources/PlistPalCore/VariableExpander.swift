import Foundation

protocol VariableExpanderProtocol {
    func expandVariables(in string: String) -> String
}

class VariableExpander: NSRegularExpression, VariableExpanderProtocol {
    let values: [String: String]

    init(values: [String: String]) {
        self.values = values

        // swiftlint:disable:next force_try
        try! super.init(pattern: #"\$\{([^\}]+)\}"#, options: [])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func replacementString(
        for result: NSTextCheckingResult,
        in string: String,
        offset: Int,
        template templ: String
    ) -> String {
        // Ensure that this is querying a replacement that matches our expected regex.
        guard result.numberOfRanges == 2, let nameRange = Range(result.range(at: 1), in: string) else {
            return super.replacementString(for: result, in: string, offset: offset, template: templ)
        }

        // Lookup the value based on the given variable name
        let name = String(string[nameRange])
        let value = values[name] ?? ""

        // Return that value for complete replacement
        return value
    }

    func expandVariables(in string: String) -> String {
        super.stringByReplacingMatches(
            in: string,
            range: NSRange(string.startIndex ..< string.endIndex, in: string),
            withTemplate: "$0"
        )
    }

    @available(*, unavailable, message: "Use expandVariables(in string:) instead")
    override func stringByReplacingMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: NSRange,
        withTemplate templ: String
    ) -> String {
        fatalError("Not Implemented")
    }
}
