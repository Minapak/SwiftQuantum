//
//  QuantumAlgorithmTutorials.swift
//  SwiftQuantum Advanced Tutorials
//
//  Created by Eunmin Park on 2025-09-26.
//  Comprehensive step-by-step quantum algorithm tutorials
//

import Foundation
import SwiftQuantum

/// Comprehensive quantum computing tutorials with visual explanations and performance analysis
public class QuantumAlgorithmTutorials {
    
    // MARK: - Tutorial 1: Understanding Quantum Superposition
    
    /// Interactive tutorial on quantum superposition with visual feedback
    public static func superpositionTutorial() {
        print("=" .repeating(60))
        print("📚 TUTORIAL 1: Understanding Quantum Superposition")
        print("=" .repeating(60))
        print()
        
        print("🎯 Learning Objectives:")
        print("   • Understand what superposition means")
        print("   • See how Hadamard gate creates superposition")
        print("   • Visualize probability distributions")
        print("   • Compare classical vs quantum behavior")
        print()
        
        print("─" .repeating(60))
        print("Step 1: Classical Bit vs Quantum Qubit")
        print("─" .repeating(60))
        
        print("\n💡 Classical bit: Either 0 OR 1")
        let classicalBit = 0
        print("   State: \(classicalBit)")
        print("   Measurement: Always \(classicalBit)")
        
        print("\n⚛️  Quantum qubit: Can be 0 AND 1 simultaneously!")
        let qubit = Qubit.zero
        print("   Initial state: |0⟩")
        print("   Probability of |0⟩: \(qubit.probability0)")
        print("   Probability of |1⟩: \(qubit.probability1)")
        
        print("\n─" .repeating(60))
        print("Step 2: Creating Superposition with Hadamard Gate")
        print("─" .repeating(60))
        
        let superposition = QuantumGates.hadamard(qubit)
        print("\n🌀 After Hadamard gate:")
        print("   State: (|0⟩ + |1⟩)/√2")
        print("   Probability of |0⟩: \(String(format: "%.3f", superposition.probability0))")
        print("   Probability of |1⟩: \(String(format: "%.3f", superposition.probability1))")
        
        print("\n📊 Visual representation:")
        visualizeBlochSphere(superposition)
        
        print("\n─" .repeating(60))
        print("Step 3: Measuring Superposition")
        print("─" .repeating(60))
        
        print("\n🎲 Running 100 measurements:")
        let measurements = superposition.measureMultiple(count: 100)
        let count0 = measurements[0] ?? 0
        let count1 = measurements[1] ?? 0
        
        print("   |0⟩: \(count0) times \(progressBar(count0, total: 100))")
        print("   |1⟩: \(count1) times \(progressBar(count1, total: 100))")
        
        print("\n✨ Key Insight: The qubit exists in BOTH states until measured!")
        print("   When measured, it 'collapses' randomly to |0⟩ or |1⟩")
        print()
    }
    
    // MARK: - Tutorial 2: Quantum Interference
    
    /// Advanced tutorial on quantum interference patterns
    public static func interferencePatternsTutorial() {
        print("=" .repeating(60))
        print("📚 TUTORIAL 2: Quantum Interference Patterns")
        print("=" .repeating(60))
        print()
        
        print("🎯 Learning Objectives:")
        print("   • Understand constructive/destructive interference")
        print("   • Learn how phase affects measurement outcomes")
        print("   • Explore the power of quantum interference")
        print()
        
        print("─" .repeating(60))
        print("Step 1: What is Quantum Interference?")
        print("─" .repeating(60))
        
        print("\n💭 Classical waves can interfere:")
        print("   Constructive: Wave peaks align → Stronger signal")
        print("   Destructive: Peak meets trough → Cancellation")
        
        print("\n⚛️  Quantum probability amplitudes interfere too!")
        print("   This is the secret sauce of quantum computing!")
        
        print("\n─" .repeating(60))
        print("Step 2: Creating Interference")
        print("─" .repeating(60))
        
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)          // Create superposition
        circuit.addGate(.rotationZ(.pi))    // Add phase
        circuit.addGate(.hadamard)          // Create interference
        
        print("\n🔬 Circuit design:")
        print(circuit.asciiDiagram())
        
        let result = circuit.execute()
        print("\n📊 Result after interference:")
        print("   State: \(result.stateDescription())")
        print("   P(|0⟩) = \(String(format: "%.3f", result.probability0))")
        print("   P(|1⟩) = \(String(format: "%.3f", result.probability1))")
        
        print("\n─" .repeating(60))
        print("Step 3: Exploring Different Phase Shifts")
        print("─" .repeating(60))
        
        print("\n🎨 Testing various phase angles:")
        print()
        print("Phase    | P(|0⟩) | P(|1⟩) | Interference Type")
        print("-" .repeating(55))
        
        let phases = [0.0, .pi/4, .pi/2, 3*.pi/4, .pi, 5*.pi/4, 3*.pi/2, 7*.pi/4]
        
        for phase in phases {
            let testCircuit = QuantumCircuit(qubit: .zero)
            testCircuit.addGate(.hadamard)
            testCircuit.addGate(.rotationZ(phase))
            testCircuit.addGate(.hadamard)
            
            let (prob0, prob1) = testCircuit.theoreticalProbabilities()
            let phaseStr = String(format: "%.2fπ", phase / .pi)
            let interferenceType = prob0 > 0.9 ? "Constructive ✨" :
                                  prob1 > 0.9 ? "Destructive 💥" : "Mixed 🌊"
            
            print(String(format: "%-8s | %.3f  | %.3f  | %@",
                        phaseStr, prob0, prob1, interferenceType))
        }
        
        print("\n✨ Key Insight: By controlling phases, we can make certain")
        print("   outcomes MORE likely and others LESS likely!")
        print("   This is how quantum algorithms gain their advantage!")
        print()
    }
    
    // MARK: - Tutorial 3: Deutsch-Jozsa Algorithm (Single-qubit version)
    
    /// Step-by-step implementation of simplified Deutsch-Jozsa algorithm
    public static func deutschJozsaTutorial() {
        print("=" .repeating(60))
        print("📚 TUTORIAL 3: Deutsch-Jozsa Algorithm")
        print("=" .repeating(60))
        print()
        
        print("🎯 Learning Objectives:")
        print("   • Understand the first quantum algorithm")
        print("   • See quantum advantage in action")
        print("   • Learn about quantum oracles")
        print()
        
        print("─" .repeating(60))
        print("The Problem")
        print("─" .repeating(60))
        
        print("\n❓ Question: Is a function f(x) constant or balanced?")
        print("   • Constant: f(x) always returns same value (all 0s or all 1s)")
        print("   • Balanced: f(x) returns 0 half the time, 1 half the time")
        
        print("\n📊 Classical approach:")
        print("   • Need to check multiple inputs")
        print("   • Worst case: Check half the inputs + 1")
        
        print("\n⚛️  Quantum approach:")
        print("   • Check ALL inputs simultaneously using superposition!")
        print("   • Need only ONE quantum evaluation!")
        
        print("\n─" .repeating(60))
        print("Step 1: Testing a CONSTANT Function")
        print("─" .repeating(60))
        
        print("\n🔬 Function: f(x) = 0 (always returns 0)")
        
        let constantCircuit = QuantumCircuit(qubit: .zero)
        print("\n   1️⃣  Start with |0⟩")
        print("       State: \(constantCircuit.initialState.stateDescription())")
        
        constantCircuit.addGate(.hadamard)
        print("\n   2️⃣  Apply Hadamard → Create superposition")
        print("       Now checking all inputs at once!")
        var state = constantCircuit.execute()
        print("       State: \(state.stateDescription())")
        
        // Constant function: do nothing (f(x) = 0)
        print("\n   3️⃣  Apply Oracle (constant function)")
        print("       No change since f(x) = 0 for all x")
        
        constantCircuit.addGate(.hadamard)
        print("\n   4️⃣  Apply Hadamard again → Create interference")
        state = constantCircuit.execute()
        print("       State: \(state.stateDescription())")
        
        let constantMeasurements = constantCircuit.measureMultiple(shots: 100)
        let constantResult = (constantMeasurements[0] ?? 0) > 50
        
        print("\n   📊 Measurements: |0⟩ = \(constantMeasurements[0] ?? 0), |1⟩ = \(constantMeasurements[1] ?? 0)")
        print("   ✅ Conclusion: Function is \(constantResult ? "CONSTANT" : "BALANCED")")
        
        print("\n─" .repeating(60))
        print("Step 2: Testing a BALANCED Function")
        print("─" .repeating(60))
        
        print("\n🔬 Function: f(x) = x (returns the input)")
        
        let balancedCircuit = QuantumCircuit(qubit: .zero)
        print("\n   1️⃣  Start with |0⟩")
        
        balancedCircuit.addGate(.hadamard)
        print("\n   2️⃣  Apply Hadamard → Create superposition")
        
        balancedCircuit.addGate(.pauliX)
        print("\n   3️⃣  Apply Oracle (balanced function)")
        print("       Pauli-X flips the state (implements f(x) = x)")
        
        balancedCircuit.addGate(.hadamard)
        print("\n   4️⃣  Apply Hadamard → Create interference")
        state = balancedCircuit.execute()
        print("       State: \(state.stateDescription())")
        
        let balancedMeasurements = balancedCircuit.measureMultiple(shots: 100)
        let balancedResult = (balancedMeasurements[0] ?? 0) > 50
        
        print("\n   📊 Measurements: |0⟩ = \(balancedMeasurements[0] ?? 0), |1⟩ = \(balancedMeasurements[1] ?? 0)")
        print("   ✅ Conclusion: Function is \(balancedResult ? "CONSTANT" : "BALANCED")")
        
        print("\n─" .repeating(60))
        print("The Quantum Advantage")
        print("─" .repeating(60))
        
        print("\n💡 Key Insights:")
        print("   1. Classical computer: May need multiple evaluations")
        print("   2. Quantum computer: Needs only ONE evaluation!")
        print("   3. Secret: Superposition + Interference = Quantum speedup")
        
        print("\n🚀 Performance Comparison:")
        performanceComparison()
        print()
    }
    
    // MARK: - Tutorial 4: Quantum Random Number Generation
    
    /// Deep dive into quantum RNG with statistical analysis
    public static func quantumRNGTutorial() {
        print("=" .repeating(60))
        print("📚 TUTORIAL 4: Quantum Random Number Generation")
        print("=" .repeating(60))
        print()
        
        print("🎯 Learning Objectives:")
        print("   • Understand true randomness vs pseudo-randomness")
        print("   • Implement quantum random number generator")
        print("   • Analyze randomness quality")
        print()
        
        print("─" .repeating(60))
        print("Step 1: Classical vs Quantum Randomness")
        print("─" .repeating(60))
        
        print("\n🎲 Classical (Pseudo-random):")
        print("   • Uses mathematical algorithms (deterministic!)")
        print("   • Same seed → Same sequence")
        print("   • Not truly random")
        
        print("\n⚛️  Quantum (True random):")
        print("   • Based on quantum measurement")
        print("   • Fundamentally unpredictable")
        print("   • Cryptographically secure")
        
        print("\n─" .repeating(60))
        print("Step 2: Building Quantum RNG")
        print("─" .repeating(60))
        
        print("\n🔧 Implementation:")
        print("""
           1. Start with |0⟩
           2. Apply Hadamard gate → (|0⟩ + |1⟩)/√2
           3. Measure → Get 0 or 1 with 50% probability
           4. Repeat for more random bits
           """)
        
        print("\n💻 Code:")
        print("""
           let circuit = QuantumCircuit(qubit: .zero)
           circuit.addGate(.hadamard)
           let randomBit = circuit.executeAndMeasure()
           """)
        
        print("\n─" .repeating(60))
        print("Step 3: Statistical Analysis")
        print("─" .repeating(60))
        
        let rng = QuantumApplications.QuantumRNG()
        
        print("\n📊 Generating 10,000 random bits...")
        let startTime = CFAbsoluteTimeGetCurrent()
        let stats = rng.testRandomness(samples: 10000)
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        
        print("\n✅ Results:")
        print("   Entropy: \(String(format: "%.6f", stats.entropy)) (max: 1.0)")
        print("   Balance: \(String(format: "%.6f", stats.balance)) (optimal: 0.0)")
        print("   Generation time: \(String(format: "%.4f", duration))s")
        
        // Visual entropy meter
        let entropyPercent = Int(stats.entropy * 100)
        print("\n   Entropy Quality:")
        print("   [\(String(repeating: "█", count: entropyPercent))\(String(repeating: "░", count: 100 - entropyPercent))] \(entropyPercent)%")
        
        print("\n─" .repeating(60))
        print("Step 4: Practical Applications")
        print("─" .repeating(60))
        
        print("\n🎲 Example: Roll a quantum die")
        let dieRoll = rng.randomInt(in: 1...6)
        print("   Result: \(dieRoll)")
        
        print("\n🔐 Example: Generate cryptographic key")
        let keyBytes = rng.randomBytes(count: 4)
        print("   Key: 0x\(keyBytes.map { String(format: "%02X", $0) }.joined())")
        
        print("\n🆔 Example: Generate UUID")
        let uuid = rng.randomUUID()
        print("   UUID: \(uuid.uuidString)")
        
        print("\n💡 Why it matters:")
        print("   • Gaming: Truly fair dice rolls")
        print("   • Cryptography: Unbreakable encryption keys")
        print("   • Simulations: Better Monte Carlo methods")
        print("   • Lotteries: Provably fair drawings")
        print()
    }
    
    // MARK: - Tutorial 5: Quantum State Tomography
    
    /// Complete guide to quantum state reconstruction
    public static func stateTomographyTutorial() {
        print("=" .repeating(60))
        print("📚 TUTORIAL 5: Quantum State Tomography")
        print("=" .repeating(60))
        print()
        
        print("🎯 Learning Objectives:")
        print("   • Learn how to characterize unknown quantum states")
        print("   • Understand measurement in different bases")
        print("   • Reconstruct quantum states from measurements")
        print()
        
        print("─" .repeating(60))
        print("The Challenge")
        print("─" .repeating(60))
        
        print("\n❓ Problem: Someone gives you a mystery quantum state")
        print("   How do you figure out what it is?")
        
        print("\n🚫 You CANNOT:")
        print("   • Directly observe the quantum state")
        print("   • Clone the quantum state (No-cloning theorem)")
        print("   • Measure without collapsing it")
        
        print("\n✅ You CAN:")
        print("   • Measure it multiple times in different bases")
        print("   • Use statistics to reconstruct the state")
        
        print("\n─" .repeating(60))
        print("Step 1: Create Mystery State")
        print("─" .repeating(60))
        
        // Create a random mystery state
        let theta = .pi / 3
        let phi = .pi / 4
        let mysteryState = Qubit.fromBlochAngles(theta: theta, phi: phi)
        
        print("\n🎭 Mystery state created!")
        print("   (Hidden from us: \(mysteryState.stateDescription()))")
        print("   Our goal: Reconstruct it using only measurements")
        
        print("\n─" .repeating(60))
        print("Step 2: Measure in Z-basis (Computational Basis)")
        print("─" .repeating(60))
        
        print("\n🔬 Measuring in computational basis (|0⟩, |1⟩)...")
        let zMeasurements = mysteryState.measureMultiple(count: 1000)
        let zProb0 = Double(zMeasurements[0] ?? 0) / 1000.0
        let zProb1 = Double(zMeasurements[1] ?? 0) / 1000.0
        
        print("   Results after 1000 shots:")
        print("   P(|0⟩) = \(String(format: "%.3f", zProb0))")
        print("   P(|1⟩) = \(String(format: "%.3f", zProb1))")
        
        print("\n   Visual:")
        print("   |0⟩: \(progressBar(Int(zProb0 * 100), total: 100))")
        print("   |1⟩: \(progressBar(Int(zProb1 * 100), total: 100))")
        
        print("\n─" .repeating(60))
        print("Step 3: Measure in X-basis")
        print("─" .repeating(60))
        
        print("\n🔬 Measuring in X-basis (|+⟩, |−⟩)...")
        let xCircuit = QuantumCircuit(qubit: mysteryState)
        xCircuit.addGate(.hadamard)  // Rotate to X-basis
        let xMeasurements = xCircuit.measureMultiple(shots: 1000)
        let xProb0 = Double(xMeasurements[0] ?? 0) / 1000.0
        
        print("   P(|+⟩) = \(String(format: "%.3f", xProb0))")
        print("   P(|−⟩) = \(String(format: "%.3f", 1 - xProb0))")
        
        print("\n─" .repeating(60))
        print("Step 4: Measure in Y-basis")
        print("─" .repeating(60))
        
        print("\n🔬 Measuring in Y-basis...")
        let yCircuit = QuantumCircuit(qubit: mysteryState)
        yCircuit.addGate(.sDagger)
        yCircuit.addGate(.hadamard)
        let yMeasurements = yCircuit.measureMultiple(shots: 1000)
        let yProb0 = Double(yMeasurements[0] ?? 0) / 1000.0
        
        print("   P(|+i⟩) = \(String(format: "%.3f", yProb0))")
        print("   P(|−i⟩) = \(String(format: "%.3f", 1 - yProb0))")
        
        print("\n─" .repeating(60))
        print("Step 5: Reconstruct the State")
        print("─" .repeating(60))
        
        print("\n🔧 Reconstruction algorithm:")
        
        // Simple reconstruction
        let alpha = sqrt(zProb0)
        let beta = sqrt(zProb1)
        let phase = xProb0 > 0.5 ? 0.0 : .pi
        
        let reconstructed = Qubit(
            amplitude0: Complex(alpha, 0),
            amplitude1: Complex(beta * cos(phase), beta * sin(phase))
        )
        
        print("   From measurements:")
        print("   α ≈ \(String(format: "%.3f", alpha))")
        print("   β ≈ \(String(format: "%.3f", beta))")
        print("   φ ≈ \(String(format: "%.3f", phase))")
        
        print("\n📊 Reconstructed state: \(reconstructed.stateDescription())")
        print("   Original state:      \(mysteryState.stateDescription())")
        
        // Calculate fidelity
        let overlap = mysteryState.amplitude0.conjugate * reconstructed.amplitude0 +
                     mysteryState.amplitude1.conjugate * reconstructed.amplitude1
        let fidelity = overlap.magnitudeSquared
        
        print("\n✅ Fidelity: \(String(format: "%.1f%%", fidelity * 100))")
        
        if fidelity > 0.95 {
            print("   Excellent reconstruction! 🎉")
        } else if fidelity > 0.85 {
            print("   Good reconstruction! 👍")
        } else {
            print("   Need more measurements for better accuracy 📊")
        }
        
        print("\n💡 Key Insight: We reconstructed the quantum state without")
        print("   ever 'seeing' it directly - just from measurements!")
        print()
    }
    
    // MARK: - Performance Comparison
    
    private static func performanceComparison() {
        print("\n📈 Algorithm Performance Metrics:")
        print()
        print("Algorithm          | Classical | Quantum  | Speedup")
        print("-" .repeating(55))
        
        // Deutsch-Jozsa
        print("Deutsch-Jozsa      | O(2ⁿ⁻¹)   | O(1)     | Exponential 🚀")
        
        // Search (Grover's in future)
        print("Search (N items)   | O(N)      | O(√N)    | Quadratic")
        
        // Factoring (Shor's in future)
        print("Factoring          | O(eⁿ)     | O(n³)    | Exponential 🚀")
        
        // Random number generation
        print("True RNG           | Impossible| O(1)     | Infinite! ⚛️")
        
        print()
        
        // Benchmark our current operations
        print("⏱️  SwiftQuantum Performance Benchmarks:")
        print()
        
        let iterations = 10000
        
        // Hadamard gate benchmark
        var start = CFAbsoluteTimeGetCurrent()
        let qubit = Qubit.zero
        for _ in 0..<iterations {
            _ = QuantumGates.hadamard(qubit)
        }
        var duration = CFAbsoluteTimeGetCurrent() - start
        print("   Hadamard gate:     \(String(format: "%.2f", Double(iterations)/duration)) ops/sec")
        
        // Circuit execution benchmark
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        circuit.addGate(.rotationZ(.pi/4))
        circuit.addGate(.hadamard)
        
        start = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = circuit.execute()
        }
        duration = CFAbsoluteTimeGetCurrent() - start
        print("   Circuit execution: \(String(format: "%.2f", Double(iterations)/duration)) ops/sec")
        
        // Measurement benchmark
        start = CFAbsoluteTimeGetCurrent()
        _ = circuit.measureMultiple(shots: iterations)
        duration = CFAbsoluteTimeGetCurrent() - start
        print("   Measurements:      \(String(format: "%.2f", Double(iterations)/duration)) ops/sec")
    }
    
    // MARK: - Visualization Helpers
    
    private static func visualizeBlochSphere(_ qubit: Qubit) {
        let (x, y, z) = qubit.blochCoordinates()
        
        print("   Bloch Sphere Position:")
        print("   x: \(String(format: "% .3f", x)) \(progressBar(Int((x + 1) * 50), total: 100, char: "→"))")
        print("   y: \(String(format: "% .3f", y)) \(progressBar(Int((y + 1) * 50), total: 100, char: "→"))")
        print("   z: \(String(format: "% .3f", z)) \(progressBar(Int((z + 1) * 50), total: 100, char: "↑"))")
        
        // ASCII Bloch sphere
        print("\n   Simple Bloch Sphere (z-axis view):")
        print("        |1⟩ (z=+1)")
        print("         ↑")
        print("         |")
        print("   ------+------ ")
        print("         |")
        print("         ↓")
        print("        |0⟩ (z=-1)")
    }
    
    private static func progressBar(_ value: Int, total: Int, char: String = "█") -> String {
        let filled = min(value * 50 / total, 50)
        let empty = 50 - filled
        return "[\(String(repeating: char, count: filled))\(String(repeating: "░", count: empty))]"
    }
    
    // MARK: - Master Tutorial Runner
    
    /// Runs all tutorials in sequence
    public static func runAllTutorials() {
        print("\n")
        print("🎓 SwiftQuantum: Complete Quantum Computing Masterclass")
        print("=" .repeating(60))
        print("📚 5 Comprehensive Tutorials")
        print("⏱️  Estimated time: 15-20 minutes")
        print("=" .repeating(60))
        print("\n")
        
        let tutorials: [(String, () -> Void)] = [
            ("Understanding Quantum Superposition", superpositionTutorial),
            ("Quantum Interference Patterns", interferencePatternsTutorial),
            ("Deutsch-Jozsa Algorithm", deutschJozsaTutorial),
            ("Quantum Random Number Generation", quantumRNGTutorial),
            ("Quantum State Tomography", stateTomographyTutorial)
        ]
        
        for (index, (name, tutorial)) in tutorials.enumerated() {
            print("\n📖 Tutorial \(index + 1)/\(tutorials.count): \(name)")
            print("Press Enter to continue...")
            _ = readLine()
            
            tutorial()
            
            if index < tutorials.count - 1 {
                print("\n" + "─" .repeating(60))
                print("Tutorial \(index + 1) complete! ✅")
                print("─" .repeating(60))
                print("\n")
            }
        }
        
        print("\n")
        print("=" .repeating(60))
        print("🎉 Congratulations! You've completed all tutorials!")
        print("=" .repeating(60))
        print()
        print("📚 What you've learned:")
        print("   ✓ Quantum superposition and measurement")
        print("   ✓ Quantum interference and phase control")
        print("   ✓ Quantum algorithms (Deutsch-Jozsa)")
        print("   ✓ Quantum random number generation")
        print("   ✓ Quantum state tomography")
        print()
        print("🚀 Next steps:")
        print("   • Experiment with the examples")
        print("   • Build your own quantum circuits")
        print("   • Explore quantum applications")
        print("   • Contribute to SwiftQuantum!")
        print()
        print("💡 Remember: Quantum computing is not about replacing")
        print("   classical computers - it's about solving problems")
        print("   that were previously impossible!")
        print()
    }
    
    // MARK: - Quick Reference Guide
    
    /// Prints a quick reference card for quantum gates and operations
    public static func printQuickReference() {
        print("""
        
        ╔════════════════════════════════════════════════════════╗
        ║        SwiftQuantum Quick Reference Guide              ║
        ╚════════════════════════════════════════════════════════╝
        
        📊 BASIC QUANTUM STATES
        ─────────────────────────────────────────────────────────
        Qubit.zero              |0⟩ state
        Qubit.one               |1⟩ state  
        Qubit.superposition     (|0⟩ + |1⟩)/√2
        Qubit.random()          Random quantum state
        
        🚪 QUANTUM GATES
        ─────────────────────────────────────────────────────────
        Pauli Gates:
          .pauliX               Quantum NOT (bit flip)
          .pauliY               Y rotation + phase flip
          .pauliZ               Phase flip
        
        Hadamard:
          .hadamard             Creates superposition
        
        Phase Gates:
          .sGate                π/2 phase shift
          .tGate                π/4 phase shift
        
        Rotation Gates:
          .rotationX(θ)         Rotate around X-axis
          .rotationY(θ)         Rotate around Y-axis
          .rotationZ(θ)         Rotate around Z-axis
        
        🔄 QUANTUM CIRCUITS
        ─────────────────────────────────────────────────────────
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        circuit.addGate(.rotationZ(.pi/4))
        let result = circuit.execute()
        
        📏 MEASUREMENTS
        ─────────────────────────────────────────────────────────
        qubit.measure()                    Single measurement
        qubit.measureMultiple(count: 100)  Statistical sampling
        circuit.measureMultiple(shots: 100) Circuit measurements
        
        🎲 QUANTUM APPLICATIONS
        ─────────────────────────────────────────────────────────
        let rng = QuantumApplications.QuantumRNG()
        rng.randomBit()                    0 or 1
        rng.randomInt(in: 1...100)         Random integer
        rng.randomUUID()                   Quantum UUID
        
        📈 PERFORMANCE TIPS
        ─────────────────────────────────────────────────────────
        • Use circuit.optimized() to remove redundant gates
        • Batch measurements for better performance
        • Cache frequently used circuits
        • Use .execute() once, measure() many times
        
        🔬 DEBUGGING & ANALYSIS
        ─────────────────────────────────────────────────────────
        qubit.stateDescription()           Human-readable state
        qubit.blochCoordinates()          (x, y, z) on Bloch sphere
        circuit.asciiDiagram()             Visual circuit diagram
        circuit.theoreticalProbabilities() Expected outcomes
        
        ═══════════════════════════════════════════════════════════
        
        """)
    }
}

// MARK: - Extension for String Repeating

extension String {
    func repeating(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
