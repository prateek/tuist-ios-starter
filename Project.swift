import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "iOSClaudeCodeStarter",
    targets: [
        // MARK: - App Target
        .app(
            name: "App",
            bundleId: "com.claudecode.starter.app",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "Claude Starter",
                    "UIUserInterfaceStyle": "Automatic",
                    "NSAppTransportSecurity": [
                        "NSAllowsLocalNetworking": true,
                        "NSExceptionDomains": [
                            "jsonplaceholder.typicode.com": [
                                "NSExceptionRequiresForwardSecrecy": false
                            ]
                        ]
                    ],
                ]
            ),
            sources: ["Projects/App/Sources/**"],
            resources: ["Projects/App/Resources/**"],
            dependencies: [
                .target(name: "Features"),
                .target(name: "DesignSystem"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        // MARK: - Features Target
        .staticLibrary(
            name: "Features",
            bundleId: "com.claudecode.starter.features",
            sources: ["Projects/Features/Sources/**"],
            dependencies: [
                .target(name: "CoreKit"),
                .target(name: "DesignSystem"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        // MARK: - CoreKit Target
        .staticLibrary(
            name: "CoreKit",
            bundleId: "com.claudecode.starter.corekit",
            sources: ["Projects/CoreKit/Sources/**"],
            resources: ["Projects/CoreKit/Sources/Data/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        // MARK: - DesignSystem Target
        .staticLibrary(
            name: "DesignSystem",
            bundleId: "com.claudecode.starter.designsystem",
            sources: ["Projects/DesignSystem/Sources/**"],
            resources: ["Projects/DesignSystem/Resources/**"]
        ),
        
        // MARK: - Testing Targets (TMA Pattern)
        .staticLibrary(
            name: "CoreKitTesting",
            bundleId: "com.claudecode.starter.corekittesting",
            sources: ["Projects/CoreKit/Testing/Sources/**"],
            dependencies: [
                .target(name: "CoreKit"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        .staticLibrary(
            name: "FeaturesTesting",
            bundleId: "com.claudecode.starter.featurestesting",
            sources: ["Projects/Features/Testing/Sources/**"],
            dependencies: [
                .target(name: "Features"),
                .target(name: "CoreKitTesting"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        .staticLibrary(
            name: "DesignSystemTesting",
            bundleId: "com.claudecode.starter.designsystemtesting",
            sources: ["Projects/DesignSystem/Testing/Sources/**"],
            dependencies: [
                .target(name: "DesignSystem"),
            ]
        ),
        
        // MARK: - Test Targets
        .unitTests(
            name: "FeaturesTests",
            bundleId: "com.claudecode.starter.featurestests",
            sources: ["Projects/Features/Tests/**"],
            dependencies: [
                .target(name: "Features"),
                .target(name: "FeaturesTesting"),
                .target(name: "DesignSystem"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        .unitTests(
            name: "CoreKitTests",
            bundleId: "com.claudecode.starter.corekittests",
            sources: ["Projects/CoreKit/Tests/**"],
            dependencies: [
                .target(name: "CoreKit"),
                .target(name: "CoreKitTesting"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
        
        .unitTests(
            name: "DesignSystemTests",
            bundleId: "com.claudecode.starter.designsystemtests",
            sources: ["Projects/DesignSystem/Tests/**"],
            dependencies: [
                .target(name: "DesignSystem"),
                .target(name: "DesignSystemTesting"),
            ]
        ),
        
        .staticLibrary(
            name: "SharedTestSupport",
            bundleId: "com.claudecode.starter.sharedtestsupport",
            sources: ["Projects/SharedTestSupport/Sources/**"],
            dependencies: [
                .target(name: "CoreKit"),
                .external(name: "ComposableArchitecture"),
            ]
        ),
    ],
    schemes: [
        // App scheme for building and running the main app
        .scheme(
            name: "App",
            shared: true,
            buildAction: .buildAction(targets: ["App"]),
            testAction: TestAction.targets(["FeaturesTests", "CoreKitTests", "DesignSystemTests"]),
            runAction: .runAction(configuration: "Debug")
        )
    ]
)