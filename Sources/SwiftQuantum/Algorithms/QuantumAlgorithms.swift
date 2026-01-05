//
//  QuantumAlgorithms.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  Implementation of major quantum algorithms as found in QuantumBridge
//  Includes: Bell State, Deutsch-Jozsa, Grover's Search, Simon's Algorithm
//

import Foundation

// MARK: - Quantum Algorithms Overview
//
// This module implements the four major quantum algorithms that demonstrate
// quantum computational advantage:
//
// 1. Bell State - Quantum entanglement demonstration
// 2. Deutsch-Jozsa - Constant vs balanced function discrimination (exponential speedup)
// 3. Grover's Search - Unstructured search (quadratic speedup: O(√N) vs O(N))
// 4. Simon's Algorithm - Hidden period finding (exponential speedup)

/// Collection of quantum algorithms with educational implementations
public struct QuantumAlgorithms {

    // MARK: - Bell State Algorithm

    /// Bell State preparation and analysis
    ///
    /// Creates maximally entangled two-qubit states demonstrating quantum correlations
    /// that violate Bell inequalities (proof of non-classical correlations).
    ///
    /// ## The Four Bell States
    /// - |Φ+⟩ = (|00⟩ + |11⟩)/√2
    /// - |Φ-⟩ = (|00⟩ - |11⟩)/√2
    /// - |Ψ+⟩ = (|01⟩ + |10⟩)/√2
    /// - |Ψ-⟩ = (|01⟩ - |10⟩)/√2
    ///
    /// ## Circuit
    /// ```
    /// q0: ─[H]─●─
    ///          │
    /// q1: ─────⊕─
    /// ```
    public struct BellState {

        /// Type of Bell state
        public enum StateType: String, CaseIterable {
            case phiPlus = "Φ+"   // (|00⟩ + |11⟩)/√2
            case phiMinus = "Φ-"  // (|00⟩ - |11⟩)/√2
            case psiPlus = "Ψ+"   // (|01⟩ + |10⟩)/√2
            case psiMinus = "Ψ-"  // (|01⟩ - |10⟩)/√2

            public var description: String {
                switch self {
                case .phiPlus: return "(|00⟩ + |11⟩)/√2"
                case .phiMinus: return "(|00⟩ - |11⟩)/√2"
                case .psiPlus: return "(|01⟩ + |10⟩)/√2"
                case .psiMinus: return "(|01⟩ - |10⟩)/√2"
                }
            }
        }

        /// Creates a Bell state of the specified type
        /// - Parameter type: Type of Bell state to create
        /// - Returns: QuantumRegister in the Bell state
        public static func create(type: StateType = .phiPlus) -> QuantumRegister {
            let register = QuantumRegister(numberOfQubits: 2)

            switch type {
            case .phiPlus:
                register.applyGate(.hadamard, to: 0)
                register.applyCNOT(control: 0, target: 1)

            case .phiMinus:
                register.applyGate(.hadamard, to: 0)
                register.applyCNOT(control: 0, target: 1)
                register.applyGate(.pauliZ, to: 0)

            case .psiPlus:
                register.applyGate(.hadamard, to: 0)
                register.applyCNOT(control: 0, target: 1)
                register.applyGate(.pauliX, to: 1)

            case .psiMinus:
                register.applyGate(.hadamard, to: 0)
                register.applyCNOT(control: 0, target: 1)
                register.applyGate(.pauliX, to: 1)
                register.applyGate(.pauliZ, to: 0)
            }

            return register
        }

        /// Runs Bell state experiment with measurements
        /// - Parameters:
        ///   - type: Type of Bell state
        ///   - shots: Number of measurements
        /// - Returns: Result with measurement statistics
        public static func run(type: StateType = .phiPlus, shots: Int = 1000) -> BellStateResult {
            let register = create(type: type)
            let measurements = register.measureMultiple(shots: shots)

            return BellStateResult(
                stateType: type,
                measurements: measurements,
                totalShots: shots
            )
        }
    }

    /// Result of Bell state experiment
    public struct BellStateResult {
        public let stateType: BellState.StateType
        public let measurements: [String: Int]
        public let totalShots: Int

        /// Expected measurement outcomes based on state type
        public var expectedOutcomes: [String] {
            switch stateType {
            case .phiPlus, .phiMinus:
                return ["00", "11"]
            case .psiPlus, .psiMinus:
                return ["01", "10"]
            }
        }

        /// Correlation coefficient between qubits
        public var correlation: Double {
            let n00 = measurements["00"] ?? 0
            let n11 = measurements["11"] ?? 0
            let n01 = measurements["01"] ?? 0
            let n10 = measurements["10"] ?? 0

            let sameOutcomes = Double(n00 + n11)
            let differentOutcomes = Double(n01 + n10)

            if totalShots == 0 { return 0 }
            return (sameOutcomes - differentOutcomes) / Double(totalShots)
        }

        public var description: String {
            var desc = "Bell State Experiment: |\(stateType.rawValue)⟩\n"
            desc += "State: \(stateType.description)\n"
            desc += "Shots: \(totalShots)\n"
            desc += "Results:\n"

            for (outcome, count) in measurements.sorted(by: { $0.key < $1.key }) {
                let percentage = Double(count) / Double(totalShots) * 100
                desc += "  |\(outcome)⟩: \(count) (\(String(format: "%.1f", percentage))%)\n"
            }

            desc += "Correlation: \(String(format: "%.3f", correlation))"
            return desc
        }
    }

    // MARK: - Deutsch-Jozsa Algorithm

    /// Deutsch-Jozsa Algorithm
    ///
    /// Determines whether a function f: {0,1}^n → {0,1} is:
    /// - Constant: f(x) = c for all x (always 0 or always 1)
    /// - Balanced: f(x) = 0 for exactly half of inputs
    ///
    /// ## Quantum Advantage
    /// - Classical: O(2^(n-1) + 1) queries (worst case)
    /// - Quantum: O(1) queries (single query!)
    /// - For n=30: 10^9× speedup
    ///
    /// ## Circuit
    /// ```
    /// x₀: ─[H]─┬─────[Uf]─[H]─[M]
    /// x₁: ─[H]─┼─────     ─[H]─[M]
    /// ...      │
    /// y:  ─[X]─[H]───────────────
    /// ```
    public struct DeutschJozsa {

        /// Type of oracle function
        public enum OracleType: String, CaseIterable {
            case constant0 = "Constant 0"   // f(x) = 0 for all x
            case constant1 = "Constant 1"   // f(x) = 1 for all x
            case balanced = "Balanced"       // f(x) = 0 for half, 1 for other half

            public var isConstant: Bool {
                return self == .constant0 || self == .constant1
            }
        }

        /// Runs the Deutsch-Jozsa algorithm
        /// - Parameters:
        ///   - numberOfQubits: Number of input qubits (n)
        ///   - oracleType: Type of oracle to use
        ///   - shots: Number of measurement shots
        /// - Returns: Result of the algorithm
        public static func run(
            numberOfQubits: Int = 3,
            oracleType: OracleType = .balanced,
            shots: Int = 100
        ) -> DeutschJozsaResult {
            precondition(numberOfQubits >= 1 && numberOfQubits <= 10,
                        "Number of qubits must be between 1 and 10")

            // Total qubits = n input qubits + 1 ancilla qubit
            let totalQubits = numberOfQubits + 1
            let register = QuantumRegister(numberOfQubits: totalQubits)

            // Step 1: Initialize ancilla to |1⟩
            register.applyGate(.pauliX, to: numberOfQubits)

            // Step 2: Apply Hadamard to all qubits
            for i in 0...numberOfQubits {
                register.applyGate(.hadamard, to: i)
            }

            // Step 3: Apply oracle
            applyOracle(register: register, numberOfInputQubits: numberOfQubits, type: oracleType)

            // Step 4: Apply Hadamard to input qubits only
            for i in 0..<numberOfQubits {
                register.applyGate(.hadamard, to: i)
            }

            // Step 5: Measure input qubits
            var measurements: [String: Int] = [:]
            let originalAmplitudes = register.saveState()

            for _ in 0..<shots {
                register.restoreState(originalAmplitudes)
                var result = ""
                for i in 0..<numberOfQubits {
                    let bit = register.measureQubit(i)
                    result += "\(bit)"
                }
                measurements[result, default: 0] += 1
            }

            // Determine if constant or balanced
            let allZeros = measurements.keys.contains(String(repeating: "0", count: numberOfQubits))
            let allZerosCount = measurements[String(repeating: "0", count: numberOfQubits)] ?? 0
            let isConstant = allZerosCount == shots

            return DeutschJozsaResult(
                numberOfQubits: numberOfQubits,
                oracleType: oracleType,
                measurements: measurements,
                isConstant: isConstant,
                totalShots: shots
            )
        }

        /// Applies the oracle for Deutsch-Jozsa
        private static func applyOracle(
            register: QuantumRegister,
            numberOfInputQubits: Int,
            type: OracleType
        ) {
            let ancillaIndex = numberOfInputQubits

            switch type {
            case .constant0:
                // f(x) = 0: Do nothing (identity)
                break

            case .constant1:
                // f(x) = 1: Flip ancilla
                register.applyGate(.pauliX, to: ancillaIndex)

            case .balanced:
                // f(x) = x_0 ⊕ x_1 ⊕ ... (XOR of all input bits)
                // Implemented as CNOT from each input to ancilla
                for i in 0..<numberOfInputQubits {
                    register.applyCNOT(control: i, target: ancillaIndex)
                }
            }
        }
    }

    /// Result of Deutsch-Jozsa algorithm
    public struct DeutschJozsaResult {
        public let numberOfQubits: Int
        public let oracleType: DeutschJozsa.OracleType
        public let measurements: [String: Int]
        public let isConstant: Bool
        public let totalShots: Int

        public var conclusion: String {
            if isConstant {
                return "Function is CONSTANT"
            } else {
                return "Function is BALANCED"
            }
        }

        public var isCorrect: Bool {
            return isConstant == oracleType.isConstant
        }

        public var description: String {
            var desc = "Deutsch-Jozsa Algorithm\n"
            desc += "=======================\n"
            desc += "Input qubits: \(numberOfQubits)\n"
            desc += "Oracle type: \(oracleType.rawValue)\n"
            desc += "Shots: \(totalShots)\n\n"
            desc += "Measurements:\n"

            for (outcome, count) in measurements.sorted(by: { $0.key < $1.key }) {
                let percentage = Double(count) / Double(totalShots) * 100
                desc += "  |\(outcome)⟩: \(count) (\(String(format: "%.1f", percentage))%)\n"
            }

            desc += "\nConclusion: \(conclusion)"
            if isCorrect {
                desc += " ✓"
            } else {
                desc += " ✗ (Expected: \(oracleType.isConstant ? "Constant" : "Balanced"))"
            }

            desc += "\n\nQuantum Advantage: With \(numberOfQubits) qubits,"
            desc += "\n  Classical: up to \(1 << (numberOfQubits - 1) + 1) queries"
            desc += "\n  Quantum: 1 query"

            return desc
        }
    }

    // MARK: - Grover's Search Algorithm

    /// Grover's Search Algorithm
    ///
    /// Searches an unstructured database of N items for a marked item.
    ///
    /// ## Quantum Advantage
    /// - Classical: O(N) queries
    /// - Quantum: O(√N) queries
    /// - For N=1,000,000: 1000× speedup
    ///
    /// ## Algorithm Steps
    /// 1. Initialize uniform superposition
    /// 2. Repeat √N times:
    ///    a. Apply oracle (mark target state)
    ///    b. Apply diffusion operator (amplify marked state)
    /// 3. Measure
    ///
    /// ## Circuit
    /// ```
    /// |0⟩^⊗n ─[H]^⊗n─[Oracle]─[Diffusion]─...─[M]
    /// ```
    public struct GroverSearch {

        /// Runs Grover's search algorithm
        /// - Parameters:
        ///   - numberOfQubits: Number of qubits (search space = 2^n)
        ///   - targetState: The state to search for
        ///   - shots: Number of measurements
        /// - Returns: Search result
        public static func run(
            numberOfQubits: Int = 3,
            targetState: Int? = nil,
            shots: Int = 100
        ) -> GroverResult {
            precondition(numberOfQubits >= 2 && numberOfQubits <= 10,
                        "Number of qubits must be between 2 and 10")

            let searchSpace = 1 << numberOfQubits
            let target = targetState ?? Int.random(in: 0..<searchSpace)
            precondition(target >= 0 && target < searchSpace,
                        "Target state must be valid")

            let register = QuantumRegister(numberOfQubits: numberOfQubits)

            // Step 1: Create uniform superposition
            for i in 0..<numberOfQubits {
                register.applyGate(.hadamard, to: i)
            }

            // Step 2: Calculate optimal number of iterations
            let iterations = optimalIterations(searchSpace: searchSpace)

            // Step 3: Grover iterations
            for _ in 0..<iterations {
                // Oracle: flip sign of target state
                applyOracle(register: register, target: target)

                // Diffusion operator: 2|s⟩⟨s| - I
                applyDiffusion(register: register)
            }

            // Step 4: Measure
            let measurements = register.measureMultiple(shots: shots)

            // Calculate success probability
            let targetString = toBinaryString(target, width: numberOfQubits)
            let successCount = measurements[targetString] ?? 0
            let successProbability = Double(successCount) / Double(shots)

            return GroverResult(
                numberOfQubits: numberOfQubits,
                targetState: target,
                iterations: iterations,
                measurements: measurements,
                successProbability: successProbability,
                totalShots: shots
            )
        }

        /// Calculates the optimal number of Grover iterations
        /// - Parameter searchSpace: Size of the search space (N)
        /// - Returns: Optimal number of iterations ≈ π/4 * √N
        public static func optimalIterations(searchSpace: Int) -> Int {
            return max(1, Int((Double.pi / 4) * sqrt(Double(searchSpace))))
        }

        /// Applies the oracle that marks the target state
        private static func applyOracle(register: QuantumRegister, target: Int) {
            // Flip the sign of the target state: |target⟩ → -|target⟩
            register.flipAmplitudeSign(at: target)
        }

        /// Applies the Grover diffusion operator
        /// D = 2|s⟩⟨s| - I where |s⟩ is uniform superposition
        private static func applyDiffusion(register: QuantumRegister) {
            let n = register.numberOfQubits
            let N = register.numberOfStates

            // Step 1: Apply H to all qubits
            for i in 0..<n {
                register.applyGate(.hadamard, to: i)
            }

            // Step 2: Apply conditional phase shift (flip all states except |0...0⟩)
            for i in 1..<N {
                register.flipAmplitudeSign(at: i)
            }

            // Step 3: Apply H to all qubits again
            for i in 0..<n {
                register.applyGate(.hadamard, to: i)
            }

            // This is equivalent to: 2|s⟩⟨s| - I
        }

        /// Converts integer to binary string
        private static func toBinaryString(_ value: Int, width: Int) -> String {
            var result = String(value, radix: 2)
            while result.count < width {
                result = "0" + result
            }
            return result
        }
    }

    /// Result of Grover's search
    public struct GroverResult {
        public let numberOfQubits: Int
        public let targetState: Int
        public let iterations: Int
        public let measurements: [String: Int]
        public let successProbability: Double
        public let totalShots: Int

        public var searchSpaceSize: Int {
            return 1 << numberOfQubits
        }

        public var targetBinaryString: String {
            var result = String(targetState, radix: 2)
            while result.count < numberOfQubits {
                result = "0" + result
            }
            return result
        }

        public var theoreticalSuccessProbability: Double {
            // P = sin²((2k+1)θ) where θ = arcsin(1/√N)
            let N = Double(searchSpaceSize)
            let theta = asin(1 / sqrt(N))
            return pow(sin(Double(2 * iterations + 1) * theta), 2)
        }

        public var description: String {
            var desc = "Grover's Search Algorithm\n"
            desc += "=========================\n"
            desc += "Search space: \(searchSpaceSize) items (\(numberOfQubits) qubits)\n"
            desc += "Target: |\(targetBinaryString)⟩ (decimal: \(targetState))\n"
            desc += "Iterations: \(iterations)\n"
            desc += "Shots: \(totalShots)\n\n"

            desc += "Top Results:\n"
            let sorted = measurements.sorted { $0.value > $1.value }
            for (i, (outcome, count)) in sorted.prefix(5).enumerated() {
                let percentage = Double(count) / Double(totalShots) * 100
                let marker = outcome == targetBinaryString ? " ← TARGET" : ""
                desc += "  \(i+1). |\(outcome)⟩: \(count) (\(String(format: "%.1f", percentage))%)\(marker)\n"
            }

            desc += "\nSuccess Rate: \(String(format: "%.1f", successProbability * 100))%"
            desc += "\nTheoretical: \(String(format: "%.1f", theoreticalSuccessProbability * 100))%"

            desc += "\n\nQuantum Advantage:"
            desc += "\n  Classical: O(\(searchSpaceSize)) queries"
            desc += "\n  Quantum: O(\(Int(sqrt(Double(searchSpaceSize))))) queries = \(iterations) iterations"

            return desc
        }
    }

    // MARK: - Simon's Algorithm

    /// Simon's Algorithm
    ///
    /// Finds a hidden period s in a function f: {0,1}^n → {0,1}^n
    /// where f(x) = f(y) iff x ⊕ y ∈ {0, s}
    ///
    /// ## Quantum Advantage
    /// - Classical: O(2^(n/2)) queries
    /// - Quantum: O(n) queries
    /// - Exponential speedup!
    ///
    /// ## Algorithm
    /// 1. Create superposition
    /// 2. Apply oracle
    /// 3. Apply Hadamard
    /// 4. Measure to get y where y·s = 0
    /// 5. Repeat n-1 times to solve linear system
    public struct SimonAlgorithm {

        /// Runs Simon's algorithm
        /// - Parameters:
        ///   - numberOfQubits: Number of input qubits
        ///   - hiddenString: The hidden period s (as integer)
        ///   - shots: Number of measurement shots
        /// - Returns: Result with found period
        public static func run(
            numberOfQubits: Int = 3,
            hiddenString: Int? = nil,
            shots: Int = 100
        ) -> SimonResult {
            precondition(numberOfQubits >= 2 && numberOfQubits <= 8,
                        "Number of qubits must be between 2 and 8")

            let maxValue = 1 << numberOfQubits
            let secret = hiddenString ?? Int.random(in: 1..<maxValue)
            precondition(secret >= 0 && secret < maxValue,
                        "Hidden string must be valid")

            // We need 2n qubits: n input + n output
            let totalQubits = 2 * numberOfQubits
            var collectedVectors: [[Int]] = []
            var measurements: [String: Int] = [:]

            // Run multiple times to collect linearly independent vectors
            for _ in 0..<shots {
                let register = QuantumRegister(numberOfQubits: totalQubits)

                // Step 1: Apply Hadamard to input qubits
                for i in 0..<numberOfQubits {
                    register.applyGate(.hadamard, to: i)
                }

                // Step 2: Apply Simon's oracle
                applySimonOracle(register: register, numberOfInputQubits: numberOfQubits, secret: secret)

                // Step 3: Apply Hadamard to input qubits
                for i in 0..<numberOfQubits {
                    register.applyGate(.hadamard, to: i)
                }

                // Step 4: Measure input qubits
                var result = ""
                var vector: [Int] = []
                for i in 0..<numberOfQubits {
                    let bit = register.measureQubit(i)
                    result += "\(bit)"
                    vector.append(bit)
                }

                measurements[result, default: 0] += 1
                collectedVectors.append(vector)
            }

            // Try to find the secret string from collected vectors
            let foundSecret = solveLinearSystem(vectors: collectedVectors, n: numberOfQubits)

            return SimonResult(
                numberOfQubits: numberOfQubits,
                hiddenString: secret,
                measurements: measurements,
                foundString: foundSecret,
                totalShots: shots
            )
        }

        /// Applies Simon's oracle
        /// f(x) = f(y) iff x ⊕ y = 0 or x ⊕ y = s
        private static func applySimonOracle(
            register: QuantumRegister,
            numberOfInputQubits: Int,
            secret: Int
        ) {
            let n = numberOfInputQubits

            // Simple oracle: f(x) = x if x < s, f(x) = x ⊕ s if x >= s
            // This can be implemented using controlled operations

            // Copy input to output (CNOT from each input to corresponding output)
            for i in 0..<n {
                register.applyCNOT(control: i, target: n + i)
            }

            // XOR with secret based on most significant bit
            // This is a simplified implementation
            if secret > 0 {
                // Apply controlled XOR with secret
                for i in 0..<n {
                    if (secret >> (n - 1 - i)) & 1 == 1 {
                        register.applyCNOT(control: 0, target: n + i)
                    }
                }
            }
        }

        /// Solves the linear system to find the secret string
        private static func solveLinearSystem(vectors: [[Int]], n: Int) -> Int? {
            // Simplified: find s such that y·s = 0 for all measured y
            // Try all possible non-zero values of s

            let maxS = 1 << n
            var bestS = 0
            var bestScore = 0

            for s in 1..<maxS {
                var score = 0
                for y in vectors {
                    var dotProduct = 0
                    for i in 0..<n {
                        let sBit = (s >> (n - 1 - i)) & 1
                        dotProduct ^= (y[i] * sBit)
                    }
                    if dotProduct == 0 {
                        score += 1
                    }
                }

                if score > bestScore {
                    bestScore = score
                    bestS = s
                }
            }

            // Also check if s=0 works (trivial case)
            if bestScore < vectors.count / 2 {
                return nil  // Couldn't find clear solution
            }

            return bestS
        }
    }

    /// Result of Simon's algorithm
    public struct SimonResult {
        public let numberOfQubits: Int
        public let hiddenString: Int
        public let measurements: [String: Int]
        public let foundString: Int?
        public let totalShots: Int

        public var hiddenBinaryString: String {
            var result = String(hiddenString, radix: 2)
            while result.count < numberOfQubits {
                result = "0" + result
            }
            return result
        }

        public var foundBinaryString: String? {
            guard let found = foundString else { return nil }
            var result = String(found, radix: 2)
            while result.count < numberOfQubits {
                result = "0" + result
            }
            return result
        }

        public var isCorrect: Bool {
            return foundString == hiddenString
        }

        public var description: String {
            var desc = "Simon's Algorithm\n"
            desc += "=================\n"
            desc += "Input qubits: \(numberOfQubits)\n"
            desc += "Hidden string s: \(hiddenBinaryString) (decimal: \(hiddenString))\n"
            desc += "Shots: \(totalShots)\n\n"

            desc += "Measured orthogonal vectors y (y·s = 0):\n"
            let sorted = measurements.sorted { $0.value > $1.value }
            for (outcome, count) in sorted.prefix(8) {
                let percentage = Double(count) / Double(totalShots) * 100
                desc += "  |\(outcome)⟩: \(count) (\(String(format: "%.1f", percentage))%)\n"
            }

            if let found = foundBinaryString {
                desc += "\nFound secret: \(found)"
                if isCorrect {
                    desc += " ✓ CORRECT"
                } else {
                    desc += " ✗ (Expected: \(hiddenBinaryString))"
                }
            } else {
                desc += "\nCould not determine secret string"
            }

            desc += "\n\nQuantum Advantage:"
            desc += "\n  Classical: O(2^(\(numberOfQubits)/2)) = O(\(1 << (numberOfQubits/2))) queries"
            desc += "\n  Quantum: O(\(numberOfQubits)) queries"

            return desc
        }
    }
}

// MARK: - Quantum Algorithm Runner

/// Convenience class for running quantum algorithms
public class QuantumAlgorithmRunner {

    /// Runs all algorithms and returns a summary
    public static func runAll(shots: Int = 100) -> String {
        var summary = "SwiftQuantum v2.0 - Quantum Algorithms Demo\n"
        summary += "============================================\n\n"

        // Bell State
        summary += "1. BELL STATE\n"
        summary += "--------------\n"
        let bellResult = QuantumAlgorithms.BellState.run(type: .phiPlus, shots: shots)
        summary += bellResult.description
        summary += "\n\n"

        // Deutsch-Jozsa
        summary += "2. DEUTSCH-JOZSA\n"
        summary += "-----------------\n"
        let djResult = QuantumAlgorithms.DeutschJozsa.run(numberOfQubits: 3, oracleType: .balanced, shots: shots)
        summary += djResult.description
        summary += "\n\n"

        // Grover
        summary += "3. GROVER'S SEARCH\n"
        summary += "-------------------\n"
        let groverResult = QuantumAlgorithms.GroverSearch.run(numberOfQubits: 3, targetState: 5, shots: shots)
        summary += groverResult.description
        summary += "\n\n"

        // Simon
        summary += "4. SIMON'S ALGORITHM\n"
        summary += "---------------------\n"
        let simonResult = QuantumAlgorithms.SimonAlgorithm.run(numberOfQubits: 3, hiddenString: 5, shots: shots)
        summary += simonResult.description

        return summary
    }
}
