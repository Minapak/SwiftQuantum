//
//  QuantumCircuitDTO.swift
//  SwiftQuantum
//
//  Created by SwiftQuantum on 2026-01-11.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Network-serializable Data Transfer Object for quantum circuits.
//  Designed for cross-platform communication with Python/Qiskit backends.
//

import Foundation

// MARK: - Quantum Circuit DTO

/// Data Transfer Object for quantum circuit data
///
/// QuantumCircuitDTO provides a flat, JSON-serializable representation
/// of a quantum circuit that can be transmitted over the network and
/// parsed by both Swift clients and Python backends.
///
/// ## Architecture Flow
/// ```
/// QuantumNative (App) → SwiftQuantum (Engine/DTO) → SwiftQuantumBackend (API)
///                     → QuantumBridge (Qiskit Worker) → IBM Quantum
/// ```
///
/// ## Example JSON
/// ```json
/// {
///   "qubits": 2,
///   "cbits": 2,
///   "instructions": [
///     {"name": "h", "qubits": [0], "params": null},
///     {"name": "cx", "qubits": [0, 1], "params": null}
///   ],
///   "name": "BellState",
///   "metadata": {"version": "2.1.0"}
/// }
/// ```
public struct QuantumCircuitDTO: Codable, Equatable, Sendable {

    // MARK: - Properties

    /// Number of quantum bits in the circuit
    public let qubits: Int

    /// Number of classical bits for measurement results
    public let cbits: Int

    /// Ordered list of gate instructions
    public let instructions: [GateDTO]

    /// Optional circuit name for identification
    public let name: String?

    /// Optional metadata dictionary for additional information
    public let metadata: [String: String]?

    // MARK: - Initialization

    /// Creates a QuantumCircuitDTO with the specified properties
    /// - Parameters:
    ///   - qubits: Number of quantum bits
    ///   - cbits: Number of classical bits (defaults to qubits count)
    ///   - instructions: Array of gate instructions
    ///   - name: Optional circuit name
    ///   - metadata: Optional metadata dictionary
    public init(
        qubits: Int,
        cbits: Int? = nil,
        instructions: [GateDTO],
        name: String? = nil,
        metadata: [String: String]? = nil
    ) {
        self.qubits = qubits
        self.cbits = cbits ?? qubits
        self.instructions = instructions
        self.name = name
        self.metadata = metadata
    }

    // MARK: - Computed Properties

    /// Total number of gates in the circuit
    public var gateCount: Int {
        return instructions.count
    }

    /// Maximum qubit index used in the circuit
    public var maxQubitIndex: Int {
        return instructions.flatMap { $0.qubits }.max() ?? 0
    }

    /// Checks if the circuit contains any multi-qubit gates
    public var hasMultiQubitGates: Bool {
        return instructions.contains { $0.qubits.count > 1 }
    }

    /// Checks if all qubit indices are valid
    public var isValid: Bool {
        let maxIndex = maxQubitIndex
        return maxIndex < qubits && qubits > 0
    }
}

// MARK: - JSON Serialization

extension QuantumCircuitDTO {

    /// Encodes the DTO to JSON data
    /// - Returns: JSON data representation
    /// - Throws: EncodingError if encoding fails
    public func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(self)
    }

    /// Encodes the DTO to a JSON string
    /// - Returns: JSON string representation
    /// - Throws: EncodingError if encoding fails
    public func toJSONString() throws -> String {
        let data = try toJSON()
        guard let string = String(data: data, encoding: .utf8) else {
            throw QuantumCircuitDTOError.encodingFailed
        }
        return string
    }

    /// Creates a DTO from JSON data
    /// - Parameter data: JSON data
    /// - Returns: Decoded QuantumCircuitDTO
    /// - Throws: DecodingError if decoding fails
    public static func fromJSON(_ data: Data) throws -> QuantumCircuitDTO {
        let decoder = JSONDecoder()
        return try decoder.decode(QuantumCircuitDTO.self, from: data)
    }

    /// Creates a DTO from a JSON string
    /// - Parameter string: JSON string
    /// - Returns: Decoded QuantumCircuitDTO
    /// - Throws: DecodingError if decoding fails
    public static func fromJSONString(_ string: String) throws -> QuantumCircuitDTO {
        guard let data = string.data(using: .utf8) else {
            throw QuantumCircuitDTOError.invalidJSONString
        }
        return try fromJSON(data)
    }
}

// MARK: - Error Types

/// Errors that can occur during DTO operations
public enum QuantumCircuitDTOError: Error, LocalizedError {
    case encodingFailed
    case invalidJSONString
    case invalidQubitIndex(index: Int, maxAllowed: Int)
    case unsupportedGate(name: String)
    case missingParameters(gateName: String)

    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode QuantumCircuitDTO to JSON"
        case .invalidJSONString:
            return "Invalid JSON string encoding"
        case .invalidQubitIndex(let index, let maxAllowed):
            return "Qubit index \(index) exceeds maximum allowed index \(maxAllowed)"
        case .unsupportedGate(let name):
            return "Unsupported gate type: \(name)"
        case .missingParameters(let gateName):
            return "Missing required parameters for gate: \(gateName)"
        }
    }
}

// MARK: - QuantumCircuit Extension for DTO Conversion

extension QuantumCircuit {

    /// Converts the quantum circuit to a DTO for network transmission
    /// - Parameters:
    ///   - name: Optional name for the circuit
    ///   - metadata: Optional metadata dictionary
    /// - Returns: QuantumCircuitDTO representation
    ///
    /// Note: Single-qubit QuantumCircuit assumes qubit index 0 for all gates.
    /// For multi-qubit circuits, use DSLQuantumCircuit.toDTO() instead.
    public func toDTO(name: String? = nil, metadata: [String: String]? = nil) -> QuantumCircuitDTO {
        let gateDTOs = gates.map { step in
            step.gate.toDTO(qubitIndex: 0)
        }

        var meta = metadata ?? [:]
        meta["source"] = "SwiftQuantum"
        meta["version"] = "2.1.0"
        meta["type"] = "single_qubit"

        return QuantumCircuitDTO(
            qubits: 1,
            cbits: 1,
            instructions: gateDTOs,
            name: name,
            metadata: meta
        )
    }

    /// Creates a QuantumCircuit from a DTO
    /// - Parameter dto: The QuantumCircuitDTO to convert
    /// - Throws: QuantumCircuitDTOError if conversion fails
    /// - Returns: New QuantumCircuit instance
    ///
    /// Note: This initializer only supports single-qubit circuits (qubits == 1).
    /// For multi-qubit circuits, use QuantumRegister with DSLQuantumCircuit.
    public convenience init(fromDTO dto: QuantumCircuitDTO) throws {
        // Single-qubit QuantumCircuit only supports 1 qubit
        guard dto.qubits == 1 else {
            // For multi-qubit, user should use QuantumRegister
            self.init(qubit: .zero)

            // Still try to add gates that target qubit 0
            for instruction in dto.instructions {
                if instruction.qubits.contains(0), let gate = instruction.toGate() {
                    self.addGate(gate)
                }
            }
            return
        }

        self.init(qubit: .zero)

        for instruction in dto.instructions {
            guard let gate = instruction.toGate() else {
                throw QuantumCircuitDTOError.unsupportedGate(name: instruction.name)
            }
            self.addGate(gate)
        }
    }

    /// Creates a QuantumCircuit from JSON data
    /// - Parameter jsonData: JSON data containing circuit definition
    /// - Throws: DecodingError or QuantumCircuitDTOError
    /// - Returns: New QuantumCircuit instance
    public static func fromJSON(_ jsonData: Data) throws -> QuantumCircuit {
        let dto = try QuantumCircuitDTO.fromJSON(jsonData)
        return try QuantumCircuit(fromDTO: dto)
    }

    /// Creates a QuantumCircuit from a JSON string
    /// - Parameter jsonString: JSON string containing circuit definition
    /// - Throws: DecodingError or QuantumCircuitDTOError
    /// - Returns: New QuantumCircuit instance
    public static func fromJSONString(_ jsonString: String) throws -> QuantumCircuit {
        let dto = try QuantumCircuitDTO.fromJSONString(jsonString)
        return try QuantumCircuit(fromDTO: dto)
    }

    /// Exports the circuit to JSON data
    /// - Parameter name: Optional name for the circuit
    /// - Returns: JSON data representation
    /// - Throws: EncodingError if encoding fails
    public func toJSON(name: String? = nil) throws -> Data {
        return try toDTO(name: name).toJSON()
    }

    /// Exports the circuit to a JSON string
    /// - Parameter name: Optional name for the circuit
    /// - Returns: JSON string representation
    /// - Throws: EncodingError if encoding fails
    public func toJSONString(name: String? = nil) throws -> String {
        return try toDTO(name: name).toJSONString()
    }
}

// MARK: - DSLQuantumCircuit Extension for DTO Conversion

extension DSLQuantumCircuit {

    /// Converts the DSL quantum circuit to a DTO for network transmission
    /// - Parameter metadata: Optional additional metadata
    /// - Returns: QuantumCircuitDTO representation
    public func toDTO(metadata: [String: String]? = nil) -> QuantumCircuitDTO {
        var gateDTOs: [GateDTO] = []

        for operation in operations {
            let dto = gateOperationToDTO(operation)
            gateDTOs.append(dto)
        }

        var meta = metadata ?? [:]
        meta["source"] = "SwiftQuantum"
        meta["version"] = "2.1.0"
        meta["type"] = "multi_qubit"

        return QuantumCircuitDTO(
            qubits: numberOfQubits,
            cbits: numberOfQubits,
            instructions: gateDTOs,
            name: name,
            metadata: meta
        )
    }

    /// Helper function to convert gate operations to DTOs
    private func gateOperationToDTO(_ operation: any QuantumGateOperation) -> GateDTO {
        // Use type-specific conversion where available
        if let h = operation as? Hadamard { return h.toDTO() }
        if let x = operation as? PauliX { return x.toDTO() }
        if let y = operation as? PauliY { return y.toDTO() }
        if let z = operation as? PauliZ { return z.toDTO() }
        if let s = operation as? SGate { return s.toDTO() }
        if let t = operation as? TGate { return t.toDTO() }
        if let rx = operation as? RX { return rx.toDTO() }
        if let ry = operation as? RY { return ry.toDTO() }
        if let rz = operation as? RZ { return rz.toDTO() }
        if let u3 = operation as? U3 { return u3.toDTO() }
        if let cx = operation as? CNOT { return cx.toDTO() }
        if let cz = operation as? CZ { return cz.toDTO() }
        if let swap = operation as? SWAP { return swap.toDTO() }
        if let cp = operation as? CPhase { return cp.toDTO() }
        if let ccx = operation as? Toffoli { return ccx.toDTO() }
        if let barrier = operation as? Barrier { return barrier.toDTO() }

        // Fallback for unknown types
        return GateDTO(
            name: "unknown",
            qubits: operation.targetQubits
        )
    }

    /// Exports the DSL circuit to JSON data
    /// - Returns: JSON data representation
    /// - Throws: EncodingError if encoding fails
    public func toJSON() throws -> Data {
        return try toDTO().toJSON()
    }

    /// Exports the DSL circuit to a JSON string
    /// - Returns: JSON string representation
    /// - Throws: EncodingError if encoding fails
    public func toJSONString() throws -> String {
        return try toDTO().toJSONString()
    }
}

// MARK: - Convenience Extensions

extension QuantumCircuitDTO {

    /// Creates a simple single-qubit circuit DTO
    /// - Parameters:
    ///   - gates: Array of gate names to apply
    ///   - name: Optional circuit name
    /// - Returns: QuantumCircuitDTO for a single-qubit circuit
    public static func singleQubit(
        gates: [String],
        name: String? = nil
    ) -> QuantumCircuitDTO {
        let instructions = gates.map { gateName in
            GateDTO(name: gateName, qubits: [0])
        }
        return QuantumCircuitDTO(
            qubits: 1,
            cbits: 1,
            instructions: instructions,
            name: name
        )
    }

    /// Creates a Bell state circuit DTO
    /// - Returns: QuantumCircuitDTO for Bell state preparation
    public static func bellState() -> QuantumCircuitDTO {
        return QuantumCircuitDTO(
            qubits: 2,
            cbits: 2,
            instructions: [
                GateDTO(name: "h", qubits: [0]),
                GateDTO(name: "cx", qubits: [0, 1])
            ],
            name: "BellState",
            metadata: ["description": "Creates entangled Bell state (|00⟩ + |11⟩)/√2"]
        )
    }

    /// Creates a GHZ state circuit DTO
    /// - Parameter qubits: Number of qubits (must be >= 2)
    /// - Returns: QuantumCircuitDTO for GHZ state preparation
    public static func ghzState(qubits: Int) -> QuantumCircuitDTO {
        var instructions: [GateDTO] = [
            GateDTO(name: "h", qubits: [0])
        ]

        for i in 1..<qubits {
            instructions.append(GateDTO(name: "cx", qubits: [0, i]))
        }

        return QuantumCircuitDTO(
            qubits: qubits,
            cbits: qubits,
            instructions: instructions,
            name: "GHZ-\(qubits)",
            metadata: ["description": "Creates \(qubits)-qubit GHZ state"]
        )
    }
}
