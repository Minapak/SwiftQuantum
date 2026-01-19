//
//  OracleEngine.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2026-01-19.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  The Oracle Logic - True Quantum Randomness for Fate Decisions
//  Uses actual quantum measurement for entertainment-grade "destiny" generation.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// OracleEngine provides quantum-based decision making using true randomness
/// from quantum measurement. Users can "consult the oracle" for yes/no decisions.
///
/// ## Quantum Foundation
/// - Uses Hadamard gate to create perfect 50:50 superposition
/// - User's question influences initial phase rotation (context injection)
/// - Measurement collapses the quantum state for the final answer
///
/// ## Example Usage
/// ```swift
/// let oracle = OracleEngine()
/// let result = oracle.consultOracle(question: "Should I take this job?")
/// print("Answer: \(result.answer ? "Yes" : "No")")
/// print("Confidence: \(result.confidence)")
/// ```
public final class OracleEngine: @unchecked Sendable {

    // MARK: - Properties

    /// Circuit used for oracle consultations
    private var circuit: QuantumCircuit

    /// History of consultations for analytics
    private var _consultationHistory: [OracleResult] = []
    public var consultationHistory: [OracleResult] {
        return _consultationHistory
    }

    /// Maximum history size to prevent memory growth
    public var maxHistorySize: Int = 100

    // MARK: - Initialization

    public init() {
        self.circuit = QuantumCircuit(qubit: .zero)
    }

    // MARK: - Oracle Consultation

    /// Consults the quantum oracle with a question.
    ///
    /// ## How It Works
    /// 1. User's question is hashed to create a unique phase angle
    /// 2. Initial state is rotated by this phase (context injection)
    /// 3. Hadamard gate creates superposition
    /// 4. Measurement collapses to Yes (|1⟩) or No (|0⟩)
    ///
    /// - Parameter question: The yes/no question to ask the oracle
    /// - Returns: OracleResult containing the answer and metadata
    public func consultOracle(question: String) -> OracleResult {
        // Reset circuit
        circuit = QuantumCircuit(qubit: .zero)

        // Step 1: Context Injection - Hash question to phase angle
        let questionHash = hashQuestion(question)
        let phaseAngle = questionHash * 2.0 * .pi  // Map to [0, 2π]

        // Apply tiny phase rotation based on question (user feels their question matters)
        // This doesn't change the 50:50 probability but adds "quantum personality"
        circuit.addGate(.rotationZ(phaseAngle * 0.001))  // Micro-rotation for UX

        // Step 2: Create superposition with Hadamard gate
        circuit.addGate(.hadamard)

        // Step 3: Execute and measure
        let finalState = circuit.execute()
        let measurementResult = finalState.measure()

        // Answer: |1⟩ = Yes, |0⟩ = No
        let answer = measurementResult == 1

        // Step 4: Calculate confidence from quantum state properties
        let confidence = calculateConfidence(state: finalState, questionHash: questionHash)

        // Step 5: Generate collapsed coordinate for visualization
        let collapsedCoordinate = generateCollapsedCoordinate(
            state: finalState,
            answer: answer,
            questionHash: questionHash
        )

        let result = OracleResult(
            answer: answer,
            confidence: confidence,
            collapsedCoordinate: collapsedCoordinate,
            question: question,
            timestamp: Date(),
            quantumState: finalState.stateDescription()
        )

        // Store in history
        addToHistory(result)

        return result
    }

    /// Performs multiple consultations and returns statistical analysis.
    ///
    /// Useful for showing users the quantum nature of the oracle.
    ///
    /// - Parameters:
    ///   - question: The question to ask
    ///   - shots: Number of consultations (default: 100)
    /// - Returns: Statistical breakdown of answers
    public func consultOracleStatistics(question: String, shots: Int = 100) -> OracleStatistics {
        var yesCount = 0
        var noCount = 0
        var totalConfidence = 0.0

        for _ in 0..<shots {
            let result = consultOracle(question: question)
            if result.answer {
                yesCount += 1
            } else {
                noCount += 1
            }
            totalConfidence += result.confidence
        }

        return OracleStatistics(
            question: question,
            totalShots: shots,
            yesCount: yesCount,
            noCount: noCount,
            averageConfidence: totalConfidence / Double(shots)
        )
    }

    /// Quick oracle check for simple decisions.
    ///
    /// Returns just the boolean answer without full analysis.
    ///
    /// - Parameter question: Question to ask
    /// - Returns: true for Yes, false for No
    public func quickDecision(question: String) -> Bool {
        return consultOracle(question: question).answer
    }

    // MARK: - Private Helpers

    /// Hashes the question string to a normalized value [0, 1].
    private func hashQuestion(_ question: String) -> Double {
        var hash: UInt64 = 0x811c9dc5  // FNV offset basis (32-bit style seed)
        let prime: UInt64 = 0x01000193

        for char in question.utf8 {
            hash ^= UInt64(char)
            hash = hash &* prime
        }

        // Normalize to [0, 1]
        return Double(hash % 1_000_000) / 1_000_000.0
    }

    /// Calculates confidence based on quantum state properties.
    private func calculateConfidence(state: Qubit, questionHash: Double) -> Double {
        // Base confidence from probability distribution clarity
        let probDiff = abs(state.probability0 - state.probability1)

        // Entropy-based component (lower entropy = higher confidence)
        let entropy = state.entropy()
        let entropyConfidence = 1.0 - entropy  // Max entropy = 1 for qubit

        // Combine factors
        let baseConfidence = 0.5 + (probDiff * 0.25) + (entropyConfidence * 0.25)

        // Add variation based on question hash for entertainment
        let variation = (questionHash - 0.5) * 0.1
        let finalConfidence = min(1.0, max(0.0, baseConfidence + variation))

        return finalConfidence
    }

    /// Generates visualization coordinates from the collapsed state.
    private func generateCollapsedCoordinate(
        state: Qubit,
        answer: Bool,
        questionHash: Double
    ) -> CGPoint {
        let (x, y, _) = state.blochCoordinates()

        // Map Bloch sphere projection to 2D visualization space
        // Add answer-based offset for visual distinction
        let answerOffset = answer ? 0.2 : -0.2

        // Scale to reasonable coordinate range [0, 1]
        let visualX = (x + 1.0) / 2.0 + (questionHash * 0.1)
        let visualY = (y + 1.0) / 2.0 + answerOffset

        return CGPoint(
            x: min(1.0, max(0.0, visualX)),
            y: min(1.0, max(0.0, visualY))
        )
    }

    /// Adds result to history with size limit management.
    private func addToHistory(_ result: OracleResult) {
        _consultationHistory.append(result)

        // Trim if exceeds max size
        if _consultationHistory.count > maxHistorySize {
            _consultationHistory.removeFirst(_consultationHistory.count - maxHistorySize)
        }
    }

    /// Clears consultation history.
    public func clearHistory() {
        _consultationHistory.removeAll()
    }
}

// MARK: - Data Structures

/// Result from an oracle consultation.
public struct OracleResult: Codable, Equatable, Sendable {
    /// The oracle's answer (true = Yes, false = No)
    public let answer: Bool

    /// Confidence level of the answer (0.0-1.0)
    public let confidence: Double

    /// 2D coordinate representing where the quantum state collapsed
    public let collapsedCoordinate: CGPoint

    /// The original question asked
    public let question: String

    /// Timestamp of the consultation
    public let timestamp: Date

    /// String representation of the quantum state at measurement
    public let quantumState: String

    /// Human-readable answer string
    public var answerString: String {
        return answer ? "Yes" : "No"
    }

    /// Confidence as percentage string
    public var confidencePercentage: String {
        return String(format: "%.1f%%", confidence * 100)
    }

    /// Display description for UI
    public var displayDescription: String {
        return "The Oracle says: \(answerString) (Confidence: \(confidencePercentage))"
    }
}

/// Statistical results from multiple oracle consultations.
public struct OracleStatistics: Codable, Equatable, Sendable {
    public let question: String
    public let totalShots: Int
    public let yesCount: Int
    public let noCount: Int
    public let averageConfidence: Double

    public var yesPercentage: Double {
        return Double(yesCount) / Double(totalShots) * 100.0
    }

    public var noPercentage: Double {
        return Double(noCount) / Double(totalShots) * 100.0
    }

    public var displayDescription: String {
        return String(format: "Yes: %.1f%% | No: %.1f%% | Avg Confidence: %.1f%%",
                     yesPercentage, noPercentage, averageConfidence * 100)
    }
}

// MARK: - CGPoint Codable Extension

// Note: CGPoint already conforms to Codable in CoreGraphics (iOS 7+, macOS 10.9+)
