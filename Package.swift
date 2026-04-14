// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MacImageViewer",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "MacImageViewerCore", targets: ["MacImageViewerCore"]),
        .executable(name: "MacImageViewer", targets: ["MacImageViewer"]),
        .executable(name: "MacImageViewerCoreChecks", targets: ["MacImageViewerCoreChecks"])
    ],
    targets: [
        .target(
            name: "MacImageViewerCore"
        ),
        .executableTarget(
            name: "MacImageViewer",
            dependencies: ["MacImageViewerCore"]
        ),
        .executableTarget(
            name: "MacImageViewerCoreChecks",
            dependencies: ["MacImageViewerCore"]
        )
    ]
)
