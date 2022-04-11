// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FlexibleGrid",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "FlexibleGrid",
      targets: ["FlexibleGrid"]),
  ],
  targets: [
    .target(
      name: "FlexibleGrid",
      dependencies: []),
    .testTarget(
      name: "FlexibleGridTests",
      dependencies: ["FlexibleGrid"]),
  ]
)
