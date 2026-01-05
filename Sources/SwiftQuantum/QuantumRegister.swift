//
//  QuantumRegister.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  Multi-qubit register implementation for quantum computing
//  Implements tensor product structure for multi-qubit states
//

import Foundation

// MARK: - Linear Algebra: Multi-Qubit Systems (Tensor Products)
//
// Multi-qubit systems extend single-qubit Hilbert space via tensor products.
// For n qubits, the state space is ℂ^(2^n) dimensional.
//
// Key Concepts:
// 1. Tensor Product: |ψ⟩⊗|φ⟩ creates combined state
//    - 2 qubits: 4 basis states {|00⟩, |01⟩, |10⟩, |11⟩}
//    - 3 qubits: 8 basis states
//    - n qubits: 2^n basis states
//
// 2. Entanglement: States that cannot be written as tensor products
//    - Bell state: (|00⟩ + |11⟩)/√2 is entangled
//    - Product state: |+⟩⊗|0⟩ = (|00⟩ + |10⟩)/√2 is NOT entangled
//
// 3. Multi-Qubit Gates:
//    - CNOT: Controlled-NOT (2-qubit gate)
//    - CZ: Controlled-Z (2-qubit gate)
//    - SWAP: Swaps two qubits
//    - Toffoli: Controlled-Controlled-NOT (3-qubit gate)

/// Represents a multi-qubit quantum register with complex amplitudes
///
/// A quantum register holds the state of multiple qubits in a single
/// state vector using the tensor product structure of Hilbert space.
///
/// ## Mathematical Representation
/// For n qubits, the state is:
/// |ψ⟩ = Σᵢ αᵢ|i⟩ where i ∈ {0, 1, ..., 2^n - 1}
///
/// ## Example Usage
/// ```swift
/// // Create a 2-qubit register in |00⟩ state
/// let register = QuantumRegister(numberOfQubits: 2)
///
/// // Apply Hadamard to first qubit
/// register.applyGate(.hadamard, to: 0)
///
/// // Apply CNOT with qubit 0 as control, qubit 1 as target
/// register.applyCNOT(control: 0, target: 1)
///
/// // Measure all qubits
/// let result = register.measureAll()
/// ```
public class QuantumRegister: @unchecked Sendable {

    // MARK: - Properties

    /// Number of qubits in the register
    public let numberOfQubits: Int

    /// Total number of basis states (2^n)
    public var numberOfStates: Int {
        return 1 << numberOfQubits
    }

    /// Complex amplitudes for all basis states
    /// Index i corresponds to state |i⟩ in binary representation
    public internal(set) var amplitudes: [Complex]

    // MARK: - Initialization

    /// Creates a quantum register with all qubits in |0⟩ state
    /// - Parameter numberOfQubits: Number of qubits in the register
    public init(numberOfQubits: Int) {
        precondition(numberOfQubits > 0 && numberOfQubits <= 20,
                    "Number of qubits must be between 1 and 20")

        self.numberOfQubits = numberOfQubits
        let numStates = 1 << numberOfQubits

        // Initialize to |00...0⟩ state
        self.amplitudes = Array(repeating: Complex.zero, count: numStates)
        self.amplitudes[0] = Complex.one
    }

    /// Creates a quantum register from individual qubits (tensor product)
    /// - Parameter qubits: Array of qubits to combine
    public init(qubits: [Qubit]) {
        precondition(!qubits.isEmpty && qubits.count <= 20,
                    "Number of qubits must be between 1 and 20")

        self.numberOfQubits = qubits.count
        let numStates = 1 << numberOfQubits
        self.amplitudes = Array(repeating: Complex.zero, count: numStates)

        // Compute tensor product
        for i in 0..<numStates {
            var amplitude = Complex.one
            for j in 0..<numberOfQubits {
                let bit = (i >> (numberOfQubits - 1 - j)) & 1
                if bit == 0 {
                    amplitude = amplitude * qubits[j].amplitude0
                } else {
                    amplitude = amplitude * qubits[j].amplitude1
                }
            }
            amplitudes[i] = amplitude
        }
    }

    /// Creates a quantum register from a specific state index
    /// - Parameters:
    ///   - numberOfQubits: Number of qubits
    ///   - state: Initial state as integer (e.g., 0 = |00...0⟩, 3 = |...011⟩)
    public init(numberOfQubits: Int, state: Int) {
        precondition(numberOfQubits > 0 && numberOfQubits <= 20,
                    "Number of qubits must be between 1 and 20")
        precondition(state >= 0 && state < (1 << numberOfQubits),
                    "State must be valid for given number of qubits")

        self.numberOfQubits = numberOfQubits
        let numStates = 1 << numberOfQubits

        self.amplitudes = Array(repeating: Complex.zero, count: numStates)
        self.amplitudes[state] = Complex.one
    }

    // MARK: - State Properties

    /// Probability distribution for all basis states
    public var probabilities: [Double] {
        return amplitudes.map { $0.magnitudeSquared }
    }

    /// Check if the state is normalized
    public var isNormalized: Bool {
        let sum = probabilities.reduce(0, +)
        return abs(sum - 1.0) < 1e-10
    }

    /// Normalize the state (in place)
    public func normalize() {
        let norm = sqrt(amplitudes.reduce(0.0) { $0 + $1.magnitudeSquared })
        guard norm > 1e-15 else { return }

        for i in 0..<amplitudes.count {
            amplitudes[i] = amplitudes[i] / norm
        }
    }

    // MARK: - Single-Qubit Gate Application

    /// Applies a single-qubit gate to a specific qubit
    /// - Parameters:
    ///   - gate: The gate to apply
    ///   - qubitIndex: Index of the target qubit (0-indexed from most significant)
    public func applyGate(_ gate: QuantumCircuit.Gate, to qubitIndex: Int) {
        precondition(qubitIndex >= 0 && qubitIndex < numberOfQubits,
                    "Qubit index out of range")

        let numStates = numberOfStates
        let bitPosition = numberOfQubits - 1 - qubitIndex
        let step = 1 << bitPosition

        // Process pairs of amplitudes that differ only in the target qubit
        for i in stride(from: 0, to: numStates, by: step * 2) {
            for j in 0..<step {
                let index0 = i + j
                let index1 = i + j + step

                // Create a temporary qubit to apply the gate
                let tempQubit = Qubit(amplitude0: amplitudes[index0],
                                      amplitude1: amplitudes[index1])
                let result = gate.apply(to: tempQubit)

                // Note: Qubit normalizes, but we need raw values
                // So we apply gate matrix directly
                let (new0, new1) = applySingleQubitGateMatrix(gate,
                                                              amp0: amplitudes[index0],
                                                              amp1: amplitudes[index1])
                amplitudes[index0] = new0
                amplitudes[index1] = new1
            }
        }
    }

    /// Applies gate matrix directly to two amplitudes
    private func applySingleQubitGateMatrix(_ gate: QuantumCircuit.Gate,
                                            amp0: Complex,
                                            amp1: Complex) -> (Complex, Complex) {
        switch gate {
        case .hadamard:
            let factor = 1.0 / sqrt(2.0)
            return (factor * (amp0 + amp1), factor * (amp0 - amp1))

        case .pauliX:
            return (amp1, amp0)

        case .pauliY:
            return (Complex(0, -1) * amp1, Complex(0, 1) * amp0)

        case .pauliZ:
            return (amp0, -amp1)

        case .sGate:
            return (amp0, Complex.i * amp1)

        case .sDagger:
            return (amp0, Complex.minusI * amp1)

        case .tGate:
            let phase = Complex.exp(Complex(0, .pi / 4))
            return (amp0, phase * amp1)

        case .tDagger:
            let phase = Complex.exp(Complex(0, -.pi / 4))
            return (amp0, phase * amp1)

        case .rotationX(let angle):
            let cos_half = cos(angle / 2)
            let sin_half = sin(angle / 2)
            let new0 = Complex(cos_half, 0) * amp0 + Complex(0, -sin_half) * amp1
            let new1 = Complex(0, -sin_half) * amp0 + Complex(cos_half, 0) * amp1
            return (new0, new1)

        case .rotationY(let angle):
            let cos_half = cos(angle / 2)
            let sin_half = sin(angle / 2)
            let new0 = Complex(cos_half, 0) * amp0 + Complex(-sin_half, 0) * amp1
            let new1 = Complex(sin_half, 0) * amp0 + Complex(cos_half, 0) * amp1
            return (new0, new1)

        case .rotationZ(let angle):
            let phaseMinus = Complex.exp(Complex(0, -angle / 2))
            let phasePlus = Complex.exp(Complex(0, angle / 2))
            return (phaseMinus * amp0, phasePlus * amp1)

        case .phase(let angle):
            let phase = Complex.exp(Complex(0, angle))
            return (amp0, phase * amp1)

        case .u3(let theta, let phi, let lambda):
            let cos_half = cos(theta / 2)
            let sin_half = sin(theta / 2)
            let exp_phi = Complex.exp(Complex(0, phi))
            let exp_lambda = Complex.exp(Complex(0, lambda))
            let exp_phi_lambda = Complex.exp(Complex(0, phi + lambda))

            let new0 = Complex(cos_half, 0) * amp0 + (-exp_lambda * sin_half) * amp1
            let new1 = (exp_phi * sin_half) * amp0 + (exp_phi_lambda * cos_half) * amp1
            return (new0, new1)

        case .identity:
            return (amp0, amp1)

        case .custom(_, let function):
            let tempQubit = Qubit(amplitude0: amp0, amplitude1: amp1)
            let result = function(tempQubit)
            return (result.amplitude0, result.amplitude1)
        }
    }

    // MARK: - Two-Qubit Gates

    /// Applies CNOT (Controlled-NOT) gate
    /// - Parameters:
    ///   - control: Index of control qubit
    ///   - target: Index of target qubit
    public func applyCNOT(control: Int, target: Int) {
        precondition(control >= 0 && control < numberOfQubits,
                    "Control qubit index out of range")
        precondition(target >= 0 && target < numberOfQubits,
                    "Target qubit index out of range")
        precondition(control != target,
                    "Control and target must be different qubits")

        let controlBit = numberOfQubits - 1 - control
        let targetBit = numberOfQubits - 1 - target

        var newAmplitudes = amplitudes

        for i in 0..<numberOfStates {
            // Check if control qubit is |1⟩
            if (i >> controlBit) & 1 == 1 {
                // Flip the target qubit
                let flippedIndex = i ^ (1 << targetBit)
                newAmplitudes[i] = amplitudes[flippedIndex]
                newAmplitudes[flippedIndex] = amplitudes[i]
            }
        }

        // Only update states where control is 1
        for i in 0..<numberOfStates {
            if (i >> controlBit) & 1 == 1 {
                let flippedIndex = i ^ (1 << targetBit)
                if i < flippedIndex {
                    amplitudes[i] = newAmplitudes[i]
                    amplitudes[flippedIndex] = newAmplitudes[flippedIndex]
                }
            }
        }
    }

    /// Applies CZ (Controlled-Z) gate
    /// - Parameters:
    ///   - control: Index of control qubit
    ///   - target: Index of target qubit
    public func applyCZ(control: Int, target: Int) {
        precondition(control >= 0 && control < numberOfQubits,
                    "Control qubit index out of range")
        precondition(target >= 0 && target < numberOfQubits,
                    "Target qubit index out of range")
        precondition(control != target,
                    "Control and target must be different qubits")

        let controlBit = numberOfQubits - 1 - control
        let targetBit = numberOfQubits - 1 - target

        for i in 0..<numberOfStates {
            // Apply phase flip when both control and target are |1⟩
            if ((i >> controlBit) & 1 == 1) && ((i >> targetBit) & 1 == 1) {
                amplitudes[i] = -amplitudes[i]
            }
        }
    }

    /// Applies SWAP gate to exchange two qubits
    /// - Parameters:
    ///   - qubit1: First qubit index
    ///   - qubit2: Second qubit index
    public func applySWAP(qubit1: Int, qubit2: Int) {
        precondition(qubit1 >= 0 && qubit1 < numberOfQubits,
                    "Qubit 1 index out of range")
        precondition(qubit2 >= 0 && qubit2 < numberOfQubits,
                    "Qubit 2 index out of range")
        precondition(qubit1 != qubit2,
                    "Cannot swap qubit with itself")

        let bit1 = numberOfQubits - 1 - qubit1
        let bit2 = numberOfQubits - 1 - qubit2

        var newAmplitudes = amplitudes

        for i in 0..<numberOfStates {
            let val1 = (i >> bit1) & 1
            let val2 = (i >> bit2) & 1

            if val1 != val2 {
                // Swap the bits
                let swappedIndex = i ^ (1 << bit1) ^ (1 << bit2)
                newAmplitudes[i] = amplitudes[swappedIndex]
            }
        }

        amplitudes = newAmplitudes
    }

    /// Applies Toffoli (CCNOT) gate
    /// - Parameters:
    ///   - control1: First control qubit index
    ///   - control2: Second control qubit index
    ///   - target: Target qubit index
    public func applyToffoli(control1: Int, control2: Int, target: Int) {
        precondition(control1 >= 0 && control1 < numberOfQubits &&
                    control2 >= 0 && control2 < numberOfQubits &&
                    target >= 0 && target < numberOfQubits,
                    "Qubit indices out of range")
        precondition(control1 != control2 && control1 != target && control2 != target,
                    "All qubits must be different")

        let c1Bit = numberOfQubits - 1 - control1
        let c2Bit = numberOfQubits - 1 - control2
        let targetBit = numberOfQubits - 1 - target

        var newAmplitudes = amplitudes

        for i in 0..<numberOfStates {
            // Check if both control qubits are |1⟩
            if ((i >> c1Bit) & 1 == 1) && ((i >> c2Bit) & 1 == 1) {
                // Flip the target qubit
                let flippedIndex = i ^ (1 << targetBit)
                newAmplitudes[i] = amplitudes[flippedIndex]
            }
        }

        amplitudes = newAmplitudes
    }

    /// Applies controlled-phase gate
    /// - Parameters:
    ///   - control: Control qubit index
    ///   - target: Target qubit index
    ///   - angle: Phase angle in radians
    public func applyControlledPhase(control: Int, target: Int, angle: Double) {
        precondition(control >= 0 && control < numberOfQubits,
                    "Control qubit index out of range")
        precondition(target >= 0 && target < numberOfQubits,
                    "Target qubit index out of range")
        precondition(control != target,
                    "Control and target must be different qubits")

        let controlBit = numberOfQubits - 1 - control
        let targetBit = numberOfQubits - 1 - target
        let phase = Complex.exp(Complex(0, angle))

        for i in 0..<numberOfStates {
            // Apply phase when both control and target are |1⟩
            if ((i >> controlBit) & 1 == 1) && ((i >> targetBit) & 1 == 1) {
                amplitudes[i] = phase * amplitudes[i]
            }
        }
    }

    // MARK: - Measurement

    /// Measures all qubits and returns the classical result
    /// - Returns: Measurement result as integer (binary representation)
    public func measureAll() -> Int {
        let probs = probabilities
        let random = Double.random(in: 0..<1)

        var cumulative = 0.0
        for i in 0..<numberOfStates {
            cumulative += probs[i]
            if random < cumulative {
                return i
            }
        }

        return numberOfStates - 1
    }

    /// Measures all qubits and returns result as bit string
    /// - Returns: Measurement result as string (e.g., "101")
    public func measureAllAsBitString() -> String {
        let result = measureAll()
        var bitString = String(result, radix: 2)

        // Pad with leading zeros
        while bitString.count < numberOfQubits {
            bitString = "0" + bitString
        }

        return bitString
    }

    /// Measures a single qubit, collapsing that part of the state
    /// - Parameter qubitIndex: Index of qubit to measure
    /// - Returns: Measurement result (0 or 1)
    public func measureQubit(_ qubitIndex: Int) -> Int {
        precondition(qubitIndex >= 0 && qubitIndex < numberOfQubits,
                    "Qubit index out of range")

        let bitPosition = numberOfQubits - 1 - qubitIndex

        // Calculate probability of measuring |0⟩
        var prob0 = 0.0
        for i in 0..<numberOfStates {
            if (i >> bitPosition) & 1 == 0 {
                prob0 += amplitudes[i].magnitudeSquared
            }
        }

        let result = Double.random(in: 0..<1) < prob0 ? 0 : 1

        // Collapse the state
        let norm = result == 0 ? sqrt(prob0) : sqrt(1 - prob0)
        for i in 0..<numberOfStates {
            let bitValue = (i >> bitPosition) & 1
            if bitValue == result {
                amplitudes[i] = amplitudes[i] / norm
            } else {
                amplitudes[i] = Complex.zero
            }
        }

        return result
    }

    /// Performs multiple measurements and returns statistics
    /// - Parameter shots: Number of measurements
    /// - Returns: Dictionary of outcome counts
    public func measureMultiple(shots: Int) -> [String: Int] {
        var results: [String: Int] = [:]

        // Save original state for repeated measurements
        let originalAmplitudes = amplitudes

        for _ in 0..<shots {
            amplitudes = originalAmplitudes
            let result = measureAllAsBitString()
            results[result, default: 0] += 1
        }

        // Restore original state
        amplitudes = originalAmplitudes

        return results
    }

    // MARK: - State Analysis

    /// Returns the probability of a specific measurement outcome
    /// - Parameter state: State index or bit string
    /// - Returns: Probability of measuring that state
    public func probability(of state: Int) -> Double {
        guard state >= 0 && state < numberOfStates else { return 0 }
        return amplitudes[state].magnitudeSquared
    }

    /// Checks if the register is in an entangled state
    /// This is a heuristic check, not a complete entanglement measure
    public var isEntangled: Bool {
        guard numberOfQubits >= 2 else { return false }

        // Simple check: try to factor as tensor product of individual qubits
        // This is a simplified check that works for common cases

        // For 2 qubits: |ψ⟩ = a|00⟩ + b|01⟩ + c|10⟩ + d|11⟩
        // Separable iff ad = bc
        if numberOfQubits == 2 {
            let a = amplitudes[0]  // |00⟩
            let b = amplitudes[1]  // |01⟩
            let c = amplitudes[2]  // |10⟩
            let d = amplitudes[3]  // |11⟩

            let ad = a * d
            let bc = b * c

            return !(ad - bc).isApproximatelyEqual(to: Complex.zero, tolerance: 1e-10)
        }

        // For more qubits, use a simplified check
        return true  // Conservative assumption
    }

    /// Computes the von Neumann entropy of the register
    /// - Returns: Entropy value
    public func entropy() -> Double {
        var entropy = 0.0
        for prob in probabilities {
            if prob > 1e-15 {
                entropy -= prob * log2(prob)
            }
        }
        return entropy
    }

    // MARK: - State Representation

    /// Returns a string description of the quantum state
    public func stateDescription() -> String {
        var terms: [String] = []

        for i in 0..<numberOfStates {
            let amp = amplitudes[i]
            if amp.magnitudeSquared > 1e-10 {
                var bitString = String(i, radix: 2)
                while bitString.count < numberOfQubits {
                    bitString = "0" + bitString
                }
                terms.append("\(amp)|\(bitString)⟩")
            }
        }

        return terms.isEmpty ? "0" : terms.joined(separator: " + ")
    }

    /// Returns a condensed state description
    public func compactDescription() -> String {
        var nonZeroCount = 0
        var maxAmpIndex = 0
        var maxAmp = 0.0

        for i in 0..<numberOfStates {
            let mag = amplitudes[i].magnitudeSquared
            if mag > 1e-10 {
                nonZeroCount += 1
                if mag > maxAmp {
                    maxAmp = mag
                    maxAmpIndex = i
                }
            }
        }

        if nonZeroCount == 1 {
            var bitString = String(maxAmpIndex, radix: 2)
            while bitString.count < numberOfQubits {
                bitString = "0" + bitString
            }
            return "|\(bitString)⟩"
        }

        return "\(nonZeroCount) superposition states"
    }

    // MARK: - Reset

    /// Resets the register to |00...0⟩ state
    public func reset() {
        for i in 0..<numberOfStates {
            amplitudes[i] = i == 0 ? Complex.one : Complex.zero
        }
    }

    /// Sets the register to a specific computational basis state
    /// - Parameter state: State index
    public func setState(_ state: Int) {
        precondition(state >= 0 && state < numberOfStates,
                    "State index out of range")

        for i in 0..<numberOfStates {
            amplitudes[i] = i == state ? Complex.one : Complex.zero
        }
    }

    /// Flips the sign of a specific amplitude (for oracle implementations)
    /// - Parameter index: State index to flip
    public func flipAmplitudeSign(at index: Int) {
        guard index >= 0 && index < numberOfStates else { return }
        amplitudes[index] = -amplitudes[index]
    }

    /// Creates a copy of current amplitudes for state restoration
    /// - Returns: Copy of amplitude array
    public func saveState() -> [Complex] {
        return amplitudes
    }

    /// Restores amplitudes from a saved state
    /// - Parameter savedState: Previously saved amplitude array
    public func restoreState(_ savedState: [Complex]) {
        guard savedState.count == numberOfStates else { return }
        amplitudes = savedState
    }
}

// MARK: - CustomStringConvertible

extension QuantumRegister: CustomStringConvertible {
    public var description: String {
        return stateDescription()
    }
}

// MARK: - Predefined States

extension QuantumRegister {

    /// Creates a Bell state |Φ+⟩ = (|00⟩ + |11⟩)/√2
    public static func bellStatePhi() -> QuantumRegister {
        let register = QuantumRegister(numberOfQubits: 2)
        register.applyGate(.hadamard, to: 0)
        register.applyCNOT(control: 0, target: 1)
        return register
    }

    /// Creates a Bell state |Φ-⟩ = (|00⟩ - |11⟩)/√2
    public static func bellStatePhiMinus() -> QuantumRegister {
        let register = QuantumRegister(numberOfQubits: 2)
        register.applyGate(.pauliX, to: 0)
        register.applyGate(.hadamard, to: 0)
        register.applyCNOT(control: 0, target: 1)
        return register
    }

    /// Creates a Bell state |Ψ+⟩ = (|01⟩ + |10⟩)/√2
    public static func bellStatePsi() -> QuantumRegister {
        let register = QuantumRegister(numberOfQubits: 2)
        register.applyGate(.hadamard, to: 0)
        register.applyCNOT(control: 0, target: 1)
        register.applyGate(.pauliX, to: 1)
        return register
    }

    /// Creates a Bell state |Ψ-⟩ = (|01⟩ - |10⟩)/√2
    public static func bellStatePsiMinus() -> QuantumRegister {
        let register = QuantumRegister(numberOfQubits: 2)
        register.applyGate(.pauliX, to: 0)
        register.applyGate(.hadamard, to: 0)
        register.applyCNOT(control: 0, target: 1)
        register.applyGate(.pauliX, to: 1)
        return register
    }

    /// Creates a GHZ state (|00...0⟩ + |11...1⟩)/√2
    /// - Parameter numberOfQubits: Number of qubits (must be >= 2)
    public static func ghzState(numberOfQubits: Int) -> QuantumRegister {
        precondition(numberOfQubits >= 2, "GHZ state requires at least 2 qubits")

        let register = QuantumRegister(numberOfQubits: numberOfQubits)
        register.applyGate(.hadamard, to: 0)

        for i in 1..<numberOfQubits {
            register.applyCNOT(control: 0, target: i)
        }

        return register
    }

    /// Creates a uniform superposition state over all basis states
    /// |+⟩^⊗n = (1/√2^n) Σᵢ |i⟩
    /// - Parameter numberOfQubits: Number of qubits
    public static func uniformSuperposition(numberOfQubits: Int) -> QuantumRegister {
        let register = QuantumRegister(numberOfQubits: numberOfQubits)

        for i in 0..<numberOfQubits {
            register.applyGate(.hadamard, to: i)
        }

        return register
    }
}
