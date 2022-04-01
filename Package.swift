// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScheduleKit",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8)],
    products: [
        .library(
            name: "ScheduleKit",
            targets: ["ScheduleKit"]),
    ],
    dependencies: [
        .package(url: "git@github.com:1amageek/SwiftColor.git", branch: "main"),
        .package(url: "git@github.com:1amageek/DocumentID.git", branch: "main"),
        .package(url: "git@github.com:1amageek/RecurrenceRule.git", branch: "main"),
        .package(url: "git@github.com:1amageek/CalendarUI.git", from: "1.0.1"),
        .package(url: "git@github.com:1amageek/TrackEditor.git", from: "0.5.1")
    ],
    targets: [
        .target(
            name: "ScheduleKit",
            dependencies: [
                .product(name: "SwiftColor", package: "SwiftColor"),
                .product(name: "DocumentID", package: "DocumentID"),
                .product(name: "RecurrenceRule", package: "RecurrenceRule"),
                .product(name: "CalendarUI", package: "CalendarUI"),
                .product(name: "TrackEditor", package: "TrackEditor")
            ]),
        .testTarget(
            name: "ScheduleKitTests",
            dependencies: ["ScheduleKit"]),
    ]
)
