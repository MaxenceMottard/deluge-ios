// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Screens",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Screens",
            targets: [
                "Screens"
            ]
        ),
    ],
    dependencies: [
        .package(path: "./Utils"),
        .package(path: "./Workers"),
        .package(url: "https://github.com/Swinject/Swinject", exact: "2.9.1"),
        .package(url: "https://github.com/kean/Nuke", from: "12.7.1"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
            ],
            path: "DesignSystem",
            resources: [
                .process("Resources")
            ],
            plugins: []
        ),
        .target(
            name: "Screens",
            dependencies: [
                "Workers",
                "Utils",
                "DesignSystem",
                .product(name: "Swinject", package: "Swinject"),
                .product(name: "NukeUI", package: "Nuke"),
            ],
            path: "Sources",
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .plugin(name: "SourceryPlugin", package: "Utils"),
            ]
        ),
        .testTarget(
            name: "ScreensTests",
            dependencies: [
                "Screens",
            ],
            path: "Tests"
        ),
    ]
)
