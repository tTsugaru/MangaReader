// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "History",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "History",
            targets: ["History"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Styles"),
        .package(path: "../Networking")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "History",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Styles", package: "Styles"),
                .product(name: "Networking", package: "Networking")
            ]
        ),
    ]
)
