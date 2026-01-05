// swift-tools-version: 6.0
// SwiftQuantum v2.0 - QuantumBridge Integration
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftQuantum",
    platforms: [
        .iOS(.v14),
        .macOS(.v14)
    ],
    products: [
        // Core quantum computing library
        .library(
            name: "SwiftQuantum",
            targets: ["SwiftQuantum"]),
    ],
    targets: [
        // Core library with algorithms, multi-qubit support, and bridge API
        .target(
            name: "SwiftQuantum",
            path: "Sources/SwiftQuantum",
            sources: [
                "Complex.swift",
                "Qubit.swift",
                "QuantumGates.swift",
                "QuantumCircuit.swift",
                "QubitVisualizer.swift",
                "SwiftQuantum.swift",
                "QuantumRegister.swift",
                "Algorithms/QuantumAlgorithms.swift",
                "Bridge/QuantumBridge.swift"
            ]
        ),
        .testTarget(
            name: "SwiftQuantumTests",
            dependencies: ["SwiftQuantum"]
        ),
    ]
)
