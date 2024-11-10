// swift-tools-version:5.5

import Foundation
import PackageDescription

var package = Package(
	name: "EverybodyCodes",
	platforms: [
		.macOS(.v12)
	],
	products: [
		.executable(name: "KingdomOfAlgorithmia2024", targets: ["KingdomOfAlgorithmia2024"])
	],
	dependencies: [
		.package(url: "https://github.com/rbruinier/AdventOfCode.git", branch: "main")
	],
	targets: [
		.executableTarget(
			name: "KingdomOfAlgorithmia2024",
			dependencies: [
				.product(
					name: "Tools",
					package: "AdventOfCode"
				)
			],
			path: "Sources/Solutions/KingdomOfAlgorithmia2024",
			resources: [
				.copy("Input"),
			],
			swiftSettings: [
				.define("Ounchecked", .when(configuration: .release)),
				.define("SWIFT_DISABLE_SAFETY_CHECKS", .when(configuration: .release)),
			]
		)
	]
)
