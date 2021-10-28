enum Format: String {
    case xml, binary
}

import ArgumentParser

extension Format: CaseIterable,  ExpressibleByArgument {}
