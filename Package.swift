// swift-tools-version: 6.0
// SwiftQuantum v2.1.0 - Premium Quantum Hybrid Platform
// High-Performance iOS Quantum Computing Engine with Harvard-MIT Research Integration
//
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Features:
// - Accelerate framework for SIMD-optimized linear algebra
// - Harvard-MIT 2025 noise models for realistic quantum simulation
// - SwiftUI-style Result Builder DSL for declarative circuit construction
// - Multi-language localization support (EN, KO, JA, ZH-Hans)
// - QuantumBridge API for IBM Quantum hardware connectivity

import PackageDescription

let package = Package(
    name: "SwiftQuantum",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
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
                // Core types
                "Complex.swift",
                "Qubit.swift",
                "QuantumGates.swift",
                "QuantumCircuit.swift",
                "QubitVisualizer.swift",
                "SwiftQuantum.swift",
                "QuantumRegister.swift",
                // High-performance linear algebra (Accelerate framework)
                "Core/LinearAlgebra.swift",
                // Harvard-MIT noise models
                "Core/NoiseModel.swift",
                // SwiftUI-style DSL
                "DSL/QuantumCircuitBuilder.swift",
                // Algorithms
                "Algorithms/QuantumAlgorithms.swift",
                // Bridge API
                "Bridge/QuantumBridge.swift",
                "Bridge/QuantumExecutor.swift",
                // Localization
                "Localization/QuantumLocalizedStrings.swift",
                // Serialization (DTO for network communication)
                "Serialization/GateDTO.swift",
                "Serialization/QuantumCircuitDTO.swift"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SwiftQuantumTests",
            dependencies: ["SwiftQuantum"]
        ),
    ]
)
