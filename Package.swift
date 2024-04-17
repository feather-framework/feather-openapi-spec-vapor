// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-spec-vapor",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherSpecVapor", targets: ["FeatherSpecVapor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.87.0"),
        .package(url: "https://github.com/feather-framework/feather-spec", .upToNextMinor(from: "0.3.0")),
        
    ],
    targets: [
        .target(name: "FeatherSpecVapor", dependencies: [
            .product(name: "FeatherSpec", package: "feather-spec"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
        .testTarget(name: "FeatherSpecVaporTests", dependencies: [
            .target(name: "FeatherSpecVapor")
        ]),
    ]
)
