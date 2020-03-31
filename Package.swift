// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstagramKit",
    products: [
        .library(
            name: "InstagramKit",
            targets: ["InstagramKit"]),
    ],
    targets: [
        .target(
            name: "InstagramKit",
            dependencies: []),
        .testTarget(
            name: "InstagramKitTests",
            dependencies: ["InstagramKit"]),
    ]
)
