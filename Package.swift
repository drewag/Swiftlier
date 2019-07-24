// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Swiftlier",
    platforms: [.iOS(.v8), .macOS(.v10_11), .tvOS(.v9)],
    products: [
        .library(name: "Swiftlier", targets: ["Swiftlier"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Swiftlier", dependencies: [], path: "Sources"),
        .testTarget(name: "SwiftlierTests", dependencies: ["Swiftlier"]),
    ]
)
