//
//  BasicQuantumOperations.swift
//  SwiftQuantum Examples
//
//  Created by Eunmin Park on 2025-09-22.
//

import Foundation
import SwiftQuantum

/// Examples demonstrating basic quantum operations
public class BasicQuantumOperations {
    
    /// Demonstrates creating and measuring qubits
    public static func qubitBasics() {
        print("=== Qubit Basics ===")
        
        // Create qubits in different states
        let zero = Qubit.zero
        let one = Qubit.one
        let superposition = Qubit.superposition
        
        print("Zero state: \(zero)")
        print("One state: \(one)")
        print("Superposition: \(superposition)")
        
        // Demonstrate measurement
        print("\nMeasurement results (1000 shots):")
        let measurements = superposition.measureMultiple(count: 1000)
        print("  |0⟩: \(measurements[0] ?? 0) times")
        print("  |1⟩: \(measurements[1] ?? 0) times")
        
        print()
    }
    
    /// Demonstrates quantum gates
    public static func quantumGates() {
        print("=== Quantum Gates ===")
        
        let qubit = Qubit.zero
        print("Initial state: \(qubit)")
        
        // Apply Pauli-X gate (quantum NOT)
        let flipped = QuantumGates.pauliX(qubit)
        print("After X gate: \(flipped)")
        
        // Apply Hadamard gate
        let hadamarded = QuantumGates.hadamard(qubit)
        print("After H gate: \(hadamarded)")
        
        // Apply rotation gates
        let rotated = QuantumGates.rotationY(qubit, angle: .pi/4)
        print("After RY(π/4): \(rotated)")
        
        print()
    }
    
    /// Demonstrates quantum circuits
    public static func quantumCircuits() {
        print("=== Quantum Circuits ===")
        
        // Create a circuit
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        circuit.addGate(.rotationZ(.pi/4))
        circuit.addGate(.hadamard)
        
        print("Circuit diagram:")
        print(circuit.asciiDiagram())
        
        // Execute circuit
        let finalState = circuit.execute()
        print("Final state: \(finalState)")
        
        // Measure multiple times
        let results = circuit.measureMultiple(shots: 1000)
        print("Measurement results:")
        print("  |0⟩: \(results[0] ?? 0)")
        print("  |1⟩: \(results[1] ?? 0)")
        
        print()
    }
    
    /// Demonstrates Bell state preparation
    public static func bellState() {
        print("=== Bell State Preparation ===")
        
        let bellCircuit = QuantumCircuit.bellState()
        print("Bell state circuit:")
        print(bellCircuit.asciiDiagram())
        
        let state = bellCircuit.execute()
        print("Bell state: \(state)")
        
        // This creates a superposition for single qubit
        let (prob0, prob1) = bellCircuit.theoreticalProbabilities()
        print("Probabilities: |0⟩ = \(prob0), |1⟩ = \(prob1)")
        
        print()
    }
    
    /// Demonstrates quantum random number generation
    public static func quantumRandomNumbers() {
        print("=== Quantum Random Number Generation ===")
        
        let randomCircuit = QuantumCircuit(qubit: .zero)
        randomCircuit.addGate(.hadamard)
        
        print("Generating 10 quantum random bits:")
        var randomBits: [Int] = []
        
        for _ in 0..<10 {
            let bit = randomCircuit.executeAndMeasure()
            randomBits.append(bit)
        }
        
        print("Random bits: \(randomBits)")
        
        // Convert to random number (0-1023)
        let randomNumber = randomBits.enumerated().reduce(0) { result, pair in
            let (index, bit) = pair
            return result + bit * Int(pow(2.0, Double(index)))
        }
        
        print("Random number (0-1023): \(randomNumber)")
        
        print()
    }
    
    /// Run all examples
    public static func runAllExamples() {
        print("🚀 iOS Quantum Engineering - Swift Examples")
        print("==========================================\n")
        
        qubitBasics()
        quantumGates()
        quantumCircuits()
        bellState()
        quantumRandomNumbers()
        
        print("✅ All examples completed successfully!")
    }
}
