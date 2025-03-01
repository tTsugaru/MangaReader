// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChapterList",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ChapterList",
            targets: ["ChapterList"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Styles")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ChapterList",
            dependencies: [
                .product(name: "Models", package: "Models"),
                .product(name: "Styles", package: "Styles")
            ]
        ),
    ]
)
