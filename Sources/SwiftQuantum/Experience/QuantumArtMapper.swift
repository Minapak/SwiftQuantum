//
//  QuantumArtMapper.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2026-01-19.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Quantum Art Data Mapping - Transform Quantum States to Visual Art Parameters
//  Maps quantum measurement results to artistic parameters for generative art.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// QuantumArtMapper transforms quantum computation results into
/// visual art parameters for generative artwork creation.
///
/// ## Mapping Philosophy
/// - **Hue**: Derived from the most probable basis state index
/// - **Complexity**: Based on entanglement entropy (higher entropy = more complex)
/// - **Contrast**: Calculated from phase variance across states
///
/// ## Example Usage
/// ```swift
/// let circuit = QuantumCircuit(qubit: .zero)
/// circuit.addGate(.hadamard)
/// let result = circuit.execute()
///
/// let mapper = QuantumArtMapper()
/// let artData = mapper.mapToArtParameters(qubit: result)
/// // Use artData.primaryHue, artData.complexity, artData.contrast for artwork
/// ```
public final class QuantumArtMapper: @unchecked Sendable {

    // MARK: - Configuration

    /// Configuration for art parameter mapping
    public struct Configuration: Sendable {
        /// Maximum complexity level (for fractal depth, etc.)
        public var maxComplexity: Int = 10

        /// Minimum complexity level
        public var minComplexity: Int = 1

        /// Hue mapping mode
        public var hueMode: HueMode = .continuous

        /// Contrast sensitivity (higher = more dramatic differences)
        public var contrastSensitivity: Double = 1.0

        public init() {}

        public enum HueMode: Sendable {
            case continuous    // Smooth 0-360 hue range
            case quantized6    // 6 primary/secondary colors
            case quantized12   // 12 color wheel segments
            case warm          // Only warm colors (0-60, 300-360)
            case cool          // Only cool colors (180-270)
        }
    }

    /// Current configuration
    public var configuration: Configuration

    // MARK: - Initialization

    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }

    // MARK: - Single Qubit Mapping

    /// Maps a single qubit's quantum state to art parameters.
    ///
    /// For single qubits:
    /// - Hue: Based on measurement probability ratio
    /// - Complexity: Based on entropy (superposition = higher complexity)
    /// - Contrast: Based on relative phase
    ///
    /// - Parameter qubit: The quantum state to map
    /// - Returns: ArtData containing visual parameters
    public func mapToArtParameters(qubit: Qubit) -> ArtData {
        // Hue: Map probability distribution to color
        // |0⟩ = 0 (red), |1⟩ = 0.5 (cyan), superposition = intermediate
        let hue = mapProbabilityToHue(prob0: qubit.probability0, prob1: qubit.probability1)

        // Complexity: Based on entropy (0 entropy = simple, 1 entropy = complex)
        let entropy = qubit.entropy()
        let normalizedEntropy = min(1.0, entropy)  // Max entropy for qubit is 1
        let complexity = mapEntropyToComplexity(entropy: normalizedEntropy)

        // Contrast: Based on relative phase difference
        let phaseDifference = abs(qubit.relativePhase)
        let normalizedPhase = phaseDifference / .pi  // Normalize to [0, 1]
        let contrast = mapPhaseToContrast(normalizedPhase: normalizedPhase)

        // Generate additional artistic parameters
        let bloch = qubit.blochCoordinates()
        let saturation = sqrt(bloch.x * bloch.x + bloch.y * bloch.y)
        let brightness = (bloch.z + 1.0) / 2.0

        return ArtData(
            primaryHue: hue,
            complexity: complexity,
            contrast: contrast,
            saturation: saturation,
            brightness: brightness,
            quantumSignature: generateQuantumSignature(qubit: qubit)
        )
    }

    // MARK: - Multi-Qubit Register Mapping

    /// Maps a quantum register's state to art parameters.
    ///
    /// For multi-qubit systems:
    /// - Hue: Based on most probable basis state index
    /// - Complexity: Based on register entropy (entanglement indicator)
    /// - Contrast: Based on phase variance across all non-zero amplitudes
    ///
    /// - Parameter register: The quantum register to map
    /// - Returns: ArtData containing visual parameters
    public func mapToArtParameters(register: QuantumRegister) -> ArtData {
        let probabilities = register.probabilities
        let amplitudes = register.amplitudes

        // Find most probable basis state
        let (maxIndex, maxProb) = findMaxProbabilityState(probabilities: probabilities)

        // Hue: Map most probable state index to hue
        let normalizedIndex = Double(maxIndex) / Double(max(1, register.numberOfStates - 1))
        let hue = mapIndexToHue(normalizedIndex: normalizedIndex)

        // Complexity: Based on entropy (entanglement indicator)
        let entropy = register.entropy()
        let maxEntropy = Double(register.numberOfQubits)  // Max entropy for n qubits
        let normalizedEntropy = entropy / maxEntropy
        let complexity = mapEntropyToComplexity(entropy: normalizedEntropy)

        // Contrast: Based on phase variance
        let phaseVariance = calculatePhaseVariance(amplitudes: amplitudes)
        let contrast = mapPhaseToContrast(normalizedPhase: sqrt(phaseVariance / (.pi * .pi)))

        // Additional parameters
        let saturation = calculateStateSaturation(probabilities: probabilities, maxProb: maxProb)
        let brightness = calculateStateBrightness(register: register)

        return ArtData(
            primaryHue: hue,
            complexity: complexity,
            contrast: contrast,
            saturation: saturation,
            brightness: brightness,
            quantumSignature: generateQuantumSignature(register: register)
        )
    }

    /// Maps circuit execution result to art parameters.
    ///
    /// Convenience method for circuit results.
    ///
    /// - Parameter circuit: Executed quantum circuit
    /// - Returns: ArtData from the circuit's final state
    public func mapToArtParameters(circuit: QuantumCircuit) -> ArtData {
        let finalState = circuit.execute()
        return mapToArtParameters(qubit: finalState)
    }

    // MARK: - Batch Processing

    /// Maps multiple quantum states to a color palette.
    ///
    /// Useful for generating cohesive color schemes from quantum data.
    ///
    /// - Parameter qubits: Array of quantum states
    /// - Returns: Array of ArtData forming a palette
    public func generatePalette(from qubits: [Qubit]) -> [ArtData] {
        return qubits.map { mapToArtParameters(qubit: $0) }
    }

    /// Generates art parameters from measurement statistics.
    ///
    /// - Parameters:
    ///   - measurements: Dictionary of measurement outcomes and counts
    ///   - totalShots: Total number of measurements
    /// - Returns: ArtData based on statistical distribution
    public func mapMeasurementStatistics(measurements: [Int: Int], totalShots: Int) -> ArtData {
        let total = Double(totalShots)

        // Calculate probabilities from measurements
        var probabilities: [Double] = []
        var maxIndex = 0
        var maxCount = 0

        for (state, count) in measurements.sorted(by: { $0.key < $1.key }) {
            probabilities.append(Double(count) / total)
            if count > maxCount {
                maxCount = count
                maxIndex = state
            }
        }

        // Hue from most frequent state
        let numStates = measurements.count
        let normalizedIndex = numStates > 1 ? Double(maxIndex) / Double(numStates - 1) : 0.5
        let hue = mapIndexToHue(normalizedIndex: normalizedIndex)

        // Complexity from distribution entropy
        var entropy = 0.0
        for prob in probabilities {
            if prob > 1e-15 {
                entropy -= prob * log2(prob)
            }
        }
        let maxPossibleEntropy = log2(Double(numStates))
        let normalizedEntropy = maxPossibleEntropy > 0 ? entropy / maxPossibleEntropy : 0
        let complexity = mapEntropyToComplexity(entropy: normalizedEntropy)

        // Contrast from probability spread
        let minProb = probabilities.min() ?? 0
        let maxProb = probabilities.max() ?? 1
        let spread = maxProb - minProb
        let contrast = spread * configuration.contrastSensitivity

        return ArtData(
            primaryHue: hue,
            complexity: complexity,
            contrast: min(1.0, contrast),
            saturation: 0.8,  // Default high saturation
            brightness: 0.7,  // Default medium-high brightness
            quantumSignature: "stats_\(totalShots)_\(measurements.count)"
        )
    }

    // MARK: - Private Mapping Functions

    private func mapProbabilityToHue(prob0: Double, prob1: Double) -> Double {
        // Linear interpolation: |0⟩ = 0 (red), |1⟩ = 0.5 (cyan)
        let baseHue = prob1 * 0.5

        switch configuration.hueMode {
        case .continuous:
            return baseHue
        case .quantized6:
            return round(baseHue * 6) / 6
        case .quantized12:
            return round(baseHue * 12) / 12
        case .warm:
            return baseHue < 0.25 ? baseHue * 0.333 : 0.833 + (baseHue - 0.25) * 0.333
        case .cool:
            return 0.5 + baseHue * 0.25
        }
    }

    private func mapIndexToHue(normalizedIndex: Double) -> Double {
        switch configuration.hueMode {
        case .continuous:
            return normalizedIndex
        case .quantized6:
            return round(normalizedIndex * 6) / 6
        case .quantized12:
            return round(normalizedIndex * 12) / 12
        case .warm:
            return normalizedIndex < 0.5 ? normalizedIndex * 0.333 : 0.833 + (normalizedIndex - 0.5) * 0.333
        case .cool:
            return 0.5 + normalizedIndex * 0.25
        }
    }

    private func mapEntropyToComplexity(entropy: Double) -> Int {
        let range = Double(configuration.maxComplexity - configuration.minComplexity)
        let scaledEntropy = entropy * range
        return configuration.minComplexity + Int(scaledEntropy.rounded())
    }

    private func mapPhaseToContrast(normalizedPhase: Double) -> Double {
        return min(1.0, normalizedPhase * configuration.contrastSensitivity)
    }

    private func findMaxProbabilityState(probabilities: [Double]) -> (index: Int, probability: Double) {
        var maxIndex = 0
        var maxProb = 0.0

        for (index, prob) in probabilities.enumerated() {
            if prob > maxProb {
                maxProb = prob
                maxIndex = index
            }
        }

        return (maxIndex, maxProb)
    }

    private func calculatePhaseVariance(amplitudes: [Complex]) -> Double {
        var phases: [Double] = []

        for amp in amplitudes {
            if amp.magnitudeSquared > 1e-10 {
                phases.append(amp.phase)
            }
        }

        guard phases.count > 1 else { return 0 }

        let mean = phases.reduce(0, +) / Double(phases.count)
        let variance = phases.map { pow($0 - mean, 2) }.reduce(0, +) / Double(phases.count)

        return variance
    }

    private func calculateStateSaturation(probabilities: [Double], maxProb: Double) -> Double {
        // Higher probability concentration = higher saturation
        return min(1.0, maxProb * 1.2)
    }

    private func calculateStateBrightness(register: QuantumRegister) -> Double {
        // More superposition states = brighter
        var nonZeroCount = 0
        for amp in register.amplitudes {
            if amp.magnitudeSquared > 1e-10 {
                nonZeroCount += 1
            }
        }
        let ratio = Double(nonZeroCount) / Double(register.numberOfStates)
        return 0.3 + ratio * 0.7  // Range: 0.3 to 1.0
    }

    private func generateQuantumSignature(qubit: Qubit) -> String {
        let bloch = qubit.blochCoordinates()
        return String(format: "q1_%.2f_%.2f_%.2f", bloch.x, bloch.y, bloch.z)
    }

    private func generateQuantumSignature(register: QuantumRegister) -> String {
        let entropy = register.entropy()
        return String(format: "q%d_e%.2f", register.numberOfQubits, entropy)
    }
}

// MARK: - Data Structures

/// Art parameters derived from quantum states.
public struct ArtData: Codable, Equatable, Sendable {
    /// Primary hue value (0.0-1.0, maps to 0-360 degrees)
    public let primaryHue: Double

    /// Complexity level for fractal/pattern generation
    public let complexity: Int

    /// Contrast value (0.0-1.0)
    public let contrast: Double

    /// Color saturation (0.0-1.0)
    public let saturation: Double

    /// Color brightness (0.0-1.0)
    public let brightness: Double

    /// Unique identifier based on quantum state
    public let quantumSignature: String

    /// Hue in degrees (0-360)
    public var hueDegrees: Double {
        return primaryHue * 360.0
    }

    /// RGB color values derived from HSB
    public var rgbColor: (red: Double, green: Double, blue: Double) {
        return hsbToRgb(h: primaryHue, s: saturation, b: brightness)
    }

    /// Hex color string
    public var hexColor: String {
        let rgb = rgbColor
        let r = Int(rgb.red * 255)
        let g = Int(rgb.green * 255)
        let b = Int(rgb.blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    #if canImport(CoreGraphics)
    /// CGColor for use with CoreGraphics/UIKit/AppKit
    public var cgColor: CGColor {
        let rgb = rgbColor
        return CGColor(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1.0)
    }
    #endif

    /// Display description for debugging
    public var displayDescription: String {
        return String(format: "Hue: %.0f° | Complexity: %d | Contrast: %.1f%% | %@",
                     hueDegrees, complexity, contrast * 100, hexColor)
    }

    /// Creates default art data
    public static var `default`: ArtData {
        return ArtData(
            primaryHue: 0.5,
            complexity: 5,
            contrast: 0.5,
            saturation: 0.8,
            brightness: 0.7,
            quantumSignature: "default"
        )
    }

    // MARK: - Color Conversion

    private func hsbToRgb(h: Double, s: Double, b: Double) -> (red: Double, green: Double, blue: Double) {
        if s == 0 {
            return (b, b, b)  // Achromatic (gray)
        }

        let h6 = h * 6.0
        let sector = Int(h6) % 6
        let f = h6 - Double(sector)
        let p = b * (1.0 - s)
        let q = b * (1.0 - s * f)
        let t = b * (1.0 - s * (1.0 - f))

        switch sector {
        case 0: return (b, t, p)
        case 1: return (q, b, p)
        case 2: return (p, b, t)
        case 3: return (p, q, b)
        case 4: return (t, p, b)
        default: return (b, p, q)
        }
    }
}

// MARK: - Convenience Extensions

extension QuantumCircuit {
    /// Maps this circuit's final state to art parameters.
    ///
    /// Convenience method for quick art generation.
    ///
    /// - Parameter mapper: Optional custom mapper (uses default if nil)
    /// - Returns: ArtData from circuit execution
    public func toArtParameters(mapper: QuantumArtMapper? = nil) -> ArtData {
        let artMapper = mapper ?? QuantumArtMapper()
        return artMapper.mapToArtParameters(circuit: self)
    }
}

extension Qubit {
    /// Maps this qubit state to art parameters.
    ///
    /// - Parameter mapper: Optional custom mapper (uses default if nil)
    /// - Returns: ArtData from qubit state
    public func toArtParameters(mapper: QuantumArtMapper? = nil) -> ArtData {
        let artMapper = mapper ?? QuantumArtMapper()
        return artMapper.mapToArtParameters(qubit: self)
    }
}

extension QuantumRegister {
    /// Maps this register's state to art parameters.
    ///
    /// - Parameter mapper: Optional custom mapper (uses default if nil)
    /// - Returns: ArtData from register state
    public func toArtParameters(mapper: QuantumArtMapper? = nil) -> ArtData {
        let artMapper = mapper ?? QuantumArtMapper()
        return artMapper.mapToArtParameters(register: self)
    }
}
