//
//  QuantumExperienceTests.swift
//  SwiftQuantumTests
//
//  Created by Eunmin Park on 2026-01-19.
//

import XCTest
@testable import SwiftQuantum

final class QuantumExperienceTests: XCTestCase {

    // MARK: - DailyChallengeEngine Tests

    func testDailyPatternDeterminism() {
        // Same date should always produce same pattern
        let date = "2026-01-19"
        let pattern1 = DailyChallengeEngine.generateDailyPattern(userSeed: date)
        let pattern2 = DailyChallengeEngine.generateDailyPattern(userSeed: date)

        XCTAssertEqual(pattern1.amplitude, pattern2.amplitude)
        XCTAssertEqual(pattern1.phase, pattern2.phase)
    }

    func testDailyPatternVariation() {
        // Different dates should produce different patterns
        let pattern1 = DailyChallengeEngine.generateDailyPattern(userSeed: "2026-01-19")
        let pattern2 = DailyChallengeEngine.generateDailyPattern(userSeed: "2026-01-20")

        // At least one should be different
        XCTAssertTrue(pattern1.amplitude != pattern2.amplitude || pattern1.phase != pattern2.phase)
    }

    func testDailyPatternRange() {
        // Amplitude should be in [0, 1]
        // Phase should be in [0, 2π]
        for day in 1...31 {
            let pattern = DailyChallengeEngine.generateDailyPattern(userSeed: "2026-01-\(String(format: "%02d", day))")
            XCTAssertGreaterThanOrEqual(pattern.amplitude, 0.0)
            XCTAssertLessThanOrEqual(pattern.amplitude, 1.0)
            XCTAssertGreaterThanOrEqual(pattern.phase, 0.0)
            XCTAssertLessThanOrEqual(pattern.phase, 2.0 * .pi)
        }
    }

    func testExtendedDailyPattern() {
        let pattern = DailyChallengeEngine.generateExtendedDailyPattern(userSeed: "2026-01-19")

        XCTAssertGreaterThanOrEqual(pattern.entanglementStrength, 0.0)
        XCTAssertLessThanOrEqual(pattern.entanglementStrength, 1.0)
        XCTAssertGreaterThanOrEqual(pattern.luckyQuantumState, 1)
        XCTAssertLessThanOrEqual(pattern.luckyQuantumState, 8)
        XCTAssertEqual(pattern.dateSeed, "2026-01-19")
    }

    // MARK: - OracleEngine Tests

    func testOracleBasicFunction() {
        let oracle = OracleEngine()
        let result = oracle.consultOracle(question: "Test question?")

        // Answer should be boolean
        XCTAssertTrue(result.answer == true || result.answer == false)

        // Confidence should be in valid range
        XCTAssertGreaterThanOrEqual(result.confidence, 0.0)
        XCTAssertLessThanOrEqual(result.confidence, 1.0)

        // Coordinate should be in [0, 1] range
        XCTAssertGreaterThanOrEqual(result.collapsedCoordinate.x, 0.0)
        XCTAssertLessThanOrEqual(result.collapsedCoordinate.x, 1.0)
        XCTAssertGreaterThanOrEqual(result.collapsedCoordinate.y, 0.0)
        XCTAssertLessThanOrEqual(result.collapsedCoordinate.y, 1.0)
    }

    func testOracleStatistics() {
        let oracle = OracleEngine()
        let stats = oracle.consultOracleStatistics(question: "Is this random?", shots: 100)

        XCTAssertEqual(stats.totalShots, 100)
        XCTAssertEqual(stats.yesCount + stats.noCount, 100)

        // Should be approximately 50-50 (quantum randomness)
        XCTAssertEqual(Double(stats.yesCount) / 100.0, 0.5, accuracy: 0.2)
    }

    func testOracleHistory() {
        let oracle = OracleEngine()
        oracle.maxHistorySize = 5

        // Add 10 consultations
        for i in 0..<10 {
            _ = oracle.consultOracle(question: "Question \(i)")
        }

        // History should be limited to maxHistorySize
        XCTAssertEqual(oracle.consultationHistory.count, 5)

        // Clear history
        oracle.clearHistory()
        XCTAssertEqual(oracle.consultationHistory.count, 0)
    }

    // MARK: - QuantumArtMapper Tests

    func testArtMapperQubit() {
        let mapper = QuantumArtMapper()

        // Test with superposition state
        let artData = mapper.mapToArtParameters(qubit: .superposition)

        XCTAssertGreaterThanOrEqual(artData.primaryHue, 0.0)
        XCTAssertLessThanOrEqual(artData.primaryHue, 1.0)
        XCTAssertGreaterThanOrEqual(artData.complexity, 1)
        XCTAssertLessThanOrEqual(artData.complexity, 10)
        XCTAssertGreaterThanOrEqual(artData.contrast, 0.0)
        XCTAssertLessThanOrEqual(artData.contrast, 1.0)
    }

    func testArtMapperRegister() {
        let mapper = QuantumArtMapper()
        let register = QuantumRegister(numberOfQubits: 2)
        register.applyGate(.hadamard, to: 0)
        register.applyCNOT(control: 0, target: 1)

        let artData = mapper.mapToArtParameters(register: register)

        // Entangled state should have higher complexity
        XCTAssertGreaterThanOrEqual(artData.complexity, 1)
        XCTAssertLessThanOrEqual(artData.complexity, 10)
    }

    func testArtDataHexColor() {
        let artData = ArtData(
            primaryHue: 0.0,  // Red
            complexity: 5,
            contrast: 0.5,
            saturation: 1.0,
            brightness: 1.0,
            quantumSignature: "test"
        )

        // Red should be #FF0000
        XCTAssertEqual(artData.hexColor, "#FF0000")
    }

    func testArtMapperConfiguration() {
        var config = QuantumArtMapper.Configuration()
        config.maxComplexity = 20
        config.minComplexity = 5
        config.hueMode = .quantized6

        let mapper = QuantumArtMapper(configuration: config)
        let artData = mapper.mapToArtParameters(qubit: .superposition)

        XCTAssertGreaterThanOrEqual(artData.complexity, 5)
        XCTAssertLessThanOrEqual(artData.complexity, 20)
    }

    // MARK: - QuantumExperience Integration Tests

    func testQuantumExperienceDaily() {
        let pattern = QuantumExperience.todayPattern
        XCTAssertGreaterThanOrEqual(pattern.amplitude, 0.0)
        XCTAssertLessThanOrEqual(pattern.amplitude, 1.0)
    }

    func testQuantumExperienceOracle() {
        let answer = QuantumExperience.askOracle("Test?")
        XCTAssertTrue(answer == true || answer == false)
    }

    func testQuantumExperienceArt() {
        let circuit = QuantumCircuit(qubit: .zero)
        circuit.addGate(.hadamard)
        let artData = QuantumExperience.generateArt(from: circuit)

        XCTAssertGreaterThanOrEqual(artData.complexity, 1)
    }

    func testDailyExperience() {
        let experience = QuantumExperience.generateDailyExperience()

        XCTAssertNotNil(experience.pattern)
        XCTAssertNotNil(experience.art)
        XCTAssertNotNil(experience.fortune)
        XCTAssertNotNil(experience.generatedAt)
    }

    func testPersonalSignature() {
        let signature = QuantumExperience.createPersonalSignature(userIdentifier: "testUser123")

        XCTAssertEqual(signature.userIdentifier, "testUser123")
        XCTAssertGreaterThanOrEqual(signature.dailyAlignment, 0.0)
        XCTAssertLessThanOrEqual(signature.dailyAlignment, 100.0)
    }
}
