// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Optile",
	platforms: [
		.iOS(.v10)
	],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(name: "Network", targets: ["Network"]),
		.library(name: "PaymentUI", targets: ["PaymentUI"]),
    ],
    dependencies: [
//		.package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.4"),
//		.package(url: "https://github.com/Realm/SwiftLint", from: "0.35.0"),
	],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "Network"),
        .target(name: "PaymentUI", dependencies: ["Network"])
//		.testTarget(name: "Tests", dependencies: ["Payment"])
    ],
	swiftLanguageVersions: [
		.v5
	]
)
