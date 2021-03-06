import Foundation
import PlistPalCore

struct Command {
    let inputPath: String
    let outputPath: String?
    let format: Format?
    let isVariableExpansionEnabled: Bool

    let fileManager = FileManager.default
    let stdout = FileHandle.standardOutput

    func run() throws {
        let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
        let inputFileURL = URL(fileURLWithPath: inputPath, isDirectory: false, relativeTo: currentDirectoryURL)

        // Load the plist file from the input directory
        var propertyList = try PropertyList(fileURL: inputFileURL)

        // Update its format if an override was specified
        switch format {
        case .binary?:
            propertyList.format = .binary
        case .xml?:
            propertyList.format = .xml
        case .none:
            break // don't change the format
        }

        // Expand variables if specified
        if isVariableExpansionEnabled {
            propertyList.contents.expandVariables(using: ProcessInfo.processInfo.environment)
        }

        // If an output path wasn't specified, just write to stdout
        guard let outputPath = outputPath else {
            stdout.write(try propertyList.serialize())
            return
        }

        // Get the outputFileURL, if it represents a directory then append the input filename
        var outputFileURL = URL(fileURLWithPath: outputPath, relativeTo: currentDirectoryURL)
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: outputFileURL.path, isDirectory: &isDirectory), isDirectory.boolValue {
            outputFileURL.appendPathComponent(inputFileURL.lastPathComponent)
        }

        // Write to the output fileURL
        try propertyList.write(to: outputFileURL)
    }
}
