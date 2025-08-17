import ProjectDescription

public extension Target {
    static func app(
        name: String,
        bundleId: String,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = []
    )
        -> Target
    {
        .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
    }

    static func framework(
        name: String,
        bundleId: String,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = []
    )
        -> Target
    {
        .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
    }

    static func staticLibrary(
        name: String,
        bundleId: String,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = []
    )
        -> Target
    {
        .target(
            name: name,
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
    }

    static func unitTests(
        name: String,
        bundleId: String,
        sources: SourceFilesList = ["Tests/**"],
        dependencies: [TargetDependency] = []
    )
        -> Target
    {
        .target(
            name: name,
            destinations: .iOS,
            product: .unitTests,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            sources: sources,
            dependencies: dependencies
        )
    }
}
