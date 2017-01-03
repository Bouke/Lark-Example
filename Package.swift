import PackageDescription

let package = Package(
    name: "LarkExample",
    dependencies: [
        .Package(url: "https://github.com/Bouke/Lark.git", majorVersion: 0)
    ]
)
