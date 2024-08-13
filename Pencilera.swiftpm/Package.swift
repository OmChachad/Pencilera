// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Pencilera",
    platforms: [
        .iOS("17.5")
    ],
    products: [
        .iOSApplication(
            name: "Pencilera",
            targets: ["App"],
            bundleIdentifier: "org.starlightapps.pencilera",
            teamIdentifier: "3S6NT5MUQZ",
            displayVersion: "1.0.1",
            bundleVersion: "6",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad
            ],
            supportedInterfaceOrientations: [

            ],
            capabilities: [
                .camera(purposeString: "Pencilera uses your camera to capture photos."),
                .photoLibrary(purposeString: "Pencilera needs to be able to save photos to your photo library.")
            ],
            appCategory: .photography
        )
    ],
    dependencies: [
        .package(url: "https://github.com/aheze/VariableBlurView", "1.0.2"..<"2.0.0"),
        .package(url: "https://github.com/Cindori/FluidGradient.git", "1.0.0"..<"2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "VariableBlurView", package: "VariableBlurView"),
                .product(name: "FluidGradient", package: "FluidGradient")
            ],
            path: "App",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
