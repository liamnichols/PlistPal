// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlistPal",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .executable(
            name: "plistpal",
            targets: ["PlistPal"]
        ),
        .library(
            name: "PlistPalCore",
            targets: ["PlistPalCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .exact("0.0.1")),
    ],
    targets: [
        .target(
            name: "PlistPal",
            dependencies: [
                "SwiftToolsSupport-auto",
                "PlistPalCore"
            ]
        ),
        .target(
            name: "PlistPalCore",
            dependencies: []
        ),
        .testTarget(
            name: "PlistPalCoreTests",
            dependencies: [
                "PlistPalCore"
            ]
        )
    ]
)
