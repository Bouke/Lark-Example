import PackageDescription

let package = Package(
    name: "Lark-Example",
    dependencies: [
        .Package(url: "https://github.com/Bouke/Lark.git", majorVersion: 0)
    ]
)
