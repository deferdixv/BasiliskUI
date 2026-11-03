// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BasiliskUI",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "BasiliskUI", targets: ["BasiliskUI"]),
    ],
    dependencies: [
        .package(path: "../BasiliskCore"),
        .package(path: "../MillariumCore"),
    ],
    targets: [
        .target(
            name: "BasiliskUI",
            dependencies: [
                .product(name: "BasiliskCore", package: "BasiliskCore"),
                .product(name: "MillariumCore", package: "MillariumCore"),
            ],
            resources: [
                .copy("Resources/Assets.xcassets"),
                .copy("Resources/swift-neue-lt-pro-black-condensed.otf"),
            ],
        ),
    ]
)
