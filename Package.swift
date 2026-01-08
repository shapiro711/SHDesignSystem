// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SHDesignSystemKit",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SHDesignSystemKit",
            targets: ["SHDesignSystemKit"]
        ),
    ],
    targets: [
        .target(
            name: "SHDesignSystemKit",
            path: "Sources/SHDesignSystem",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SHDesignSystemKitTests",
            dependencies: ["SHDesignSystemKit"]
        ),
    ]
)
