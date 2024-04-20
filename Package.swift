// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirePhoneOTP",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(
            name: "PhoneOTPLoginView",
            targets: ["FirePhoneOTP"]),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
        .package(url: "https://github.com/jonahaung2/CountryPhoneCodeTextField", from: .init(stringLiteral: "1.0.0")),
    ],
    targets: [
        .target(
            name: "FirePhoneOTP",
            dependencies: [
                "CountryPhoneCodeTextField",
                .product(name: "FirebaseAuth", package: "Firebase")
            ]),
        .testTarget(
            name: "FirePhoneOTPTests",
            dependencies: ["FirePhoneOTP"]),
    ]
)
