//
//  SuperpositionPlayground.swift
//  SwiftQuantum Examples
//
//  Created by Eunmin Park on 2025-09-30.
//  Interactive playground for exploring quantum superposition
//

import Foundation
import SwiftQuantum

/// Interactive playground for exploring quantum superposition
///
/// This playground provides hands-on demonstrations of quantum superposition,
/// one of the most fundamental concepts in quantum computing.
///
/// ## Features
/// - Create and visualize different superposition states
/// - Observe quantum measurement collapse
/// - Explore the Bloch sphere
/// - Understand quantum parallelism
///
/// ## Usage
/// ```swift
/// // Run all demonstrations
/// SuperpositionPlayground.runAll()
///
/// // Or run individual demos
/// SuperpositionPlayground.exploreSuperpositionStates()
/// SuperpositionPlayground.demonstrateQuantumCollapse()
/// ```
public class SuperpositionPlayground {
    
    // MARK: - Main Demonstrations
    
    /// Demonstrates creating different superposition states
    ///
    /// Explores various quantum states from equal superposition to biased
    /// and complex superpositions with phase.
    public static func exploreSuperpositionStates() {
        printHeader("Quantum Superposition Playground")
        
        // 1. Equal Superposition (Hadamard state)
        print("\n1️⃣  Equal Superposition: |+⟩ = (|0⟩ + |1⟩)/√2")
        printSeparator()
        let equal = Qubit.superposition
        print(equal.visualize())
        print(equal.measureAndVisualize(shots: 1000))
        
        // 2. Biased Superposition (60-40)
        print("\n2️⃣  Biased Superposition: 60% |0⟩, 40% |1⟩")
        printSeparator()
        let biased = Qubit(alpha: sqrt(0.6), beta: sqrt(0.4))
        print(biased.visualize())
        print(biased.measureAndVisualize(shots: 1000))
        
        // 3. Extreme Superposition (90-10)
        print("\n3️⃣  Extreme Superposition: 90% |0⟩, 10% |1⟩")
        printSeparator()
        let extreme = Qubit(alpha: sqrt(0.9), beta: sqrt(0.1))
        print(extreme.visualize())
        print(extreme.measureAndVisualize(shots: 1000))
        
        // 4. Complex Superposition (with phase)
        print("\n4️⃣  Complex Superposition: |ψ⟩ = (|0⟩ + i|1⟩)/√2")
        printSeparator()
        let complex = Qubit.iState
        print(complex.visualize())
        print("💡 Note: Phase difference = \(String(format: "%.3f", complex.relativePhase)) radians")
        print(complex.measureAndVisualize(shots: 1000))
        
        // 5. Minus Superposition
        print("\n5️⃣  Minus Superposition: |−⟩ = (|0⟩ − |1⟩)/√2")
        printSeparator()
        let minus = Qubit.minusSuperposition
        print(minus.visualize())
        print(minus.measureAndVisualize(shots: 1000))
        print("💡 Same probabilities as |+⟩, but opposite phase!")
        
        printSuccess("Explored 5 different superposition states!")
    }
    
    /// Interactive superposition creator
    ///
    /// Allows user to create custom superposition states by specifying
    /// the probability of measuring |0⟩.
    public static func createCustomSuperposition() {
        printHeader("Custom Superposition Creator")
        
        print("""
        
        ✨ Let's create your own quantum superposition!
        
        You'll specify the probability of measuring |0⟩,
        and we'll create and visualize the corresponding quantum state.
        
        """)
        
        print("Enter probability for |0⟩ (0.0 to 1.0): ", terminator: "")
        
        if let input = readLine(), let prob0 = Double(input) {
            guard prob0 >= 0 && prob0 <= 1 else {
                printError("Invalid probability! Must be between 0 and 1.")
                return
            }
            
            let prob1 = 1.0 - prob0
            let alpha = sqrt(prob0)
            let beta = sqrt(prob1)
            
            let customQubit = Qubit(alpha: alpha, beta: beta)
            
            print("\n🎯 Your Custom Superposition Created!")
            printSeparator()
            print(customQubit.visualize())
            print(customQubit.measureAndVisualize(shots: 1000))
            
            // Show mathematical representation
            print("\n📐 Mathematical Representation:")
            print("   |ψ⟩ = \(String(format: "%.4f", alpha))|0⟩ + \(String(format: "%.4f", beta))|1⟩")
            print("   P(|0⟩) = |α|² = \(String(format: "%.4f", prob0))")
            print("   P(|1⟩) = |β|² = \(String(format: "%.4f", prob1))")
            print("   Normalization: |α|² + |β|² = \(String(format: "%.10f", prob0 + prob1)) ✓")
            
            // Compare with standard states
            print("\n🔍 Comparison with Standard States:")
            if abs(prob0 - 1.0) < 0.01 {
                print("   → Very close to |0⟩ state!")
            } else if abs(prob0) < 0.01 {
                print("   → Very close to |1⟩ state!")
            } else if abs(prob0 - 0.5) < 0.01 {
                print("   → Equal superposition like |+⟩ or |−⟩!")
            } else if prob0 > 0.5 {
                print("   → Biased toward |0⟩ state")
            } else {
                print("   → Biased toward |1⟩ state")
            }
            
        } else {
            printError("Invalid input!")
        }
    }
    
    /// Demonstrates the collapse of superposition upon measurement
    ///
    /// Shows how measuring a quantum state destroys the superposition
    /// and forces it into a definite classical state.
    public static func demonstrateQuantumCollapse() {
        printHeader("Quantum Measurement Collapse")
        
        print("""
        
        🎯 Quantum superposition is fragile!
        
        When you measure a quantum state, it "collapses" from existing
        in multiple states simultaneously to being in just ONE definite state.
        
        Let's observe this phenomenon...
        
        """)
        
        let superposition = Qubit.superposition
        
        print("🌀 Before Measurement:")
        printSeparator()
        print("State exists in superposition - BOTH |0⟩ AND |1⟩ simultaneously")
        print(superposition.visualize())
        
        print("\n🎲 Performing measurement...")
        for i in 1...3 {
            print(".", terminator: "")
            fflush(stdout)
            Thread.sleep(forTimeInterval: 0.5)
        }
        print()
        
        let result = superposition.measure()
        
        print("\n💥 After Measurement:")
        printSeparator()
        print("State collapsed to: |\(result)⟩")
        print("The superposition has been DESTROYED!")
        print("The qubit is now in a definite classical state.")
        
        // Show that measuring the collapsed state gives deterministic result
        let collapsed = result == 0 ? Qubit.zero : Qubit.one
        
        print("\n🔬 Verification - measuring the collapsed state 10 times:")
        print("(If truly collapsed, we should get the same result every time)")
        print()
        
        var results: [Int] = []
        for i in 1...10 {
            let verification = collapsed.measure()
            results.append(verification)
            print("  Measurement \(String(format: "%2d", i)): |\(verification)⟩", terminator: "")
            
            if verification == result {
                print(" ✓")
            } else {
                print(" ✗ (This should never happen!)")
            }
        }
        
        if results.allSatisfy({ $0 == result }) {
            printSuccess("Perfect! All measurements gave the same result.")
            print("This confirms the state has collapsed to a definite value.")
        }
        
        print("""
        
        💡 Key Insight:
        ════════════════════════════════════════════════════════
        Measurement is IRREVERSIBLE. Once you measure a quantum
        state, the superposition is destroyed and you cannot
        recover it. This is called "wavefunction collapse" and
        is one of the most mysterious aspects of quantum mechanics!
        
        """)
    }
    
    /// Explores different angles on the Bloch sphere
    ///
    /// Demonstrates how different angles (θ, φ) correspond to different
    /// quantum states on the Bloch sphere.
    public static func exploreBlochSphere() {
        printHeader("Bloch Sphere Explorer")
        
        print("""
        
        🌐 The Bloch sphere is a geometric representation of quantum states.
        
        Every point on the surface represents a valid quantum state:
        • θ (theta): Polar angle - controls |0⟩ vs |1⟩ probability
        • φ (phi): Azimuthal angle - controls phase
        
        Let's explore some key points...
        
        """)
        
        let points: [(theta: Double, phi: Double, name: String, description: String)] = [
            (0, 0, "North Pole |0⟩", "Pure |0⟩ state - 100% chance of measuring 0"),
            (.pi, 0, "South Pole |1⟩", "Pure |1⟩ state - 100% chance of measuring 1"),
            (.pi/2, 0, "Equator X+ |+⟩", "Equal superposition with positive phase"),
            (.pi/2, .pi, "Equator X− |−⟩", "Equal superposition with negative phase"),
            (.pi/2, .pi/2, "Equator Y+ |+i⟩", "Equal superposition with +i phase"),
            (.pi/2, 3*.pi/2, "Equator Y− |−i⟩", "Equal superposition with −i phase"),
            (.pi/4, 0, "Tilted 45°", "Biased toward |0⟩ (85.4% vs 14.6%)"),
            (.pi/3, .pi/4, "Custom Angle", "General quantum state with phase"),
        ]
        
        for (index, point) in points.enumerated() {
            print("\n[\(index + 1)] 📍 \(point.name)")
            printSeparator(length: 50)
            print("   Description: \(point.description)")
            print("   Spherical coords: θ = \(String(format: "%.4f", point.theta)) rad (\(String(format: "%.1f", point.theta * 180 / .pi))°)")
            print("                     φ = \(String(format: "%.4f", point.phi)) rad (\(String(format: "%.1f", point.phi * 180 / .pi))°)")
            
            let qubit = Qubit.fromBlochAngles(theta: point.theta, phi: point.phi)
            let (x, y, z) = qubit.blochCoordinates()
            
            print("   Cartesian coords: (\(String(format: "%.3f", x)), \(String(format: "%.3f", y)), \(String(format: "%.3f", z)))")
            print("   Probabilities:    P(|0⟩) = \(String(format: "%.3f", qubit.probability0)), P(|1⟩) = \(String(format: "%.3f", qubit.probability1))")
            
            // Verify it's on the unit sphere
            let radius = sqrt(x*x + y*y + z*z)
            print("   Radius:           \(String(format: "%.6f", radius)) (should be 1.000000)")
        }
        
        print("""
        
        💡 Bloch Sphere Properties:
        ════════════════════════════════════════════════════════
        • All valid quantum states lie on the SURFACE (radius = 1)
        • Opposite points represent orthogonal states
        • The equator contains all equal superpositions (50-50)
        • Phase only matters for interference (covered in next tutorial!)
        
        """)
    }
    
    /// Shows how superposition enables quantum parallelism
    ///
    /// Demonstrates the key advantage of quantum computing: the ability
    /// to process multiple inputs simultaneously using superposition.
    public static func demonstrateQuantumParallelism() {
        printHeader("Quantum Parallelism Demo")
        
        print("""
        
        ⚡ This is what makes quantum computers powerful!
        
        Classical computers evaluate functions one input at a time.
        Quantum computers can evaluate ALL inputs SIMULTANEOUSLY!
        
        """)
        
        print("📊 Classical Computing:")
        printSeparator(length: 50)
        print("To test a function f(x) on inputs 0 and 1:")
        print("  Step 1: Compute f(0) = ?")
        print("  Step 2: Compute f(1) = ?")
        print("  Total: 2 function evaluations ❌")
        
        print("\n⚛️  Quantum Computing:")
        printSeparator(length: 50)
        print("Using superposition, we test BOTH at once!")
        print()
        
        // Create superposition of both inputs
        let input = Qubit.superposition
        print("Step 1: Create input superposition")
        print("  Input: |ψ⟩ = (|0⟩ + |1⟩)/√2")
        print("  This represents BOTH 0 and 1 simultaneously!")
        print(input.visualize())
        
        print("\nStep 2: Apply function f (represented by quantum gate)")
        print("  We'll use Pauli-X gate as our function (flips 0↔1)")
        
        let circuit = QuantumCircuit(qubit: input)
        circuit.addGate(.pauliX)
        
        let output = circuit.execute()
        
        print("\nStep 3: Observe output")
        print("  Output: |ψ'⟩ = (|1⟩ + |0⟩)/√2")
        print("  We evaluated f(0) AND f(1) in ONE step! ✅")
        print(output.visualize())
        
        print("""
        
        💡 The Quantum Advantage:
        ════════════════════════════════════════════════════════
        For n qubits, classical computers need 2ⁿ evaluations.
        Quantum computers need just 1 evaluation!
        
        Examples:
        • 10 qubits:  1,024 classical vs 1 quantum evaluation
        • 50 qubits:  1,125,899,906,842,624 classical vs 1 quantum!
        • 300 qubits: More evaluations than atoms in universe vs 1!
        
        This exponential speedup is why quantum computing is so powerful!
        
        ⚠️  Important: We can't just "read out" all 2ⁿ results due to
        measurement collapse. Quantum algorithms cleverly use interference
        to amplify the correct answer. More on this in future tutorials!
        
        """)
    }
    
    // MARK: - Batch Comparisons
    
    /// Compares multiple superposition states side by side
    public static func compareStandardStates() {
        printHeader("Standard Quantum States Comparison")
        
        let states: [(name: String, qubit: Qubit)] = [
            ("|0⟩", Qubit.zero),
            ("|1⟩", Qubit.one),
            ("|+⟩", Qubit.superposition),
            ("|−⟩", Qubit.minusSuperposition),
            ("|+i⟩", Qubit.iState),
            ("|−i⟩", Qubit.minusIState),
        ]
        
        print(QubitVisualizer.visualizeBatch(states))
        
        print("\n🔍 Detailed Comparison of |+⟩ vs |−⟩:")
        print(Qubit.superposition.compare(
            with: Qubit.minusSuperposition,
            label: "|+⟩ State",
            otherLabel: "|−⟩ State"
        ))
    }
    
    // MARK: - Master Runner
    
    /// Runs all demonstrations in sequence
    ///
    /// This is the main entry point for the playground. It guides the user
    /// through all demonstrations with pauses between sections.
    public static func runAll() {
        print("""
        
        
        ╔══════════════════════════════════════════════════════════════╗
        ║                                                              ║
        ║          🌀 Quantum Superposition Playground 🌀              ║
        ║                                                              ║
        ║              Exploring the Heart of Quantum Computing       ║
        ║                                                              ║
        ╚══════════════════════════════════════════════════════════════╝
        
        Welcome! This interactive playground will guide you through
        the fascinating world of quantum superposition.
        
        You'll learn:
        ✅ What superposition really means
        ✅ How to create and visualize quantum states
        ✅ Why measurement destroys superposition
        ✅ How the Bloch sphere works
        ✅ Why quantum parallelism is powerful
        
        Let's begin!
        
        """)
        
        waitForUser("Press Enter to start...")
        
        // 1. Explore different superposition states
        exploreSuperpositionStates()
        waitForUser("\nPress Enter to continue to Custom Superposition Creator...")
        
        // 2. Create custom superposition
        createCustomSuperposition()
        waitForUser("\nPress Enter to continue to Quantum Collapse Demo...")
        
        // 3. Demonstrate quantum collapse
        demonstrateQuantumCollapse()
        waitForUser("\nPress Enter to continue to Bloch Sphere Explorer...")
        
        // 4. Explore Bloch sphere
        exploreBlochSphere()
        waitForUser("\nPress Enter to continue to Quantum Parallelism Demo...")
        
        // 5. Demonstrate quantum parallelism
        demonstrateQuantumParallelism()
        waitForUser("\nPress Enter to see State Comparison...")
        
        // 6. Compare standard states
        compareStandardStates()
        
        // Final message
        print("""
        
        
        ╔══════════════════════════════════════════════════════════════╗
        ║                                                              ║
        ║              🎉 Congratulations! 🎉                          ║
        ║                                                              ║
        ║      You've completed the Superposition Playground!         ║
        ║                                                              ║
        ╚══════════════════════════════════════════════════════════════╝
        
        📚 What You've Learned:
        ════════════════════════════════════════════════════════════════
        ✓ Quantum superposition: existing in multiple states at once
        ✓ Complex amplitudes and measurement probabilities
        ✓ The Bloch sphere geometric representation
        ✓ How measurement collapses superposition
        ✓ Why quantum parallelism gives exponential speedup
        
        🚀 Next Steps:
        ════════════════════════════════════════════════════════════════
        → Build the iOS Superposition Visualizer app
        → Learn about Quantum Gates in the next tutorial
        → Experiment with creating your own quantum states
        → Explore quantum algorithms like Deutsch-Jozsa
        
        💡 Challenge Yourself:
        ════════════════════════════════════════════════════════════════
        1. Create a state with exactly 75% probability of |0⟩
        2. Find the Bloch angles for the state (|0⟩ - i|1⟩)/√2
        3. Explain why |+⟩ and |−⟩ have the same probabilities
           but are different states
        
        Happy quantum computing! ⚛️
        
        """)
    }
    
    // MARK: - Helper Functions
    
    private static func printHeader(_ title: String) {
        let length = max(60, title.count + 4)
        print("\n" + String(repeating: "═", count: length))
        print("  " + title)
        print(String(repeating: "═", count: length))
    }
    
    private static func printSeparator(length: Int = 60) {
        print(String(repeating: "─", count: length))
    }
    
    private static func printSuccess(_ message: String) {
        print("\n✅ \(message)\n")
    }
    
    private static func printError(_ message: String) {
        print("\n❌ \(message)\n")
    }
    
    private static func waitForUser(_ prompt: String = "Press Enter to continue...") {
        print("\n" + String(repeating: "─", count: 60))
        print(prompt, terminator: "")
        _ = readLine()
        print()
    }
}

// Helper extension
extension String {
    func repeating(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
