# PlistPal

**plistpal** can be used to convert the format of a plist file or expand variables within the file in a similar way to how Info.plist files are expanded during the build process.

```
$ plistpal -h                                                                       
OVERVIEW: plistpal can be used to convert the format of a plist file or expand
variables within the file in a similar way to how Info.plist files are expanded
during the build process.

USAGE: plistpal --input <input> [--output <output>] [--format <format>] [--expand-variables]

OPTIONS:
  -i, --input <input>     The path to plist file used for reading
  -o, --output <output>   Optional path used for writing the output plist. If
                          not specified, output will be written to stdout.
  -f, --format <format>   The format to use when writing the plist. If not
                          specified, the original input format will be used.
  -e, --expand-variables  When present, tells plistpal to substitute variable
                          placeholders (i.e '${SOME_VAR}') in the plist with
                          environment variables.
  -h, --help              Show help information.
```

## Use Case

As an exmaple, if you have a .plist file in your iOS or macOS project that you'd like to either compress (using binary format) or inject build settings then you can execute the following command in a custom Build Rule within Xcode: 

```
plistpal --input "${SCRIPT_INPUT_FILE}" --output "${SCRIPT_OUTPUT_FILE_0}" --format binary --expand-variables 
```
