// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-openapi-spec-runner-vapor",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherOpenAPISpecRunnerVapor", targets: ["FeatherOpenAPISpecRunnerVapor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.87.0"),
        .package(url: "https://github.com/feather-framework/feather-openapi-spec", .upToNextMinor(from: "0.1.0")),
        
    ],
    targets: [
        .target(name: "FeatherOpenAPISpecRunnerVapor", dependencies: [
            .product(name: "FeatherOpenAPISpec", package: "feather-openapi-spec"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
        .testTarget(name: "FeatherOpenAPISpecRunnerVaporTests", dependencies: [
            .target(name: "FeatherOpenAPISpecRunnerVapor")
        ]),
    ]
)
