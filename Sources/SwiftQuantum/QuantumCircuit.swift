//
//  QuantumCircuit.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-22.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//// MARK: - Linear Algebra: Quantum Circuits as Matrix Composition
//
// Quantum circuits demonstrate the power of composing linear transformations.
// Each gate is a matrix, and circuit execution is sequential matrix multiplication.
//
// Key Linear Algebra Concepts:
//
// 1. Matrix Composition (Associativity)
//    - Circuit: |ψ_final⟩ = U_n···U_2·U_1|ψ_initial⟩
//    - Matrix product: U_total = U_n·U_(n-1)···U_2·U_1
//    - Order matters: Matrix multiplication is non-commutative
//
// 2. Sequential Transformations
//    - Each gate transforms the state vector
//    - Intermediate states: |ψ_k⟩ = U_k|ψ_(k-1)⟩
//    - Final state: |ψ_final⟩ = (U_n···U_1)|ψ_0⟩
//
// 3. Circuit Optimization
//    - Gate cancellation: U·U† = I (inverse gates)
//    - Gate fusion: U_2·U_1 = U_combined (combine gates)
//    - Matrix simplification: H·H = I, X·X = I, etc.
//
// 4. Unitary Preservation
//    - Each gate is unitary: U†U = I
//    - Composition preserves unitarity: (U_2U_1)†(U_2U_1) = I
//    - Circuit always maps unit vectors to unit vectors
//
// 5. Measurement as Projection
//    - Measurement projects state onto basis vectors
//    - Probability = |⟨basis|ψ⟩|² (inner product squared)
//    - Non-unitary operation (destroys superposition)
//
// Educational Resource:
// For visual understanding of matrix transformations and compositions:
// https://eunminpark.hashnode.dev/reviews-linear-algebra-through-three-lenses-an-ios-developers-journey-with-3blue1brown
//
// Circuit Execution:
// |ψ⟩ → [Gate1] → [Gate2] → [Gate3] → ... → [GateN] → |ψ'⟩
//   ↓       ↓         ↓         ↓              ↓        ↓
//  |ψ₀⟩   U₁|ψ₀⟩   U₂U₁|ψ₀⟩  ...         U_N···U₁|ψ₀⟩  |ψ_final⟩
//

import Foundation

/// A quantum circuit for composing and executing quantum gate operations
///
/// QuantumCircuit provides a high-level interface for building quantum algorithms
/// by chaining gates and measurements. It supports circuit visualization,
/// optimization, and execution with measurement statistics.
///
/// ## Example Usage
/// ```swift
/// var circuit = QuantumCircuit(qubit: .zero)
/// circuit.addGate(.hadamard)
/// circuit.addGate(.rotationZ(.pi/4))
///
/// let result = circuit.execute()
/// let measurements = circuit.measureMultiple(shots: 1000)
/// ```
public class QuantumCircuit {
    
    // MARK: - Gate Types
    
    /// Enumeration of available quantum gates
    public enum Gate: Equatable {
        case hadamard
        case pauliX
        case pauliY
        case pauliZ
        case sGate
        case sDagger
        case tGate
        case tDagger
        case rotationX(Double)
        case rotationY(Double)
        case rotationZ(Double)
        case phase(Double)
        case u3(theta: Double, phi: Double, lambda: Double)
        case identity
        case custom(String, (Qubit) -> Qubit)
        
        /// Human-readable name for the gate
        public var name: String {
            switch self {
            case .hadamard: return "H"
            case .pauliX: return "X"
            case .pauliY: return "Y"
            case .pauliZ: return "Z"
            case .sGate: return "S"
            case .sDagger: return "S†"
            case .tGate: return "T"
            case .tDagger: return "T†"
            case .rotationX(let angle): return "RX(\(String(format: "%.3f", angle)))"
            case .rotationY(let angle): return "RY(\(String(format: "%.3f", angle)))"
            case .rotationZ(let angle): return "RZ(\(String(format: "%.3f", angle)))"
            case .phase(let angle): return "P(\(String(format: "%.3f", angle)))"
            case .u3(let theta, let phi, let lambda):
                return "U3(\(String(format: "%.3f", theta)),\(String(format: "%.3f", phi)),\(String(format: "%.3f", lambda)))"
            case .identity: return "I"
            case .custom(let name, _): return name
            }
        }
        
        /// Apply the gate to a qubit
        public func apply(to qubit: Qubit) -> Qubit {
            switch self {
            case .hadamard:
                return QuantumGates.hadamard(qubit)
            case .pauliX:
                return QuantumGates.pauliX(qubit)
            case .pauliY:
                return QuantumGates.pauliY(qubit)
            case .pauliZ:
                return QuantumGates.pauliZ(qubit)
            case .sGate:
                return QuantumGates.sGate(qubit)
            case .sDagger:
                return QuantumGates.sDagger(qubit)
            case .tGate:
                return QuantumGates.tGate(qubit)
            case .tDagger:
                return QuantumGates.tDagger(qubit)
            case .rotationX(let angle):
                return QuantumGates.rotationX(qubit, angle: angle)
            case .rotationY(let angle):
                return QuantumGates.rotationY(qubit, angle: angle)
            case .rotationZ(let angle):
                return QuantumGates.rotationZ(qubit, angle: angle)
            case .phase(let angle):
                return QuantumGates.phaseGate(qubit, angle: angle)
            case .u3(let theta, let phi, let lambda):
                return QuantumGates.u3Gate(qubit, theta: theta, phi: phi, lambda: lambda)
            case .identity:
                return QuantumGates.identity(qubit)
            case .custom(_, let function):
                return function(qubit)
            }
        }
        
        /// Check equality (custom gates are never equal)
        public static func == (lhs: Gate, rhs: Gate) -> Bool {
            switch (lhs, rhs) {
            case (.hadamard, .hadamard): return true
            case (.pauliX, .pauliX): return true
            case (.pauliY, .pauliY): return true
            case (.pauliZ, .pauliZ): return true
            case (.sGate, .sGate): return true
            case (.sDagger, .sDagger): return true
            case (.tGate, .tGate): return true
            case (.tDagger, .tDagger): return true
            case (.identity, .identity): return true
            case let (.rotationX(a1), .rotationX(a2)): return abs(a1 - a2) < 1e-15
            case let (.rotationY(a1), .rotationY(a2)): return abs(a1 - a2) < 1e-15
            case let (.rotationZ(a1), .rotationZ(a2)): return abs(a1 - a2) < 1e-15
            case let (.phase(a1), .phase(a2)): return abs(a1 - a2) < 1e-15
            case let (.u3(t1, p1, l1), .u3(t2, p2, l2)):
                return abs(t1 - t2) < 1e-15 && abs(p1 - p2) < 1e-15 && abs(l1 - l2) < 1e-15
            default: return false
            }
        }
    }
    
    // MARK: - Circuit Step
    
    /// Represents a single step in the quantum circuit
    public struct CircuitStep {
        public let gate: Gate
        public let timestamp: Date
        public let stepNumber: Int
        
        public init(gate: Gate, stepNumber: Int) {
            self.gate = gate
            self.stepNumber = stepNumber
            self.timestamp = Date()
        }
    }
    
    // MARK: - Properties
    
    /// Initial qubit state
    public let initialState: Qubit
    
    /// Sequence of gates in the circuit
    private(set) public var gates: [CircuitStep] = []
    
    /// Circuit execution statistics
    public private(set) var executionCount = 0
    public private(set) var lastExecutionTime: TimeInterval = 0
    
    /// Circuit metadata
    public let creationTime = Date()
    public private(set) var lastModified = Date()
    
    // MARK: - Computed Properties
    
    /// Current number of gates in the circuit
    public var gateCount: Int {
        return gates.count
    }
    
    /// Check if circuit is empty
    public var isEmpty: Bool {
        return gates.isEmpty
    }
    
    /// Estimated circuit depth (for single-qubit circuits, this equals gate count)
    public var depth: Int {
        return gateCount
    }
    
    // MARK: - Initialization
    
    /// Creates a quantum circuit with initial state
    /// - Parameter initialState: Starting qubit state (default: |0⟩)
    public init(qubit initialState: Qubit = .zero) {
        self.initialState = initialState
    }
    
    /// Creates a quantum circuit from an existing circuit (copy constructor)
    /// - Parameter circuit: Circuit to copy
    public init(copying circuit: QuantumCircuit) {
        self.initialState = circuit.initialState
        self.gates = circuit.gates
        self.executionCount = 0  // Reset execution stats
        self.lastExecutionTime = 0
    }
    
    // MARK: - Gate Addition
    
    /// Adds a gate to the circuit
    /// - Parameter gate: Quantum gate to add
    /// - Returns: Self for method chaining
    @discardableResult
    public func addGate(_ gate: Gate) -> QuantumCircuit {
        let step = CircuitStep(gate: gate, stepNumber: gates.count)
        gates.append(step)
        lastModified = Date()
        return self
    }
    
    /// Adds multiple gates to the circuit
    /// - Parameter gates: Array of gates to add in sequence
    /// - Returns: Self for method chaining
    @discardableResult
    public func addGates(_ gates: [Gate]) -> QuantumCircuit {
        for gate in gates {
            addGate(gate)
        }
        return self
    }
    
    /// Inserts a gate at a specific position
    /// - Parameters:
    ///   - gate: Gate to insert
    ///   - index: Position to insert at
    /// - Returns: Self for method chaining
    @discardableResult
    public func insertGate(_ gate: Gate, at index: Int) -> QuantumCircuit {
        guard index >= 0 && index <= gates.count else {
            fatalError("Index out of bounds")
        }
        
        let step = CircuitStep(gate: gate, stepNumber: index)
        gates.insert(step, at: index)
        
        // Update step numbers for subsequent gates
        for i in (index + 1)..<gates.count {
            gates[i] = CircuitStep(gate: gates[i].gate, stepNumber: i)
        }
        
        lastModified = Date()
        return self
    }
    
    /// Removes a gate at a specific position
    /// - Parameter index: Index of gate to remove
    /// - Returns: Self for method chaining
    @discardableResult
    public func removeGate(at index: Int) -> QuantumCircuit {
        guard index >= 0 && index < gates.count else {
            fatalError("Index out of bounds")
        }
        
        gates.remove(at: index)
        
        // Update step numbers for subsequent gates
        for i in index..<gates.count {
            gates[i] = CircuitStep(gate: gates[i].gate, stepNumber: i)
        }
        
        lastModified = Date()
        return self
    }
    
    /// Removes all gates from the circuit
    /// - Returns: Self for method chaining
    @discardableResult
    public func removeAllGates() -> QuantumCircuit {
        gates.removeAll()
        lastModified = Date()
        return self
    }
    
    // MARK: - Circuit Execution
    
    /// Executes the quantum circuit and returns the final state
    /// - Returns: Final qubit state after applying all gates
    public func execute() -> Qubit {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let finalState = gates.reduce(initialState) { currentState, step in
            step.gate.apply(to: currentState)
        }
        
        lastExecutionTime = CFAbsoluteTimeGetCurrent() - startTime
        executionCount += 1
        
        return finalState
    }
    
    /// Executes the circuit and performs a single measurement
    /// - Returns: Measurement result (0 or 1)
    public func executeAndMeasure() -> Int {
        let finalState = execute()
        return finalState.measure()
    }
    
    /// Executes the circuit multiple times and returns measurement statistics
    /// - Parameter shots: Number of executions/measurements
    /// - Returns: Dictionary with measurement outcomes and their counts
    public func measureMultiple(shots: Int) -> [Int: Int] {
        var results: [Int: Int] = [0: 0, 1: 0]
        
        for _ in 0..<shots {
            let result = executeAndMeasure()
            results[result, default: 0] += 1
        }
        
        return results
    }
    
    /// Executes the circuit and returns measurement probabilities
    /// - Parameter shots: Number of measurements for statistical estimation
    /// - Returns: Tuple with (probability of 0, probability of 1)
    public func measurementProbabilities(shots: Int = 10000) -> (prob0: Double, prob1: Double) {
        let measurements = measureMultiple(shots: shots)
        let count0 = measurements[0] ?? 0
        let count1 = measurements[1] ?? 0
        
        return (
            prob0: Double(count0) / Double(shots),
            prob1: Double(count1) / Double(shots)
        )
    }
    
    // MARK: - Circuit Analysis
    
    /// Calculates the theoretical measurement probabilities without execution
    /// - Returns: Tuple with theoretical probabilities
    public func theoreticalProbabilities() -> (prob0: Double, prob1: Double) {
        let finalState = execute()
        return (prob0: finalState.probability0, prob1: finalState.probability1)
    }
    
    /// Returns the final quantum state without measurement
    /// - Returns: Final qubit state after all gates
    public func finalState() -> Qubit {
        return execute()
    }
    
    /// Checks if the circuit implements a unitary operation
    /// - Returns: true if the circuit preserves normalization
    public func isUnitary() -> Bool {
        let testCases: [Qubit] = [.zero, .one, .superposition, .random(), .random()]
        
        for testCase in testCases {
            let originalCircuit = QuantumCircuit(qubit: testCase)
            originalCircuit.addGates(gates.map { $0.gate })
            
            let result = originalCircuit.execute()
            if !result.isNormalized {
                return false
            }
        }
        
        return true
    }
    
    /// Estimates the fidelity between this circuit and another
    /// - Parameters:
    ///   - other: Other quantum circuit to compare
    ///   - testStates: States to test (default: standard test cases)
    /// - Returns: Average fidelity across test states
    public func fidelity(with other: QuantumCircuit,
                        testStates: [Qubit] = [.zero, .one, .superposition]) -> Double {
        var totalFidelity = 0.0
        
        for testState in testStates {
            let circuit1 = QuantumCircuit(qubit: testState)
            circuit1.addGates(gates.map { $0.gate })
            
            let circuit2 = QuantumCircuit(qubit: testState)
            circuit2.addGates(other.gates.map { $0.gate })
            
            let state1 = circuit1.execute()
            let state2 = circuit2.execute()
            
            // Calculate state fidelity: |⟨ψ₁|ψ₂⟩|²
            let overlap = state1.amplitude0.conjugate * state2.amplitude0 +
                         state1.amplitude1.conjugate * state2.amplitude1
            totalFidelity += overlap.magnitudeSquared
        }
        
        return totalFidelity / Double(testStates.count)
    }
    
    // MARK: - Circuit Optimization
    
    /// Optimizes the circuit by removing redundant gates
    /// - Returns: New optimized circuit
    public func optimized() -> QuantumCircuit {
        let optimized = QuantumCircuit(qubit: initialState)
        var currentGates = gates.map { $0.gate }
        
        // Remove consecutive inverse gates
        var i = 0
        while i < currentGates.count - 1 {
            let current = currentGates[i]
            let next = currentGates[i + 1]
            
            // Check for inverse pairs
            let shouldRemove = isInversePair(current, next)
            
            if shouldRemove {
                currentGates.remove(at: i + 1)
                currentGates.remove(at: i)
                i = max(0, i - 1)  // Step back to check new adjacencies
            } else {
                i += 1
            }
        }
        
        optimized.addGates(currentGates)
        return optimized
    }
    
    /// Checks if two gates are inverse pairs
    private func isInversePair(_ gate1: Gate, _ gate2: Gate) -> Bool {
        switch (gate1, gate2) {
        case (.pauliX, .pauliX), (.pauliY, .pauliY), (.pauliZ, .pauliZ):
            return true  // Pauli gates are self-inverse
        case (.hadamard, .hadamard):
            return true  // Hadamard is self-inverse
        case (.sGate, .sDagger), (.sDagger, .sGate):
            return true
        case (.tGate, .tDagger), (.tDagger, .tGate):
            return true
        case let (.rotationX(a1), .rotationX(a2)):
            return abs(a1 + a2) < 1e-15
        case let (.rotationY(a1), .rotationY(a2)):
            return abs(a1 + a2) < 1e-15
        case let (.rotationZ(a1), .rotationZ(a2)):
            return abs(a1 + a2) < 1e-15
        case let (.phase(a1), .phase(a2)):
            return abs(a1 + a2) < 1e-15
        default:
            return false
        }
    }
    
    // MARK: - Circuit Composition
    
    /// Composes this circuit with another circuit
    /// - Parameter other: Circuit to append
    /// - Returns: New composed circuit
    public func composed(with other: QuantumCircuit) -> QuantumCircuit {
        let composed = QuantumCircuit(qubit: initialState)
        composed.addGates(gates.map { $0.gate })
        composed.addGates(other.gates.map { $0.gate })
        return composed
    }
    
    /// Creates the inverse of this circuit
    /// - Returns: Circuit that undoes the operations of this circuit
    public func inverse() -> QuantumCircuit {
        let inverse = QuantumCircuit(qubit: initialState)
        
        // Add gates in reverse order with inverse operations
        for step in gates.reversed() {
            if let inverseGate = step.gate.inverse() {
                inverse.addGate(inverseGate)
            } else {
                fatalError("Cannot invert gate: \(step.gate.name)")
            }
        }
        
        return inverse
    }
    
    /// Repeats the circuit n times
    /// - Parameter times: Number of repetitions
    /// - Returns: New circuit with repeated operations
    public func repeated(_ times: Int) -> QuantumCircuit {
        let repeated = QuantumCircuit(qubit: initialState)
        
        for _ in 0..<times {
            repeated.addGates(gates.map { $0.gate })
        }
        
        return repeated
    }
    
    // MARK: - Visualization
    
    /// Returns a text representation of the circuit
    /// - Returns: ASCII art representation of the quantum circuit
    public func asciiDiagram() -> String {
        guard !gates.isEmpty else {
            return "q₀ ─────"
        }
        
        var diagram = "q₀ ─"
        
        for step in gates {
            let gateName = step.gate.name
            let padding = max(0, 3 - gateName.count)
            let leftPad = padding / 2
            let rightPad = padding - leftPad
            
            diagram += "┤"
            diagram += String(repeating: " ", count: leftPad)
            diagram += gateName
            diagram += String(repeating: " ", count: rightPad)
            diagram += "├─"
        }
        
        diagram.removeLast()  // Remove trailing dash
        return diagram
    }
    
    /// Returns a detailed description of the circuit
    /// - Returns: Multi-line string with circuit information
    public func detailedDescription() -> String {
        var description = """
        Quantum Circuit Summary:
        ========================
        Initial State: \(initialState.stateDescription())
        Gate Count: \(gateCount)
        Circuit Depth: \(depth)
        Executions: \(executionCount)
        Last Execution Time: \(String(format: "%.6f", lastExecutionTime))s
        
        Gates:
        """
        
        for (index, step) in gates.enumerated() {
            description += "\n\(index + 1). \(step.gate.name)"
        }
        
        if !gates.isEmpty {
            let finalState = execute()
            description += """
            
            
            Final State: \(finalState.stateDescription())
            Measurement Probabilities:
              |0⟩: \(String(format: "%.1f", finalState.probability0 * 100))%
              |1⟩: \(String(format: "%.1f", finalState.probability1 * 100))%
            
            Circuit Diagram:
            \(asciiDiagram())
            """
        }
        
        return description
    }
}

// MARK: - Gate Inverse Extension

extension QuantumCircuit.Gate {
    /// Returns the inverse of this gate, if it exists
    /// - Returns: Inverse gate or nil if not invertible
    public func inverse() -> QuantumCircuit.Gate? {
        switch self {
        case .hadamard: return .hadamard  // Self-inverse
        case .pauliX: return .pauliX      // Self-inverse
        case .pauliY: return .pauliY      // Self-inverse
        case .pauliZ: return .pauliZ      // Self-inverse
        case .sGate: return .sDagger
        case .sDagger: return .sGate
        case .tGate: return .tDagger
        case .tDagger: return .tGate
        case .rotationX(let angle): return .rotationX(-angle)
        case .rotationY(let angle): return .rotationY(-angle)
        case .rotationZ(let angle): return .rotationZ(-angle)
        case .phase(let angle): return .phase(-angle)
        case .u3(let theta, let phi, let lambda):
            return .u3(theta: -theta, phi: -lambda, lambda: -phi)
        case .identity: return .identity
        case .custom(_, _): return nil    // Custom gates don't have known inverses
        }
    }
}

// MARK: - CustomStringConvertible

extension QuantumCircuit: CustomStringConvertible {
    public var description: String {
        return asciiDiagram()
    }
}

// MARK: - Predefined Circuits

extension QuantumCircuit {
    
    /// Creates a Bell state preparation circuit
    /// Transforms |00⟩ → (|00⟩ + |11⟩)/√2
    /// - Returns: Circuit that creates Bell state (single qubit version creates superposition)
    public static func bellState() -> QuantumCircuit {
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        return circuit
    }
    
    /// Creates a quantum Fourier transform circuit (single qubit version)
    /// - Returns: QFT circuit for single qubit
    public static func qft() -> QuantumCircuit {
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        return circuit
    }
    
    /// Creates a random quantum circuit
    /// - Parameters:
    ///   - depth: Number of random gates to add
    ///   - initialState: Starting state (default: |0⟩)
    /// - Returns: Circuit with random gates
    public static func random(depth: Int, initialState: Qubit = .zero) -> QuantumCircuit {
        let circuit = QuantumCircuit(qubit: initialState)
        let availableGates: [Gate] = [
            .hadamard, .pauliX, .pauliY, .pauliZ, .sGate, .tGate,
            .rotationX(.pi * Double.random(in: -1...1)),
            .rotationY(.pi * Double.random(in: -1...1)),
            .rotationZ(.pi * Double.random(in: -1...1))
        ]
        
        for _ in 0..<depth {
            let randomGate = availableGates.randomElement()!
            circuit.addGate(randomGate)
        }
        
        return circuit
    }
    
    /// Creates a circuit that rotates a qubit to any desired state
    /// - Parameter targetState: The desired final state
    /// - Returns: Circuit that transforms |0⟩ to the target state
    public static func statePreparation(target: Qubit) -> QuantumCircuit {
        let circuit = QuantumCircuit(qubit: .zero)
        
        // Calculate the angles needed for U3 gate
        let (x, y, z) = target.blochCoordinates()
        let theta = acos(z)
        let phi = atan2(y, x)
        
        // Use U3 gate to prepare the state
        circuit.addGate(.u3(theta: theta, phi: phi, lambda: 0))
        
        return circuit
    }
}
