// Add to a new file: Utilities/Extensions.swift

import SwiftUI

// MARK: - Color Extensions (추가 필요한 것들)
extension Color {
    static let quantumGreen = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let quantumRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let quantumYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
}

// MARK: - Complex Number for Quantum States
struct Complex: Codable {
    var real: Double
    var imaginary: Double
    
    static let zero = Complex(real: 0, imaginary: 0)
    static let one = Complex(real: 1, imaginary: 0)
    static let i = Complex(real: 0, imaginary: 1)
    
    var magnitude: Double {
        sqrt(real * real + imaginary * imaginary)
    }
}

// MARK: - Qubit State
struct QubitState: Codable {
    var alpha: Complex = Complex.one
    var beta: Complex = Complex.zero
    
    var prob0: Double {
        alpha.magnitude * alpha.magnitude
    }
    
    var prob1: Double {
        beta.magnitude * beta.magnitude
    }
    
    mutating func reset() {
        alpha = Complex.one
        beta = Complex.zero
    }
    
    mutating func setToOne() {
        alpha = Complex.zero
        beta = Complex.one
    }
    
    mutating func setToPlus() {
        let sqrt2 = 1.0 / sqrt(2.0)
        alpha = Complex(real: sqrt2, imaginary: 0)
        beta = Complex(real: sqrt2, imaginary: 0)
    }
    
    mutating func setToMinus() {
        let sqrt2 = 1.0 / sqrt(2.0)
        alpha = Complex(real: sqrt2, imaginary: 0)
        beta = Complex(real: -sqrt2, imaginary: 0)
    }
    
    mutating func applyHadamard() {
        let sqrt2 = 1.0 / sqrt(2.0)
        let newAlpha = Complex(
            real: sqrt2 * (alpha.real + beta.real),
            imaginary: sqrt2 * (alpha.imaginary + beta.imaginary)
        )
        let newBeta = Complex(
            real: sqrt2 * (alpha.real - beta.real),
            imaginary: sqrt2 * (alpha.imaginary - beta.imaginary)
        )
        alpha = newAlpha
        beta = newBeta
    }
    
    mutating func applyPauliX() {
        swap(&alpha, &beta)
    }
    
    mutating func applyPauliY() {
        let newAlpha = Complex(
            real: -beta.imaginary,
            imaginary: beta.real
        )
        let newBeta = Complex(
            real: alpha.imaginary,
            imaginary: -alpha.real
        )
        alpha = newAlpha
        beta = newBeta
    }
    
    mutating func applyPauliZ() {
        beta = Complex(
            real: -beta.real,
            imaginary: -beta.imaginary
        )
    }
    
    mutating func applyPhaseS() {
        beta = Complex(
            real: -beta.imaginary,
            imaginary: beta.real
        )
    }
    
    mutating func applyTGate() {
        let sqrt2 = 1.0 / sqrt(2.0)
        beta = Complex(
            real: sqrt2 * (beta.real - beta.imaginary),
            imaginary: sqrt2 * (beta.real + beta.imaginary)
        )
    }
}

// MARK: - Quantum Circuit Model
struct QuantumCircuit: Codable {
    var gates: [String] = []
    var qubits: Int = 1
    
    mutating func addGate(_ gate: String) {
        gates.append(gate)
    }
    
    mutating func clear() {
        gates.removeAll()
    }
}
