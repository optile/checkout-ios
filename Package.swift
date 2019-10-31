// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Optile",
	platforms: [
		.iOS(.v10)
	],
    products: [
		.library(name: "Optile", targets: ["Payment"]),
    ],
    dependencies: [
//		.package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.4"),
//		.package(url: "https://github.com/Realm/SwiftLint", from: "0.35.0"),
	],
    targets: [
		.target(name: "Payment", path: "Sources"),
		
		.testTarget(name: "PaymentTests", dependencies: ["Payment"], path: "Tests")
    ],
	swiftLanguageVersions: [
		.v5
	]
)
