import TSCUtility

let parser = ArgumentParser(
    commandName: "plistpal",
    usage: "--input <filepath> [--output <filepath>] [--format {xml|binary}] [--expandVariables]",
    overview: "plistpal can be used to convert the format of a plist file or expand variables within the file in a similar way to how Info.plist files are expanded during the build process."
)

let inputOption = parser.add(
    option: "--input",
    shortName: "-i",
    kind: String.self,
    usage: "The path to plist file used for reading",
    completion: .filename
)

let outputOption = parser.add(
    option: "--output",
    shortName: "-o",
    kind: String.self,
    usage: "Optional path used for writing the output plist. If not specified, output will be written to stdout.",
    completion: .filename
)

let formatOption = parser.add(
    option: "--format",
    shortName: "-f",
    kind: Format.self,
    usage: "The format to use when writing the plist. If not specified, the original input format will be used.",
    completion: ShellCompletion.none
)

let expandVariablesOption = parser.add(
    option: "--expand-variables",
    shortName: "-e",
    kind: Bool.self,
    usage: "When present, tells plistpal to substitute variable placeholders (i.e '${SOME_VAR}') in the plist with environment variables.",
    completion: ShellCompletion.none
)

do {
    let argsv = Array(CommandLine.arguments.dropFirst())
    let parguments = try parser.parse(argsv)

    guard let inputPath = parguments.get(inputOption) else {
        throw ArgumentError.missingArgument("--input")
    }

    let command = Command(
        inputPath: inputPath,
        outputPath: parguments.get(outputOption),
        format: parguments.get(formatOption),
        isVariableExpansionEnabled: parguments.get(expandVariablesOption) == true
    )

    try command.run()

// Error Handling
} catch {
    print(String(describing: error))
}


