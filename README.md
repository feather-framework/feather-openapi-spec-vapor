# Feather Spec Vapor

The `FeatherSpecVapor` library provides a Vapor runtime for the Feather Spec tool.

## Getting started

⚠️ This repository is a work in progress, things can break until it reaches v1.0.0. 

Use at your own risk.

### Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-spec-vapor", .upToNextMinor(from: "0.3.0")),
```

and to your application target, add `FeatherSpecVapor` to your dependencies:

```swift
.product(name: "FeatherSpecVapor", package: "feather-spec-vapor")
```

Example `Package.swift` file with `FeatherSpecVapor` as a dependency:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-spec-vapor", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        .target(name: "MyApplication", dependencies: [
            .product(name: "FeatherSpecVapor", package: "feather-spec-vapor")
        ]),
        .testTarget(name: "MyApplicationTests", dependencies: [
            .target(name: "MyApplication"),
        ]),
    ]
)
```
