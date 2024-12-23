import ProjectDescription

let project = Project(
    name: "Pitstop-Tuist",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "./xcconfigs/Pitstop-Project.xcconfig"),
    ]),
    targets: [
        .target(
            name: "Pitstop-APP",
            destinations: .iOS,
            product: .app, // [!code ++] // or .staticFramework, .staticLibrary...
            bundleId: "com.academy.pitstopD",
            deploymentTargets: .iOS("16.6"),
            sources: ["Sources/**"],
            scripts: [
                .pre(
                    script: "Scripts/swiftformat.sh",
                    name: "SwiftFormat",
                    basedOnDependencyAnalysis: false
                ),
                .pre(
                    script: "Scripts/swiftlint.sh",
                    name: "SwiftLint",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                /** Dependencies go here **/
                /** .external(name: "Kingfisher") **/
                /** .target(name: "OtherProjectTarget") **/
            ],
            settings: .settings(configurations: [
                .debug(name: "Debug", xcconfig: "./xcconfigs/Debug.xcconfig"),
            ])
        ),
    ]
)
