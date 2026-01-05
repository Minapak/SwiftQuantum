//
//  SwiftQuantum.swift
//  SwiftQuantum v2.0 - QuantumBridge Integration
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  Main module file - exports all public types
//

import Foundation

// MARK: - SwiftQuantum v2.0
//
// A comprehensive quantum computing framework for iOS/macOS
// Integrating QuantumBridge features for IBM Quantum connectivity
//
// Features:
// - Single & Multi-Qubit States (up to 20 qubits)
// - 15+ Quantum Gates (H, X, Y, Z, S, T, CNOT, CZ, SWAP, Toffoli, etc.)
// - 4 Major Quantum Algorithms (Bell State, Deutsch-Jozsa, Grover, Simon)
// - IBM Quantum Integration via Bridge API
// - QASM Export for Real Hardware
// - Educational Visualizations
//
// Performance:
// - Single gate: ~1µs
// - Circuit execution: ~10µs
// - 1000 shots measurement: ~50µs
//
// Repository: https://github.com/Minapak/SwiftQuantum
// QuantumBridge: https://github.com/Minapak/QuantumBridge

/// SwiftQuantum Version Information
public struct SwiftQuantumVersion {
    /// Current version string
    public static let version = "2.0.0"

    /// Build date
    public static let buildDate = "2025-01-05"

    /// QuantumBridge compatibility
    public static let bridgeCompatibility = "1.0"

    /// Maximum supported qubits
    public static let maxQubits = 20

    /// Framework description
    public static var description: String {
        """
        SwiftQuantum v\(version)
        QuantumBridge Integration
        Build: \(buildDate)
        Max Qubits: \(maxQubits)

        Features:
        - Complex number mathematics
        - Single qubit (Qubit) and multi-qubit (QuantumRegister) support
        - 15+ quantum gates including multi-qubit operations
        - 4 major quantum algorithms
        - IBM Quantum Bridge API
        - QASM circuit export

        © 2025 iOS Quantum Engineering. MIT License.
        """
    }
}
