// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pipe",
    platforms: [
        .iOS(.v11), .macOS(.v10_15), .watchOS(.v2), .tvOS(.v9)
    ],
    products: [
        .library(
            name: "Pipe",
            targets: ["Pipe"]),
    ],
    targets: [
        .target(
            name: "Pipe",
            dependencies: []),
        .testTarget(
            name: "PipeTests",
            dependencies: ["Pipe"]),
    ]
)
