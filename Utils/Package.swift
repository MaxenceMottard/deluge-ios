// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Utils",
            targets: [
                "Networking",
                "Routing",
                "Utils",
            ]
        ),
        .plugin(name: "SwiftGenPlugin", targets: ["SwiftGenPlugin"]),
        .plugin(name: "SourceryPlugin", targets: ["SourceryPlugin"]),
    ],
    dependencies: [
//        .package(
//          url: "https://github.com/kean/Nuke",
//          from: "12.7.1"
//        ),
    ],
    targets: [
        // MARK: Plugins

        .plugin(
            name: "SwiftGenPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftGen"],
            path: "Plugins/SwiftGen"
        ),
        .binaryTarget(
            name: "SwiftGen",
            url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.6.3/swiftgen-6.6.3.artifactbundle.zip",
            checksum: "caf1feaf93dd32bc5037f0b6ded8d0f4fe28ab5d2f6e5c3edf2572006ba0b7eb"
        ),

        .plugin(
            name: "SourceryPlugin",
            capability: .buildTool(),
            dependencies: ["Sourcery"],
            path: "Plugins/Sourcery"
        ),
        .binaryTarget(
            name: "Sourcery",
            url: "https://github.com/krzysztofzablocki/Sourcery/releases/download/2.2.5/sourcery-2.2.5.artifactbundle.zip",
            checksum: "875ef49ba5e5aeb6dc6fb3094485ee54062deb4e487827f5756a9ea75b66ffd8"
        ),

        // MARK: Libraries

        .target(
            name: "Networking",
            dependencies: [],
            path: "Networking/Sources",
            plugins: [
                .plugin(name: "SourceryPlugin")
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            path: "Networking/Tests"
        ),
        .target(
            name: "Routing",
            path: "Routing",
            plugins: [
                .plugin(name: "SourceryPlugin")
            ]
        ),
        .target(
            name: "Utils",
            path: "Utils/Sources",
            plugins: [
                .plugin(name: "SourceryPlugin")
            ]
        ),
    ]
)
