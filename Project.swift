import ProjectDescription

let project = Project(
    name: "Pitstop-Tuist",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "./xcconfigs/Pitstop-Project.xcconfig"),
    ]),
    targets: [
        .target(
            name: "Debug",
            destinations: .iOS,
            product: .framework, // [!code ++] // or .staticFramework, .staticLibrary...
            bundleId: "com.academy.pitstopD",
            sources: ["Hurricane/**"],
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
