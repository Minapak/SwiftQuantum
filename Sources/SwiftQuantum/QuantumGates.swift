//
//  QuantumGates.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-22.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import Foundation

/// Collection of fundamental quantum gates for single-qubit operations
///
/// Quantum gates are the building blocks of quantum circuits, representing
/// unitary operations that transform qubit states. This struct provides
/// implementations of the most commonly used single-qubit gates.
///
/// ## Mathematical Background
/// All quantum gates are represented as 2×2 unitary matrices that operate
/// on the complex amplitudes of a qubit state vector.
///
/// ## Example Usage
/// ```swift
/// let qubit = Qubit.zero
/// let superposition = QuantumGates.hadamard(qubit)
/// let rotated = QuantumGates.rotationZ(qubit, angle: .pi/4)
/// ```
public struct QuantumGates {
    
    // MARK: - Pauli Gates
    
    /// Pauli-X Gate (Quantum NOT Gate)
    ///
    /// Flips the qubit state: |0⟩ ↔ |1⟩
    ///
    /// Matrix representation:
    /// ```
    /// X = |0  1|
    ///     |1  0|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Qubit with flipped amplitudes
    public static func pauliX(_ qubit: Qubit) -> Qubit {
        return Qubit(
            amplitude0: qubit.amplitude1,
            amplitude1: qubit.amplitude0
        )
    }
    
    /// Pauli-Y Gate
    ///
    /// Rotates the qubit around the Y-axis of the Bloch sphere
    ///
    /// Matrix representation:
    /// ```
    /// Y = |0  -i|
    ///     |i   0|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Y-rotated qubit state
    public static func pauliY(_ qubit: Qubit) -> Qubit {
        return Qubit(
            amplitude0: Complex(0.0, -1.0) * qubit.amplitude1,
            amplitude1: Complex(0.0, 1.0) * qubit.amplitude0
        )
    }
    
    /// Pauli-Z Gate (Phase Flip Gate)
    ///
    /// Applies a phase flip to the |1⟩ component
    ///
    /// Matrix representation:
    /// ```
    /// Z = |1   0|
    ///     |0  -1|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Phase-flipped qubit state
    public static func pauliZ(_ qubit: Qubit) -> Qubit {
        return Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: -qubit.amplitude1
        )
    }
    
    // MARK: - Hadamard Gate
    
    /// Hadamard Gate
    ///
    /// Creates equal superposition from basis states:
    /// - |0⟩ → (|0⟩ + |1⟩)/√2
    /// - |1⟩ → (|0⟩ - |1⟩)/√2
    ///
    /// Matrix representation:
    /// ```
    /// H = (1/√2) |1   1|
    ///            |1  -1|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Qubit in superposition state
    public static func hadamard(_ qubit: Qubit) -> Qubit {
        let factor = 1.0 / sqrt(2.0)
        
        let newAmplitude0 = factor * (qubit.amplitude0 + qubit.amplitude1)
        let newAmplitude1 = factor * (qubit.amplitude0 - qubit.amplitude1)
        
        return Qubit(
            amplitude0: newAmplitude0,
            amplitude1: newAmplitude1
        )
    }
    
    // MARK: - Phase Gates
    
    /// S Gate (Phase Gate)
    ///
    /// Applies a π/2 phase shift to the |1⟩ component
    ///
    /// Matrix representation:
    /// ```
    /// S = |1  0|
    ///     |0  i|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Phase-shifted qubit state
    public static func sGate(_ qubit: Qubit) -> Qubit {
        return Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: Complex.i * qubit.amplitude1
        )
    }
    
    /// S† Gate (S-dagger, inverse of S gate)
    ///
    /// Applies a -π/2 phase shift to the |1⟩ component
    ///
    /// Matrix representation:
    /// ```
    /// S† = |1   0|
    ///      |0  -i|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Inverse phase-shifted qubit state
    public static func sDagger(_ qubit: Qubit) -> Qubit {
        return Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: Complex.minusI * qubit.amplitude1
        )
    }
    
    /// T Gate (π/8 Gate)
    ///
    /// Applies a π/4 phase shift to the |1⟩ component
    ///
    /// Matrix representation:
    /// ```
    /// T = |1    0   |
    ///     |0  e^(iπ/4)|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: T-gate transformed qubit state
    public static func tGate(_ qubit: Qubit) -> Qubit {
        let phase = Complex.exp(Complex(0.0, .pi / 4))
        
        return Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: phase * qubit.amplitude1
        )
    }
    
    /// T† Gate (T-dagger, inverse of T gate)
    ///
    /// Applies a -π/4 phase shift to the |1⟩ component
    ///
    /// Matrix representation:
    /// ```
    /// T† = |1     0    |
    ///      |0  e^(-iπ/4)|
    /// ```
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Inverse T-gate transformed qubit state
    public static func tDagger(_ qubit: Qubit) -> Qubit {
        let phase = Complex.exp(Complex(0.0, -.pi / 4))
        
        return Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: phase * qubit.amplitude1
        )
    }
    
    // MARK: - Rotation Gates
    
    /// Rotation around X-axis (RX Gate)
    ///
    /// Rotates the qubit state around the X-axis of the Bloch sphere
    ///
    /// Matrix representation:
    /// ```
    /// RX(θ) = |cos(θ/2)  -i*sin(θ/2)|
    ///         |-i*sin(θ/2)  cos(θ/2)|
    /// ```
    ///
    /// - Parameters:
    ///   - qubit: Input qubit state
    ///   - angle: Rotation angle in radians
    /// - Returns: X-rotated qubit state
    public static func rotationX(_ qubit: Qubit, angle: Double) -> Qubit {
        let cos_half = cos(angle / 2.0)
        let sin_half = sin(angle / 2.0)
        let minus_i_sin = Complex(0.0, -sin_half)
        
        let newAmplitude0 = Complex(cos_half, 0.0) * qubit.amplitude0 + minus_i_sin * qubit.amplitude1
        let newAmplitude1 = minus_i_sin * qubit.amplitude0 + Complex(cos_half, 0.0) * qubit.amplitude1
        
        return Qubit(
            amplitude0: newAmplitude0,
            amplitude1: newAmplitude1
        )
    }
    
    /// Rotation around Y-axis (RY Gate)
    ///
    /// Rotates the qubit state around the Y-axis of the Bloch sphere
    ///
    /// Matrix representation:
    /// ```
    /// RY(θ) = |cos(θ/2)  -sin(θ/2)|
    ///         |sin(θ/2)   cos(θ/2)|
    /// ```
    ///
    /// - Parameters:
    ///   - qubit: Input qubit state
    ///   - angle: Rotation angle in radians
    /// - Returns: Y-rotated qubit state
    public static func rotationY(_ qubit: Qubit, angle: Double) -> Qubit {
        let cos_half = cos(angle / 2.0)
        let sin_half = sin(angle / 2.0)
        
        let newAmplitude0 = Complex(cos_half, 0.0) * qubit.amplitude0 + Complex(-sin_half, 0.0) * qubit.amplitude1
        let newAmplitude1 = Complex(sin_half, 0.0) * qubit.amplitude0 + Complex(cos_half, 0.0) * qubit.amplitude1
        
        return Qubit(
            amplitude0: newAmplitude0,
            amplitude1: newAmplitude1
        )
    }
    
    /// Rotation around Z-axis (RZ Gate)
    ///
    /// Rotates the qubit state around the Z-axis of the Bloch sphere
    ///
    /// Matrix representation:
    /// ```
    /// RZ(θ) = |e^(-iθ/2)     0    |
    ///         |    0     e^(iθ/2)|
    /// ```
    ///
    /// - Parameters:
    ///   - qubit: Input qubit state
    ///   - angle: Rotation angle in radians
    /// - Returns: Z-rotated qubit state
    public static func rotationZ(_ qubit: Qubit, angle: Double) -> Qubit {
        let phase_minus = Complex.exp(Complex(0.0, -angle / 2.0))
        let phase_plus = Complex.exp(Complex(0.0, angle / 2.0))
        
        return Qubit(
            amplitude0: phase_minus * qubit.amplitude0,
            amplitude1: phase_plus * qubit.amplitude1
        )
    }
    
    // MARK: - Arbitrary Single-Qubit Gates
    
    /// Universal single-qubit gate (U3 Gate)
    ///
    /// Most general single-qubit unitary operation, parameterized by three angles
    ///
    /// Matrix representation:
    /// ```
    /// U3(θ,φ,λ) = |cos(θ/2)           -e^(iλ)*sin(θ/2)    |
    ///             |e^(iφ)*sin(θ/2)    e^(i(φ+λ))*cos(θ/2)|
    /// ```
    ///
    /// - Parameters:
    ///   - qubit: Input qubit state
    ///   - theta: Rotation angle θ
    ///   - phi: Phase angle φ
    ///   - lambda: Phase angle λ
    /// - Returns: Transformed qubit state
    public static func u3Gate(_ qubit: Qubit, theta: Double, phi: Double, lambda: Double) -> Qubit {
        let cos_half = cos(theta / 2.0)
        let sin_half = sin(theta / 2.0)
        
        let exp_phi = Complex.exp(Complex(0.0, phi))
        let exp_lambda = Complex.exp(Complex(0.0, lambda))
        let exp_phi_lambda = Complex.exp(Complex(0.0, phi + lambda))
        
        let newAmplitude0 = Complex(cos_half, 0.0) * qubit.amplitude0 +
                           (-exp_lambda * sin_half) * qubit.amplitude1
        
        let newAmplitude1 = (exp_phi * sin_half) * qubit.amplitude0 +
                           (exp_phi_lambda * cos_half) * qubit.amplitude1
        
        return Qubit(
            amplitude0: newAmplitude0,
            amplitude1: newAmplitude1
        )
    }
    
    /// Phase Gate with arbitrary angle
    ///
    /// Applies a phase shift of angle φ to the |1⟩ component
    ///
    /// Matrix representation:
    /// ```
    /// P(φ) = |1    0   |
    ///        |0  e^(iφ)|
    /// ```
    ///
    /// - Parameters:
    ///   - qubit: Input qubit state
    ///   - angle: Phase angle in radians
    /// - Returns: Phase-shifted qubit state
    public static func phaseGate(_ qubit: Qubit, angle: Double) -> Qubit {
        let phase = Complex.exp(Complex(0.0, angle))
        
        return Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: phase * qubit.amplitude1
        )
    }
    
    // MARK: - Composite Gates
    
    /// Square root of X gate
    ///
    /// When applied twice, equals the Pauli-X gate
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: √X transformed qubit state
    public static func sqrtX(_ qubit: Qubit) -> Qubit {
        return rotationX(qubit, angle: .pi / 2)
    }
    
    /// Square root of Y gate
    ///
    /// When applied twice, equals the Pauli-Y gate
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: √Y transformed qubit state
    public static func sqrtY(_ qubit: Qubit) -> Qubit {
        return rotationY(qubit, angle: .pi / 2)
    }
    
    /// Identity gate (no operation)
    ///
    /// Returns the qubit unchanged
    ///
    /// - Parameter qubit: Input qubit state
    /// - Returns: Unchanged qubit state
    public static func identity(_ qubit: Qubit) -> Qubit {
        return qubit
    }
}

// MARK: - Gate Sequences

extension QuantumGates {
    
    /// Applies a sequence of single-qubit gates
    ///
    /// - Parameters:
    ///   - qubit: Initial qubit state
    ///   - gates: Array of gate functions to apply in order
    /// - Returns: Final qubit state after applying all gates
    public static func applySequence(_ qubit: Qubit, gates: [(Qubit) -> Qubit]) -> Qubit {
        return gates.reduce(qubit) { current, gate in
            gate(current)
        }
    }
    
    /// Creates a gate that applies the Hadamard gate n times
    ///
    /// Note: H² = I, so even n gives identity, odd n gives Hadamard
    ///
    /// - Parameter n: Number of times to apply Hadamard
    /// - Returns: Gate function
    public static func hadamardPower(_ n: Int) -> (Qubit) -> Qubit {
        return { qubit in
            if n % 2 == 0 {
                return qubit  // Even power of H is identity
            } else {
                return hadamard(qubit)  // Odd power of H is H
            }
        }
    }
}

// MARK: - Gate Verification

extension QuantumGates {
    
    /// Verifies that a gate preserves the normalization of qubit states
    ///
    /// - Parameters:
    ///   - gate: Gate function to test
    ///   - testCases: Array of test qubits (default: standard test cases)
    /// - Returns: true if all test cases remain normalized after gate application
    public static func verifyUnitarity(
        gate: (Qubit) -> Qubit,
        testCases: [Qubit] = [.zero, .one, .superposition, .random(), .random()]
    ) -> Bool {
        for testCase in testCases {
            let result = gate(testCase)
            if !result.isNormalized {
                return false
            }
        }
        return true
    }
    
    /// Checks if two gates are equivalent (within numerical precision)
    ///
    /// - Parameters:
    ///   - gate1: First gate function
    ///   - gate2: Second gate function
    ///   - tolerance: Numerical tolerance for comparison
    /// - Returns: true if gates produce equivalent results
    public static func areGatesEquivalent(
        _ gate1: (Qubit) -> Qubit,
        _ gate2: (Qubit) -> Qubit,
        tolerance: Double = 1e-14
    ) -> Bool {
        let testCases: [Qubit] = [.zero, .one, .superposition, .random(), .random()]
        
        for testCase in testCases {
            let result1 = gate1(testCase)
            let result2 = gate2(testCase)
            
            if !result1.amplitude0.isApproximatelyEqual(to: result2.amplitude0, tolerance: tolerance) ||
               !result1.amplitude1.isApproximatelyEqual(to: result2.amplitude1, tolerance: tolerance) {
                return false
            }
        }
        return true
    }
}
