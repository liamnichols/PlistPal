import ArgumentParser
import Foundation
import PlistPalCore

@main
struct Command: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "plistpal",
        abstract: "plistpal can be used to convert the format of a plist file or expand variables within the file in a similar way to how Info.plist files are expanded during the build process."
    )

    @Option(
        name: [.customLong("input"), .short],
        help: "The path to plist file used for reading",
        completion: .file()
    )
    var inputPath: String

    @Option(
        name: [.customLong("output"), .short],
        help: "Optional path used for writing the output plist. If not specified, output will be written to stdout.",
        completion: .file()
    )
    var outputPath: String?

    @Option(
        name: .shortAndLong,
        help: "The format to use when writing the plist. If not specified, the original input format will be used.",
        completion: .list(Format.allCases.map(\.rawValue))
    )
    var format: Format?

    @Flag(
        name: [.customLong("expandVariables"), .customShort("e")],
        help: "When present, tells plistpal to substitute variable placeholders (i.e '${SOME_VAR}') in the plist with environment variables."
    )
    var isVariableExpansionEnabled: Bool = false

    mutating func run() throws {
        let fileManager = FileManager.default
        let stdout = FileHandle.standardOutput
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
