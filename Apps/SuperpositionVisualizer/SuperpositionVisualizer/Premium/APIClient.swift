//
//  APIClient.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/13.
//  Backend API Client for StoreKit 2 Integration
//

import Foundation

/// API Client for communicating with SwiftQuantum Backend
actor APIClient {
    static let shared = APIClient()

    // MARK: - Configuration

    #if DEBUG
    private let baseURL = "http://localhost:8000"  // Local development
    private let bridgeURL = "http://localhost:8001"  // Local QuantumBridge
    #else
    private let baseURL = "https://api.swiftquantum.tech"  // Production (HTTPS)
    private let bridgeURL = "https://bridge.swiftquantum.tech"  // Production QuantumBridge
    #endif

    private var authToken: String? {
        get { UserDefaults.standard.string(forKey: "SwiftQuantum_AuthToken") }
        set { UserDefaults.standard.set(newValue, forKey: "SwiftQuantum_AuthToken") }
    }

    // MARK: - Token Management

    func setAuthToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: "SwiftQuantum_AuthToken")
    }

    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "SwiftQuantum_AuthToken")
    }

    func clearAuthToken() {
        UserDefaults.standard.removeObject(forKey: "SwiftQuantum_AuthToken")
    }

    // MARK: - Generic Request

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        // Add auth token if available
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Encode body if provided
        if let body = body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Handle HTTP errors
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }

    // MARK: - Convenience Methods

    func get<T: Decodable>(_ endpoint: String) async throws -> T {
        try await request(endpoint, method: "GET")
    }

    func post<T: Decodable>(_ endpoint: String, body: Encodable? = nil) async throws -> T {
        try await request(endpoint, method: "POST", body: body)
    }

    func put<T: Decodable>(_ endpoint: String, body: Encodable? = nil) async throws -> T {
        try await request(endpoint, method: "PUT", body: body)
    }

    func delete<T: Decodable>(_ endpoint: String) async throws -> T {
        try await request(endpoint, method: "DELETE")
    }
}

// MARK: - API Errors

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case httpError(statusCode: Int)
    case serverError(statusCode: Int)
    case decodingError
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .unauthorized:
            return "Authentication required"
        case .forbidden:
            return "Access denied"
        case .notFound:
            return "Resource not found"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .decodingError:
            return "Failed to parse response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - API Request/Response Models

// Transaction verification request
struct VerifyTransactionRequest: Encodable {
    let transactionId: String
}

// Payment verification response
struct PaymentResponse: Decodable {
    let success: Bool
    let message: String?
    let error: String?
    let subscriptionType: String?
    let expiresAt: Date?
    let transactionId: String?
}

// Subscription status response
struct SubscriptionStatusResponse: Decodable {
    let subscriptionType: String
    let isActive: Bool
    let expiresAt: Date?
    let features: [String]?
    let daysRemaining: Int?
}

// Sync status response
struct SyncStatusResponse: Decodable {
    let success: Bool
    let subscriptionType: String?
    let isActive: Bool
    let expiresAt: Date?
    let message: String?
}

// iOS purchase result
struct iOSPurchaseResult: Decodable {
    let success: Bool
    let subscriptionType: String?
    let expiresAt: Date?
    let errorCode: String?
    let errorMessage: String?
}

// iOS restore result
struct iOSRestoreResult: Decodable {
    let success: Bool
    let restoredCount: Int
    let subscriptionType: String?
    let expiresAt: Date?
    let message: String?
}

// MARK: - Payment API Extension

extension APIClient {

    /// Verify transaction with backend after StoreKit purchase
    func verifyTransaction(transactionId: String) async throws -> PaymentResponse {
        let request = VerifyTransactionRequest(transactionId: transactionId)
        return try await post("/api/v1/payment/verify/transaction", body: request)
    }

    /// Get current subscription status
    func getSubscriptionStatus() async throws -> SubscriptionStatusResponse {
        return try await get("/api/v1/payment/subscription/status")
    }

    /// Sync subscription status with Apple
    func syncSubscriptionStatus() async throws -> SyncStatusResponse {
        return try await post("/api/v1/payment/subscription/sync")
    }

    /// iOS purchase complete
    func iOSPurchaseComplete(transactionId: String) async throws -> iOSPurchaseResult {
        let request = VerifyTransactionRequest(transactionId: transactionId)
        return try await post("/api/v1/payment/ios/purchase", body: request)
    }

    /// iOS restore purchases
    func iOSRestorePurchases() async throws -> iOSRestoreResult {
        return try await post("/api/v1/payment/ios/restore")
    }
}

// MARK: - QuantumBridge API Extension

extension APIClient {

    /// Generic request to QuantumBridge
    func bridgeRequest<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: bridgeURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60  // Longer timeout for quantum computations

        if let body = body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }

    /// Check QuantumBridge health
    func bridgeHealthCheck() async throws -> BridgeHealthResponse {
        return try await bridgeRequest("/health")
    }

    /// Run Bell State on QuantumBridge
    func runBellState(stateType: String = "phi_plus", shots: Int = 1024) async throws -> BellStateResponse {
        let request = BellStateRequest(stateType: stateType, shots: shots)
        return try await bridgeRequest("/bell-state", method: "POST", body: request)
    }

    /// Run custom quantum circuit
    func runQuantumCircuit(qasm: String, shots: Int = 1024) async throws -> CircuitResponse {
        let request = CircuitRequest(qasm: qasm, shots: shots)
        return try await bridgeRequest("/run-circuit", method: "POST", body: request)
    }

    /// Run Grover's algorithm
    func runGrover(numQubits: Int, markedStates: [Int], shots: Int = 1024) async throws -> GroverResponse {
        let request = GroverRequest(numQubits: numQubits, markedStates: markedStates, shots: shots)
        return try await bridgeRequest("/grover", method: "POST", body: request)
    }

    /// Run Deutsch-Jozsa algorithm
    func runDeutschJozsa(numQubits: Int, oracleType: String, shots: Int = 1024) async throws -> DeutschJozsaResponse {
        let request = DeutschJozsaRequest(numQubits: numQubits, oracleType: oracleType, shots: shots)
        return try await bridgeRequest("/deutsch-jozsa", method: "POST", body: request)
    }
}

// MARK: - QuantumBridge Request/Response Models

struct BridgeHealthResponse: Decodable {
    let status: String
    let service: String
    let version: String
    let qiskitAvailable: Bool
    let algorithmsAvailable: Bool
}

struct BellStateRequest: Encodable {
    let stateType: String
    let shots: Int
}

struct BellStateResponse: Decodable {
    let status: String
    let jobId: String
    let result: BellStateResult
    let evidenceHash: String
    let executionTime: Double
}

struct BellStateResult: Decodable {
    let counts: [String: Int]
    let stateType: String
}

struct CircuitRequest: Encodable {
    let qasm: String
    let shots: Int
}

struct CircuitResponse: Decodable {
    let status: String
    let jobId: String
    let counts: [String: Int]
    let executionTime: Double
}

struct GroverRequest: Encodable {
    let numQubits: Int
    let markedStates: [Int]
    let shots: Int
}

struct GroverResponse: Decodable {
    let status: String
    let jobId: String
    let result: GroverResult
    let executionTime: Double
}

struct GroverResult: Decodable {
    let counts: [String: Int]
    let markedStates: [Int]
    let iterations: Int
}

struct DeutschJozsaRequest: Encodable {
    let numQubits: Int
    let oracleType: String
    let shots: Int
}

struct DeutschJozsaResponse: Decodable {
    let status: String
    let jobId: String
    let result: DeutschJozsaResult
    let executionTime: Double
}

struct DeutschJozsaResult: Decodable {
    let counts: [String: Int]
    let oracleType: String
    let isConstant: Bool
}
