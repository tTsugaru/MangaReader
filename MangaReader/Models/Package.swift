// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    dependencies: [
        .package(path: "../Utility")
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Utility", package: "Utility")
            ]
        ),
    ]
)
