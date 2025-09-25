//
//  AdvancedQuantumExamples.swift
//  SwiftQuantum Examples
//
//  Created by Eunmin Park on 2025-09-22.
//

import Foundation
import SwiftQuantum

/// Advanced examples demonstrating quantum algorithms and applications
public class AdvancedQuantumExamples {
    
    /// Demonstrates the Deutsch Algorithm (simplified single-qubit version)
    /// Determines if a function is constant or balanced with just one quantum evaluation
    public static func deutschAlgorithm() {
        print("=== Deutsch Algorithm ===")
        print("Quantum algorithm to determine if a function is constant or balanced")
        print()
        
        // Test with constant function (f(x) = 0)
        let constantResult = deutschAlgorithmImplementation(isConstant: true)
        print("Constant function test:")
        print("Result: \(constantResult ? "CONSTANT" : "BALANCED")")
        
        // Test with balanced function (f(x) = x)
        let balancedResult = deutschAlgorithmImplementation(isConstant: false)
        print("Balanced function test:")
        print("Result: \(balancedResult ? "CONSTANT" : "BALANCED")")
        
        print("✅ Deutsch algorithm demonstrates quantum advantage!")
        print()
    }
    
    private static func deutschAlgorithmImplementation(isConstant: Bool) -> Bool {
        let circuit = QuantumCircuit(qubit: .zero)
        
        // Step 1: Create superposition
        circuit.addGate(.hadamard)
        
        // Step 2: Apply oracle (function)
        if !isConstant {
            // Balanced function: flip the bit
            circuit.addGate(.pauliX)
        }
        // Constant function: do nothing
        
        // Step 3: Interference
        circuit.addGate(.hadamard)
        
        // Step 4: Measure
        let measurements = circuit.measureMultiple(shots: 1000)
        let zeroCount = measurements[0] ?? 0
        
        // If mostly |0⟩, function is constant
        // If mostly |1⟩, function is balanced
        return zeroCount > 500
    }
    
    /// Demonstrates Quantum Phase Estimation (simplified)
    public static func quantumPhaseEstimation() {
        print("=== Quantum Phase Estimation ===")
        print("Estimating the phase of a quantum gate")
        print()
        
        // Estimate phase of S gate (should be π/2)
        let estimatedPhase = estimatePhase(gate: .sGate)
        let actualPhase = Double.pi / 2.0
        
        print("S Gate phase estimation:")
        print("Estimated: \(String(format: "%.4f", estimatedPhase))")
        print("Actual: \(String(format: "%.4f", actualPhase))")
        print("Error: \(String(format: "%.4f", abs(estimatedPhase - actualPhase)))")
        
        // Estimate phase of T gate (should be π/4)
        let tPhaseEstimated = estimatePhase(gate: .tGate)
        let tPhaseActual = Double.pi / 4.0
        
        print("\nT Gate phase estimation:")
        print("Estimated: \(String(format: "%.4f", tPhaseEstimated))")
        print("Actual: \(String(format: "%.4f", tPhaseActual))")
        print("Error: \(String(format: "%.4f", abs(tPhaseEstimated - tPhaseActual)))")
        
        print()
    }
    
    private static func estimatePhase(gate: QuantumCircuit.Gate) -> Double {
        // Simple phase estimation using interference
        let circuit = QuantumCircuit(qubit: .one) // Start with |1⟩
        
        // Apply gate multiple times and measure phase accumulation
        circuit.addGate(gate)
        circuit.addGate(.hadamard)
        
        let finalState = circuit.execute()
        
        // Extract phase from the complex amplitudes
        let phase = finalState.amplitude1.phase - finalState.amplitude0.phase
        return abs(phase)
    }
    
    /// Demonstrates Quantum Random Walk
    public static func quantumRandomWalk() {
        print("=== Quantum Random Walk ===")
        print("Simulating quantum random walk with coin flips")
        print()
        
        let steps = 10
        var position = 0
        var positions: [Int] = [position]
        
        print("Classical random walk:")
        for step in 1...steps {
            // Classical coin flip
            let coinFlip = Int.random(in: 0...1)
            position += coinFlip == 0 ? -1 : 1
            positions.append(position)
            
            if step <= 5 || step % 2 == 0 {
                print("Step \(step): position = \(position)")
            }
        }
        print("Final classical position: \(position)")
        
        print("\nQuantum random walk:")
        var quantumPositions: [Double] = []
        
        for step in 1...steps {
            let walkCircuit = QuantumCircuit(qubit: .zero)
            
            // Quantum coin: Hadamard creates superposition
            walkCircuit.addGate(.hadamard)
            
            // Add some quantum interference
            if step % 2 == 0 {
                walkCircuit.addGate(.rotationZ(Double.pi / 4))
            }
            
            // Measure and calculate expected position
            let measurements = walkCircuit.measureMultiple(shots: 1000)
            let prob1 = Double(measurements[1] ?? 0) / 1000.0
            let expectedStep = 2 * prob1 - 1 // Convert to -1, +1
            
            quantumPositions.append(expectedStep)
            
            if step <= 5 || step % 2 == 0 {
                print("Step \(step): quantum bias = \(String(format: "%.3f", expectedStep))")
            }
        }
        
        let quantumTotal = quantumPositions.reduce(0, +)
        print("Quantum walk total bias: \(String(format: "%.3f", quantumTotal))")
        
        print()
    }
    
    /// Demonstrates Quantum Fourier Transform (single qubit version)
    public static func quantumFourierTransform() {
        print("=== Quantum Fourier Transform ===")
        print("Single-qubit QFT demonstration")
        print()
        
        // QFT on single qubit is just Hadamard
        let qftCircuit = QuantumCircuit(qubit: .zero)
        qftCircuit.addGate(.hadamard)
        
        print("QFT Circuit:")
        print(qftCircuit.asciiDiagram())
        
        // Apply QFT to different input states
        let testStates: [(String, Qubit)] = [
            ("|0⟩", .zero),
            ("|1⟩", .one),
            ("|+⟩", .superposition),
            ("|−⟩", .minusSuperposition)
        ]
        
        for (name, state) in testStates {
            let circuit = QuantumCircuit(qubit: state)
            circuit.addGate(.hadamard) // Single-qubit QFT
            
            let result = circuit.execute()
            let (prob0, prob1) = circuit.theoreticalProbabilities()
            
            print("\nQFT(\(name)):")
            print("Output state: \(result.stateDescription())")
            print("Probabilities: |0⟩ = \(String(format: "%.3f", prob0)), |1⟩ = \(String(format: "%.3f", prob1))")
        }
        
        print()
    }
    
    /// Demonstrates Quantum Interference Patterns
    public static func quantumInterference() {
        print("=== Quantum Interference Patterns ===")
        print("Exploring constructive and destructive interference")
        print()
        
        // Create interference with different phase rotations
        let phases: [Double] = [0, .pi/4, .pi/2, 3*.pi/4, .pi, 5*.pi/4, 3*.pi/2, 7*.pi/4]
        
        print("Phase\t|0⟩ Prob\t|1⟩ Prob\tDescription")
        print("-----\t-------\t-------\t-----------")
        
        for phase in phases {
            let circuit = QuantumCircuit(qubit: .zero)
            circuit.addGate(.hadamard)          // Create superposition
            circuit.addGate(.rotationZ(phase))  // Add phase
            circuit.addGate(.hadamard)          // Create interference
            
            let (prob0, prob1) = circuit.theoreticalProbabilities()
            let phaseStr = String(format: "%.2fπ", phase / .pi)
            let prob0Str = String(format: "%.3f", prob0)
            let prob1Str = String(format: "%.3f", prob1)
            
            let description = prob0 > 0.8 ? "Constructive" :
                             prob1 > 0.8 ? "Destructive" : "Mixed"
            
            print("\(phaseStr)\t\(prob0Str)\t\t\(prob1Str)\t\t\(description)")
        }
        
        print("\n💫 Notice how different phases create different interference patterns!")
        print()
    }
    
    /// Demonstrates Quantum State Tomography (reconstruction)
    public static func quantumStateTomography() {
        print("=== Quantum State Tomography ===")
        print("Reconstructing unknown quantum states through measurements")
        print()
        
        // Create an unknown state
        let unknownState = Qubit.fromBlochAngles(theta: .pi/3, phi: .pi/4)
        print("Unknown state (for verification): \(unknownState.stateDescription())")
        
        // Perform measurements in different bases
        let measurements = performTomographyMeasurements(state: unknownState)
        
        print("\nMeasurement Results:")
        for (basis, results) in measurements {
            let prob0 = Double(results[0] ?? 0) / 1000.0
            let prob1 = Double(results[1] ?? 0) / 1000.0
            print("\(basis) basis: P(0) = \(String(format: "%.3f", prob0)), P(1) = \(String(format: "%.3f", prob1))")
        }
        
        // Reconstruct state (simplified)
        let reconstructed = reconstructState(from: measurements)
        print("\nReconstructed state: \(reconstructed.stateDescription())")
        
        // Calculate fidelity
        let fidelity = stateFidelity(unknownState, reconstructed)
        print("Reconstruction fidelity: \(String(format: "%.3f", fidelity))")
        
        print()
    }
    
    private static func performTomographyMeasurements(state: Qubit) -> [String: [Int: Int]] {
        var measurements: [String: [Int: Int]] = [:]
        
        // Z basis (computational basis)
        measurements["Z"] = state.measureMultiple(count: 1000)
        
        // X basis
        let xMeasCircuit = QuantumCircuit(qubit: state)
        xMeasCircuit.addGate(.hadamard) // Rotate to X basis
        measurements["X"] = xMeasCircuit.measureMultiple(shots: 1000)
        
        // Y basis
        let yMeasCircuit = QuantumCircuit(qubit: state)
        yMeasCircuit.addGate(.sDagger)  // Rotate to Y basis
        yMeasCircuit.addGate(.hadamard)
        measurements["Y"] = yMeasCircuit.measureMultiple(shots: 1000)
        
        return measurements
    }
    
    private static func reconstructState(from measurements: [String: [Int: Int]]) -> Qubit {
        // Simplified state reconstruction using measurement results
        guard let zResults = measurements["Z"],
              let xResults = measurements["X"] else {
            return .zero
        }
        
        let zProb0 = Double(zResults[0] ?? 0) / 1000.0
        let xProb0 = Double(xResults[0] ?? 0) / 1000.0
        
        // Rough reconstruction (in practice, this would use more sophisticated methods)
        let alpha = sqrt(zProb0)
        let beta = sqrt(1 - zProb0)
        
        // Adjust phase based on X measurement
        let phase = xProb0 > 0.5 ? 0.0 : .pi
        
        return Qubit(
            amplitude0: Complex(alpha, 0),
            amplitude1: Complex(beta * cos(phase), beta * sin(phase))
        )
    }
    
    private static func stateFidelity(_ state1: Qubit, _ state2: Qubit) -> Double {
        // Calculate |⟨ψ₁|ψ₂⟩|²
        let overlap = state1.amplitude0.conjugate * state2.amplitude0 +
                     state1.amplitude1.conjugate * state2.amplitude1
        return overlap.magnitudeSquared
    }
    
    /// Demonstrates Quantum Error Detection
    public static func quantumErrorDetection() {
        print("=== Quantum Error Detection ===")
        print("Simulating quantum errors and detection methods")
        print()
        
        let originalState = Qubit.superposition
        print("Original state: \(originalState.stateDescription())")
        
        // Simulate different types of errors
        let errors: [(String, QuantumCircuit.Gate)] = [
            ("Bit flip (X)", .pauliX),
            ("Phase flip (Z)", .pauliZ),
            ("Bit-phase flip (Y)", .pauliY)
        ]
        
        for (errorName, errorGate) in errors {
            print("\nSimulating \(errorName) error:")
            
            // Apply error with 30% probability
            let errorProbability = 0.3
            var errorCount = 0
            let trials = 1000
            
            for _ in 0..<trials {
                let circuit = QuantumCircuit(qubit: originalState)
                
                // Randomly apply error
                if Double.random(in: 0...1) < errorProbability {
                    circuit.addGate(errorGate)
                    errorCount += 1
                }
                
                // In practice, error detection/correction would happen here
            }
            
            print("Applied error in \(errorCount)/\(trials) cases (\(String(format: "%.1f", Double(errorCount)/Double(trials)*100))%)")
            
            // Show what the error does to the state
            let errorCircuit = QuantumCircuit(qubit: originalState)
            errorCircuit.addGate(errorGate)
            let erroredState = errorCircuit.execute()
            
            print("Error transforms state to: \(erroredState.stateDescription())")
            print("Fidelity after error: \(String(format: "%.3f", stateFidelity(originalState, erroredState)))")
        }
        
        print("\n🛡️ Error detection and correction are crucial for practical quantum computing!")
        print()
    }
    
    /// Run all advanced examples
    public static func runAllAdvancedExamples() {
        print("🔬 Advanced Quantum Computing Examples")
        print("=====================================\n")
        
        deutschAlgorithm()
        quantumPhaseEstimation()
        quantumRandomWalk()
        quantumFourierTransform()
        quantumInterference()
        quantumStateTomography()
        quantumErrorDetection()
        
        print("🚀 All advanced examples completed successfully!")
        print("These examples demonstrate the power and potential of quantum computing!")
    }
}
