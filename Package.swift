// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Swiftlier",
    products: [
        .library(name: "Swiftlier", targets: ["Swiftlier"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Swiftlier", dependencies: [], path: "Sources"),
        .testTarget(name: "SwiftlierTests", dependencies: ["Swiftlier"]),
    ]
)
