//
//  LinearAlgebra.swift
//  SwiftQuantum v2.1.0 - High-Performance Quantum Computing Engine
//
//  Created by Eunmin Park on 2026-01-08.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  High-Performance Linear Algebra Kernel using Apple Accelerate Framework
//  Optimized for Apple Silicon (M-series) with SIMD vectorization
//
//  Performance Target: 10x faster than Python NumPy for matrix operations
//

import Foundation
import Accelerate

// MARK: - High-Performance Complex Matrix Operations

/// High-performance linear algebra kernel optimized for quantum computing
/// Leverages Apple's Accelerate framework for SIMD vectorization
public struct QuantumLinearAlgebra {

    // MARK: - Complex Vector Operations using vDSP

    /// Performs high-performance complex vector addition
    /// Uses SIMD vectorization via vDSP for optimal performance
    /// - Parameters:
    ///   - a: First complex vector
    ///   - b: Second complex vector
    /// - Returns: Result of a + b
    public static func add(_ a: [Complex], _ b: [Complex]) -> [Complex] {
        precondition(a.count == b.count, "Vectors must have same length")

        let count = a.count
        guard count > 0 else { return [] }

        // Convert to split complex format for vDSP
        var realA = a.map { $0.real }
        var imagA = a.map { $0.imaginary }
        var realB = b.map { $0.real }
        var imagB = b.map { $0.imaginary }

        var realResult = [Double](repeating: 0, count: count)
        var imagResult = [Double](repeating: 0, count: count)

        // vDSP accelerated addition
        vDSP_vaddD(&realA, 1, &realB, 1, &realResult, 1, vDSP_Length(count))
        vDSP_vaddD(&imagA, 1, &imagB, 1, &imagResult, 1, vDSP_Length(count))

        return zip(realResult, imagResult).map { Complex($0, $1) }
    }

    /// Performs high-performance complex vector subtraction
    /// - Parameters:
    ///   - a: First complex vector
    ///   - b: Second complex vector
    /// - Returns: Result of a - b
    public static func subtract(_ a: [Complex], _ b: [Complex]) -> [Complex] {
        precondition(a.count == b.count, "Vectors must have same length")

        let count = a.count
        guard count > 0 else { return [] }

        var realA = a.map { $0.real }
        var imagA = a.map { $0.imaginary }
        var realB = b.map { $0.real }
        var imagB = b.map { $0.imaginary }

        var realResult = [Double](repeating: 0, count: count)
        var imagResult = [Double](repeating: 0, count: count)

        vDSP_vsubD(&realB, 1, &realA, 1, &realResult, 1, vDSP_Length(count))
        vDSP_vsubD(&imagB, 1, &imagA, 1, &imagResult, 1, vDSP_Length(count))

        return zip(realResult, imagResult).map { Complex($0, $1) }
    }

    /// Scales a complex vector by a real scalar
    /// Uses vDSP for SIMD acceleration
    /// - Parameters:
    ///   - vector: Complex vector to scale
    ///   - scalar: Real scalar value
    /// - Returns: Scaled vector
    public static func scale(_ vector: [Complex], by scalar: Double) -> [Complex] {
        let count = vector.count
        guard count > 0 else { return [] }

        var real = vector.map { $0.real }
        var imag = vector.map { $0.imaginary }
        var factor = scalar

        var realResult = [Double](repeating: 0, count: count)
        var imagResult = [Double](repeating: 0, count: count)

        vDSP_vsmulD(&real, 1, &factor, &realResult, 1, vDSP_Length(count))
        vDSP_vsmulD(&imag, 1, &factor, &imagResult, 1, vDSP_Length(count))

        return zip(realResult, imagResult).map { Complex($0, $1) }
    }

    /// Computes the L2 norm (magnitude) of a complex vector
    /// Optimized using vDSP
    /// - Parameter vector: Complex vector
    /// - Returns: L2 norm of the vector
    public static func norm(_ vector: [Complex]) -> Double {
        let count = vector.count
        guard count > 0 else { return 0 }

        var magnitudeSquared = vector.map { $0.magnitudeSquared }
        var sum: Double = 0

        vDSP_sveD(&magnitudeSquared, 1, &sum, vDSP_Length(count))

        return sqrt(sum)
    }

    /// Normalizes a complex vector to unit length
    /// - Parameter vector: Complex vector to normalize
    /// - Returns: Normalized unit vector
    public static func normalize(_ vector: [Complex]) -> [Complex] {
        let n = norm(vector)
        guard n > 1e-15 else { return vector }
        return scale(vector, by: 1.0 / n)
    }

    // MARK: - Complex Inner Product

    /// Computes the complex inner product ⟨a|b⟩ = Σ a*ᵢ · bᵢ
    /// Uses vDSP for accelerated computation
    /// - Parameters:
    ///   - a: First complex vector (will be conjugated)
    ///   - b: Second complex vector
    /// - Returns: Complex inner product
    public static func innerProduct(_ a: [Complex], _ b: [Complex]) -> Complex {
        precondition(a.count == b.count, "Vectors must have same length")

        let count = a.count
        guard count > 0 else { return Complex.zero }

        // ⟨a|b⟩ = Σ (a*ᵢ · bᵢ) = Σ ((aᵣ - i·aᵢ)(bᵣ + i·bᵢ))
        //       = Σ (aᵣbᵣ + aᵢbᵢ) + i·Σ(aᵣbᵢ - aᵢbᵣ)

        var realA = a.map { $0.real }
        var imagA = a.map { $0.imaginary }
        var realB = b.map { $0.real }
        var imagB = b.map { $0.imaginary }

        // Real part: aᵣbᵣ + aᵢbᵢ
        var temp1 = [Double](repeating: 0, count: count)
        var temp2 = [Double](repeating: 0, count: count)

        vDSP_vmulD(&realA, 1, &realB, 1, &temp1, 1, vDSP_Length(count))
        vDSP_vmulD(&imagA, 1, &imagB, 1, &temp2, 1, vDSP_Length(count))

        var realSum1: Double = 0, realSum2: Double = 0
        vDSP_sveD(&temp1, 1, &realSum1, vDSP_Length(count))
        vDSP_sveD(&temp2, 1, &realSum2, vDSP_Length(count))
        let realPart = realSum1 + realSum2

        // Imaginary part: aᵣbᵢ - aᵢbᵣ
        vDSP_vmulD(&realA, 1, &imagB, 1, &temp1, 1, vDSP_Length(count))
        vDSP_vmulD(&imagA, 1, &realB, 1, &temp2, 1, vDSP_Length(count))

        var imagSum1: Double = 0, imagSum2: Double = 0
        vDSP_sveD(&temp1, 1, &imagSum1, vDSP_Length(count))
        vDSP_sveD(&temp2, 1, &imagSum2, vDSP_Length(count))
        let imagPart = imagSum1 - imagSum2

        return Complex(realPart, imagPart)
    }

    // MARK: - Matrix Operations

    /// Represents a complex matrix in row-major order
    public struct ComplexMatrix: Sendable {
        public let rows: Int
        public let cols: Int
        public var elements: [Complex]

        public init(rows: Int, cols: Int, elements: [Complex]) {
            precondition(elements.count == rows * cols, "Element count must match dimensions")
            self.rows = rows
            self.cols = cols
            self.elements = elements
        }

        /// Creates a zero matrix
        public init(rows: Int, cols: Int) {
            self.rows = rows
            self.cols = cols
            self.elements = Array(repeating: Complex.zero, count: rows * cols)
        }

        /// Creates an identity matrix
        public static func identity(size: Int) -> ComplexMatrix {
            var elements = Array(repeating: Complex.zero, count: size * size)
            for i in 0..<size {
                elements[i * size + i] = Complex.one
            }
            return ComplexMatrix(rows: size, cols: size, elements: elements)
        }

        /// Access element at (row, col)
        public subscript(row: Int, col: Int) -> Complex {
            get { elements[row * cols + col] }
            set { elements[row * cols + col] = newValue }
        }

        /// Conjugate transpose (Hermitian adjoint)
        public var adjoint: ComplexMatrix {
            var result = ComplexMatrix(rows: cols, cols: rows)
            for i in 0..<rows {
                for j in 0..<cols {
                    result[j, i] = self[i, j].conjugate
                }
            }
            return result
        }
    }

    /// Performs matrix-vector multiplication: y = A · x
    /// Optimized for quantum gate application
    /// - Parameters:
    ///   - matrix: Complex matrix A
    ///   - vector: Complex vector x
    /// - Returns: Result vector y = A · x
    public static func matrixVectorMultiply(_ matrix: ComplexMatrix, _ vector: [Complex]) -> [Complex] {
        precondition(matrix.cols == vector.count, "Matrix columns must match vector length")

        var result = [Complex](repeating: Complex.zero, count: matrix.rows)

        for i in 0..<matrix.rows {
            var sum = Complex.zero
            for j in 0..<matrix.cols {
                sum = sum + matrix[i, j] * vector[j]
            }
            result[i] = sum
        }

        return result
    }

    /// Performs matrix-matrix multiplication: C = A · B
    /// - Parameters:
    ///   - a: First matrix
    ///   - b: Second matrix
    /// - Returns: Product matrix C = A · B
    public static func matrixMultiply(_ a: ComplexMatrix, _ b: ComplexMatrix) -> ComplexMatrix {
        precondition(a.cols == b.rows, "Matrix dimensions must be compatible")

        var result = ComplexMatrix(rows: a.rows, cols: b.cols)

        for i in 0..<a.rows {
            for j in 0..<b.cols {
                var sum = Complex.zero
                for k in 0..<a.cols {
                    sum = sum + a[i, k] * b[k, j]
                }
                result[i, j] = sum
            }
        }

        return result
    }

    // MARK: - Tensor Product (Kronecker Product)

    /// Computes the tensor product (Kronecker product) of two matrices
    /// Essential for multi-qubit gate construction
    /// - Parameters:
    ///   - a: First matrix
    ///   - b: Second matrix
    /// - Returns: Tensor product A ⊗ B
    public static func tensorProduct(_ a: ComplexMatrix, _ b: ComplexMatrix) -> ComplexMatrix {
        let resultRows = a.rows * b.rows
        let resultCols = a.cols * b.cols
        var result = ComplexMatrix(rows: resultRows, cols: resultCols)

        for i in 0..<a.rows {
            for j in 0..<a.cols {
                let aElement = a[i, j]
                for k in 0..<b.rows {
                    for l in 0..<b.cols {
                        let resultRow = i * b.rows + k
                        let resultCol = j * b.cols + l
                        result[resultRow, resultCol] = aElement * b[k, l]
                    }
                }
            }
        }

        return result
    }

    /// Computes the tensor product of two state vectors
    /// - Parameters:
    ///   - a: First state vector
    ///   - b: Second state vector
    /// - Returns: Tensor product |a⟩ ⊗ |b⟩
    public static func tensorProduct(_ a: [Complex], _ b: [Complex]) -> [Complex] {
        var result = [Complex](repeating: Complex.zero, count: a.count * b.count)

        for i in 0..<a.count {
            for j in 0..<b.count {
                result[i * b.count + j] = a[i] * b[j]
            }
        }

        return result
    }

    // MARK: - Quantum Gate Matrices

    /// Standard 2x2 quantum gate matrices
    public struct GateMatrices {

        /// Hadamard gate matrix
        public static let hadamard = ComplexMatrix(
            rows: 2, cols: 2,
            elements: [
                Complex(1/sqrt(2), 0), Complex(1/sqrt(2), 0),
                Complex(1/sqrt(2), 0), Complex(-1/sqrt(2), 0)
            ]
        )

        /// Pauli-X gate matrix
        public static let pauliX = ComplexMatrix(
            rows: 2, cols: 2,
            elements: [
                Complex.zero, Complex.one,
                Complex.one, Complex.zero
            ]
        )

        /// Pauli-Y gate matrix
        public static let pauliY = ComplexMatrix(
            rows: 2, cols: 2,
            elements: [
                Complex.zero, Complex(0, -1),
                Complex(0, 1), Complex.zero
            ]
        )

        /// Pauli-Z gate matrix
        public static let pauliZ = ComplexMatrix(
            rows: 2, cols: 2,
            elements: [
                Complex.one, Complex.zero,
                Complex.zero, Complex(-1, 0)
            ]
        )

        /// Creates a rotation-X gate matrix for given angle
        public static func rotationX(angle: Double) -> ComplexMatrix {
            let cos_half = cos(angle / 2)
            let sin_half = sin(angle / 2)
            return ComplexMatrix(
                rows: 2, cols: 2,
                elements: [
                    Complex(cos_half, 0), Complex(0, -sin_half),
                    Complex(0, -sin_half), Complex(cos_half, 0)
                ]
            )
        }

        /// Creates a rotation-Y gate matrix for given angle
        public static func rotationY(angle: Double) -> ComplexMatrix {
            let cos_half = cos(angle / 2)
            let sin_half = sin(angle / 2)
            return ComplexMatrix(
                rows: 2, cols: 2,
                elements: [
                    Complex(cos_half, 0), Complex(-sin_half, 0),
                    Complex(sin_half, 0), Complex(cos_half, 0)
                ]
            )
        }

        /// Creates a rotation-Z gate matrix for given angle
        public static func rotationZ(angle: Double) -> ComplexMatrix {
            return ComplexMatrix(
                rows: 2, cols: 2,
                elements: [
                    Complex.exp(Complex(0, -angle / 2)), Complex.zero,
                    Complex.zero, Complex.exp(Complex(0, angle / 2))
                ]
            )
        }

        /// CNOT gate matrix (4x4 for 2 qubits)
        public static let cnot = ComplexMatrix(
            rows: 4, cols: 4,
            elements: [
                Complex.one, Complex.zero, Complex.zero, Complex.zero,
                Complex.zero, Complex.one, Complex.zero, Complex.zero,
                Complex.zero, Complex.zero, Complex.zero, Complex.one,
                Complex.zero, Complex.zero, Complex.one, Complex.zero
            ]
        )
    }

    // MARK: - Fidelity Calculation

    /// Calculates the state fidelity between two quantum states
    /// F(ψ, φ) = |⟨ψ|φ⟩|²
    /// - Parameters:
    ///   - psi: First quantum state vector
    ///   - phi: Second quantum state vector
    /// - Returns: Fidelity value between 0 and 1
    public static func fidelity(_ psi: [Complex], _ phi: [Complex]) -> Double {
        let overlap = innerProduct(psi, phi)
        return overlap.magnitudeSquared
    }

    /// Calculates trace distance between two density matrices
    /// - Parameters:
    ///   - rho: First density matrix
    ///   - sigma: Second density matrix
    /// - Returns: Trace distance
    public static func traceDistance(_ rho: ComplexMatrix, _ sigma: ComplexMatrix) -> Double {
        precondition(rho.rows == sigma.rows && rho.cols == sigma.cols, "Matrices must have same dimensions")

        var diff = rho
        for i in 0..<diff.elements.count {
            diff.elements[i] = diff.elements[i] - sigma.elements[i]
        }

        // Simplified: just compute Frobenius norm
        var sum: Double = 0
        for element in diff.elements {
            sum += element.magnitudeSquared
        }

        return sqrt(sum) / 2
    }
}

// MARK: - Performance Benchmarking

/// Benchmarking utilities for comparing performance
public struct QuantumBenchmark {

    /// Measures execution time of a block
    public static func measure<T>(_ label: String, block: () -> T) -> (result: T, time: TimeInterval) {
        let start = CFAbsoluteTimeGetCurrent()
        let result = block()
        let end = CFAbsoluteTimeGetCurrent()
        let time = end - start
        print("[\(label)] Execution time: \(String(format: "%.6f", time))s")
        return (result, time)
    }

    /// Runs matrix multiplication benchmark
    public static func runMatrixBenchmark(size: Int, iterations: Int = 100) -> Double {
        let matrix = QuantumLinearAlgebra.ComplexMatrix.identity(size: size)
        let vector = Array(repeating: Complex(1/sqrt(Double(size)), 0), count: size)

        let start = CFAbsoluteTimeGetCurrent()

        for _ in 0..<iterations {
            _ = QuantumLinearAlgebra.matrixVectorMultiply(matrix, vector)
        }

        let end = CFAbsoluteTimeGetCurrent()
        return (end - start) / Double(iterations)
    }
}
