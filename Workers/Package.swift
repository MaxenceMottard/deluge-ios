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
        .package(path: "./Utils"),
        .package(url: "https://github.com/Swinject/Swinject", exact: "2.9.1"),
    ],
    targets: [
        .target(
            name: "Workers",
            dependencies: [
                .product(name: "Utils", package: "Utils"),
                .product(name: "Swinject", package: "Swinject"),
            ],
            path: "Sources",
            plugins: [
                .plugin(name: "SourceryPlugin", package: "Utils"),
            ]
        ),
    ]
)
