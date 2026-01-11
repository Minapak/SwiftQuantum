//
//  GateDTO.swift
//  SwiftQuantum
//
//  Created by SwiftQuantum on 2026-01-11.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Network-serializable Data Transfer Object for quantum gates.
//  Designed for cross-platform compatibility with Python/Qiskit backends.
//

import Foundation

// MARK: - Gate DTO

/// Data Transfer Object for quantum gate operations
///
/// GateDTO represents a quantum gate in a flat, JSON-serializable format
/// that can be easily parsed by both Swift and Python backends.
///
/// ## Qiskit Gate Naming Convention
/// The `name` field uses standard Qiskit gate names for compatibility:
/// - Single-qubit: "h", "x", "y", "z", "s", "sdg", "t", "tdg", "id"
/// - Rotation: "rx", "ry", "rz", "p" (phase), "u3"
/// - Two-qubit: "cx" (CNOT), "cz", "swap", "cp" (controlled-phase)
/// - Three-qubit: "ccx" (Toffoli)
///
/// ## Example JSON
/// ```json
/// {
///   "name": "rx",
///   "qubits": [0],
///   "params": [1.5707963267948966]
/// }
/// ```
public struct GateDTO: Codable, Equatable, Sendable {

    // MARK: - Properties

    /// Qiskit-compatible gate name
    /// Examples: "h", "x", "y", "z", "cx", "rx", "rz", "u3"
    public let name: String

    /// Target qubit indices (0-indexed)
    /// Single-qubit gates: [target]
    /// Two-qubit gates: [control, target] for cx/cz, [qubit1, qubit2] for swap
    /// Three-qubit gates: [control1, control2, target] for ccx
    public let qubits: [Int]

    /// Optional gate parameters (rotation angles, phase values)
    /// - rx, ry, rz: [angle]
    /// - p (phase): [angle]
    /// - u3: [theta, phi, lambda]
    /// - cp (controlled-phase): [angle]
    public let params: [Double]?

    // MARK: - Initialization

    /// Creates a GateDTO with the specified properties
    public init(name: String, qubits: [Int], params: [Double]? = nil) {
        self.name = name
        self.qubits = qubits
        self.params = params
    }

    // MARK: - Qiskit Gate Name Constants

    /// Standard Qiskit gate names for reference
    public enum QiskitGateName {
        // Single-qubit gates
        public static let hadamard = "h"
        public static let pauliX = "x"
        public static let pauliY = "y"
        public static let pauliZ = "z"
        public static let sGate = "s"
        public static let sDagger = "sdg"
        public static let tGate = "t"
        public static let tDagger = "tdg"
        public static let identity = "id"

        // Rotation gates
        public static let rotationX = "rx"
        public static let rotationY = "ry"
        public static let rotationZ = "rz"
        public static let phase = "p"
        public static let u3 = "u3"

        // Two-qubit gates
        public static let cnot = "cx"
        public static let cz = "cz"
        public static let swap = "swap"
        public static let controlledPhase = "cp"

        // Three-qubit gates
        public static let toffoli = "ccx"

        // Special
        public static let barrier = "barrier"
        public static let measure = "measure"
    }
}

// MARK: - QuantumCircuit.Gate to GateDTO Conversion

extension QuantumCircuit.Gate {

    /// Converts a QuantumCircuit.Gate to a GateDTO
    /// - Parameter qubitIndex: The target qubit index (default: 0)
    /// - Returns: GateDTO representation of this gate
    public func toDTO(qubitIndex: Int = 0) -> GateDTO {
        switch self {
        case .hadamard:
            return GateDTO(name: GateDTO.QiskitGateName.hadamard, qubits: [qubitIndex])

        case .pauliX:
            return GateDTO(name: GateDTO.QiskitGateName.pauliX, qubits: [qubitIndex])

        case .pauliY:
            return GateDTO(name: GateDTO.QiskitGateName.pauliY, qubits: [qubitIndex])

        case .pauliZ:
            return GateDTO(name: GateDTO.QiskitGateName.pauliZ, qubits: [qubitIndex])

        case .sGate:
            return GateDTO(name: GateDTO.QiskitGateName.sGate, qubits: [qubitIndex])

        case .sDagger:
            return GateDTO(name: GateDTO.QiskitGateName.sDagger, qubits: [qubitIndex])

        case .tGate:
            return GateDTO(name: GateDTO.QiskitGateName.tGate, qubits: [qubitIndex])

        case .tDagger:
            return GateDTO(name: GateDTO.QiskitGateName.tDagger, qubits: [qubitIndex])

        case .rotationX(let angle):
            return GateDTO(name: GateDTO.QiskitGateName.rotationX, qubits: [qubitIndex], params: [angle])

        case .rotationY(let angle):
            return GateDTO(name: GateDTO.QiskitGateName.rotationY, qubits: [qubitIndex], params: [angle])

        case .rotationZ(let angle):
            return GateDTO(name: GateDTO.QiskitGateName.rotationZ, qubits: [qubitIndex], params: [angle])

        case .phase(let angle):
            return GateDTO(name: GateDTO.QiskitGateName.phase, qubits: [qubitIndex], params: [angle])

        case .u3(let theta, let phi, let lambda):
            return GateDTO(name: GateDTO.QiskitGateName.u3, qubits: [qubitIndex], params: [theta, phi, lambda])

        case .identity:
            return GateDTO(name: GateDTO.QiskitGateName.identity, qubits: [qubitIndex])

        case .custom(let customName, _):
            // Custom gates are serialized with their name but cannot be deserialized
            return GateDTO(name: "custom_\(customName)", qubits: [qubitIndex])
        }
    }
}

// MARK: - GateDTO to QuantumCircuit.Gate Conversion

extension GateDTO {

    /// Converts a GateDTO to a QuantumCircuit.Gate
    /// - Returns: QuantumCircuit.Gate, or nil if the gate type is not supported
    public func toGate() -> QuantumCircuit.Gate? {
        switch name {
        case QiskitGateName.hadamard:
            return .hadamard

        case QiskitGateName.pauliX:
            return .pauliX

        case QiskitGateName.pauliY:
            return .pauliY

        case QiskitGateName.pauliZ:
            return .pauliZ

        case QiskitGateName.sGate:
            return .sGate

        case QiskitGateName.sDagger:
            return .sDagger

        case QiskitGateName.tGate:
            return .tGate

        case QiskitGateName.tDagger:
            return .tDagger

        case QiskitGateName.rotationX:
            guard let params = params, !params.isEmpty else { return nil }
            return .rotationX(params[0])

        case QiskitGateName.rotationY:
            guard let params = params, !params.isEmpty else { return nil }
            return .rotationY(params[0])

        case QiskitGateName.rotationZ:
            guard let params = params, !params.isEmpty else { return nil }
            return .rotationZ(params[0])

        case QiskitGateName.phase:
            guard let params = params, !params.isEmpty else { return nil }
            return .phase(params[0])

        case QiskitGateName.u3:
            guard let params = params, params.count >= 3 else { return nil }
            return .u3(theta: params[0], phi: params[1], lambda: params[2])

        case QiskitGateName.identity:
            return .identity

        default:
            // Unknown gate type
            return nil
        }
    }
}

// MARK: - DSL Gate Operations to GateDTO

extension Hadamard {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.hadamard, qubits: [qubit])
    }
}

extension PauliX {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.pauliX, qubits: [qubit])
    }
}

extension PauliY {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.pauliY, qubits: [qubit])
    }
}

extension PauliZ {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.pauliZ, qubits: [qubit])
    }
}

extension SGate {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.sGate, qubits: [qubit])
    }
}

extension TGate {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.tGate, qubits: [qubit])
    }
}

extension RX {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.rotationX, qubits: [qubit], params: [angle])
    }
}

extension RY {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.rotationY, qubits: [qubit], params: [angle])
    }
}

extension RZ {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.rotationZ, qubits: [qubit], params: [angle])
    }
}

extension U3 {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.u3, qubits: [qubit], params: [theta, phi, lambda])
    }
}

extension CNOT {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.cnot, qubits: [control, target])
    }
}

extension CZ {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.cz, qubits: [control, target])
    }
}

extension SWAP {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.swap, qubits: [qubit1, qubit2])
    }
}

extension CPhase {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.controlledPhase, qubits: [control, target], params: [angle])
    }
}

extension Toffoli {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.toffoli, qubits: [control1, control2, target])
    }
}

extension Barrier {
    public func toDTO() -> GateDTO {
        return GateDTO(name: GateDTO.QiskitGateName.barrier, qubits: qubits)
    }
}
