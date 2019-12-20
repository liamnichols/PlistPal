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
        .package(url: "https://github.com/apple/swift-package-manager.git", .exact("0.5.0")),
    ],
    targets: [
        .target(
            name: "PlistPal",
            dependencies: [
                "SPMUtility",
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
