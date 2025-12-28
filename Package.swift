// swift-tools-version: 5.10

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "NewType",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13),
  ],
  products: [
    .library(
      name: "NewType",
      targets: ["NewType"],
    ),
    .executable(
      name: "NewTypeClient",
      targets: ["NewTypeClient"],
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.6.3"),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0-latest"),
  ],
  targets: [
    .macro(
      name: "NewTypeCompilerPlugin",
      dependencies: [
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ],
    ),
    .testTarget(
      name: "NewTypeCompilerPluginTests",
      dependencies: [
        .target(name: "NewTypeCompilerPlugin"),
        .product(name: "MacroTesting", package: "swift-macro-testing"),
      ],
    ),
    .target(
      name: "NewType",
      dependencies: ["NewTypeCompilerPlugin"],
    ),
    .executableTarget(
      name: "NewTypeClient",
      dependencies: ["NewType"],
    ),
  ],
)
