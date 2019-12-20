enum Format: String {
    case xml, binary
}

import TSCUtility

extension Format: StringEnumArgument {
    static let completion: ShellCompletion = ShellCompletion.none
}
