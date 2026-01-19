//
//  DailyChallengeEngine.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2026-01-19.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Daily Pulse Logic - Entertainment Module
//  Generates deterministic daily patterns for global user synchronization.
//

import Foundation

/// DailyChallengeEngine generates deterministic daily quantum patterns
/// for the Daily Pulse feature, ensuring all users worldwide see
/// the same pattern on the same day.
///
/// ## Design Philosophy
/// - Deterministic: Same date = Same pattern (globally synchronized)
/// - O(1) complexity: No expensive matrix operations
/// - Entertainment-focused: Creates engaging visual parameters
///
/// ## Example Usage
/// ```swift
/// let today = "2026-01-19"
/// let pattern = DailyChallengeEngine.generateDailyPattern(userSeed: today)
/// print("Amplitude: \(pattern.amplitude), Phase: \(pattern.phase)")
/// ```
public struct DailyChallengeEngine {

    // MARK: - Daily Pattern Generation

    /// Generates a deterministic daily pattern based on the date seed.
    ///
    /// The algorithm uses a hash-based approach to ensure:
    /// 1. Same date always produces identical results (deterministic)
    /// 2. Different dates produce visually distinct patterns
    /// 3. O(1) time complexity (instant response)
    ///
    /// - Parameter userSeed: Date string in "YYYY-MM-DD" format
    /// - Returns: Tuple containing amplitude (0.0-1.0) and phase (0.0-2π)
    ///
    /// ## Mathematical Foundation
    /// Uses FNV-1a hash algorithm for uniform distribution:
    /// - Amplitude derived from upper bits (normalized to [0,1])
    /// - Phase derived from lower bits (normalized to [0,2π])
    public static func generateDailyPattern(userSeed: String) -> (amplitude: Double, phase: Double) {
        // FNV-1a hash for deterministic pseudo-randomness
        let hash = fnv1aHash(userSeed)

        // Extract amplitude from upper 32 bits (normalized to 0.0-1.0)
        let upperBits = UInt32((hash >> 32) & 0xFFFFFFFF)
        let amplitude = Double(upperBits) / Double(UInt32.max)

        // Extract phase from lower 32 bits (normalized to 0.0-2π)
        let lowerBits = UInt32(hash & 0xFFFFFFFF)
        let phase = (Double(lowerBits) / Double(UInt32.max)) * 2.0 * .pi

        return (amplitude: amplitude, phase: phase)
    }

    /// Generates extended daily pattern with additional quantum-inspired parameters.
    ///
    /// Provides more detailed data for richer visualizations.
    ///
    /// - Parameter userSeed: Date string in "YYYY-MM-DD" format
    /// - Returns: Extended pattern data structure
    public static func generateExtendedDailyPattern(userSeed: String) -> DailyPatternData {
        let basePattern = generateDailyPattern(userSeed: userSeed)
        let hash = fnv1aHash(userSeed)

        // Generate additional parameters from hash variations
        let secondaryHash = fnv1aHash(userSeed + "_secondary")
        let tertiaryHash = fnv1aHash(userSeed + "_tertiary")

        // Entanglement strength (0.0-1.0)
        let entanglementStrength = Double((secondaryHash >> 32) & 0xFFFFFFFF) / Double(UInt32.max)

        // Coherence time (normalized value representing stability)
        let coherenceTime = Double(secondaryHash & 0xFFFFFFFF) / Double(UInt32.max)

        // Interference pattern seed (for visual generation)
        let interferencePattern = Int((tertiaryHash >> 48) & 0xFFFF)

        // Lucky qubit states (1-8 range, like quantum octets)
        let luckyState = Int((hash >> 16) & 0x7) + 1

        return DailyPatternData(
            amplitude: basePattern.amplitude,
            phase: basePattern.phase,
            entanglementStrength: entanglementStrength,
            coherenceTime: coherenceTime,
            interferencePattern: interferencePattern,
            luckyQuantumState: luckyState,
            dateSeed: userSeed
        )
    }

    /// Generates today's pattern using current date.
    ///
    /// Convenience method that automatically uses today's date.
    ///
    /// - Returns: Today's daily pattern
    public static func generateTodayPattern() -> (amplitude: Double, phase: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let today = formatter.string(from: Date())
        return generateDailyPattern(userSeed: today)
    }

    /// Generates today's extended pattern.
    ///
    /// - Returns: Today's extended daily pattern data
    public static func generateTodayExtendedPattern() -> DailyPatternData {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let today = formatter.string(from: Date())
        return generateExtendedDailyPattern(userSeed: today)
    }

    // MARK: - Streak & Engagement

    /// Calculates quantum alignment score between user and daily pattern.
    ///
    /// Used for gamification - higher scores indicate better "quantum alignment".
    ///
    /// - Parameters:
    ///   - userPattern: User's personal quantum signature
    ///   - dailyPattern: Today's daily pattern
    /// - Returns: Alignment score (0.0-100.0)
    public static func calculateAlignment(
        userPattern: (amplitude: Double, phase: Double),
        dailyPattern: (amplitude: Double, phase: Double)
    ) -> Double {
        // Amplitude similarity (0-50 points)
        let amplitudeDiff = abs(userPattern.amplitude - dailyPattern.amplitude)
        let amplitudeScore = (1.0 - amplitudeDiff) * 50.0

        // Phase alignment (0-50 points)
        // Use cosine similarity for circular values
        let phaseDiff = userPattern.phase - dailyPattern.phase
        let phaseScore = ((cos(phaseDiff) + 1.0) / 2.0) * 50.0

        return amplitudeScore + phaseScore
    }

    // MARK: - Private Helpers

    /// FNV-1a hash algorithm for deterministic pseudo-random generation.
    ///
    /// Properties:
    /// - Fast O(n) where n is string length
    /// - Good distribution (avalanche effect)
    /// - Deterministic (same input = same output)
    private static func fnv1aHash(_ string: String) -> UInt64 {
        var hash: UInt64 = 0xcbf29ce484222325  // FNV offset basis
        let fnvPrime: UInt64 = 0x100000001b3   // FNV prime

        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* fnvPrime
        }

        return hash
    }
}

// MARK: - Data Structures

/// Extended daily pattern data with quantum-inspired parameters.
public struct DailyPatternData: Codable, Equatable, Sendable {
    /// Primary amplitude value (0.0-1.0)
    public let amplitude: Double

    /// Primary phase value (0.0-2π)
    public let phase: Double

    /// Simulated entanglement strength for visual effects (0.0-1.0)
    public let entanglementStrength: Double

    /// Coherence time indicator for stability visualization (0.0-1.0)
    public let coherenceTime: Double

    /// Seed for generating interference patterns (visual element)
    public let interferencePattern: Int

    /// Lucky quantum state number (1-8)
    public let luckyQuantumState: Int

    /// Original date seed
    public let dateSeed: String

    /// Formatted display string for the pattern
    public var displayDescription: String {
        return String(format: "Amplitude: %.2f | Phase: %.2f° | Lucky State: |%d⟩",
                     amplitude,
                     phase * 180.0 / .pi,
                     luckyQuantumState)
    }

    /// Creates Bloch sphere coordinates from the pattern
    public var blochCoordinates: (x: Double, y: Double, z: Double) {
        let theta = amplitude * .pi  // Map amplitude to polar angle
        let phi = phase              // Use phase directly as azimuthal

        return (
            x: sin(theta) * cos(phi),
            y: sin(theta) * sin(phi),
            z: cos(theta)
        )
    }
}
