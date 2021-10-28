// swift-tools-version:5.4
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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "PlistPal",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
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
