//
//  Qubit.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-22.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import Foundation

// MARK: - Linear Algebra in Quantum States
//
// A qubit is fundamentally a 2-dimensional complex vector in Hilbert space.
// This implementation demonstrates core linear algebra concepts:
//
// 1. Vector Space Structure (Hilbert Space ℂ²)
//    - Qubits live in 2D complex vector space
//    - |ψ⟩ = α|0⟩ + β|1⟩ is a linear combination of basis vectors
//    - Basis: {|0⟩ = [1,0]ᵀ, |1⟩ = [0,1]ᵀ}
//
// 2. Inner Product Space
//    - Inner product: ⟨φ|ψ⟩ = φ₀*ψ₀ + φ₁*ψ₁ (conjugate transpose)
//    - Norm: ||ψ|| = √⟨ψ|ψ⟩ = √(|α|² + |β|²) = 1 (normalized)
//    - Orthogonality: ⟨0|1⟩ = 0 (basis vectors are orthonormal)
//
// 3. Probability from Inner Products
//    - P(|0⟩) = |⟨0|ψ⟩|² = |α|² (Born rule)
//    - P(|1⟩) = |⟨1|ψ⟩|² = |β|² (Born rule)
//    - Normalization: |α|² + |β|² = 1 ensures valid probabilities
//
// 4. Bloch Sphere Representation (Geometric Visualization)
//    - Maps qubit to point on unit sphere in ℝ³
//    - Uses Pauli matrices (basis for Hermitian operators)
//    - Coordinates: x = ⟨ψ|σₓ|ψ⟩, y = ⟨ψ|σᵧ|ψ⟩, z = ⟨ψ|σᵤ|ψ⟩
//
// Educational Resource:
// For visual understanding of vectors, inner products, and transformations:
// https://eunminpark.hashnode.dev/reviews-linear-algebra-through-three-lenses-an-ios-developers-journey-with-3blue1brown
//
// Key Linear Algebra Concepts:
// - Vector normalization: v̂ = v/||v||
// - Projection: Prob(|i⟩) = |⟨i|ψ⟩|²
// - Basis change: Measurement in different bases
// - Unitary transformations: Quantum gates preserve norm

/// Represents a quantum bit (qubit) with complex amplitude coefficients
///
/// A qubit is the fundamental unit of quantum information, existing in a superposition
/// of |0⟩ and |1⟩ states until measured.
///
/// ## Mathematical Representation
/// |ψ⟩ = α|0⟩ + β|1⟩
/// where |α|² + |β|² = 1 (normalization condition)
///
/// ## Linear Algebra Structure
/// The qubit is a vector in 2D complex Hilbert space:
/// ```
/// |ψ⟩ = [α]  where α, β ∈ ℂ
///       [β]
/// ```
///
/// ## Example Usage
/// ```swift
/// // Create a qubit in |0⟩ state
/// let qubit = Qubit.zero
///
/// // Create a qubit in superposition
/// let superposition = Qubit.superposition
///
/// // Create a custom qubit state
/// let custom = Qubit(
///     amplitude0: Complex(0.6, 0.0),
///     amplitude1: Complex(0.8, 0.0)
/// )
/// ```
public struct Qubit: Equatable, Hashable, Sendable  {
    
    // MARK: - Properties
    
    /// Complex amplitude for |0⟩ state (α coefficient)
    /// Linear Algebra: First component of state vector in ℂ²
    /// Corresponds to [1,0]ᵀ basis vector
    public let amplitude0: Complex
    
    /// Complex amplitude for |1⟩ state (β coefficient)
    /// Linear Algebra: Second component of state vector in ℂ²
    /// Corresponds to [0,1]ᵀ basis vector
    public let amplitude1: Complex
    
    // MARK: - Computed Properties
    
    /// Probability of measuring |0⟩ state
    /// Linear Algebra: Squared inner product |⟨0|ψ⟩|² = |α|²
    /// Born Rule: Probability = |amplitude|²
    public var probability0: Double {
        return amplitude0.magnitudeSquared
    }
    
    /// Probability of measuring |1⟩ state
    /// Linear Algebra: Squared inner product |⟨1|ψ⟩|² = |β|²
    /// Born Rule: Probability = |amplitude|²
    public var probability1: Double {
        return amplitude1.magnitudeSquared
    }
    
    /// Check if the qubit is in a valid quantum state (normalized)
    /// Linear Algebra: Verifies ||ψ|| = 1 (unit vector in Hilbert space)
    /// Normalization condition: |α|² + |β|² = 1
    public var isNormalized: Bool {
        let sum = probability0 + probability1
        return abs(sum - 1.0) < 1e-10
    }
    
    /// Phase difference between |0⟩ and |1⟩ amplitudes
    /// Linear Algebra: Relative phase in complex plane
    /// Important for quantum interference effects
    public var relativePhase: Double {
        return amplitude1.phase - amplitude0.phase
    }
    
    // MARK: - Initialization
    
    /// Creates a qubit with specified amplitudes
    /// Linear Algebra: Constructs normalized vector in ℂ²
    /// Normalization: |ψ⟩ → |ψ⟩/||ψ|| ensures ||ψ|| = 1
    /// - Parameters:
    ///   - amplitude0: Complex amplitude for |0⟩ state
    ///   - amplitude1: Complex amplitude for |1⟩ state
    /// - Note: Amplitudes will be automatically normalized
    public init(amplitude0: Complex, amplitude1: Complex) {
        // Linear Algebra: Calculate L2 norm ||ψ|| = √(|α|² + |β|²)
        let norm = sqrt(amplitude0.magnitudeSquared + amplitude1.magnitudeSquared)
        
        guard norm > 0 else {
            // Handle degenerate case: default to |0⟩ state
            self.amplitude0 = Complex(1.0, 0.0)
            self.amplitude1 = Complex(0.0, 0.0)
            return
        }
        
        // Linear Algebra: Normalize by dividing by norm
        // v̂ = v/||v|| creates unit vector
        self.amplitude0 = amplitude0 / norm
        self.amplitude1 = amplitude1 / norm
    }
    
    /// Creates a qubit from real amplitudes (no imaginary components)
    /// Linear Algebra: Restricts vector to real subspace of ℂ²
    /// - Parameters:
    ///   - alpha: Real amplitude for |0⟩ state
    ///   - beta: Real amplitude for |1⟩ state
    public init(alpha: Double, beta: Double) {
        self.init(
            amplitude0: Complex(alpha, 0.0),
            amplitude1: Complex(beta, 0.0)
        )
    }
    
    // MARK: - Standard States
    
    /// Qubit in |0⟩ state
    /// Linear Algebra: Basis vector [1,0]ᵀ in computational basis
    /// Standard basis vector e₁
    public static let zero = Qubit(amplitude0: Complex(1.0, 0.0), amplitude1: Complex(0.0, 0.0))
    
    /// Qubit in |1⟩ state
    /// Linear Algebra: Basis vector [0,1]ᵀ in computational basis
    /// Standard basis vector e₂
    public static let one = Qubit(amplitude0: Complex(0.0, 0.0), amplitude1: Complex(1.0, 0.0))
    
    /// Qubit in equal superposition (|+⟩ state)
    /// |+⟩ = (|0⟩ + |1⟩)/√2
    /// Linear Algebra: Normalized sum of basis vectors
    /// Vector: [1/√2, 1/√2]ᵀ
    public static let superposition = Qubit(alpha: 1.0/sqrt(2), beta: 1.0/sqrt(2))
    
    /// Qubit in minus superposition (|−⟩ state)
    /// |−⟩ = (|0⟩ − |1⟩)/√2
    /// Linear Algebra: Normalized difference of basis vectors
    /// Vector: [1/√2, -1/√2]ᵀ
    public static let minusSuperposition = Qubit(alpha: 1.0/sqrt(2), beta: -1.0/sqrt(2))
    
    /// Qubit in |i⟩ state (complex superposition)
    /// |i⟩ = (|0⟩ + i|1⟩)/√2
    /// Linear Algebra: Vector with imaginary component
    /// Vector: [1/√2, i/√2]ᵀ, demonstrates complex vector space
    public static let iState = Qubit(
        amplitude0: Complex(1.0/sqrt(2), 0.0),
        amplitude1: Complex(0.0, 1.0/sqrt(2))
    )
    
    /// Qubit in |−i⟩ state (negative complex superposition)
    /// |−i⟩ = (|0⟩ − i|1⟩)/√2
    /// Linear Algebra: Vector with negative imaginary component
    /// Vector: [1/√2, -i/√2]ᵀ
    public static let minusIState = Qubit(
        amplitude0: Complex(1.0/sqrt(2), 0.0),
        amplitude1: Complex(0.0, -1.0/sqrt(2))
    )
    
    // MARK: - Measurement
    
    /// Measures the qubit, collapsing it to either |0⟩ or |1⟩
    /// Linear Algebra: Projection onto basis vectors
    /// P(|0⟩) = |⟨0|ψ⟩|² = |α|² (Born rule)
    /// - Returns: 0 or 1 based on quantum probability
    /// - Note: This is a destructive operation in real quantum systems
    public func measure() -> Int {
        let random = Double.random(in: 0...1)
        return random < probability0 ? 0 : 1
    }
    
    /// Performs multiple measurements and returns statistics
    /// Linear Algebra: Monte Carlo sampling of probability distribution
    /// - Parameter count: Number of measurements to perform
    /// - Returns: Dictionary with measurement results and their frequencies
    public func measureMultiple(count: Int) -> [Int: Int] {
        var results: [Int: Int] = [0: 0, 1: 0]
        
        for _ in 0..<count {
            let result = measure()
            results[result, default: 0] += 1
        }
        
        return results
    }
    
    // MARK: - Quantum State Analysis
    
    /// Calculates the Bloch sphere coordinates (x, y, z)
    /// Linear Algebra: Projects quantum state onto Pauli operator basis
    /// - x = ⟨ψ|σₓ|ψ⟩ = 2Re(α*β) (expectation value of Pauli-X)
    /// - y = ⟨ψ|σᵧ|ψ⟩ = 2Im(α*β) (expectation value of Pauli-Y)
    /// - z = ⟨ψ|σᵤ|ψ⟩ = |α|² - |β|² (expectation value of Pauli-Z)
    /// Result is always on unit sphere: x² + y² + z² = 1
    /// - Returns: Tuple representing the qubit's position on the Bloch sphere
    public func blochCoordinates() -> (x: Double, y: Double, z: Double) {
        // Linear Algebra: Calculate expectation values of Pauli matrices
        // These are inner products ⟨ψ|σᵢ|ψ⟩ for i ∈ {x,y,z}
        let x = 2 * (amplitude0.real * amplitude1.real + amplitude0.imaginary * amplitude1.imaginary)
        let y = 2 * (amplitude1.real * amplitude0.imaginary - amplitude0.real * amplitude1.imaginary)
        let z = probability0 - probability1
        
        return (x: x, y: y, z: z)
    }
    
    /// Calculates the purity of the quantum state
    /// Linear Algebra: For pure states, Tr(ρ²) = 1 where ρ = |ψ⟩⟨ψ|
    /// - Returns: 1.0 for pure states, less for mixed states
    public func purity() -> Double {
        // For pure states, purity is always 1
        // This would be different for density matrices (mixed states)
        return 1.0
    }
    
    /// Calculates von Neumann entropy of the qubit
    /// Linear Algebra: S = -Tr(ρ log ρ) = -∑ᵢ pᵢ log pᵢ
    /// Measures uncertainty/mixedness of state
    /// - Returns: Entropy value (0 for pure |0⟩ or |1⟩, maximum for superposition)
    public func entropy() -> Double {
        let p0 = probability0
        let p1 = probability1
        
        guard p0 > 0 && p1 > 0 else { return 0.0 }
        
        // Shannon entropy formula (von Neumann entropy for qubits)
        return -(p0 * log2(p0) + p1 * log2(p1))
    }
    
    // MARK: - Utility Methods
    
    /// Returns a string representation of the qubit state
    /// Linear Algebra: Displays vector as linear combination of basis vectors
    /// Format: α|0⟩ + β|1⟩
    public func stateDescription() -> String {
        let a0 = amplitude0
        let a1 = amplitude1
        
        var result = ""
        
        // Handle |0⟩ term
        if abs(a0.real) > 1e-10 || abs(a0.imaginary) > 1e-10 {
            result += a0.description + "|0⟩"
        }
        
        // Handle |1⟩ term
        if abs(a1.real) > 1e-10 || abs(a1.imaginary) > 1e-10 {
            if !result.isEmpty {
                result += " + "
            }
            result += a1.description + "|1⟩"
        }
        
        return result.isEmpty ? "0|0⟩" : result
    }
}

// MARK: - CustomStringConvertible

extension Qubit: CustomStringConvertible {
    public var description: String {
        return stateDescription()
    }
}

// MARK: - Quantum State Manipulation

extension Qubit {
    
    /// Creates a random qubit state
    /// Linear Algebra: Generates random point on Bloch sphere (unit sphere in ℝ³)
    /// Uses spherical coordinates then converts to Hilbert space vector
    /// - Returns: A qubit with random amplitudes on the Bloch sphere
    public static func random() -> Qubit {
        let theta = Double.random(in: 0...(2 * .pi))
        let phi = Double.random(in: 0...(2 * .pi))
        
        let alpha = Complex(cos(theta/2), 0.0)
        let beta = Complex(sin(theta/2) * cos(phi), sin(theta/2) * sin(phi))
        
        return Qubit(amplitude0: alpha, amplitude1: beta)
    }
    
    /// Creates a qubit from Bloch sphere angles
    /// Linear Algebra: Converts spherical coordinates to Hilbert space vector
    /// - θ (theta): Polar angle, controls amplitude ratio |α|/|β|
    /// - φ (phi): Azimuthal angle, controls relative phase
    /// Transformation: |ψ⟩ = cos(θ/2)|0⟩ + e^(iφ)sin(θ/2)|1⟩
    /// - Parameters:
    ///   - theta: Polar angle (0 to π)
    ///   - phi: Azimuthal angle (0 to 2π)
    /// - Returns: Qubit corresponding to the Bloch sphere coordinates
    public static func fromBlochAngles(theta: Double, phi: Double) -> Qubit {
        // Linear Algebra: Parameterization of unit sphere
        // Maps (θ,φ) ∈ [0,π]×[0,2π] → point on S² → qubit in ℂ²
        let alpha = Complex(cos(theta/2), 0.0)
        let beta = Complex(sin(theta/2) * cos(phi), sin(theta/2) * sin(phi))
        
        return Qubit(amplitude0: alpha, amplitude1: beta)
    }
}