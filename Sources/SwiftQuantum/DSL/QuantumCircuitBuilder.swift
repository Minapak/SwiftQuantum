//
//  QuantumCircuitBuilder.swift
//  SwiftQuantum v2.1.0 - SwiftUI-Style Quantum Circuit DSL
//
//  Created by Eunmin Park on 2026-01-08.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Swift Result Builder implementation for declarative quantum circuit construction
//  Inspired by SwiftUI's @ViewBuilder pattern
//
//  Usage Example:
//  ```swift
//  let circuit = DSLQuantumCircuit(numberOfQubits: 2) {
//      Hadamard(0)
//      CNOT(control: 0, target: 1)
//  }
//  ```
//

import Foundation

// MARK: - Gate Operation Protocol

/// Protocol for quantum gate operations in the DSL
public protocol QuantumGateOperation: Sendable {
    /// Applies the gate operation to a quantum register
    func apply(to register: QuantumRegister)

    /// Returns the QASM representation of this gate
    var qasmRepresentation: String { get }

    /// Number of qubits this gate operates on
    var qubitCount: Int { get }

    /// The qubits this gate targets
    var targetQubits: [Int] { get }
}

// MARK: - Single Qubit Gates

/// Hadamard gate - creates superposition
public struct Hadamard: QuantumGateOperation {
    public let qubit: Int

    public init(_ qubit: Int) {
        self.qubit = qubit
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.hadamard, to: qubit)
    }

    public var qasmRepresentation: String { "h q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Pauli-X gate (NOT gate)
public struct PauliX: QuantumGateOperation {
    public let qubit: Int

    public init(_ qubit: Int) {
        self.qubit = qubit
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.pauliX, to: qubit)
    }

    public var qasmRepresentation: String { "x q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Pauli-Y gate
public struct PauliY: QuantumGateOperation {
    public let qubit: Int

    public init(_ qubit: Int) {
        self.qubit = qubit
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.pauliY, to: qubit)
    }

    public var qasmRepresentation: String { "y q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Pauli-Z gate
public struct PauliZ: QuantumGateOperation {
    public let qubit: Int

    public init(_ qubit: Int) {
        self.qubit = qubit
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.pauliZ, to: qubit)
    }

    public var qasmRepresentation: String { "z q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// S gate (√Z)
public struct SGate: QuantumGateOperation {
    public let qubit: Int

    public init(_ qubit: Int) {
        self.qubit = qubit
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.sGate, to: qubit)
    }

    public var qasmRepresentation: String { "s q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// T gate (π/8 gate)
public struct TGate: QuantumGateOperation {
    public let qubit: Int

    public init(_ qubit: Int) {
        self.qubit = qubit
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.tGate, to: qubit)
    }

    public var qasmRepresentation: String { "t q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Rotation around X-axis
public struct RX: QuantumGateOperation {
    public let qubit: Int
    public let angle: Double

    public init(_ qubit: Int, angle: Double) {
        self.qubit = qubit
        self.angle = angle
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.rotationX(angle), to: qubit)
    }

    public var qasmRepresentation: String { "rx(\(angle)) q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Rotation around Y-axis
public struct RY: QuantumGateOperation {
    public let qubit: Int
    public let angle: Double

    public init(_ qubit: Int, angle: Double) {
        self.qubit = qubit
        self.angle = angle
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.rotationY(angle), to: qubit)
    }

    public var qasmRepresentation: String { "ry(\(angle)) q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Rotation around Z-axis
public struct RZ: QuantumGateOperation {
    public let qubit: Int
    public let angle: Double

    public init(_ qubit: Int, angle: Double) {
        self.qubit = qubit
        self.angle = angle
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.rotationZ(angle), to: qubit)
    }

    public var qasmRepresentation: String { "rz(\(angle)) q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

/// Universal U3 gate
public struct U3: QuantumGateOperation {
    public let qubit: Int
    public let theta: Double
    public let phi: Double
    public let lambda: Double

    public init(_ qubit: Int, theta: Double, phi: Double, lambda: Double) {
        self.qubit = qubit
        self.theta = theta
        self.phi = phi
        self.lambda = lambda
    }

    public func apply(to register: QuantumRegister) {
        register.applyGate(.u3(theta: theta, phi: phi, lambda: lambda), to: qubit)
    }

    public var qasmRepresentation: String { "u3(\(theta),\(phi),\(lambda)) q[\(qubit)];" }
    public var qubitCount: Int { 1 }
    public var targetQubits: [Int] { [qubit] }
}

// MARK: - Two Qubit Gates

/// CNOT (Controlled-NOT) gate
public struct CNOT: QuantumGateOperation {
    public let control: Int
    public let target: Int

    public init(control: Int, target: Int) {
        self.control = control
        self.target = target
    }

    public func apply(to register: QuantumRegister) {
        register.applyCNOT(control: control, target: target)
    }

    public var qasmRepresentation: String { "cx q[\(control)],q[\(target)];" }
    public var qubitCount: Int { 2 }
    public var targetQubits: [Int] { [control, target] }
}

/// CZ (Controlled-Z) gate
public struct CZ: QuantumGateOperation {
    public let control: Int
    public let target: Int

    public init(control: Int, target: Int) {
        self.control = control
        self.target = target
    }

    public func apply(to register: QuantumRegister) {
        register.applyCZ(control: control, target: target)
    }

    public var qasmRepresentation: String { "cz q[\(control)],q[\(target)];" }
    public var qubitCount: Int { 2 }
    public var targetQubits: [Int] { [control, target] }
}

/// SWAP gate
public struct SWAP: QuantumGateOperation {
    public let qubit1: Int
    public let qubit2: Int

    public init(_ qubit1: Int, _ qubit2: Int) {
        self.qubit1 = qubit1
        self.qubit2 = qubit2
    }

    public func apply(to register: QuantumRegister) {
        register.applySWAP(qubit1: qubit1, qubit2: qubit2)
    }

    public var qasmRepresentation: String { "swap q[\(qubit1)],q[\(qubit2)];" }
    public var qubitCount: Int { 2 }
    public var targetQubits: [Int] { [qubit1, qubit2] }
}

/// Controlled-Phase gate
public struct CPhase: QuantumGateOperation {
    public let control: Int
    public let target: Int
    public let angle: Double

    public init(control: Int, target: Int, angle: Double) {
        self.control = control
        self.target = target
        self.angle = angle
    }

    public func apply(to register: QuantumRegister) {
        register.applyControlledPhase(control: control, target: target, angle: angle)
    }

    public var qasmRepresentation: String { "cp(\(angle)) q[\(control)],q[\(target)];" }
    public var qubitCount: Int { 2 }
    public var targetQubits: [Int] { [control, target] }
}

// MARK: - Three Qubit Gates

/// Toffoli (CCNOT) gate
public struct Toffoli: QuantumGateOperation {
    public let control1: Int
    public let control2: Int
    public let target: Int

    public init(control1: Int, control2: Int, target: Int) {
        self.control1 = control1
        self.control2 = control2
        self.target = target
    }

    public func apply(to register: QuantumRegister) {
        register.applyToffoli(control1: control1, control2: control2, target: target)
    }

    public var qasmRepresentation: String { "ccx q[\(control1)],q[\(control2)],q[\(target)];" }
    public var qubitCount: Int { 3 }
    public var targetQubits: [Int] { [control1, control2, target] }
}

// MARK: - Barrier (for visualization)

/// Barrier - visual separator in circuit diagram
public struct Barrier: QuantumGateOperation {
    public let qubits: [Int]

    public init(_ qubits: Int...) {
        self.qubits = qubits
    }

    public init(all: Int) {
        self.qubits = Array(0..<all)
    }

    public func apply(to register: QuantumRegister) {
        // Barrier is just for visualization, no operation
    }

    public var qasmRepresentation: String {
        let qubitStr = qubits.map { "q[\($0)]" }.joined(separator: ",")
        return "barrier \(qubitStr);"
    }

    public var qubitCount: Int { qubits.count }
    public var targetQubits: [Int] { qubits }
}

// MARK: - Result Builder

/// Result builder for declarative quantum circuit construction
@resultBuilder
public struct QuantumCircuitDSLBuilder {

    public static func buildBlock(_ components: [any QuantumGateOperation]...) -> [any QuantumGateOperation] {
        return components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[any QuantumGateOperation]]) -> [any QuantumGateOperation] {
        return components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [any QuantumGateOperation]?) -> [any QuantumGateOperation] {
        return component ?? []
    }

    public static func buildEither(first component: [any QuantumGateOperation]) -> [any QuantumGateOperation] {
        return component
    }

    public static func buildEither(second component: [any QuantumGateOperation]) -> [any QuantumGateOperation] {
        return component
    }

    public static func buildExpression(_ expression: any QuantumGateOperation) -> [any QuantumGateOperation] {
        return [expression]
    }

    public static func buildLimitedAvailability(_ component: [any QuantumGateOperation]) -> [any QuantumGateOperation] {
        return component
    }
}

// MARK: - DSL Circuit

/// Quantum circuit built using the DSL
public class DSLQuantumCircuit: @unchecked Sendable {
    public let operations: [any QuantumGateOperation]
    public let numberOfQubits: Int
    public let name: String

    /// Creates a circuit from DSL operations
    public init(
        numberOfQubits: Int,
        name: String = "DSLCircuit",
        @QuantumCircuitDSLBuilder _ builder: () -> [any QuantumGateOperation]
    ) {
        self.numberOfQubits = numberOfQubits
        self.name = name
        self.operations = builder()
    }

    /// Auto-detect qubit count from operations
    public init(
        name: String = "DSLCircuit",
        @QuantumCircuitDSLBuilder _ builder: () -> [any QuantumGateOperation]
    ) {
        self.name = name
        self.operations = builder()
        self.numberOfQubits = (operations.flatMap { $0.targetQubits }.max() ?? 0) + 1
    }

    /// Number of gates in the circuit
    public var gateCount: Int {
        return operations.count
    }

    /// Circuit depth (simplified - equals gate count for single thread)
    public var depth: Int {
        return operations.count
    }

    /// Executes the circuit and returns measurement results
    public func execute(shots: Int = 1000) -> [String: Int] {
        let register = QuantumRegister(numberOfQubits: numberOfQubits)

        for operation in operations {
            operation.apply(to: register)
        }

        return register.measureMultiple(shots: shots)
    }

    /// Executes the circuit and returns the final state
    public func executeAndGetState() -> QuantumRegister {
        let register = QuantumRegister(numberOfQubits: numberOfQubits)

        for operation in operations {
            operation.apply(to: register)
        }

        return register
    }

    /// Executes with noise model
    public func executeWithNoise(
        noiseModel: any QuantumNoiseModel,
        shots: Int = 1000
    ) -> [String: Int] {
        let register = QuantumRegister(numberOfQubits: numberOfQubits)

        for (index, operation) in operations.enumerated() {
            operation.apply(to: register)
            // Apply noise after each gate
            register.applyNoiseModel(noiseModel, gateDepth: index + 1)
        }

        return register.measureMultiple(shots: shots)
    }

    /// Generates OpenQASM 2.0 code
    public func toQASM() -> String {
        var qasm = "OPENQASM 2.0;\n"
        qasm += "include \"qelib1.inc\";\n\n"
        qasm += "// Circuit: \(name)\n"
        qasm += "// Generated by SwiftQuantum v2.1.0\n\n"
        qasm += "qreg q[\(numberOfQubits)];\n"
        qasm += "creg c[\(numberOfQubits)];\n\n"

        for operation in operations {
            qasm += operation.qasmRepresentation + "\n"
        }

        // Add measurement
        qasm += "\n// Measurement\n"
        for i in 0..<numberOfQubits {
            qasm += "measure q[\(i)] -> c[\(i)];\n"
        }

        return qasm
    }

    /// ASCII circuit diagram
    public func asciiDiagram() -> String {
        var lines: [[String]] = Array(repeating: [], count: numberOfQubits)

        for qubit in 0..<numberOfQubits {
            lines[qubit].append("q\(qubit): ")
        }

        for operation in operations {
            for qubit in 0..<numberOfQubits {
                if operation.targetQubits.contains(qubit) {
                    lines[qubit].append("─[\(type(of: operation))]─")
                } else {
                    lines[qubit].append("─────────────")
                }
            }
        }

        return lines.map { $0.joined() }.joined(separator: "\n")
    }
}

// MARK: - Convenience Factory Methods

/// Factory methods for creating common quantum circuits
public struct QuantumCircuitFactory {

    /// Creates a Bell state circuit
    public static func bellState() -> DSLQuantumCircuit {
        let register = QuantumRegister(numberOfQubits: 2)
        register.applyGate(.hadamard, to: 0)
        register.applyCNOT(control: 0, target: 1)

        return DSLQuantumCircuit(numberOfQubits: 2, name: "BellState") {
            Hadamard(0)
            CNOT(control: 0, target: 1)
        }
    }

    /// Creates a GHZ state circuit for n qubits
    public static func ghzState(qubits: Int) -> DSLQuantumCircuit {
        var ops: [any QuantumGateOperation] = [Hadamard(0)]
        for i in 1..<qubits {
            ops.append(CNOT(control: 0, target: i))
        }

        return DSLQuantumCircuit(numberOfQubits: qubits, name: "GHZ-\(qubits)") {
            Hadamard(0)
            CNOT(control: 0, target: 1)
        }
    }

    /// Creates a quantum teleportation circuit
    public static func teleportation() -> DSLQuantumCircuit {
        return DSLQuantumCircuit(numberOfQubits: 3, name: "Teleportation") {
            // Prepare Bell pair between qubits 1 and 2
            Hadamard(1)
            CNOT(control: 1, target: 2)
            // Bell measurement on qubits 0 and 1
            CNOT(control: 0, target: 1)
            Hadamard(0)
        }
    }
}

// MARK: - Repeat Gate Structure

/// Repeat gates multiple times
public struct RepeatGates: QuantumGateOperation {
    public let count: Int
    public let storedOperations: [any QuantumGateOperation]

    public init(
        _ count: Int,
        @QuantumCircuitDSLBuilder _ builder: () -> [any QuantumGateOperation]
    ) {
        self.count = count
        self.storedOperations = builder()
    }

    public func apply(to register: QuantumRegister) {
        for _ in 0..<count {
            for operation in storedOperations {
                operation.apply(to: register)
            }
        }
    }

    public var qasmRepresentation: String {
        let ops = storedOperations.map { $0.qasmRepresentation }.joined(separator: " ")
        return "// Repeat \(count) times: \(ops)"
    }

    public var qubitCount: Int {
        return storedOperations.flatMap { $0.targetQubits }.max() ?? 0
    }

    public var targetQubits: [Int] {
        return Array(Set(storedOperations.flatMap { $0.targetQubits }))
    }
}

// MARK: - Apply to Range

/// Apply a gate to a range of qubits
public struct ApplyToRange: QuantumGateOperation {
    public let qubits: [Int]
    public let gateType: GateType

    public enum GateType: Sendable {
        case hadamard
        case pauliX
        case pauliY
        case pauliZ
    }

    public init(_ range: Range<Int>, gate: GateType) {
        self.qubits = Array(range)
        self.gateType = gate
    }

    public init(_ qubits: [Int], gate: GateType) {
        self.qubits = qubits
        self.gateType = gate
    }

    public func apply(to register: QuantumRegister) {
        for qubit in qubits {
            switch gateType {
            case .hadamard:
                register.applyGate(.hadamard, to: qubit)
            case .pauliX:
                register.applyGate(.pauliX, to: qubit)
            case .pauliY:
                register.applyGate(.pauliY, to: qubit)
            case .pauliZ:
                register.applyGate(.pauliZ, to: qubit)
            }
        }
    }

    public var qasmRepresentation: String {
        let gateName: String
        switch gateType {
        case .hadamard: gateName = "h"
        case .pauliX: gateName = "x"
        case .pauliY: gateName = "y"
        case .pauliZ: gateName = "z"
        }
        return qubits.map { "\(gateName) q[\($0)];" }.joined(separator: "\n")
    }

    public var qubitCount: Int { qubits.count }
    public var targetQubits: [Int] { qubits }
}
