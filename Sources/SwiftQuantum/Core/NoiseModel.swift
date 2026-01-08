//
//  NoiseModel.swift
//  SwiftQuantum v2.1.0 - Harvard-MIT Fault-Tolerant Quantum Computing
//
//  Created by Eunmin Park on 2026-01-08.
//  Copyright © 2026 iOS Quantum Engineering. All rights reserved.
//
//  Implementation of noise models based on Harvard-MIT 2025 Nature publications:
//  - "448-qubit fault-tolerant quantum architecture" (Nature, Nov 2025)
//  - "Continuous operation of a coherent 3,000-qubit system" (Nature, Sep 2025)
//  - "Magic state distillation on neutral atom quantum computers" (Nature, Jul 2025)
//
//  Key Characteristics Modeled:
//  - Neutral atom decoherence
//  - Atom loss probability
//  - Dephasing noise
//  - Surface code error correction
//  - Magic state distillation fidelity
//

import Foundation

// MARK: - Noise Model Protocol

/// Protocol for quantum noise models
public protocol QuantumNoiseModel: Sendable {
    /// Unique identifier for the noise model
    var modelId: String { get }

    /// Human-readable name
    var name: String { get }

    /// Description of the noise characteristics
    var description: String { get }

    /// Applies noise to a quantum state vector
    /// - Parameters:
    ///   - amplitudes: State vector amplitudes
    ///   - gateDepth: Current circuit depth
    /// - Returns: Noisy state vector
    func applyNoise(to amplitudes: [Complex], gateDepth: Int) -> [Complex]

    /// Calculates fidelity degradation for given circuit depth
    /// - Parameter depth: Circuit depth
    /// - Returns: Expected fidelity (0-1)
    func expectedFidelity(depth: Int) -> Double
}

// MARK: - Harvard-MIT 2025 Noise Model

/// Noise model based on Harvard-MIT 2025 neutral atom research
/// Implements realistic error characteristics from Nature publications
public struct HarvardMITNoiseModel: QuantumNoiseModel, Sendable {

    public let modelId = "harvard_mit_2025"
    public let name = "Harvard-MIT Neutral Atom (2025)"

    public var description: String {
        """
        Noise model based on Harvard-MIT 2025 Nature publications.
        - Platform: Neutral atom quantum computer
        - Architecture: 448-qubit fault-tolerant design
        - Error rate: Sub-0.5% logical error rate
        - Coherence: 2+ hours continuous operation
        """
    }

    // MARK: - Error Parameters (from Nature 2025 papers)

    /// Single-qubit gate error rate
    public let singleQubitErrorRate: Double

    /// Two-qubit gate error rate
    public let twoQubitErrorRate: Double

    /// Measurement error rate
    public let measurementErrorRate: Double

    /// Atom loss probability per operation
    public let atomLossRate: Double

    /// T2 dephasing time in microseconds
    public let t2Dephasing: Double

    /// Whether to simulate surface code error correction
    public let errorCorrectionEnabled: Bool

    /// Surface code distance (typically 3, 5, or 7)
    public let codeDistance: Int

    /// Random number generator for stochastic noise
    private let useRandomNoise: Bool

    // MARK: - Initialization

    public init(
        singleQubitErrorRate: Double = 0.001,      // 0.1% error rate
        twoQubitErrorRate: Double = 0.005,          // 0.5% error rate
        measurementErrorRate: Double = 0.002,       // 0.2% error rate
        atomLossRate: Double = 0.0001,              // 0.01% per operation
        t2Dephasing: Double = 1000.0,               // 1ms T2 time
        errorCorrectionEnabled: Bool = true,
        codeDistance: Int = 3,
        useRandomNoise: Bool = true
    ) {
        self.singleQubitErrorRate = singleQubitErrorRate
        self.twoQubitErrorRate = twoQubitErrorRate
        self.measurementErrorRate = measurementErrorRate
        self.atomLossRate = atomLossRate
        self.t2Dephasing = t2Dephasing
        self.errorCorrectionEnabled = errorCorrectionEnabled
        self.codeDistance = codeDistance
        self.useRandomNoise = useRandomNoise
    }

    // MARK: - Preset Configurations

    /// Ideal noise model (no errors)
    public static let ideal = HarvardMITNoiseModel(
        singleQubitErrorRate: 0,
        twoQubitErrorRate: 0,
        measurementErrorRate: 0,
        atomLossRate: 0,
        t2Dephasing: Double.infinity,
        errorCorrectionEnabled: false,
        useRandomNoise: false
    )

    /// Harvard-MIT 2025 published parameters
    public static let harvard2025 = HarvardMITNoiseModel(
        singleQubitErrorRate: 0.0005,    // Sub-0.1% achieved
        twoQubitErrorRate: 0.003,         // ~0.3% two-qubit gate fidelity
        measurementErrorRate: 0.001,
        atomLossRate: 0.0001,
        t2Dephasing: 2000.0,              // 2ms demonstrated
        errorCorrectionEnabled: true,
        codeDistance: 3
    )

    /// High-fidelity configuration with error correction
    public static let highFidelity = HarvardMITNoiseModel(
        singleQubitErrorRate: 0.0001,
        twoQubitErrorRate: 0.001,
        measurementErrorRate: 0.0005,
        atomLossRate: 0.00001,
        t2Dephasing: 5000.0,
        errorCorrectionEnabled: true,
        codeDistance: 5
    )

    /// Realistic NISQ-era configuration (more noise)
    public static let nisqRealistic = HarvardMITNoiseModel(
        singleQubitErrorRate: 0.005,
        twoQubitErrorRate: 0.02,
        measurementErrorRate: 0.01,
        atomLossRate: 0.001,
        t2Dephasing: 500.0,
        errorCorrectionEnabled: false,
        useRandomNoise: true
    )

    // MARK: - Noise Application

    public func applyNoise(to amplitudes: [Complex], gateDepth: Int) -> [Complex] {
        guard useRandomNoise else {
            return applyDeterministicNoise(to: amplitudes, gateDepth: gateDepth)
        }

        var noisyAmplitudes = amplitudes

        // Apply dephasing noise (T2 process)
        noisyAmplitudes = applyDephasingNoise(noisyAmplitudes, depth: gateDepth)

        // Apply amplitude damping (atom loss)
        noisyAmplitudes = applyAmplitudeDamping(noisyAmplitudes, depth: gateDepth)

        // Apply gate errors
        noisyAmplitudes = applyGateErrors(noisyAmplitudes, depth: gateDepth)

        // Apply error correction if enabled
        if errorCorrectionEnabled {
            noisyAmplitudes = applyErrorCorrection(noisyAmplitudes, depth: gateDepth)
        }

        // Renormalize
        return QuantumLinearAlgebra.normalize(noisyAmplitudes)
    }

    /// Applies deterministic noise degradation (no randomness)
    private func applyDeterministicNoise(to amplitudes: [Complex], gateDepth: Int) -> [Complex] {
        let fidelity = expectedFidelity(depth: gateDepth)
        let noiseScale = sqrt(fidelity)

        return amplitudes.map { amplitude in
            Complex(amplitude.real * noiseScale, amplitude.imaginary * noiseScale)
        }
    }

    /// Applies T2 dephasing noise
    private func applyDephasingNoise(_ amplitudes: [Complex], depth: Int) -> [Complex] {
        // Dephasing rate based on T2 time
        let dephasingRate = 1.0 / t2Dephasing
        let dephasingFactor = exp(-Double(depth) * dephasingRate)

        return amplitudes.enumerated().map { index, amplitude in
            if index == 0 {
                // Ground state unaffected
                return amplitude
            } else {
                // Apply random phase noise to excited states
                let phaseNoise = Double.random(in: -0.01...0.01) * Double(depth)
                let noisyPhase = amplitude.phase + phaseNoise
                let noisyMagnitude = amplitude.magnitude * dephasingFactor
                return Complex(
                    noisyMagnitude * cos(noisyPhase),
                    noisyMagnitude * sin(noisyPhase)
                )
            }
        }
    }

    /// Applies amplitude damping (atom loss)
    private func applyAmplitudeDamping(_ amplitudes: [Complex], depth: Int) -> [Complex] {
        let lossProbability = atomLossRate * Double(depth)
        let survivalProbability = max(0, 1.0 - lossProbability)
        let dampingFactor = sqrt(survivalProbability)

        return amplitudes.map { amplitude in
            Complex(amplitude.real * dampingFactor, amplitude.imaginary * dampingFactor)
        }
    }

    /// Applies gate error noise
    private func applyGateErrors(_ amplitudes: [Complex], depth: Int) -> [Complex] {
        let totalErrorRate = singleQubitErrorRate * Double(depth)
        let fidelity = max(0, 1.0 - totalErrorRate)

        return amplitudes.map { amplitude in
            // Add small random perturbation
            let noiseReal = Double.random(in: -0.001...0.001) * sqrt(1 - fidelity)
            let noiseImag = Double.random(in: -0.001...0.001) * sqrt(1 - fidelity)
            return Complex(
                amplitude.real + noiseReal,
                amplitude.imaginary + noiseImag
            )
        }
    }

    /// Applies surface code error correction (simplified simulation)
    private func applyErrorCorrection(_ amplitudes: [Complex], depth: Int) -> [Complex] {
        // Surface code threshold: errors below threshold are corrected
        let threshold = 0.01 * Double(codeDistance)

        // Logical error rate after correction
        let physicalErrorRate = singleQubitErrorRate * Double(depth)
        let logicalErrorRate = pow(physicalErrorRate / threshold, Double(codeDistance))

        // Correction improves fidelity
        let correctionFidelity = 1.0 - logicalErrorRate

        return amplitudes.map { amplitude in
            let scale = sqrt(correctionFidelity)
            return Complex(amplitude.real * scale, amplitude.imaginary * scale)
        }
    }

    // MARK: - Fidelity Calculation

    public func expectedFidelity(depth: Int) -> Double {
        let d = Double(depth)

        // Base fidelity from gate errors
        let gateError = 1.0 - pow(1.0 - singleQubitErrorRate, d)

        // Dephasing contribution
        let dephasingError = 1.0 - exp(-d / t2Dephasing)

        // Atom loss contribution
        let lossError = 1.0 - pow(1.0 - atomLossRate, d)

        // Combined error (assuming independent)
        let totalError = gateError + dephasingError + lossError

        // Apply error correction if enabled
        if errorCorrectionEnabled {
            let threshold = 0.01 * Double(codeDistance)
            let logicalError = pow(totalError / threshold, Double(codeDistance))
            return max(0, 1.0 - logicalError)
        }

        return max(0, 1.0 - totalError)
    }
}

// MARK: - Noise Model Manager

/// Manages and provides access to different noise models
public struct NoiseModelManager: Sendable {

    /// All available noise models
    public static let availableModels: [String: any QuantumNoiseModel] = [
        "ideal": HarvardMITNoiseModel.ideal,
        "harvard2025": HarvardMITNoiseModel.harvard2025,
        "high_fidelity": HarvardMITNoiseModel.highFidelity,
        "nisq_realistic": HarvardMITNoiseModel.nisqRealistic
    ]

    /// Gets a noise model by ID
    public static func model(for id: String) -> (any QuantumNoiseModel)? {
        return availableModels[id]
    }

    /// Default noise model (Harvard-MIT 2025)
    public static var defaultModel: any QuantumNoiseModel {
        return HarvardMITNoiseModel.harvard2025
    }
}

// MARK: - Density Matrix Support

/// Represents a density matrix for mixed state simulation
public struct DensityMatrix: Sendable {
    public let dimension: Int
    public var elements: [Complex]

    public init(dimension: Int) {
        self.dimension = dimension
        self.elements = Array(repeating: Complex.zero, count: dimension * dimension)
    }

    /// Creates density matrix from pure state |ψ⟩⟨ψ|
    public init(pureState: [Complex]) {
        self.dimension = pureState.count
        self.elements = Array(repeating: Complex.zero, count: dimension * dimension)

        for i in 0..<dimension {
            for j in 0..<dimension {
                elements[i * dimension + j] = pureState[i] * pureState[j].conjugate
            }
        }
    }

    /// Access element at (row, col)
    public subscript(row: Int, col: Int) -> Complex {
        get { elements[row * dimension + col] }
        set { elements[row * dimension + col] = newValue }
    }

    /// Trace of the density matrix
    public var trace: Complex {
        var sum = Complex.zero
        for i in 0..<dimension {
            sum = sum + self[i, i]
        }
        return sum
    }

    /// Purity: Tr(ρ²)
    public var purity: Double {
        var sum: Double = 0
        for i in 0..<dimension {
            for j in 0..<dimension {
                sum += (self[i, j] * self[j, i]).real
            }
        }
        return sum
    }

    /// Von Neumann entropy: S = -Tr(ρ log ρ)
    public var entropy: Double {
        // Simplified: use eigenvalue-based calculation
        // For educational purposes, using purity approximation
        let p = purity
        if p > 0.9999 {
            return 0  // Nearly pure state
        }
        // Mixed state entropy estimate
        return -log2(p)
    }
}

// MARK: - Error Correction Codes

/// Surface code error correction simulation
public struct SurfaceCode: Sendable {
    public let distance: Int
    public let physicalQubitsPerLogical: Int

    public init(distance: Int) {
        precondition(distance >= 3 && distance % 2 == 1, "Distance must be odd and >= 3")
        self.distance = distance
        // Surface code uses d² physical qubits per logical qubit
        self.physicalQubitsPerLogical = distance * distance
    }

    /// Calculates logical error rate from physical error rate
    /// Based on threshold theorem: p_L ∝ (p/p_th)^((d+1)/2)
    public func logicalErrorRate(physicalErrorRate: Double, threshold: Double = 0.01) -> Double {
        if physicalErrorRate >= threshold {
            return 1.0  // Above threshold, no improvement
        }

        let ratio = physicalErrorRate / threshold
        let exponent = Double(distance + 1) / 2.0
        return pow(ratio, exponent)
    }

    /// Number of syndrome measurement cycles for fault tolerance
    public var syndromeRounds: Int {
        return distance
    }

    /// Decoding success probability for given physical error rate
    public func decodingSuccessProbability(physicalErrorRate: Double) -> Double {
        let logicalError = logicalErrorRate(physicalErrorRate: physicalErrorRate)
        return 1.0 - logicalError
    }
}

// MARK: - Magic State Distillation

/// Magic state distillation for T-gate implementation
/// Based on Harvard-MIT 2025 neutral atom demonstration
public struct MagicStateDistillation: Sendable {
    public let inputFidelity: Double
    public let distillationLevel: Int

    public init(inputFidelity: Double = 0.99, distillationLevel: Int = 1) {
        self.inputFidelity = inputFidelity
        self.distillationLevel = distillationLevel
    }

    /// Output fidelity after distillation
    /// Uses the 15-to-1 distillation protocol
    public var outputFidelity: Double {
        // 15-to-1 protocol: output error ≈ 35 * input_error³
        let inputError = 1.0 - inputFidelity
        var error = inputError

        for _ in 0..<distillationLevel {
            error = 35 * pow(error, 3)
        }

        return 1.0 - error
    }

    /// Resource overhead (magic states consumed per output)
    public var resourceOverhead: Int {
        return Int(pow(15.0, Double(distillationLevel)))
    }

    /// Whether distillation achieves target fidelity
    public func achievesTarget(targetFidelity: Double) -> Bool {
        return outputFidelity >= targetFidelity
    }
}

// MARK: - Noise Model Extensions for QuantumRegister

extension QuantumRegister {

    /// Applies a noise model to the current state
    /// - Parameters:
    ///   - noiseModel: The noise model to apply
    ///   - gateDepth: Current circuit depth
    public func applyNoiseModel(_ noiseModel: any QuantumNoiseModel, gateDepth: Int) {
        let noisyAmplitudes = noiseModel.applyNoise(to: amplitudes, gateDepth: gateDepth)
        for i in 0..<amplitudes.count {
            amplitudes[i] = noisyAmplitudes[i]
        }
    }

    /// Simulates measurement with noise
    /// - Parameters:
    ///   - noiseModel: The noise model to apply
    ///   - shots: Number of measurement shots
    ///   - gateDepth: Circuit depth at measurement
    /// - Returns: Noisy measurement counts
    public func measureWithNoise(
        noiseModel: any QuantumNoiseModel,
        shots: Int,
        gateDepth: Int
    ) -> [String: Int] {
        // Apply noise before measurement
        let originalAmplitudes = saveState()
        applyNoiseModel(noiseModel, gateDepth: gateDepth)

        // Perform measurements
        let results = measureMultiple(shots: shots)

        // Restore original state
        restoreState(originalAmplitudes)

        return results
    }
}
