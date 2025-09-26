//
//  RunTutorials.swift
//  SwiftQuantum Tutorial Runner
//
//  Created by Eunmin Park on 2025-09-26.
//  Main entry point for running quantum computing tutorials
//

import Foundation
import SwiftQuantum

// MARK: - Main Tutorial Menu

@main
struct TutorialRunner {
    static func main() {
        printWelcomeBanner()
        
        while true {
            displayMenu()
            
            if let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if !handleMenuChoice(choice) {
                    break
                }
            }
        }
        
        printGoodbyeMessage()
    }
    
    static func printWelcomeBanner() {
        print("""
        
        ╔══════════════════════════════════════════════════════════════╗
        ║                                                              ║
        ║              ⚛️  SwiftQuantum Tutorial System  ⚛️             ║
        ║                                                              ║
        ║            Explore Quantum Computing on iOS!                ║
        ║                                                              ║
        ╚══════════════════════════════════════════════════════════════╝
        
        Welcome to the interactive quantum computing tutorial system!
        
        """)
    }
    
    static func displayMenu() {
        print("""
        
        ═══════════════════════════════════════════════════════════════
        📚 MAIN MENU
        ═══════════════════════════════════════════════════════════════
        
        📖 Tutorials:
           1. Understanding Quantum Superposition
           2. Quantum Interference Patterns
           3. Deutsch-Jozsa Algorithm
           4. Quantum Random Number Generation
           5. Quantum State Tomography
           6. Run ALL Tutorials (Masterclass)
        
        🔬 Interactive Demos:
           7. Build Custom Quantum Circuit
           8. Quantum Gate Playground
           9. Measurement Statistics Analyzer
        
        📚 Documentation:
           10. Generate HTML Documentation
           11. Generate Markdown Documentation
           12. Quick Reference Card
        
        🎮 Fun Examples:
           13. Quantum Coin Flip
           14. Quantum Dice Roller
           15. Quantum UUID Generator
           16. Performance Benchmarks
        
        ❌ Exit:
           0. Quit
        
        ═══════════════════════════════════════════════════════════════
        
        Enter your choice (0-16): \
        """, terminator: "")
    }
    
    static func handleMenuChoice(_ choice: String) -> Bool {
        print("\n")
        
        switch choice {
        // Tutorials
        case "1":
            QuantumAlgorithmTutorials.superpositionTutorial()
        case "2":
            QuantumAlgorithmTutorials.interferencePatternsTutorial()
        case "3":
            QuantumAlgorithmTutorials.deutschJozsaTutorial()
        case "4":
            QuantumAlgorithmTutorials.quantumRNGTutorial()
        case "5":
            QuantumAlgorithmTutorials.stateTomographyTutorial()
        case "6":
            QuantumAlgorithmTutorials.runAllTutorials()
            
        // Interactive Demos
        case "7":
            runCircuitBuilder()
        case "8":
            runGatePlayground()
        case "9":
            runMeasurementAnalyzer()
            
        // Documentation
        case "10":
            generateHTMLDocs()
        case "11":
            generateMarkdownDocs()
        case "12":
            QuantumAlgorithmTutorials.printQuickReference()
            
        // Fun Examples
        case "13":
            runQuantumCoinFlip()
        case "14":
            runQuantumDiceRoller()
        case "15":
            runQuantumUUIDGenerator()
        case "16":
            runPerformanceBenchmarks()
            
        // Exit
        case "0":
            return false
            
        default:
            print("❌ Invalid choice. Please enter a number between 0 and 16.")
        }
        
        print("\nPress Enter to continue...")
        _ = readLine()
        
        return true
    }
    
    // MARK: - Interactive Demos
    
    static func runCircuitBuilder() {
        print("=" .repeating(60))
        print("🔬 INTERACTIVE CIRCUIT BUILDER")
        print("=" .repeating(60))
        print()
        
        let circuit = QuantumCircuit(qubit: .zero)
        var gates: [String] = []
        
        while true {
            print("\nCurrent Circuit:")
            print(circuit.asciiDiagram())
            
            if !gates.isEmpty {
                print("\nGates added: \(gates.joined(separator: " → "))")
            }
            
            print("""
            
            Choose a gate to add:
              1. Hadamard (H)
              2. Pauli-X (NOT)
              3. Pauli-Y
              4. Pauli-Z
              5. S Gate
              6. T Gate
              7. Rotation (custom angle)
              8. Execute & Measure
              9. Clear Circuit
              0. Back to Menu
            
            Enter choice: \
            """, terminator: "")
            
            guard let choice = readLine() else { continue }
            
            switch choice {
            case "1":
                circuit.addGate(.hadamard)
                gates.append("H")
                print("✅ Added Hadamard gate")
            case "2":
                circuit.addGate(.pauliX)
                gates.append("X")
                print("✅ Added Pauli-X gate")
            case "3":
                circuit.addGate(.pauliY)
                gates.append("Y")
                print("✅ Added Pauli-Y gate")
            case "4":
                circuit.addGate(.pauliZ)
                gates.append("Z")
                print("✅ Added Pauli-Z gate")
            case "5":
                circuit.addGate(.sGate)
                gates.append("S")
                print("✅ Added S gate")
            case "6":
                circuit.addGate(.tGate)
                gates.append("T")
                print("✅ Added T gate")
            case "7":
                print("Enter rotation angle in degrees (0-360): ", terminator: "")
                if let angleStr = readLine(), let degrees = Double(angleStr) {
                    let radians = degrees * .pi / 180.0
                    circuit.addGate(.rotationY(radians))
                    gates.append("RY(\(Int(degrees))°)")
                    print("✅ Added rotation gate")
                }
            case "8":
                print("\n📊 Executing circuit with 1000 measurements...")
                let measurements = circuit.measureMultiple(shots: 1000)
                let count0 = measurements[0] ?? 0
                let count1 = measurements[1] ?? 0
                
                print("\nResults:")
                print("  |0⟩: \(count0) times (\(String(format: "%.1f", Double(count0)/10.0))%)")
                print("  |1⟩: \(count1) times (\(String(format: "%.1f", Double(count1)/10.0))%)")
                
                let finalState = circuit.execute()
                print("\nFinal State: \(finalState.stateDescription())")
                
                print("\nPress Enter to continue...")
                _ = readLine()
            case "9":
                circuit.removeAllGates()
                gates.removeAll()
                print("✅ Circuit cleared")
            case "0":
                return
            default:
                print("❌ Invalid choice")
            }
        }
    }
    
    static func runGatePlayground() {
        print("=" .repeating(60))
        print("🎮 QUANTUM GATE PLAYGROUND")
        print("=" .repeating(60))
        print()
        
        let testStates: [(String, Qubit)] = [
            ("|0⟩", .zero),
            ("|1⟩", .one),
            ("|+⟩", .superposition),
            ("|−⟩", .minusSuperposition),
            ("|i⟩", .iState)
        ]
        
        let gates: [(String, (Qubit) -> Qubit)] = [
            ("Hadamard (H)", QuantumGates.hadamard),
            ("Pauli-X (NOT)", QuantumGates.pauliX),
            ("Pauli-Y", QuantumGates.pauliY),
            ("Pauli-Z", QuantumGates.pauliZ),
            ("S Gate", QuantumGates.sGate),
            ("T Gate", QuantumGates.tGate)
        ]
        
        print("Testing all gates on common quantum states:\n")
        
        for (gateName, gateFunc) in gates {
            print("Gate: \(gateName)")
            print("─" .repeating(60))
            
            for (stateName, state) in testStates {
                let result = gateFunc(state)
                let (prob0, prob1) = (result.probability0, result.probability1)
                
                print("  \(stateName) → \(result.stateDescription())")
                print("      P(|0⟩)=\(String(format: "%.3f", prob0)), P(|1⟩)=\(String(format: "%.3f", prob1))")
            }
            print()
        }
    }
    
    static func runMeasurementAnalyzer() {
        print("=" .repeating(60))
        print("📊 MEASUREMENT STATISTICS ANALYZER")
        print("=" .repeating(60))
        print()
        
        print("Enter theta angle (0-180): ", terminator: "")
        guard let thetaStr = readLine(), let thetaDeg = Double(thetaStr) else { return }
        
        print("Enter phi angle (0-360): ", terminator: "")
        guard let phiStr = readLine(), let phiDeg = Double(phiStr) else { return }
        
        let theta = thetaDeg * .pi / 180.0
        let phi = phiDeg * .pi / 180.0
        
        let qubit = Qubit.fromBlochAngles(theta: theta, phi: phi)
        
        print("\n🔬 Analyzing state: \(qubit.stateDescription())")
        print()
        
        let shotCounts = [10, 100, 1000, 10000]
        
        print("Shots    | P(|0⟩) Measured | P(|0⟩) Theory | Error")
        print("─" .repeating(60))
        
        for shots in shotCounts {
            let measurements = qubit.measureMultiple(count: shots)
            let measuredProb = Double(measurements[0] ?? 0) / Double(shots)
            let theoryProb = qubit.probability0
            let error = abs(measuredProb - theoryProb)
            
            print(String(format: "%-8d | %.6f        | %.6f      | %.6f",
                        shots, measuredProb, theoryProb, error))
        }
        
        print("\n💡 Notice how error decreases with more measurements!")
    }
    
    // MARK: - Documentation Generation
    
    static func generateHTMLDocs() {
        print("📄 Generating HTML documentation...")
        
        do {
            try DocumentationGenerator.saveHTMLDocumentation(
                to: "./SwiftQuantum_Documentation.html"
            )
            print("""
            
            ✅ Success! HTML documentation generated!
            
            📂 Location: ./SwiftQuantum_Documentation.html
            
            🌐 Open this file in your web browser to view:
               • Interactive tutorials
               • API reference
               • Visual demonstrations
               • Code examples
            
            """)
        } catch {
            print("❌ Error generating HTML: \(error)")
        }
    }
    
    static func generateMarkdownDocs() {
        print("📝 Generating Markdown documentation...")
        
        do {
            try DocumentationGenerator.saveMarkdownDocumentation(
                to: "./DOCUMENTATION.md"
            )
            print("""
            
            ✅ Success! Markdown documentation generated!
            
            📂 Location: ./DOCUMENTATION.md
            
            📚 This comprehensive guide includes:
               • Complete API reference
               • Usage examples
               • Performance tips
               • Troubleshooting guide
            
            """)
        } catch {
            print("❌ Error generating Markdown: \(error)")
        }
    }
    
    // MARK: - Fun Examples
    
    static func runQuantumCoinFlip() {
        print("=" .repeating(60))
        print("🪙 QUANTUM COIN FLIP")
        print("=" .repeating(60))
        print()
        
        print("Using quantum superposition for true randomness!\n")
        
        for i in 1...5 {
            print("Flip \(i): ", terminator: "")
            
            // Dramatic pause
            Thread.sleep(forTimeInterval: 0.5)
            
            let circuit = QuantumCircuit(qubit: .zero)
            circuit.addGate(.hadamard)
            let result = circuit.executeAndMeasure()
            
            print(result == 0 ? "🟡 HEADS" : "⚫ TAILS")
        }
        
        print("\n💡 Each flip uses quantum measurement - truly random!")
    }
    
    static func runQuantumDiceRoller() {
        print("=" .repeating(60))
        print("🎲 QUANTUM DICE ROLLER")
        print("=" .repeating(60))
        print()
        
        let rng = QuantumApplications.QuantumRNG()
        
        print("Rolling quantum dice 10 times...\n")
        
        var results: [Int: Int] = [:]
        
        for i in 1...10 {
            let roll = rng.randomInt(in: 1...6)
            results[roll, default: 0] += 1
            
            let emoji = ["⚀", "⚁", "⚂", "⚃", "⚄", "⚅"][roll - 1]
            print("Roll \(i): \(emoji) (\(roll))")
            
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        print("\n📊 Distribution:")
        for die in 1...6 {
            let count = results[die] ?? 0
            let emoji = ["⚀", "⚁", "⚂", "⚃", "⚄", "⚅"][die - 1]
            print("\(emoji) \(die): \(String(repeating: "█", count: count))")
        }
    }
    
    static func runQuantumUUIDGenerator() {
        print("=" .repeating(60))
        print("🆔 QUANTUM UUID GENERATOR")
        print("=" .repeating(60))
        print()
        
        let rng = QuantumApplications.QuantumRNG()
        
        print("Generating 5 quantum-random UUIDs:\n")
        
        for i in 1...5 {
            let uuid = rng.randomUUID()
            print("\(i). \(uuid.uuidString)")
        }
        
        print("\n✨ These UUIDs are generated using quantum randomness")
        print("   Perfect for cryptographic applications!")
    }
    
    static func runPerformanceBenchmarks() {
        print("=" .repeating(60))
        print("⚡ PERFORMANCE BENCHMARKS")
        print("=" .repeating(60))
        print()
        
        let iterations = 10000
        
        // Qubit creation
        var start = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = Qubit.random()
        }
        var duration = CFAbsoluteTimeGetCurrent() - start
        print("Qubit Creation:     \(String(format: "%8.0f", Double(iterations)/duration)) ops/sec")
        
        // Hadamard gate
        let qubit = Qubit.zero
        start = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = QuantumGates.hadamard(qubit)
        }
        duration = CFAbsoluteTimeGetCurrent() - start
        print("Hadamard Gate:      \(String(format: "%8.0f", Double(iterations)/duration)) ops/sec")
        
        // Circuit execution
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        circuit.addGate(.rotationZ(.pi/4))
        circuit.addGate(.hadamard)
        
        start = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = circuit.execute()
        }
        duration = CFAbsoluteTimeGetCurrent() - start
        print("Circuit Execution:  \(String(format: "%8.0f", Double(iterations)/duration)) ops/sec")
        
        // Measurements
        start = CFAbsoluteTimeGetCurrent()
        _ = circuit.measureMultiple(shots: iterations)
        duration = CFAbsoluteTimeGetCurrent() - start
        print("Measurements:       \(String(format: "%8.0f", Double(iterations)/duration)) ops/sec")
        
        // Complex arithmetic
        let c1 = Complex(3, 4)
        let c2 = Complex(1, 2)
        start = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = c1 + c2
            _ = c1 * c2
        }
        duration = CFAbsoluteTimeGetCurrent() - start
        print("Complex Operations: \(String(format: "%8.0f", Double(iterations)/duration)) ops/sec")
        
        print("\n🚀 SwiftQuantum is optimized for mobile performance!")
    }
    
    // MARK: - Goodbye
    
    static func printGoodbyeMessage() {
        print("""
        
        ╔══════════════════════════════════════════════════════════════╗
        ║                                                              ║
        ║            Thank you for exploring SwiftQuantum!            ║
        ║                                                              ║
        ║        🌟 Keep exploring the quantum universe! 🌟           ║
        ║                                                              ║
        ╚══════════════════════════════════════════════════════════════╝
        
        📚 Resources:
           • GitHub: https://github.com/Minapak/SwiftQuantum
           • Documentation: ./DOCUMENTATION.md
           • Examples: ./Examples/
        
        💡 What's Next?
           • Build your own quantum algorithms
           • Contribute to the project
           • Share your quantum discoveries!
        
        🚀 The quantum future starts with you!
        
        """)
    }
}

// Helper extension
extension String {
    func repeating(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}
