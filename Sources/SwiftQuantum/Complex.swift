//
//  Complex.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-22.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import Foundation

/// A complex number implementation optimized for quantum computing
public struct Complex: Equatable, Hashable, Sendable  {
    
    // MARK: - Properties
    
    /// Real part of the complex number
    public let real: Double
    
    /// Imaginary part of the complex number
    public let imaginary: Double
    
    // MARK: - Computed Properties
    
    /// Magnitude (absolute value) of the complex number
    public var magnitude: Double {
        return sqrt(real * real + imaginary * imaginary)
    }
    
    /// Square of the magnitude (for performance optimization)
    public var magnitudeSquared: Double {
        return real * real + imaginary * imaginary
    }
    
    /// Phase (argument) of the complex number in radians
    public var phase: Double {
        return atan2(imaginary, real)
    }
    
    /// Complex conjugate: a + bi → a - bi
    public var conjugate: Complex {
        return Complex(real, -imaginary)
    }
    
    // MARK: - Initialization
    
    /// Creates a complex number with real and imaginary parts
    public init(_ real: Double, _ imaginary: Double = 0.0) {
        self.real = real
        self.imaginary = imaginary
    }
    
    // MARK: - Constants
    
    /// Zero complex number (0 + 0i)
    public static let zero = Complex(0.0, 0.0)
    
    /// Unity complex number (1 + 0i)
    public static let one = Complex(1.0, 0.0)
    
    /// Imaginary unit (0 + 1i)
    public static let i = Complex(0.0, 1.0)
    
    /// Negative imaginary unit (0 - 1i)
    public static let minusI = Complex(0.0, -1.0)
    
    // MARK: - Arithmetic Operations
    
    /// Addition of two complex numbers
    public static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real + rhs.real, lhs.imaginary + rhs.imaginary)
    }
    
    /// Subtraction of two complex numbers
    public static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(lhs.real - rhs.real, lhs.imaginary - rhs.imaginary)
    }
    
    /// Multiplication of two complex numbers
    public static func * (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(
            lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
            lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
        )
    }
    
    /// Division of two complex numbers
    public static func / (lhs: Complex, rhs: Complex) -> Complex {
        let denominator = rhs.magnitudeSquared
        let numerator = lhs * rhs.conjugate
        return Complex(numerator.real / denominator, numerator.imaginary / denominator)
    }
    
    /// Scalar multiplication (complex * real)
    public static func * (lhs: Complex, rhs: Double) -> Complex {
        return Complex(lhs.real * rhs, lhs.imaginary * rhs)
    }
    
    /// Scalar multiplication (real * complex)
    public static func * (lhs: Double, rhs: Complex) -> Complex {
        return Complex(lhs * rhs.real, lhs * rhs.imaginary)
    }
    
    /// Scalar division (complex / real)
    public static func / (lhs: Complex, rhs: Double) -> Complex {
        return Complex(lhs.real / rhs, lhs.imaginary / rhs)
    }
    
    /// Unary minus
    public static prefix func - (operand: Complex) -> Complex {
        return Complex(-operand.real, -operand.imaginary)
    }
    
    // MARK: - Mathematical Functions
    
    /// Complex exponential: e^(a + bi) = e^a * (cos(b) + i*sin(b))
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
    /// - Parameters:
    ///   - other: The other complex number
    ///   - tolerance: The tolerance for comparison (default: 1e-15)
    /// - Returns: true if the numbers are approximately equal
    public func isApproximatelyEqual(to other: Complex, tolerance: Double = 1e-15) -> Bool {
        return abs(real - other.real) < tolerance && abs(imaginary - other.imaginary) < tolerance
    }
}
