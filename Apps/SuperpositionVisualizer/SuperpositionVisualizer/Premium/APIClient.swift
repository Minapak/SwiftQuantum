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
    #else
    private let baseURL = "https://api.swiftquantum.app"  // Production
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
