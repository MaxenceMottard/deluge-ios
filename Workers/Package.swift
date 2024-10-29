// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Workers",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Workers",
            targets: ["Workers"]
        ),
    ],
    dependencies: [
        .package(path: "./Utils")
    ],
    targets: [
        .target(
            name: "Workers",
            dependencies: [
                .product(name: "Utils", package: "Utils"),
            ],
            path: "Sources"
        ),
    ]
)
