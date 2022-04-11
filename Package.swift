// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BIP44",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BIP44",
            targets: ["BIP44"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/anquii/BIP32.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/anquii/CryptoSwiftWrapper.git",
            .upToNextMajor(from: "1.4.3")
        )
    ],
    targets: [
        .target(
            name: "BIP44",
            dependencies: ["BIP32"]
        ),
        .testTarget(
            name: "BIP44Tests",
            dependencies: [
                "BIP44",
                "CryptoSwiftWrapper"
            ]
        )
    ]
)
