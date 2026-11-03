// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BasiliskUI",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "BasiliskUI", targets: ["BasiliskUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/deferdixv/BasiliskCore.git", from: "1.0.0"),
        .package(url: "https://github.com/deferdixv/MillariumCore.git", from: "1.0.0"),
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
