enum Format: String {
    case xml, binary
}

import SPMUtility

extension Format: StringEnumArgument {
    static let completion: ShellCompletion = ShellCompletion.none
}
