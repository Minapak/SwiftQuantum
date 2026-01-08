//
//  QuantumExecutor.swift
//  SwiftQuantum v2.1.0 - Premium Quantum Hybrid Platform
//
//  Created by Eunmin Park on 2026-01-06.
//  Copyright (c) 2026 iOS Quantum Engineering. All rights reserved.
//
//  QuantumExecutor Protocol - Abstraction layer for local simulator and remote QPU
//  Based on Harvard-MIT 2025 Fault-Tolerant Quantum Computing Research
//
//  References:
//  - Nature (2025.11): "448-qubit fault-tolerant quantum architecture" - Harvard/MIT
//  - Nature (2025.09): "Continuous operation of a coherent 3,000-qubit system"
//  - Nature (2025.07): "Magic state distillation on neutral atom quantum computers"
//

import Foundation

// MARK: - QuantumExecutor Protocol

/// Protocol defining the interface for quantum circuit execution
/// Supports both local simulation and remote QPU (QuantumBridge) execution
///
/// This abstraction enables seamless switching between:
/// - Local Swift simulator for development and testing
/// - Remote IBM Quantum hardware via QuantumBridge API
/// - Future quantum cloud providers
///
/// ## Usage Example
/// ```swift
/// let localExecutor = LocalQuantumExecutor()
/// let bridgeExecutor = QuantumBridgeExecutor(apiKey: "YOUR_KEY")
///
/// // Same interface for both
/// let result = try await executor.execute(circuit: circuit, shots: 1000)
/// ```
public protocol QuantumExecutor: Sendable {

    /// Unique identifier for the executor type
    var executorType: ExecutorType { get }

    /// Human-readable name of the executor
    var name: String { get }

    /// Whether the executor is currently available
    var isAvailable: Bool { get }

    /// Maximum number of qubits supported
    var maxQubits: Int { get }

    /// Executes a quantum circuit and returns measurement results
    /// - Parameters:
    ///   - circuit: The circuit builder containing gates
    ///   - shots: Number of measurement shots
    /// - Returns: Execution result with counts and metadata
    func execute(circuit: BridgeCircuitBuilder, shots: Int) async throws -> ExecutionResult

    /// Submits a job for asynchronous execution
    /// - Parameters:
    ///   - circuit: The circuit builder containing gates
    ///   - shots: Number of measurement shots
    /// - Returns: Job information for tracking
    func submitJob(circuit: BridgeCircuitBuilder, shots: Int) async throws -> QuantumJob

    /// Retrieves the status and result of a submitted job
    /// - Parameter jobId: The job identifier
    /// - Returns: Updated job information
    func getJobStatus(jobId: String) async throws -> QuantumJob

    /// Cancels a pending job
    /// - Parameter jobId: The job identifier
    func cancelJob(jobId: String) async throws

    /// Gets current queue status for the executor
    func getQueueStatus() async throws -> QueueStatus
}

// MARK: - Executor Types

/// Types of quantum executors available
public enum ExecutorType: String, Codable, Sendable {
    case localSimulator = "swift_simulator"
    case ibmBrisbane = "ibm_brisbane"
    case ibmOsaka = "ibm_osaka"
    case ibmKyoto = "ibm_kyoto"
    case ibmSimulator = "ibmq_qasm_simulator"
    case quantumBridgeCloud = "quantum_bridge_cloud"

    /// Whether this executor runs on real quantum hardware
    public var isRealHardware: Bool {
        switch self {
        case .localSimulator, .ibmSimulator:
            return false
        default:
            return true
        }
    }

    /// Typical qubit count for this executor
    public var typicalQubits: Int {
        switch self {
        case .localSimulator:
            return 20
        case .ibmSimulator:
            return 32
        case .ibmBrisbane:
            return 127
        case .ibmOsaka:
            return 127
        case .ibmKyoto:
            return 127
        case .quantumBridgeCloud:
            return 100
        }
    }
}

// MARK: - Execution Result

/// Result of quantum circuit execution
public struct ExecutionResult: Codable, Sendable {
    /// Measurement counts for each outcome
    public let counts: [String: Int]

    /// Total number of shots executed
    public let shots: Int

    /// Executor used for execution
    public let executor: String

    /// Execution time in seconds
    public let executionTime: Double

    /// Fidelity estimate (1.0 for simulator, varies for hardware)
    public let fidelity: Double

    /// Timestamp of execution
    public let timestamp: Date

    /// Additional metadata
    public let metadata: [String: String]

    /// Error correction status (based on Harvard-MIT fault-tolerant research)
    public let errorCorrectionInfo: ErrorCorrectionInfo?

    public init(
        counts: [String: Int],
        shots: Int,
        executor: String,
        executionTime: Double,
        fidelity: Double = 1.0,
        timestamp: Date = Date(),
        metadata: [String: String] = [:],
        errorCorrectionInfo: ErrorCorrectionInfo? = nil
    ) {
        self.counts = counts
        self.shots = shots
        self.executor = executor
        self.executionTime = executionTime
        self.fidelity = fidelity
        self.timestamp = timestamp
        self.metadata = metadata
        self.errorCorrectionInfo = errorCorrectionInfo
    }

    /// Converts counts to probabilities
    public var probabilities: [String: Double] {
        let total = Double(shots)
        return counts.mapValues { Double($0) / total }
    }

    /// Most likely measurement outcome
    public var mostLikelyOutcome: String? {
        counts.max(by: { $0.value < $1.value })?.key
    }
}

// MARK: - Error Correction Info (Harvard-MIT Research Based)

/// Error correction information based on 2025 Harvard-MIT fault-tolerant research
public struct ErrorCorrectionInfo: Codable, Sendable {
    /// Surface code distance used
    public let codeDistance: Int

    /// Number of error correction cycles applied
    public let correctionCycles: Int

    /// Logical error rate per cycle
    public let logicalErrorRate: Double

    /// Physical-to-logical qubit ratio
    public let overheadRatio: Double

    /// Whether magic state distillation was used
    public let magicStateDistillation: Bool

    /// Estimated fidelity after error correction
    public let correctedFidelity: Double

    /// Reference to the research
    public let researchReference: String

    public init(
        codeDistance: Int = 3,
        correctionCycles: Int = 1,
        logicalErrorRate: Double = 0.005,
        overheadRatio: Double = 17.0,
        magicStateDistillation: Bool = false,
        correctedFidelity: Double = 0.995,
        researchReference: String = "Harvard-MIT Nature 2025"
    ) {
        self.codeDistance = codeDistance
        self.correctionCycles = correctionCycles
        self.logicalErrorRate = logicalErrorRate
        self.overheadRatio = overheadRatio
        self.magicStateDistillation = magicStateDistillation
        self.correctedFidelity = correctedFidelity
        self.researchReference = researchReference
    }
}

// MARK: - Quantum Job

/// Represents an asynchronous quantum computing job
public struct QuantumJob: Codable, Sendable {
    /// Unique job identifier
    public let jobId: String

    /// Current job status
    public let status: JobStatus

    /// Executor being used
    public let executor: String

    /// Time job was created
    public let createdAt: Date

    /// Time job started executing
    public let startedAt: Date?

    /// Time job completed
    public let completedAt: Date?

    /// Position in queue (if queued)
    public let queuePosition: Int?

    /// Estimated wait time in seconds
    public let estimatedWaitTime: Double?

    /// Execution result (if completed)
    public let result: ExecutionResult?

    /// Error message (if failed)
    public let errorMessage: String?

    public init(
        jobId: String,
        status: JobStatus,
        executor: String,
        createdAt: Date = Date(),
        startedAt: Date? = nil,
        completedAt: Date? = nil,
        queuePosition: Int? = nil,
        estimatedWaitTime: Double? = nil,
        result: ExecutionResult? = nil,
        errorMessage: String? = nil
    ) {
        self.jobId = jobId
        self.status = status
        self.executor = executor
        self.createdAt = createdAt
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.queuePosition = queuePosition
        self.estimatedWaitTime = estimatedWaitTime
        self.result = result
        self.errorMessage = errorMessage
    }
}

/// Job status enumeration
public enum JobStatus: String, Codable, Sendable {
    case queued = "QUEUED"
    case validating = "VALIDATING"
    case running = "RUNNING"
    case completed = "COMPLETED"
    case failed = "FAILED"
    case cancelled = "CANCELLED"

    /// Whether the job is in a terminal state
    public var isTerminal: Bool {
        switch self {
        case .completed, .failed, .cancelled:
            return true
        default:
            return false
        }
    }
}

// MARK: - Queue Status

/// Status of the execution queue
public struct QueueStatus: Codable, Sendable {
    /// Total jobs in queue
    public let pendingJobs: Int

    /// Currently running jobs
    public let runningJobs: Int

    /// Estimated average wait time in seconds
    public let averageWaitTime: Double

    /// Whether the queue is accepting new jobs
    public let isAcceptingJobs: Bool

    /// Maintenance window information
    public let maintenanceInfo: String?

    public init(
        pendingJobs: Int,
        runningJobs: Int,
        averageWaitTime: Double,
        isAcceptingJobs: Bool = true,
        maintenanceInfo: String? = nil
    ) {
        self.pendingJobs = pendingJobs
        self.runningJobs = runningJobs
        self.averageWaitTime = averageWaitTime
        self.isAcceptingJobs = isAcceptingJobs
        self.maintenanceInfo = maintenanceInfo
    }
}

// MARK: - Executor Errors

/// Errors that can occur during quantum execution
public enum QuantumExecutorError: Error, LocalizedError {
    case notAvailable(executor: String)
    case circuitTooLarge(qubits: Int, maxQubits: Int)
    case invalidApiKey
    case jobNotFound(jobId: String)
    case executionFailed(reason: String)
    case networkError(underlying: Error)
    case queueFull
    case maintenanceMode
    case rateLimited(retryAfter: TimeInterval)
    case invalidCircuit(reason: String)

    public var errorDescription: String? {
        switch self {
        case .notAvailable(let executor):
            return "Executor '\(executor)' is not available"
        case .circuitTooLarge(let qubits, let maxQubits):
            return "Circuit requires \(qubits) qubits but executor only supports \(maxQubits)"
        case .invalidApiKey:
            return "Invalid or missing API key for remote execution"
        case .jobNotFound(let jobId):
            return "Job '\(jobId)' not found"
        case .executionFailed(let reason):
            return "Execution failed: \(reason)"
        case .networkError(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        case .queueFull:
            return "Execution queue is full, please try again later"
        case .maintenanceMode:
            return "Executor is in maintenance mode"
        case .rateLimited(let retryAfter):
            return "Rate limited, retry after \(Int(retryAfter)) seconds"
        case .invalidCircuit(let reason):
            return "Invalid circuit: \(reason)"
        }
    }
}

// MARK: - Local Quantum Executor (Swift Simulator)

/// Local quantum executor using SwiftQuantum's built-in simulator
public final class LocalQuantumExecutor: QuantumExecutor, @unchecked Sendable {

    public let executorType: ExecutorType = .localSimulator
    public let name: String = "SwiftQuantum Local Simulator"
    public let isAvailable: Bool = true
    public let maxQubits: Int = 20

    /// Enable simulated error correction (based on Harvard-MIT research)
    public let simulateErrorCorrection: Bool

    /// Simulated gate error rate
    public let simulatedErrorRate: Double

    public init(simulateErrorCorrection: Bool = false, simulatedErrorRate: Double = 0.001) {
        self.simulateErrorCorrection = simulateErrorCorrection
        self.simulatedErrorRate = simulatedErrorRate
    }

    public func execute(circuit: BridgeCircuitBuilder, shots: Int) async throws -> ExecutionResult {
        let startTime = CFAbsoluteTimeGetCurrent()

        // Execute on local simulator
        let counts = circuit.execute(shots: shots)

        let executionTime = CFAbsoluteTimeGetCurrent() - startTime

        // Calculate fidelity based on simulated errors
        let fidelity = simulateErrorCorrection ?
            calculateCorrectedFidelity(gateCount: circuit.gateCount) :
            1.0 - (Double(circuit.gateCount) * simulatedErrorRate)

        let errorCorrectionInfo: ErrorCorrectionInfo? = simulateErrorCorrection ?
            ErrorCorrectionInfo(
                codeDistance: 3,
                correctionCycles: max(1, circuit.depth / 10),
                logicalErrorRate: 0.005,
                overheadRatio: 17.0,
                magicStateDistillation: circuit.gateCount > 20,
                correctedFidelity: fidelity
            ) : nil

        return ExecutionResult(
            counts: counts,
            shots: shots,
            executor: executorType.rawValue,
            executionTime: executionTime,
            fidelity: fidelity,
            metadata: [
                "simulator_version": "2.1.0",
                "max_qubits": "\(maxQubits)",
                "error_correction": simulateErrorCorrection ? "enabled" : "disabled"
            ],
            errorCorrectionInfo: errorCorrectionInfo
        )
    }

    public func submitJob(circuit: BridgeCircuitBuilder, shots: Int) async throws -> QuantumJob {
        // Local execution is synchronous, so we execute immediately
        let result = try await execute(circuit: circuit, shots: shots)

        return QuantumJob(
            jobId: UUID().uuidString,
            status: .completed,
            executor: executorType.rawValue,
            completedAt: Date(),
            result: result
        )
    }

    public func getJobStatus(jobId: String) async throws -> QuantumJob {
        throw QuantumExecutorError.jobNotFound(jobId: jobId)
    }

    public func cancelJob(jobId: String) async throws {
        // Local jobs complete immediately, nothing to cancel
    }

    public func getQueueStatus() async throws -> QueueStatus {
        return QueueStatus(
            pendingJobs: 0,
            runningJobs: 0,
            averageWaitTime: 0,
            isAcceptingJobs: true
        )
    }

    /// Calculates corrected fidelity using Harvard-MIT error correction model
    private func calculateCorrectedFidelity(gateCount: Int) -> Double {
        // Based on Harvard-MIT 2025 research: sub-0.5% error rate with surface codes
        let baseErrorRate = 0.005
        let correctionFactor = 0.9  // 90% error correction efficiency

        let uncorrectedError = Double(gateCount) * simulatedErrorRate
        let correctedError = uncorrectedError * (1 - correctionFactor)

        return max(0.0, 1.0 - correctedError)
    }
}

// MARK: - QuantumBridge Remote Executor

/// Remote quantum executor using QuantumBridge API for IBM Quantum
public final class QuantumBridgeExecutor: QuantumExecutor, @unchecked Sendable {

    public let executorType: ExecutorType
    public let name: String
    public var isAvailable: Bool { apiKey != nil }
    public let maxQubits: Int

    /// API key for authentication
    private let apiKey: String?

    /// Base URL for QuantumBridge API
    private let baseURL: String

    /// Error mitigation configuration
    public var errorMitigation: QuantumBridge.ErrorMitigationConfig

    /// Active jobs cache
    private var activeJobs: [String: QuantumJob] = [:]

    public init(
        executorType: ExecutorType = .ibmBrisbane,
        apiKey: String? = nil,
        baseURL: String = "https://api.quantum-bridge.io",
        errorMitigation: QuantumBridge.ErrorMitigationConfig = .standard
    ) {
        self.executorType = executorType
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.errorMitigation = errorMitigation
        self.maxQubits = executorType.typicalQubits

        self.name = "QuantumBridge - \(executorType.rawValue)"
    }

    /// Note: API key is set at initialization

    public func execute(circuit: BridgeCircuitBuilder, shots: Int) async throws -> ExecutionResult {
        guard isAvailable else {
            throw QuantumExecutorError.invalidApiKey
        }

        // Submit job and wait for completion
        var job = try await submitJob(circuit: circuit, shots: shots)

        // Poll for completion
        while !job.status.isTerminal {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            job = try await getJobStatus(jobId: job.jobId)
        }

        guard job.status == .completed, let result = job.result else {
            throw QuantumExecutorError.executionFailed(reason: job.errorMessage ?? "Unknown error")
        }

        return result
    }

    public func submitJob(circuit: BridgeCircuitBuilder, shots: Int) async throws -> QuantumJob {
        guard isAvailable else {
            throw QuantumExecutorError.invalidApiKey
        }

        // In a real implementation, this would make an HTTP request to QuantumBridge
        // For now, we simulate the job submission

        let jobId = "qb-\(UUID().uuidString.prefix(8))"

        let job = QuantumJob(
            jobId: jobId,
            status: .queued,
            executor: executorType.rawValue,
            queuePosition: Int.random(in: 1...50),
            estimatedWaitTime: Double.random(in: 60...3600)
        )

        activeJobs[jobId] = job

        return job
    }

    public func getJobStatus(jobId: String) async throws -> QuantumJob {
        guard let job = activeJobs[jobId] else {
            throw QuantumExecutorError.jobNotFound(jobId: jobId)
        }

        // Simulate job progression
        let updatedJob: QuantumJob

        switch job.status {
        case .queued:
            updatedJob = QuantumJob(
                jobId: jobId,
                status: .running,
                executor: job.executor,
                createdAt: job.createdAt,
                startedAt: Date()
            )
        case .running:
            // Simulate completion with mock results
            let mockCounts: [String: Int] = ["00": 480, "11": 520]
            let result = ExecutionResult(
                counts: mockCounts,
                shots: 1000,
                executor: executorType.rawValue,
                executionTime: 2.5,
                fidelity: 0.985,
                metadata: [
                    "backend": executorType.rawValue,
                    "error_mitigation": "enabled"
                ],
                errorCorrectionInfo: ErrorCorrectionInfo()
            )

            updatedJob = QuantumJob(
                jobId: jobId,
                status: .completed,
                executor: job.executor,
                createdAt: job.createdAt,
                startedAt: job.startedAt,
                completedAt: Date(),
                result: result
            )
        default:
            updatedJob = job
        }

        activeJobs[jobId] = updatedJob
        return updatedJob
    }

    public func cancelJob(jobId: String) async throws {
        guard activeJobs[jobId] != nil else {
            throw QuantumExecutorError.jobNotFound(jobId: jobId)
        }

        activeJobs[jobId] = QuantumJob(
            jobId: jobId,
            status: .cancelled,
            executor: executorType.rawValue
        )
    }

    public func getQueueStatus() async throws -> QueueStatus {
        // Simulated queue status
        return QueueStatus(
            pendingJobs: Int.random(in: 10...100),
            runningJobs: Int.random(in: 1...5),
            averageWaitTime: Double.random(in: 300...1800),
            isAcceptingJobs: true
        )
    }
}

// MARK: - Executor Factory

/// Factory for creating quantum executors
public struct QuantumExecutorFactory {

    /// Creates a local simulator executor
    public static func createLocalExecutor(
        simulateErrorCorrection: Bool = false
    ) -> LocalQuantumExecutor {
        return LocalQuantumExecutor(simulateErrorCorrection: simulateErrorCorrection)
    }

    /// Creates a QuantumBridge executor for IBM Quantum
    public static func createBridgeExecutor(
        backend: ExecutorType = .ibmBrisbane,
        apiKey: String? = nil
    ) -> QuantumBridgeExecutor {
        return QuantumBridgeExecutor(executorType: backend, apiKey: apiKey)
    }

    /// Creates an executor based on configuration
    public static func create(
        type: ExecutorType,
        apiKey: String? = nil
    ) -> any QuantumExecutor {
        switch type {
        case .localSimulator:
            return createLocalExecutor()
        default:
            return createBridgeExecutor(backend: type, apiKey: apiKey)
        }
    }
}

// MARK: - Executor Manager

/// Manages multiple quantum executors and routes jobs
@MainActor
public final class QuantumExecutorManager: ObservableObject {

    /// Currently selected executor type
    @Published public var selectedExecutor: ExecutorType = .localSimulator

    /// Available executors
    @Published public private(set) var availableExecutors: [ExecutorType] = []

    /// Active jobs across all executors
    @Published public private(set) var activeJobs: [QuantumJob] = []

    /// Executor instances
    private var executors: [ExecutorType: any QuantumExecutor] = [:]

    /// API key for remote executors
    private var apiKey: String?

    public init() {
        // Local simulator is always available
        executors[.localSimulator] = LocalQuantumExecutor()
        availableExecutors = [.localSimulator]
    }

    /// Configures remote execution with API key
    public func configureRemote(apiKey: String) {
        self.apiKey = apiKey

        // Add remote executors
        let remoteTypes: [ExecutorType] = [.ibmBrisbane, .ibmOsaka, .ibmKyoto, .ibmSimulator]

        for type in remoteTypes {
            executors[type] = QuantumBridgeExecutor(executorType: type, apiKey: apiKey)
            if !availableExecutors.contains(type) {
                availableExecutors.append(type)
            }
        }
    }

    /// Gets the current executor
    public var currentExecutor: any QuantumExecutor {
        executors[selectedExecutor] ?? LocalQuantumExecutor()
    }

    /// Executes a circuit on the selected executor
    public nonisolated func execute(circuit: BridgeCircuitBuilder, shots: Int = 1000) async throws -> ExecutionResult {
        let executor = await MainActor.run { currentExecutor }
        return try await executor.execute(circuit: circuit, shots: shots)
    }

    /// Submits a job to the selected executor
    public nonisolated func submitJob(circuit: BridgeCircuitBuilder, shots: Int = 1000) async throws -> QuantumJob {
        let executor = await MainActor.run { currentExecutor }
        let job = try await executor.submitJob(circuit: circuit, shots: shots)
        await MainActor.run { activeJobs.append(job) }
        return job
    }

    /// Refreshes all active job statuses
    public func refreshJobStatuses() async {
        var updatedJobs: [QuantumJob] = []

        for job in activeJobs {
            if !job.status.isTerminal {
                if let executor = executors.values.first(where: { $0.executorType.rawValue == job.executor }) {
                    if let updated = try? await executor.getJobStatus(jobId: job.jobId) {
                        updatedJobs.append(updated)
                    } else {
                        updatedJobs.append(job)
                    }
                } else {
                    updatedJobs.append(job)
                }
            } else {
                updatedJobs.append(job)
            }
        }

        activeJobs = updatedJobs
    }
}
