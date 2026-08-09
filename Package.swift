// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SHDesignSystemKit",
    platforms: [
        .iOS(.v26)
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
            path: "Sources/SHDesignSystem"
        )
    ]
)
