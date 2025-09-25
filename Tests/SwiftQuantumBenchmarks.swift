//
//  SwiftQuantumBenchmarks.swift
//  SwiftQuantum Performance Tests
//
//  Created by Eunmin Park on 2025-09-22.
//

import XCTest
@testable import SwiftQuantum

final class SwiftQuantumBenchmarks: XCTestCase {
    
    // MARK: - Complex Number Benchmarks
    
    func testComplexArithmeticPerformance() {
        let iterations = 100_000
        let a = Complex(3.0, 4.0)
        let b = Complex(1.0, 2.0)
        
        measure {
            for _ in 0..<iterations {
                let _ = a + b
                let _ = a - b
                let _ = a * b
                let _ = a / b
            }
        }
    }
    
    func testComplexExponentialPerformance() {
        let iterations = 10_000
        
        measure {
            for i in 0..<iterations {
                let z = Complex(Double(i) * 0.001, Double(i) * 0.001)
                let _ = Complex.exp(z)
            }
        }
    }
    
    // MARK: - Qubit Operation Benchmarks
    
    func testQubitInitializationPerformance() {
        let iterations = 50_000
        
        measure {
            for i in 0..<iterations {
                let alpha = Double(i) / Double(iterations)
                let beta = sqrt(1.0 - alpha * alpha)
                let _ = Qubit(alpha: alpha, beta: beta)
            }
        }
    }
    
    func testQubitMeasurementPerformance() {
        let qubit = Qubit.superposition
        let measurements = 100_000
        
        measure {
            for _ in 0..<measurements {
                let _ = qubit.measure()
            }
        }
    }
    
    func testQubitBlochCoordinatesPerformance() {
        let qubits = (0..<10_000).map { _ in Qubit.random() }
        
        measure {
            for qubit in qubits {
                let _ = qubit.blochCoordinates()
            }
        }
    }
    
    // MARK: - Quantum Gate Benchmarks
    
    func testPauliGatesPerformance() {
        let qubits = (0..<1_000).map { _ in Qubit.random() }
        
        measure {
            for qubit in qubits {
                let _ = QuantumGates.pauliX(qubit)
                let _ = QuantumGates.pauliY(qubit)
                let _ = QuantumGates.pauliZ(qubit)
            }
        }
    }
    
    func testHadamardGatePerformance() {
        let qubits = (0..<5_000).map { _ in Qubit.random() }
        
        measure {
            for qubit in qubits {
                let _ = QuantumGates.hadamard(qubit)
            }
        }
    }
    
    func testRotationGatesPerformance() {
        let qubits = (0..<1_000).map { _ in Qubit.random() }
        let angles = (0..<1_000).map { _ in Double.random(in: -Double.pi...Double.pi) }
        
        measure {
            for (qubit, angle) in zip(qubits, angles) {
                let _ = QuantumGates.rotationX(qubit, angle: angle)
                let _ = QuantumGates.rotationY(qubit, angle: angle)
                let _ = QuantumGates.rotationZ(qubit, angle: angle)
            }
        }
    }
    
    func testU3GatePerformance() {
        let qubits = (0..<1_000).map { _ in Qubit.random() }
        
        measure {
            for (i, qubit) in qubits.enumerated() {
                let theta = Double(i) * 0.001
                let phi = Double(i) * 0.002
                let lambda = Double(i) * 0.003
                let _ = QuantumGates.u3Gate(qubit, theta: theta, phi: phi, lambda: lambda)
            }
        }
    }
    
    // MARK: - Quantum Circuit Benchmarks
    
    func testCircuitConstructionPerformance() {
        let circuitCount = 1_000
        let gatesPerCircuit = 50
        
        measure {
            for _ in 0..<circuitCount {
                let circuit = QuantumCircuit(qubit: .zero)
                
                for _ in 0..<gatesPerCircuit {
                    let gateType = Int.random(in: 0...6)
                    switch gateType {
                    case 0: circuit.addGate(.hadamard)
                    case 1: circuit.addGate(.pauliX)
                    case 2: circuit.addGate(.pauliY)
                    case 3: circuit.addGate(.pauliZ)
                    case 4: circuit.addGate(.sGate)
                    case 5: circuit.addGate(.tGate)
                    case 6: circuit.addGate(.rotationZ(Double.random(in: 0...(2 * .pi))))
                    default: break
                    }
                }
            }
        }
    }
    
    func testCircuitExecutionPerformance() {
        let circuits = (0..<100).map { _ -> QuantumCircuit in
            let circuit = QuantumCircuit(qubit: .random())
            for _ in 0..<20 {
                let gates: [QuantumCircuit.Gate] = [.hadamard, .pauliX, .pauliY, .pauliZ, .sGate, .tGate]
                circuit.addGate(gates.randomElement()!)
            }
            return circuit
        }
        
        measure {
            for circuit in circuits {
                for _ in 0..<100 {
                    let _ = circuit.execute()
                }
            }
        }
    }
    
    func testCircuitMeasurementPerformance() {
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        circuit.addGate(.rotationY(.pi / 4))
        circuit.addGate(.rotationZ(.pi / 3))
        
        measure {
            let _ = circuit.measureMultiple(shots: 10_000)
        }
    }
    
    func testCircuitOptimizationPerformance() {
        let circuits = (0..<50).map { _ -> QuantumCircuit in
            let circuit = QuantumCircuit(qubit: .zero)
            
            // Add redundant gates for optimization testing
            for _ in 0..<20 {
                circuit.addGate(.hadamard)
                circuit.addGate(.hadamard) // H² = I
                circuit.addGate(.pauliX)
                circuit.addGate(.pauliX) // X² = I
                circuit.addGate(.rotationZ(.pi))
                circuit.addGate(.rotationZ(-.pi)) // RZ(π)RZ(-π) = I
            }
            
            return circuit
        }
        
        measure {
            for circuit in circuits {
                let _ = circuit.optimized()
            }
        }
    }
    
    // MARK: - Memory Usage Tests
    
    func testMemoryUsageWithManyQubits() {
        let qubitCount = 10_000
        
        measure {
            let qubits = (0..<qubitCount).map { _ in Qubit.random() }
            
            // Perform operations to ensure qubits aren't optimized away
            var sum = 0.0
            for qubit in qubits {
                sum += qubit.probability0
            }
            
            // Use sum to prevent optimization
            XCTAssertGreaterThan(sum, 0)
        }
    }
    
    func testMemoryUsageWithManyCircuits() {
        let circuitCount = 1_000
        
        measure {
            let circuits = (0..<circuitCount).map { _ -> QuantumCircuit in
                let circuit = QuantumCircuit(qubit: .random())
                circuit.addGate(.hadamard)
                circuit.addGate(.rotationZ(Double.random(in: 0...(2 * .pi))))
                circuit.addGate(.hadamard)
                return circuit
            }
            
            // Execute circuits to ensure they aren't optimized away
            var totalProbability = 0.0
            for circuit in circuits {
                let state = circuit.execute()
                totalProbability += state.probability0
            }
            
            XCTAssertGreaterThan(totalProbability, 0)
        }
    }
    
    // MARK: - Stress Tests
    
    func testLargeCircuitExecution() {
        let gateCount = 1_000
        let circuit = QuantumCircuit(qubit: .zero)
        
        // Build large circuit
        for i in 0..<gateCount {
            let angle = Double(i) * 0.01
            circuit.addGate(.rotationY(angle))
            
            if i % 10 == 0 {
                circuit.addGate(.hadamard)
            }
        }
        
        measure {
            let _ = circuit.execute()
        }
    }
    
    func testManyMeasurements() {
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        
        let measurementCount = 1_000_000
        
        measure {
            let _ = circuit.measureMultiple(shots: measurementCount)
        }
    }
    
    func testRandomCircuitGeneration() {
        let circuitCount = 500
        let maxGatesPerCircuit = 100
        
        measure {
            for _ in 0..<circuitCount {
                let gateCount = Int.random(in: 1...maxGatesPerCircuit)
                let circuit = QuantumCircuit.random(depth: gateCount)
                let _ = circuit.execute()
            }
        }
    }
    
    // MARK: - Accuracy Tests
    
    func testQuantumGateAccuracy() {
        let tolerance = 1e-14
        
        // Test gate sequences that should return to original state
        let testCases: [(String, [QuantumCircuit.Gate], Qubit)] = [
            ("H²", [.hadamard, .hadamard], .zero),
            ("X²", [.pauliX, .pauliX], .zero),
            ("Y²", [.pauliY, .pauliY], .zero),
            ("Z²", [.pauliZ, .pauliZ], .zero),
            ("S†S", [.sDagger, .sGate], .one),
            ("T†T", [.tDagger, .tGate], .superposition),
        ]
        
        for (name, gates, initialState) in testCases {
            let circuit = QuantumCircuit(qubit: initialState)
            for gate in gates {
                circuit.addGate(gate)
            }
            
            let finalState = circuit.execute()
            
            // Check if we returned to original state
            let amplitude0Diff = abs(finalState.amplitude0.real - initialState.amplitude0.real)
            let amplitude1Diff = abs(finalState.amplitude1.real - initialState.amplitude1.real)
            
            XCTAssertLessThan(amplitude0Diff, tolerance, "Gate sequence \(name) failed accuracy test")
            XCTAssertLessThan(amplitude1Diff, tolerance, "Gate sequence \(name) failed accuracy test")
        }
    }
    
    func testNormalizationPreservation() {
        let testCount = 1_000
        let maxGates = 20
        
        for _ in 0..<testCount {
            let circuit = QuantumCircuit(qubit: .random())
            
            let gateCount = Int.random(in: 1...maxGates)
            for _ in 0..<gateCount {
                let gates: [QuantumCircuit.Gate] = [
                    .hadamard, .pauliX, .pauliY, .pauliZ, .sGate, .tGate,
                    .rotationX(Double.random(in: 0...(2 * .pi))),
                    .rotationY(Double.random(in: 0...(2 * .pi))),
                    .rotationZ(Double.random(in: 0...(2 * .pi)))
                ]
                circuit.addGate(gates.randomElement()!)
            }
            
            let finalState = circuit.execute()
            XCTAssertTrue(finalState.isNormalized, "Normalization not preserved in random circuit")
        }
    }
    
    // MARK: - Statistical Tests
    
    func testQuantumRandomness() {
        let rng = QuantumApplications.QuantumRNG()
        let sampleCount = 100_000
        
        measure {
            let results = rng.testRandomness(samples: sampleCount)
            
            // Entropy should be close to 1.0 for good randomness
            XCTAssertGreaterThan(results.entropy, 0.99, "Quantum RNG entropy too low")
            
            // Balance should be close to 0.0 (equal distribution)
            XCTAssertLessThan(results.balance, 0.02, "Quantum RNG balance too poor")
        }
    }
    
    func testQuantumMeasurementDistribution() {
        let angles = stride(from: 0.0, through: Double.pi, by: Double.pi / 10)
        
        for angle in angles {
            let qubit = Qubit.fromBlochAngles(theta: angle, phi: 0)
            let expectedProb0 = cos(angle / 2) * cos(angle / 2)
            
            let measurements = qubit.measureMultiple(count: 10_000)
            let actualProb0 = Double(measurements[0] ?? 0) / 10_000.0
            
            let error = abs(expectedProb0 - actualProb0)
            XCTAssertLessThan(error, 0.02, "Measurement distribution error too large for angle \(angle)")
        }
    }
    
    // MARK: - Comparison Benchmarks
    
    func testSwiftQuantumVsBuiltinRandom() {
        let iterations = 100_000
        let quantum_rng = QuantumApplications.QuantumRNG()
        
        // Builtin random
        measure {
            for _ in 0..<iterations {
                let _ = Int.random(in: 0...1)
            }
        }
        
        // Quantum random
        measure {
            for _ in 0..<iterations {
                let _ = quantum_rng.randomBit()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    override func setUp() {
        super.setUp()
        // Set up any global test configuration
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Clean up after tests
        super.tearDown()
    }
}
