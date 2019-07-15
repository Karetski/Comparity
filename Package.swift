// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Comparity",
    products: [
        .library(name: "Comparity", targets: ["Comparity"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Karetski/Testament.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(name: "Comparity", dependencies: []),
        .testTarget(name: "ComparityTests", dependencies: ["Comparity", "Testament"]),
    ]
)
