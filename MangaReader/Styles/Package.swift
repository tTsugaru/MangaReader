// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Styles",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Styles",
            targets: ["Styles"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Utility"),
        .package(url: "https://github.com/onevcat/Kingfisher", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Styles",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Utility", package: "Utility"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
    ]
)
