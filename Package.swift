// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FusionLocation",
    platforms: [.macOS(.v10_14), .iOS(.v12)],
    products: [
        .library(
            name: "FusionLocation",
            targets: ["FusionLocation"]),
    ],
    dependencies: [
        .package(name: "Android", url: "https://github.com/scade-platform/swift-android.git", .branch("android/24"))        
    ],
    targets: [
        .target(
            name: "FusionLocation",
            dependencies: [
              .target(name: "FusionLocation_Common"),              
              .target(name: "FusionLocation_Apple", condition: .when(platforms: [.iOS, .macOS])),
              .target(name: "FusionLocation_Android", condition: .when(platforms: [.android])),
            ]            
        ),
        .target(
            name: "FusionLocation_Common"
        ),        
        .target(
            name: "FusionLocation_Apple",
            dependencies: [
              .target(name: "FusionLocation_Common"),
            ]                        
        ),            	
        .target(
            name: "FusionLocation_Android",
            dependencies: [
              .target(name: "FusionLocation_Common"),
              .product(name: "Android", package: "Android", condition: .when(platforms: [.android])),
              .product(name: "AndroidOS", package: "Android", condition: .when(platforms: [.android])),
              .product(name: "AndroidLocation", package: "Android", condition: .when(platforms: [.android]))              
            ],
            resources: [.copy("Generated/FusionLocation_Android.java")]         
        )
    ]
)
