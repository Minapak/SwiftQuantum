//
//  QuantumStateManager.swift
//  SuperpositionVisualizer
//
//  Observable object for managing quantum state across the app
//

import SwiftUI
#if canImport(SwiftQuantum)
import SwiftQuantum
#else
extension Qubit {
    static var previewSuperposition: Qubit {
        return Qubit.superposition
    }
}
#endif

/// Manages quantum state and distributes it across the app
class QuantumStateManager: ObservableObject {
    @Published var qubit: Qubit
    @Published var probability0: Double
    @Published var phase: Double
    @Published var displayText: String = ""
    @Published var showDisplay: Bool = false
    
    init(qubit: Qubit = Qubit.superposition) {
        self.qubit = qubit
        self.probability0 = qubit.probability0
        self.phase = 0.0
    }
    
    // MARK: - Update Methods
    
    /// Update quantum state directly
    func setQubit(_ newQubit: Qubit) {
        self.qubit = newQubit
        self.probability0 = newQubit.probability0
        withAnimation {
            showDisplay = true
        }
    }
    
    /// Update from probability and phase
    func updateState(probability0: Double, phase: Double) {
        self.probability0 = probability0
        self.phase = phase
        
        let alpha = sqrt(probability0)
        let beta = sqrt(1 - probability0)
        
        self.qubit = Qubit(
            amplitude0: Complex(alpha, 0),
            amplitude1: Complex(beta * cos(phase), beta * sin(phase))
        )
    }
    
    /// Set to a basic state
    func setState(_ state: BasicQuantumState) {
        switch state {
        case .zero:
            setQubit(Qubit.zero)
            displayText = "State: |0⟩\nP(|0⟩): 100%"
            
        case .one:
            setQubit(Qubit.one)
            displayText = "State: |1⟩\nP(|1⟩): 100%"
            
        case .plus:
            setQubit(Qubit.superposition)
            displayText = "State: |+⟩\n(|0⟩ + |1⟩)/√2\nP(|0⟩): 50%"
            
        case .minus:
            let qubit = Qubit(
                amplitude0: Complex(1/sqrt(2), 0),
                amplitude1: Complex(-1/sqrt(2), 0)
            )
            setQubit(qubit)
            displayText = "State: |−⟩\n(|0⟩ − |1⟩)/√2\nP(|0⟩): 50%"
            
        case .iState:
            let qubit = Qubit(
                amplitude0: Complex(1/sqrt(2), 0),
                amplitude1: Complex(0, 1/sqrt(2))
            )
            setQubit(qubit)
            displayText = "State: |i⟩\n(|0⟩ + i|1⟩)/√2"
        }
    }
    
    /// Apply Hadamard gate to the current state
    func applyHadamard() {
        let alpha = sqrt(probability0)
        let beta = sqrt(1 - probability0)
        
        // Hadamard matrix application:
        // H|ψ⟩ = (1/√2)[(α + β)|0⟩ + (α - β)|1⟩]
        let newAlpha = (alpha + beta) / sqrt(2)
        let newBeta = (alpha - beta) / sqrt(2)
        
        let newQubit = Qubit(
            amplitude0: Complex(newAlpha, 0),
            amplitude1: Complex(newBeta, 0)
        )
        
        setQubit(newQubit)
        displayText = "Hadamard Gate Applied\n✓ H|ψ⟩ = (|0⟩ + |1⟩)/√2"
    }
    
    /// Apply Pauli-X gate (bit flip) to the current state
    func applyPauliX() {
        // Pauli-X: |0⟩ ↔ |1⟩
        let newQubit = Qubit(
            amplitude0: qubit.amplitude1,
            amplitude1: qubit.amplitude0
        )
        
        setQubit(newQubit)
        displayText = "Pauli-X Gate Applied\n✓ Bit Flip: |0⟩ ↔ |1⟩"
    }
    
    /// Apply Pauli-Z gate (phase flip) to the current state
    func applyPauliZ() {
        // Pauli-Z: applies -1 phase to |1⟩
        let newQubit = Qubit(
            amplitude0: qubit.amplitude0,
            amplitude1: Complex(qubit.amplitude1.real * -1, qubit.amplitude1.imaginary * -1)
        )
        
        setQubit(newQubit)
        displayText = "Pauli-Z Gate Applied\n✓ Phase Flip"
    }
    
    /// Apply Pauli-Y gate
    func applyPauliY() {
        // Pauli-Y: applies i * Pauli-Z * Pauli-X
        let newQubit = Qubit(
            amplitude0: Complex(qubit.amplitude1.imaginary * -1, qubit.amplitude1.real),
            amplitude1: Complex(qubit.amplitude0.imaginary, qubit.amplitude0.real * -1)
        )
        
        setQubit(newQubit)
        displayText = "Pauli-Y Gate Applied\n✓ Y Rotation"
    }
    
    /// Set superposition with custom probability
    func setSuperposition(_ probability: Double) {
        updateState(probability0: probability, phase: 0.0)
        displayText = "Superposition Set\nP(|0⟩): \(String(format: "%.1f%%", probability * 100))\nP(|1⟩): \(String(format: "%.1f%%", (1-probability) * 100))"
        withAnimation {
            showDisplay = true
        }
    }
    
    /// Perform measurement simulation and update state
    func performMeasurement() {
        let result = qubit.measure()
        if result == 0 {
            setQubit(Qubit.zero)
            displayText = "✓ Measurement Result: |0⟩"
        } else {
            setQubit(Qubit.one)
            displayText = "✓ Measurement Result: |1⟩"
        }
    }
    
    /// Perform statistical measurement
    func performStatisticalMeasurement(_ shots: Int = 1000) {
        let results = qubit.measureMultiple(count: shots)
        let count0 = results[0] ?? 0
        let count1 = results[1] ?? 0
        let p0 = Double(count0) / Double(shots)
        let p1 = Double(count1) / Double(shots)
        
        displayText = """
        ✓ \(shots) Shots Measured
        |0⟩: \(count0) (\(String(format: "%.1f%%", p0 * 100)))
        |1⟩: \(count1) (\(String(format: "%.1f%%", p1 * 100)))
        """
        withAnimation {
            showDisplay = true
        }
    }
    
    /// Reset to default superposition
    func reset() {
        setQubit(Qubit.superposition)
        displayText = "Reset to Default State"
    }
}

// MARK: - Basic Quantum States

enum BasicQuantumState: String, CaseIterable {
    case zero = "|0⟩"
    case one = "|1⟩"
    case plus = "|+⟩"
    case minus = "|−⟩"
    case iState = "|i⟩"
}

// MARK: - Quantum Gate Types

enum QuantumGateType {
    case hadamard
    case pauliX
    case pauliY
    case pauliZ
    case phase
    case tGate
    case rotationX(Double)
    case rotationY(Double)
    case rotationZ(Double)
    
    var description: String {
        switch self {
        case .hadamard: return "Hadamard (H)"
        case .pauliX: return "Pauli-X"
        case .pauliY: return "Pauli-Y"
        case .pauliZ: return "Pauli-Z"
        case .phase: return "Phase (S)"
        case .tGate: return "T Gate"
        case .rotationX: return "Rotation X"
        case .rotationY: return "Rotation Y"
        case .rotationZ: return "Rotation Z"
        }
    }
}
