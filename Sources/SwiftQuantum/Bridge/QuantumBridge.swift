//
//  QuantumBridge.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  Bridge API for Swift-Python interoperability
//  Enables communication with IBM Quantum and Qiskit ecosystem
//

import Foundation

// MARK: - QuantumBridge API
//
// This module provides a bridge between SwiftQuantum and external quantum
// computing platforms like IBM Quantum through a JSON-based API.
//
// Key Features:
// 1. Circuit serialization/deserialization (JSON/QASM)
// 2. Result format conversion
// 3. Job management interface
// 4. Error mitigation settings

/// Bridge for Swift-Python quantum computing interoperability
public struct QuantumBridge {

    // MARK: - Circuit Serialization

    /// Represents a serializable quantum circuit
    public struct SerializedCircuit: Codable {
        public let version: String
        public let numberOfQubits: Int
        public let gates: [SerializedGate]
        public let metadata: CircuitMetadata

        public init(circuit: QuantumRegister, name: String = "circuit") {
            self.version = "2.0"
            self.numberOfQubits = circuit.numberOfQubits
            self.gates = []  // Gates would be tracked separately
            self.metadata = CircuitMetadata(name: name, createdAt: Date())
        }
    }

    /// Serialized gate representation
    public struct SerializedGate: Codable {
        public let name: String
        public let qubits: [Int]
        public let parameters: [Double]?

        public init(name: String, qubits: [Int], parameters: [Double]? = nil) {
            self.name = name
            self.qubits = qubits
            self.parameters = parameters
        }
    }

    /// Circuit metadata
    public struct CircuitMetadata: Codable {
        public let name: String
        public let createdAt: Date
        public let source: String

        public init(name: String, createdAt: Date, source: String = "SwiftQuantum") {
            self.name = name
            self.createdAt = createdAt
            self.source = source
        }
    }

    // MARK: - QASM Export

    /// Converts a circuit description to OpenQASM 2.0 format
    public static func toQASM(
        numberOfQubits: Int,
        gates: [(name: String, qubits: [Int], params: [Double]?)]
    ) -> String {
        var qasm = "OPENQASM 2.0;\n"
        qasm += "include \"qelib1.inc\";\n\n"
        qasm += "qreg q[\(numberOfQubits)];\n"
        qasm += "creg c[\(numberOfQubits)];\n\n"

        for gate in gates {
            let qubitStr = gate.qubits.map { "q[\($0)]" }.joined(separator: ", ")

            switch gate.name.lowercased() {
            case "h", "hadamard":
                qasm += "h \(qubitStr);\n"
            case "x", "paulix":
                qasm += "x \(qubitStr);\n"
            case "y", "pauliy":
                qasm += "y \(qubitStr);\n"
            case "z", "pauliz":
                qasm += "z \(qubitStr);\n"
            case "s":
                qasm += "s \(qubitStr);\n"
            case "sdg", "sdagger":
                qasm += "sdg \(qubitStr);\n"
            case "t":
                qasm += "t \(qubitStr);\n"
            case "tdg", "tdagger":
                qasm += "tdg \(qubitStr);\n"
            case "cx", "cnot":
                qasm += "cx \(qubitStr);\n"
            case "cz":
                qasm += "cz \(qubitStr);\n"
            case "swap":
                qasm += "swap \(qubitStr);\n"
            case "ccx", "toffoli":
                qasm += "ccx \(qubitStr);\n"
            case "rx":
                if let params = gate.params, !params.isEmpty {
                    qasm += "rx(\(params[0])) \(qubitStr);\n"
                }
            case "ry":
                if let params = gate.params, !params.isEmpty {
                    qasm += "ry(\(params[0])) \(qubitStr);\n"
                }
            case "rz":
                if let params = gate.params, !params.isEmpty {
                    qasm += "rz(\(params[0])) \(qubitStr);\n"
                }
            case "u3":
                if let params = gate.params, params.count >= 3 {
                    qasm += "u3(\(params[0]), \(params[1]), \(params[2])) \(qubitStr);\n"
                }
            default:
                qasm += "// Unknown gate: \(gate.name)\n"
            }
        }

        // Add measurement at the end
        for i in 0..<numberOfQubits {
            qasm += "measure q[\(i)] -> c[\(i)];\n"
        }

        return qasm
    }

    // MARK: - Result Conversion

    /// Measurement result from external backend
    public struct BackendResult: Codable {
        public let counts: [String: Int]
        public let shots: Int
        public let backend: String
        public let executionTime: Double?
        public let metadata: [String: String]?

        public init(counts: [String: Int], shots: Int, backend: String,
                   executionTime: Double? = nil, metadata: [String: String]? = nil) {
            self.counts = counts
            self.shots = shots
            self.backend = backend
            self.executionTime = executionTime
            self.metadata = metadata
        }
    }

    /// Converts SwiftQuantum measurements to backend result format
    public static func toBackendResult(
        measurements: [String: Int],
        backend: String = "swift_simulator"
    ) -> BackendResult {
        let shots = measurements.values.reduce(0, +)
        return BackendResult(
            counts: measurements,
            shots: shots,
            backend: backend
        )
    }

    /// Converts backend result to SwiftQuantum format
    public static func fromBackendResult(_ result: BackendResult) -> [String: Int] {
        return result.counts
    }

    // MARK: - JSON Serialization

    /// Encodes quantum data to JSON
    public static func toJSON<T: Encodable>(_ value: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(value) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Decodes quantum data from JSON
    public static func fromJSON<T: Decodable>(_ json: String, as type: T.Type) -> T? {
        guard let data = json.data(using: .utf8) else { return nil }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try? decoder.decode(type, from: data)
    }

    // MARK: - IBM Quantum Integration Preparation

    /// Configuration for IBM Quantum backend
    public struct IBMQuantumConfig: Codable, Sendable {
        public let apiToken: String?
        public let backend: String
        public let shots: Int
        public let optimization_level: Int
        public let resilience_level: Int

        public init(
            apiToken: String? = nil,
            backend: String = "ibm_brisbane",
            shots: Int = 1000,
            optimization_level: Int = 1,
            resilience_level: Int = 1
        ) {
            self.apiToken = apiToken
            self.backend = backend
            self.shots = shots
            self.optimization_level = optimization_level
            self.resilience_level = resilience_level
        }

        public static let simulator = IBMQuantumConfig(backend: "ibmq_qasm_simulator")
        public static let brisbane = IBMQuantumConfig(backend: "ibm_brisbane")
        public static let kyoto = IBMQuantumConfig(backend: "ibm_kyoto")
    }

    /// Job status for async execution
    public enum JobStatus: String, Codable {
        case queued = "QUEUED"
        case running = "RUNNING"
        case completed = "COMPLETED"
        case failed = "FAILED"
        case cancelled = "CANCELLED"
    }

    /// Job information
    public struct JobInfo: Codable {
        public let jobId: String
        public let status: JobStatus
        public let backend: String
        public let createdAt: Date
        public let completedAt: Date?
        public let result: BackendResult?

        public init(jobId: String, status: JobStatus, backend: String,
                   createdAt: Date = Date(), completedAt: Date? = nil,
                   result: BackendResult? = nil) {
            self.jobId = jobId
            self.status = status
            self.backend = backend
            self.createdAt = createdAt
            self.completedAt = completedAt
            self.result = result
        }
    }

    // MARK: - Error Mitigation Settings

    /// Error mitigation configuration
    public struct ErrorMitigationConfig: Codable, Sendable {
        public let zneEnabled: Bool           // Zero Noise Extrapolation
        public let m3Enabled: Bool            // Matrix-free Measurement Mitigation
        public let dynamicalDecoupling: Bool  // Dynamical Decoupling
        public let twirling: Bool             // Pauli Twirling

        public init(
            zneEnabled: Bool = false,
            m3Enabled: Bool = true,
            dynamicalDecoupling: Bool = false,
            twirling: Bool = false
        ) {
            self.zneEnabled = zneEnabled
            self.m3Enabled = m3Enabled
            self.dynamicalDecoupling = dynamicalDecoupling
            self.twirling = twirling
        }

        public static let none = ErrorMitigationConfig(
            zneEnabled: false, m3Enabled: false,
            dynamicalDecoupling: false, twirling: false
        )

        public static let standard = ErrorMitigationConfig(
            zneEnabled: false, m3Enabled: true,
            dynamicalDecoupling: true, twirling: false
        )

        public static let aggressive = ErrorMitigationConfig(
            zneEnabled: true, m3Enabled: true,
            dynamicalDecoupling: true, twirling: true
        )
    }
}

// MARK: - SwiftQuantum Adapter

/// Adapter for converting between SwiftQuantum and QuantumBridge formats
public struct SwiftQuantumAdapter {

    /// Converts QuantumRegister state to probability dictionary
    public static func toProbabilities(_ register: QuantumRegister) -> [String: Double] {
        var result: [String: Double] = [:]
        let n = register.numberOfQubits

        for i in 0..<register.numberOfStates {
            let prob = register.probability(of: i)
            if prob > 1e-10 {
                var bitString = String(i, radix: 2)
                while bitString.count < n {
                    bitString = "0" + bitString
                }
                result[bitString] = prob
            }
        }

        return result
    }

    /// Converts single Qubit to dictionary representation
    public static func toDict(_ qubit: Qubit) -> [String: Any] {
        let bloch = qubit.blochCoordinates()
        return [
            "amplitude0_real": qubit.amplitude0.real,
            "amplitude0_imag": qubit.amplitude0.imaginary,
            "amplitude1_real": qubit.amplitude1.real,
            "amplitude1_imag": qubit.amplitude1.imaginary,
            "probability0": qubit.probability0,
            "probability1": qubit.probability1,
            "bloch_x": bloch.x,
            "bloch_y": bloch.y,
            "bloch_z": bloch.z,
            "entropy": qubit.entropy()
        ]
    }

    /// Creates Qubit from dictionary representation
    public static func fromDict(_ dict: [String: Double]) -> Qubit? {
        guard let a0r = dict["amplitude0_real"],
              let a0i = dict["amplitude0_imag"],
              let a1r = dict["amplitude1_real"],
              let a1i = dict["amplitude1_imag"] else {
            return nil
        }

        return Qubit(
            amplitude0: Complex(a0r, a0i),
            amplitude1: Complex(a1r, a1i)
        )
    }

    /// Converts algorithm result to JSON-serializable format
    public static func algorithmResultToDict(
        name: String,
        measurements: [String: Int],
        metadata: [String: Any] = [:]
    ) -> [String: Any] {
        var result: [String: Any] = [
            "algorithm": name,
            "measurements": measurements,
            "total_shots": measurements.values.reduce(0, +)
        ]

        for (key, value) in metadata {
            result[key] = value
        }

        return result
    }
}

// MARK: - Circuit Builder for Bridge

/// Fluent interface for building circuits compatible with QuantumBridge
public class BridgeCircuitBuilder {

    private var numberOfQubits: Int
    private var gates: [(name: String, qubits: [Int], params: [Double]?)] = []
    private var name: String

    public init(numberOfQubits: Int, name: String = "circuit") {
        self.numberOfQubits = numberOfQubits
        self.name = name
    }

    @discardableResult
    public func h(_ qubit: Int) -> Self {
        gates.append(("h", [qubit], nil))
        return self
    }

    @discardableResult
    public func x(_ qubit: Int) -> Self {
        gates.append(("x", [qubit], nil))
        return self
    }

    @discardableResult
    public func y(_ qubit: Int) -> Self {
        gates.append(("y", [qubit], nil))
        return self
    }

    @discardableResult
    public func z(_ qubit: Int) -> Self {
        gates.append(("z", [qubit], nil))
        return self
    }

    @discardableResult
    public func s(_ qubit: Int) -> Self {
        gates.append(("s", [qubit], nil))
        return self
    }

    @discardableResult
    public func t(_ qubit: Int) -> Self {
        gates.append(("t", [qubit], nil))
        return self
    }

    @discardableResult
    public func rx(_ qubit: Int, angle: Double) -> Self {
        gates.append(("rx", [qubit], [angle]))
        return self
    }

    @discardableResult
    public func ry(_ qubit: Int, angle: Double) -> Self {
        gates.append(("ry", [qubit], [angle]))
        return self
    }

    @discardableResult
    public func rz(_ qubit: Int, angle: Double) -> Self {
        gates.append(("rz", [qubit], [angle]))
        return self
    }

    @discardableResult
    public func cx(control: Int, target: Int) -> Self {
        gates.append(("cx", [control, target], nil))
        return self
    }

    @discardableResult
    public func cz(control: Int, target: Int) -> Self {
        gates.append(("cz", [control, target], nil))
        return self
    }

    @discardableResult
    public func swap(_ qubit1: Int, _ qubit2: Int) -> Self {
        gates.append(("swap", [qubit1, qubit2], nil))
        return self
    }

    @discardableResult
    public func ccx(control1: Int, control2: Int, target: Int) -> Self {
        gates.append(("ccx", [control1, control2, target], nil))
        return self
    }

    @discardableResult
    public func u3(_ qubit: Int, theta: Double, phi: Double, lambda: Double) -> Self {
        gates.append(("u3", [qubit], [theta, phi, lambda]))
        return self
    }

    /// Builds and returns the QASM representation
    public func toQASM() -> String {
        return QuantumBridge.toQASM(numberOfQubits: numberOfQubits, gates: gates)
    }

    /// Builds and executes on SwiftQuantum simulator
    public func execute(shots: Int = 1000) -> [String: Int] {
        let register = QuantumRegister(numberOfQubits: numberOfQubits)

        for gate in gates {
            switch gate.name.lowercased() {
            case "h":
                register.applyGate(.hadamard, to: gate.qubits[0])
            case "x":
                register.applyGate(.pauliX, to: gate.qubits[0])
            case "y":
                register.applyGate(.pauliY, to: gate.qubits[0])
            case "z":
                register.applyGate(.pauliZ, to: gate.qubits[0])
            case "s":
                register.applyGate(.sGate, to: gate.qubits[0])
            case "t":
                register.applyGate(.tGate, to: gate.qubits[0])
            case "rx":
                if let angle = gate.params?.first {
                    register.applyGate(.rotationX(angle), to: gate.qubits[0])
                }
            case "ry":
                if let angle = gate.params?.first {
                    register.applyGate(.rotationY(angle), to: gate.qubits[0])
                }
            case "rz":
                if let angle = gate.params?.first {
                    register.applyGate(.rotationZ(angle), to: gate.qubits[0])
                }
            case "cx":
                register.applyCNOT(control: gate.qubits[0], target: gate.qubits[1])
            case "cz":
                register.applyCZ(control: gate.qubits[0], target: gate.qubits[1])
            case "swap":
                register.applySWAP(qubit1: gate.qubits[0], qubit2: gate.qubits[1])
            case "ccx":
                register.applyToffoli(control1: gate.qubits[0],
                                     control2: gate.qubits[1],
                                     target: gate.qubits[2])
            default:
                break
            }
        }

        return register.measureMultiple(shots: shots)
    }

    /// Returns gate count
    public var gateCount: Int {
        return gates.count
    }

    /// Returns circuit depth (simplified - just gate count for now)
    public var depth: Int {
        return gates.count
    }
}
