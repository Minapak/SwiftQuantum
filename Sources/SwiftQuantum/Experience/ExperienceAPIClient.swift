//
//  ExperienceAPIClient.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2026-01-19.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Backend API Client for QuantumExperience
//  Connects to https://api.swiftquantum.tech/api/v1/experience/*
//

import Foundation

/// API client for QuantumExperience backend integration
///
/// Provides methods to sync local QuantumExperience data with the backend.
/// Falls back to local computation if network is unavailable.
///
/// ## Example Usage
/// ```swift
/// let client = ExperienceAPIClient.shared
///
/// // Get today's pattern from backend (or local fallback)
/// let pattern = try await client.getTodayPattern()
///
/// // Sync oracle consultation to backend
/// let result = try await client.consultOracle(question: "Should I invest?")
/// ```
public actor ExperienceAPIClient {

    // MARK: - Singleton

    /// Shared instance
    public static let shared = ExperienceAPIClient()

    // MARK: - Configuration

    /// Backend API base URL
    public var baseURL: String = "https://api.swiftquantum.tech"

    /// Request timeout in seconds
    public var timeoutInterval: TimeInterval = 30

    /// Whether to use local fallback on network failure
    public var useLocalFallback: Bool = true

    /// Auth token for authenticated requests
    private var authToken: String?

    // MARK: - Initialization

    private init() {}

    // MARK: - Configuration Methods

    /// Set the auth token for authenticated requests
    public func setAuthToken(_ token: String?) {
        self.authToken = token
    }

    /// Configure the API client
    public func configure(baseURL: String? = nil, timeout: TimeInterval? = nil) {
        if let baseURL = baseURL {
            self.baseURL = baseURL
        }
        if let timeout = timeout {
            self.timeoutInterval = timeout
        }
    }

    // MARK: - Daily Pulse API

    /// Get today's daily pattern from backend
    ///
    /// Falls back to local computation if network fails.
    public func getTodayPattern() async throws -> DailyPatternData {
        do {
            let response: DailyPatternAPIResponse = try await get("/api/v1/experience/daily/today")
            return response.toDailyPatternData()
        } catch {
            if useLocalFallback {
                return DailyChallengeEngine.generateTodayExtendedPattern()
            }
            throw error
        }
    }

    /// Get pattern for specific date from backend
    public func getPattern(for date: String) async throws -> DailyPatternData {
        do {
            let response: DailyPatternAPIResponse = try await get("/api/v1/experience/daily/pattern/\(date)")
            return response.toDailyPatternData()
        } catch {
            if useLocalFallback {
                return DailyChallengeEngine.generateExtendedDailyPattern(userSeed: date)
            }
            throw error
        }
    }

    /// Calculate alignment score via backend
    public func calculateAlignment(
        userAmplitude: Double,
        userPhase: Double,
        dailyAmplitude: Double,
        dailyPhase: Double
    ) async throws -> AlignmentResult {
        let body: [String: Any] = [
            "userAmplitude": userAmplitude,
            "userPhase": userPhase,
            "dailyAmplitude": dailyAmplitude,
            "dailyPhase": dailyPhase
        ]

        do {
            let response: AlignmentAPIResponse = try await post("/api/v1/experience/daily/alignment", body: body)
            return AlignmentResult(
                alignmentScore: response.alignmentScore,
                amplitudeScore: response.amplitudeScore,
                phaseScore: response.phaseScore
            )
        } catch {
            if useLocalFallback {
                let score = DailyChallengeEngine.calculateAlignment(
                    userPattern: (amplitude: userAmplitude, phase: userPhase),
                    dailyPattern: (amplitude: dailyAmplitude, phase: dailyPhase)
                )
                return AlignmentResult(
                    alignmentScore: score,
                    amplitudeScore: score * 0.5,
                    phaseScore: score * 0.5
                )
            }
            throw error
        }
    }

    // MARK: - Oracle API

    /// Consult oracle via backend
    ///
    /// Syncs consultation to backend for history tracking.
    public func consultOracle(question: String) async throws -> OracleResult {
        let body: [String: Any] = ["question": question]

        do {
            let response: OracleAPIResponse = try await post("/api/v1/experience/oracle/consult", body: body)
            return response.toOracleResult()
        } catch {
            if useLocalFallback {
                return QuantumExperience.oracle.consultOracle(question: question)
            }
            throw error
        }
    }

    /// Get oracle statistics from backend
    public func oracleStatistics(question: String, shots: Int = 100) async throws -> OracleStatistics {
        let body: [String: Any] = [
            "question": question,
            "shots": shots
        ]

        do {
            let response: OracleStatisticsAPIResponse = try await post("/api/v1/experience/oracle/statistics", body: body)
            return response.toOracleStatistics()
        } catch {
            if useLocalFallback {
                return QuantumExperience.oracle.consultOracleStatistics(question: question, shots: shots)
            }
            throw error
        }
    }

    // MARK: - Art API

    /// Generate art parameters from qubit state via backend
    public func generateArt(from qubit: Qubit) async throws -> ArtData {
        let body: [String: Any] = [
            "amplitude0Real": qubit.amplitude0.real,
            "amplitude0Imag": qubit.amplitude0.imaginary,
            "amplitude1Real": qubit.amplitude1.real,
            "amplitude1Imag": qubit.amplitude1.imaginary
        ]

        do {
            let response: ArtDataAPIResponse = try await post("/api/v1/experience/art/from-qubit", body: body)
            return response.toArtData()
        } catch {
            if useLocalFallback {
                return QuantumExperience.art.mapToArtParameters(qubit: qubit)
            }
            throw error
        }
    }

    // MARK: - Combined Experience API

    /// Get complete daily experience from backend
    public func getDailyExperience() async throws -> DailyExperience {
        do {
            let response: DailyExperienceAPIResponse = try await get("/api/v1/experience/combined/daily")
            return response.toDailyExperience()
        } catch {
            if useLocalFallback {
                return QuantumExperience.generateDailyExperience()
            }
            throw error
        }
    }

    /// Create personal quantum signature via backend
    public func createPersonalSignature(userIdentifier: String) async throws -> PersonalQuantumSignature {
        let body: [String: Any] = ["userIdentifier": userIdentifier]

        do {
            let response: PersonalSignatureAPIResponse = try await post("/api/v1/experience/combined/signature", body: body)
            return response.toPersonalSignature()
        } catch {
            if useLocalFallback {
                return QuantumExperience.createPersonalSignature(userIdentifier: userIdentifier)
            }
            throw error
        }
    }

    // MARK: - Private Network Methods

    private func get<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw ExperienceAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ExperienceAPIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ExperienceAPIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }

    private func post<T: Decodable>(_ endpoint: String, body: [String: Any]) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw ExperienceAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ExperienceAPIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ExperienceAPIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - API Response Models

/// API response for daily pattern
private struct DailyPatternAPIResponse: Decodable {
    let amplitude: Double
    let phase: Double
    let entanglementStrength: Double
    let coherenceTime: Double
    let interferencePattern: Int
    let luckyQuantumState: Int
    let dateSeed: String
    let blochCoordinates: BlochCoordinatesResponse

    func toDailyPatternData() -> DailyPatternData {
        return DailyPatternData(
            amplitude: amplitude,
            phase: phase,
            entanglementStrength: entanglementStrength,
            coherenceTime: coherenceTime,
            interferencePattern: interferencePattern,
            luckyQuantumState: luckyQuantumState,
            dateSeed: dateSeed
        )
    }
}

private struct BlochCoordinatesResponse: Decodable {
    let x: Double
    let y: Double
    let z: Double
}

/// API response for alignment
private struct AlignmentAPIResponse: Decodable {
    let alignmentScore: Double
    let amplitudeScore: Double
    let phaseScore: Double
}

/// API response for oracle result
private struct OracleAPIResponse: Decodable {
    let answer: Bool
    let confidence: Double
    let collapsedCoordinate: CoordinateResponse
    let question: String
    let timestamp: Date
    let quantumState: String
    let answerString: String
    let confidencePercentage: String

    func toOracleResult() -> OracleResult {
        return OracleResult(
            answer: answer,
            confidence: confidence,
            collapsedCoordinate: CGPoint(x: collapsedCoordinate.x, y: collapsedCoordinate.y),
            question: question,
            timestamp: timestamp,
            quantumState: quantumState
        )
    }
}

private struct CoordinateResponse: Decodable {
    let x: Double
    let y: Double
}

/// API response for oracle statistics
private struct OracleStatisticsAPIResponse: Decodable {
    let question: String
    let totalShots: Int
    let yesCount: Int
    let noCount: Int
    let averageConfidence: Double
    let yesPercentage: Double
    let noPercentage: Double

    func toOracleStatistics() -> OracleStatistics {
        return OracleStatistics(
            question: question,
            totalShots: totalShots,
            yesCount: yesCount,
            noCount: noCount,
            averageConfidence: averageConfidence
        )
    }
}

/// API response for art data
private struct ArtDataAPIResponse: Decodable {
    let primaryHue: Double
    let complexity: Int
    let contrast: Double
    let saturation: Double
    let brightness: Double
    let quantumSignature: String
    let hueDegrees: Double
    let hexColor: String
    let rgbColor: RGBColorResponse

    func toArtData() -> ArtData {
        return ArtData(
            primaryHue: primaryHue,
            complexity: complexity,
            contrast: contrast,
            saturation: saturation,
            brightness: brightness,
            quantumSignature: quantumSignature
        )
    }
}

private struct RGBColorResponse: Decodable {
    let red: Double
    let green: Double
    let blue: Double
}

/// API response for daily experience
private struct DailyExperienceAPIResponse: Decodable {
    let pattern: DailyPatternAPIResponse
    let art: ArtDataAPIResponse
    let fortune: OracleAPIResponse
    let generatedAt: Date

    func toDailyExperience() -> DailyExperience {
        return DailyExperience(
            pattern: pattern.toDailyPatternData(),
            art: art.toArtData(),
            fortune: fortune.toOracleResult(),
            generatedAt: generatedAt
        )
    }
}

/// API response for personal signature
private struct PersonalSignatureAPIResponse: Decodable {
    let userIdentifier: String
    let artParameters: ArtDataAPIResponse
    let dailyAlignment: Double
    let blochCoordinates: BlochCoordinatesResponse
    let quantumStateDescription: String

    func toPersonalSignature() -> PersonalQuantumSignature {
        // Create qubit from Bloch coordinates
        let theta = acos(blochCoordinates.z)
        let phi = atan2(blochCoordinates.y, blochCoordinates.x)
        let qubit = Qubit.fromBlochAngles(theta: theta, phi: phi)

        return PersonalQuantumSignature(
            userIdentifier: userIdentifier,
            quantumState: qubit,
            artParameters: artParameters.toArtData(),
            dailyAlignment: dailyAlignment,
            blochCoordinates: (x: blochCoordinates.x, y: blochCoordinates.y, z: blochCoordinates.z)
        )
    }
}

// MARK: - Supporting Types

/// Result of alignment calculation
public struct AlignmentResult: Sendable {
    public let alignmentScore: Double
    public let amplitudeScore: Double
    public let phaseScore: Double
}

/// API errors
public enum ExperienceAPIError: Error, Sendable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
    case networkError(String)
}

extension ExperienceAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}
