// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlistPal",
    products: [
        .executable(
            name: "PlistPal",
            targets: ["PlistPal"]
        ),
        .library(
            name: "PlistPalCore",
            targets: ["PlistPalCore"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PlistPal",
            dependencies: [
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
