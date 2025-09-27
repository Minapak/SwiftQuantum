//
//  Complex.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-22.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import Foundation

// MARK: - Linear Algebra Foundation: Complex Numbers
//
// Complex numbers form the foundation of quantum computing mathematics.
// In linear algebra terms, complex numbers extend the real number field ℝ to ℂ,
// enabling representation of quantum states with both magnitude and phase.
//
// Key Linear Algebra Concepts Used Here:
// 1. Vector Space: Complex numbers form a 2D vector space over real numbers
//    - Real part: first component
//    - Imaginary part: second component
//
// 2. Inner Product Space: Complex conjugation enables inner products
//    - ⟨z₁, z₂⟩ = z₁* · z₂ (dot product with conjugation)
//    - Used for quantum state overlap calculations
//
// 3. Norm: |z| = √(re² + im²) defines distance in complex plane
//    - Essential for quantum state normalization
//
// Educational Resource:
// For visual understanding of complex numbers and linear algebra:
// https://eunminpark.hashnode.dev/reviews-linear-algebra-through-three-lenses-an-ios-developers-journey-with-3blue1brown
//
// Mathematical Background:
// - Complex multiplication: (a+bi)(c+di) = (ac-bd) + (ad+bc)i
// - Euler's formula: e^(iθ) = cos(θ) + i·sin(θ)
// - Polar form: z = r·e^(iθ) where r is magnitude, θ is phase

/// A complex number implementation optimized for quantum computing
public struct Complex: Equatable, Hashable, Sendable  {
    
    // MARK: - Properties
    
    /// Real part of the complex number
    /// Linear Algebra: First component of 2D vector in ℂ
    public let real: Double
    
    /// Imaginary part of the complex number
    /// Linear Algebra: Second component of 2D vector in ℂ
    public let imaginary: Double
    
    // MARK: - Computed Properties
    
    /// Magnitude (absolute value) of the complex number
    /// Linear Algebra: L2 norm (Euclidean distance from origin)
    /// Formula: ||z|| = √(re² + im²)
    public var magnitude: Double {
        return sqrt(real * real + imaginary * imaginary)
    }
    
    /// Square of the magnitude (for performance optimization)
    /// Linear Algebra: Squared L2 norm, used in probability calculations
    /// Formula: ||z||² = re² + im²
    public var magnitudeSquared: Double {
        return real * real + imaginary * imaginary
    }
    
    /// Phase (argument) of the complex number in radians
    /// Linear Algebra: Angle in polar coordinates
    /// Formula: θ = arctan(im/re)
    public var phase: Double {
        return atan2(imaginary, real)
    }
    
    /// Complex conjugate: a + bi → a - bi
    /// Linear Algebra: Reflection across real axis, used in inner products
    /// Essential for: ⟨ψ|φ⟩ = ψ*·φ (quantum state overlap)
    public var conjugate: Complex {
        return Complex(real, -imaginary)
    }
    
    // MARK: - Initialization
    
    /// Creates a complex number with real and imaginary parts
    /// Linear Algebra: Constructs vector [re, im] in ℂ
    public init(_ real: Double, _ imaginary: Double = 0.0) {
        self.real = real
        self.imaginary = imaginary
    }
    
    // MARK: - Constants
    
    /// Zero complex number (0 + 0i)
    /// Linear Algebra: Zero vector in complex vector space
    public static let zero = Complex(0.0, 0.0)
    
    /// Unity complex number (1 + 0i)
    /// Linear Algebra: Identity element for multiplication
    public static let one = Complex(1.0, 0.0)
    
    /// Imaginary unit (0 + 1i)
    /// Linear Algebra: Basis vector for imaginary axis
    /// Fundamental property: i² = -1
    public static let i = Complex(0.0, 1.0)
    
    /// Negative imaginary unit (0 - 1i)
    /// Linear Algebra: Negative basis vector for imaginary axis
    public static let minusI = Complex(0.0, -1.0)
    
    // MARK: - Arithmetic Operations
    
    /// Addition of two complex numbers
    /// Linear Algebra: Vector addition in ℂ
    /// Formula: (a+bi) + (c+di) = (a+c) + (b+d)i
    public static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real + rhs.real, lhs.imaginary + rhs.imaginary)
    }
    
    /// Subtraction of two complex numbers
    /// Linear Algebra: Vector subtraction in ℂ
    /// Formula: (a+bi) - (c+di) = (a-c) + (b-d)i
    public static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real - rhs.real, lhs.imaginary - rhs.imaginary)
    }
    
    /// Multiplication of two complex numbers
    /// Linear Algebra: Composition of rotations and scalings in complex plane
    /// Formula: (a+bi)(c+di) = (ac-bd) + (ad+bc)i
    /// Geometric interpretation: Multiply magnitudes, add phases
    public static func * (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(
            lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
            lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
        )
    }
    
    /// Division of two complex numbers
    /// Linear Algebra: Inverse operation using conjugate
    /// Formula: z₁/z₂ = (z₁·z₂*) / |z₂|²
    public static func / (lhs: Complex, rhs: Complex) -> Complex {
        let denominator = rhs.magnitudeSquared
        let numerator = lhs * rhs.conjugate
        return Complex(numerator.real / denominator, numerator.imaginary / denominator)
    }
    
    /// Scalar multiplication (complex * real)
    /// Linear Algebra: Scalar multiplication in vector space
    /// Scales magnitude while preserving phase
    public static func * (lhs: Complex, rhs: Double) -> Complex {
        return Complex(lhs.real * rhs, lhs.imaginary * rhs)
    }
    
    /// Scalar multiplication (real * complex)
    /// Linear Algebra: Commutative scalar multiplication
    public static func * (lhs: Double, rhs: Complex) -> Complex {
        return Complex(lhs * rhs.real, lhs * rhs.imaginary)
    }
    
    /// Scalar division (complex / real)
    /// Linear Algebra: Scalar division in vector space
    public static func / (lhs: Complex, rhs: Double) -> Complex {
        return Complex(lhs.real / rhs, lhs.imaginary / rhs)
    }
    
    /// Unary minus
    /// Linear Algebra: Additive inverse (reflection through origin)
    public static prefix func - (operand: Complex) -> Complex {
        return Complex(-operand.real, -operand.imaginary)
    }
    
    // MARK: - Mathematical Functions
    
    /// Complex exponential: e^(a + bi) = e^a * (cos(b) + i*sin(b))
    /// Linear Algebra: Connects exponential with rotation in complex plane (Euler's formula)
    /// This is the bridge between algebra and geometry in quantum mechanics
    /// Formula: e^(iθ) traces unit circle in complex plane
    public static func exp(_ z: Complex) -> Complex {
        let magnitude = Darwin.exp(z.real)
        return Complex(
            magnitude * cos(z.imaginary),
            magnitude * sin(z.imaginary)
        )
    }
}

// MARK: - CustomStringConvertible

extension Complex: CustomStringConvertible {
    public var description: String {
        if abs(imaginary) < 1e-15 {
            return String(format: "%.3f", real)
        }
        
        if abs(real) < 1e-15 {
            if abs(imaginary - 1.0) < 1e-15 {
                return "i"
            } else if abs(imaginary + 1.0) < 1e-15 {
                return "-i"
            } else {
                return String(format: "%.3fi", imaginary)
            }
        }
        
        let realPart = String(format: "%.3f", real)
        let imagPart = abs(imaginary)
        let sign = imaginary >= 0 ? "+" : "-"
        
        if abs(imagPart - 1.0) < 1e-15 {
            return "\(realPart) \(sign) i"
        } else {
            return String(format: "%@ %@ %.3fi", realPart, sign, imagPart)
        }
    }
}

extension Complex {
    /// Checks if two complex numbers are approximately equal
    /// Linear Algebra: Approximate equality in metric space
    /// Uses L∞ norm (maximum absolute difference in components)
    /// - Parameters:
    ///   - other: The other complex number
    ///   - tolerance: The tolerance for comparison (default: 1e-15)
    /// - Returns: true if the numbers are approximately equal
    public func isApproximatelyEqual(to other: Complex, tolerance: Double = 1e-15) -> Bool {
        return abs(real - other.real) < tolerance && abs(imaginary - other.imaginary) < tolerance
    }
}