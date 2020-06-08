// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommitChecker",
    dependencies: [
        .package(name: "Ink", url: "https://github.com/johnsundell/ink.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "CommitChecker",
            dependencies: ["Ink"]
        ),
        .testTarget(
            name: "CommitCheckerTests",
            dependencies: ["CommitChecker"]),
    ]
)
