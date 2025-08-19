// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [:],
        targetSettings: [
            "SwiftNavigation": .settings(
                base: [
                    "OTHER_SWIFT_FLAGS": .array([]),
                ]
            ),
        ]
    )
#endif

let package = Package(
    name: "Dependencies",
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMinor(from: "1.21.1")
        ),
    ]
)
