//
//  QuantumExperience.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2026-01-19.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  QuantumExperience Module - Entertainment Logic for Premium Features
//  Provides Daily Pulse, Oracle, and Art generation capabilities.
//

import Foundation

/// QuantumExperience is the main entry point for entertainment-focused
/// quantum features in SwiftQuantum.
///
/// This module provides three core experiences:
/// 1. **Daily Pulse**: Global daily patterns that synchronize all users
/// 2. **The Oracle**: Quantum-based yes/no decision making
/// 3. **Quantum Art**: Transform quantum states into visual art parameters
///
/// ## Example Usage
/// ```swift
/// // Get today's global quantum pattern
/// let dailyPattern = QuantumExperience.daily.generateTodayPattern()
///
/// // Ask the quantum oracle a question
/// let oracleResult = QuantumExperience.oracle.consultOracle(question: "Should I invest?")
///
/// // Generate art from a quantum circuit
/// let circuit = QuantumCircuit(qubit: .zero)
/// circuit.addGate(.hadamard)
/// let artData = QuantumExperience.art.mapToArtParameters(circuit: circuit)
/// ```
public struct QuantumExperience {

    // MARK: - Singleton Engines

    /// Daily Challenge Engine for synchronized global patterns
    public static let daily = DailyChallengeEngine.self

    /// Oracle Engine instance for quantum decision making
    public static let oracle = OracleEngine()

    /// Art Mapper instance for quantum-to-visual transformation
    public static let art = QuantumArtMapper()

    // MARK: - Quick Access Methods

    /// Get today's quantum pattern
    public static var todayPattern: (amplitude: Double, phase: Double) {
        return daily.generateTodayPattern()
    }

    /// Get today's extended pattern data
    public static var todayExtendedPattern: DailyPatternData {
        return daily.generateTodayExtendedPattern()
    }

    /// Quick oracle decision (returns true for Yes, false for No)
    public static func askOracle(_ question: String) -> Bool {
        return oracle.quickDecision(question: question)
    }

    /// Full oracle consultation with confidence and metadata
    public static func consultOracle(_ question: String) -> OracleResult {
        return oracle.consultOracle(question: question)
    }

    /// Generate art parameters from a quantum circuit
    public static func generateArt(from circuit: QuantumCircuit) -> ArtData {
        return art.mapToArtParameters(circuit: circuit)
    }

    /// Generate art parameters from a qubit state
    public static func generateArt(from qubit: Qubit) -> ArtData {
        return art.mapToArtParameters(qubit: qubit)
    }

    /// Generate art parameters from a quantum register
    public static func generateArt(from register: QuantumRegister) -> ArtData {
        return art.mapToArtParameters(register: register)
    }

    // MARK: - Combined Experience

    /// Generates a complete daily experience package
    ///
    /// Combines all three engines for a cohesive daily quantum experience.
    ///
    /// - Returns: DailyExperience containing pattern, fortune, and art
    public static func generateDailyExperience() -> DailyExperience {
        let pattern = daily.generateTodayExtendedPattern()

        // Generate art from the daily pattern
        let patternQubit = Qubit.fromBlochAngles(
            theta: pattern.amplitude * .pi,
            phi: pattern.phase
        )
        let artData = art.mapToArtParameters(qubit: patternQubit)

        // Generate daily fortune
        let fortuneResult = oracle.consultOracle(question: "What does today hold?")

        return DailyExperience(
            pattern: pattern,
            art: artData,
            fortune: fortuneResult,
            generatedAt: Date()
        )
    }

    /// Creates a personalized quantum signature for a user
    ///
    /// - Parameter userIdentifier: Unique user identifier (name, ID, etc.)
    /// - Returns: Personal quantum signature data
    public static func createPersonalSignature(userIdentifier: String) -> PersonalQuantumSignature {
        // Generate deterministic pattern from user ID
        let userPattern = daily.generateDailyPattern(userSeed: userIdentifier)

        // Create user's quantum state
        let userQubit = Qubit.fromBlochAngles(
            theta: userPattern.amplitude * .pi,
            phi: userPattern.phase
        )

        // Map to art parameters
        let userArt = art.mapToArtParameters(qubit: userQubit)

        // Calculate alignment with today
        let todayPattern = daily.generateTodayPattern()
        let alignment = daily.calculateAlignment(
            userPattern: userPattern,
            dailyPattern: todayPattern
        )

        return PersonalQuantumSignature(
            userIdentifier: userIdentifier,
            quantumState: userQubit,
            artParameters: userArt,
            dailyAlignment: alignment,
            blochCoordinates: userQubit.blochCoordinates()
        )
    }
}

// MARK: - Data Structures

/// Complete daily experience data
public struct DailyExperience: Codable, Sendable {
    /// Today's quantum pattern
    public let pattern: DailyPatternData

    /// Art parameters derived from today's pattern
    public let art: ArtData

    /// Oracle fortune for the day
    public let fortune: OracleResult

    /// Timestamp when generated
    public let generatedAt: Date

    /// Display summary
    public var summary: String {
        return """
        Daily Quantum Experience
        ========================
        Pattern: \(pattern.displayDescription)
        Art: \(art.displayDescription)
        Fortune: \(fortune.displayDescription)
        """
    }
}

/// Personal quantum signature for a user
public struct PersonalQuantumSignature: Sendable {
    /// User identifier used to generate signature
    public let userIdentifier: String

    /// Personal quantum state
    public let quantumState: Qubit

    /// Art parameters for personal visualization
    public let artParameters: ArtData

    /// Alignment score with today's pattern (0-100)
    public let dailyAlignment: Double

    /// Bloch sphere coordinates
    public let blochCoordinates: (x: Double, y: Double, z: Double)

    /// Display description
    public var displayDescription: String {
        return String(format: """
        Quantum Signature for '\(userIdentifier)'
        State: \(quantumState.stateDescription())
        Color: \(artParameters.hexColor)
        Daily Alignment: %.1f%%
        """, dailyAlignment)
    }
}

// MARK: - Module Version

extension QuantumExperience {
    /// Module version information
    public static let version = "1.0.0"

    /// Module description
    public static let moduleDescription = """
    QuantumExperience v\(version)
    Entertainment Logic Module for SwiftQuantum

    Features:
    • Daily Pulse: Synchronized global quantum patterns
    • The Oracle: Quantum-based decision making
    • Quantum Art: State-to-visual parameter mapping

    © 2026 iOS Quantum Engineering
    """
}
