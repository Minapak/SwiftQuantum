
//
//  Qubit.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-22.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import Foundation

/// Represents a quantum bit (qubit) with complex amplitude coefficients
///
/// A qubit is the fundamental unit of quantum information, existing in a superposition
/// of |0⟩ and |1⟩ states until measured.
///
/// ## Mathematical Representation
/// |ψ⟩ = α|0⟩ + β|1⟩
/// where |α|² + |β|² = 1 (normalization condition)
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
    public let amplitude0: Complex
    
    /// Complex amplitude for |1⟩ state (β coefficient)
    public let amplitude1: Complex
    
    // MARK: - Computed Properties
    
    /// Probability of measuring |0⟩ state
    public var probability0: Double {
        return amplitude0.magnitudeSquared
    }
    
    /// Probability of measuring |1⟩ state
    public var probability1: Double {
        return amplitude1.magnitudeSquared
    }
    
    /// Check if the qubit is in a valid quantum state (normalized)
    public var isNormalized: Bool {
        let sum = probability0 + probability1
        return abs(sum - 1.0) < 1e-10
    }
    
    /// Phase difference between |0⟩ and |1⟩ amplitudes
    public var relativePhase: Double {
        return amplitude1.phase - amplitude0.phase
    }
    
    // MARK: - Initialization
    
    /// Creates a qubit with specified amplitudes
    /// - Parameters:
    ///   - amplitude0: Complex amplitude for |0⟩ state
    ///   - amplitude1: Complex amplitude for |1⟩ state
    /// - Note: Amplitudes will be automatically normalized
    public init(amplitude0: Complex, amplitude1: Complex) {
        let norm = sqrt(amplitude0.magnitudeSquared + amplitude1.magnitudeSquared)
        
        guard norm > 0 else {
            // Handle degenerate case
            self.amplitude0 = Complex(1.0, 0.0)
            self.amplitude1 = Complex(0.0, 0.0)
            return
        }
        
        self.amplitude0 = amplitude0 / norm
        self.amplitude1 = amplitude1 / norm
    }
    
    /// Creates a qubit from real amplitudes (no imaginary components)
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
    public static let zero = Qubit(amplitude0: Complex(1.0, 0.0), amplitude1: Complex(0.0, 0.0))
    
    /// Qubit in |1⟩ state
    public static let one = Qubit(amplitude0: Complex(0.0, 0.0), amplitude1: Complex(1.0, 0.0))
    
    /// Qubit in equal superposition (|+⟩ state)
    /// |+⟩ = (|0⟩ + |1⟩)/√2
    public static let superposition = Qubit(alpha: 1.0/sqrt(2), beta: 1.0/sqrt(2))
    
    /// Qubit in minus superposition (|−⟩ state)
    /// |−⟩ = (|0⟩ − |1⟩)/√2
    public static let minusSuperposition = Qubit(alpha: 1.0/sqrt(2), beta: -1.0/sqrt(2))
    
    /// Qubit in |i⟩ state (complex superposition)
    /// |i⟩ = (|0⟩ + i|1⟩)/√2
    public static let iState = Qubit(
        amplitude0: Complex(1.0/sqrt(2), 0.0),
        amplitude1: Complex(0.0, 1.0/sqrt(2))
    )
    
    /// Qubit in |−i⟩ state (negative complex superposition)
    /// |−i⟩ = (|0⟩ − i|1⟩)/√2
    public static let minusIState = Qubit(
        amplitude0: Complex(1.0/sqrt(2), 0.0),
        amplitude1: Complex(0.0, -1.0/sqrt(2))
    )
    
    // MARK: - Measurement
    
    /// Measures the qubit, collapsing it to either |0⟩ or |1⟩
    /// - Returns: 0 or 1 based on quantum probability
    /// - Note: This is a destructive operation in real quantum systems
    public func measure() -> Int {
        let random = Double.random(in: 0...1)
        return random < probability0 ? 0 : 1
    }
    
    /// Performs multiple measurements and returns statistics
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
    /// - Returns: Tuple representing the qubit's position on the Bloch sphere
    public func blochCoordinates() -> (x: Double, y: Double, z: Double) {
        let x = 2 * (amplitude0.real * amplitude1.real + amplitude0.imaginary * amplitude1.imaginary)
        let y = 2 * (amplitude1.real * amplitude0.imaginary - amplitude0.real * amplitude1.imaginary)
        let z = probability0 - probability1
        
        return (x: x, y: y, z: z)
    }
    
    /// Calculates the purity of the quantum state
    /// - Returns: 1.0 for pure states, less for mixed states
    public func purity() -> Double {
        // For pure states, purity is always 1
        // This would be different for density matrices
        return 1.0
    }
    
    /// Calculates von Neumann entropy of the qubit
    /// - Returns: Entropy value (0 for pure |0⟩ or |1⟩, maximum for superposition)
    public func entropy() -> Double {
        let p0 = probability0
        let p1 = probability1
        
        guard p0 > 0 && p1 > 0 else { return 0.0 }
        
        return -(p0 * log2(p0) + p1 * log2(p1))
    }
    
    // MARK: - Utility Methods
    
    /// Returns a string representation of the qubit state
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
    /// - Returns: A qubit with random amplitudes on the Bloch sphere
    public static func random() -> Qubit {
        let theta = Double.random(in: 0...(2 * .pi))
        let phi = Double.random(in: 0...(2 * .pi))
        
        let alpha = Complex(cos(theta/2), 0.0)
        let beta = Complex(sin(theta/2) * cos(phi), sin(theta/2) * sin(phi))
        
        return Qubit(amplitude0: alpha, amplitude1: beta)
    }
    
    /// Creates a qubit from Bloch sphere angles
    /// - Parameters:
    ///   - theta: Polar angle (0 to π)
    ///   - phi: Azimuthal angle (0 to 2π)
    /// - Returns: Qubit corresponding to the Bloch sphere coordinates
    public static func fromBlochAngles(theta: Double, phi: Double) -> Qubit {
        let alpha = Complex(cos(theta/2), 0.0)
        let beta = Complex(sin(theta/2) * cos(phi), sin(theta/2) * sin(phi))
        
        return Qubit(amplitude0: alpha, amplitude1: beta)
    }
}
