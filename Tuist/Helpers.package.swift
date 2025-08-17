// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProjectDescriptionHelpers",
    products: [
        .library(
            name: "ProjectDescriptionHelpers",
            targets: ["ProjectDescriptionHelpers"]
        ),
    ],
    targets: [
        .target(
            name: "ProjectDescriptionHelpers"
        ),
    ]
)
