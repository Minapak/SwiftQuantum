//
//  AuthModels.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/18.
//  Shared Auth Models - Compatible with QuantumNative
//

import Foundation

// MARK: - Sign Up Request
struct SignUpRequest: Codable {
    let email: String
    let username: String
    let password: String
}

// MARK: - Login Request
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Auth Response
struct AuthResponse: Codable {
    let access_token: String
    let token_type: String?
    let user_id: Int?
    let username: String?
    let email: String?
    let expires_in: Int?

    enum CodingKeys: String, CodingKey {
        case access_token
        case token_type
        case user_id
        case username
        case email
        case expires_in
    }
}

// MARK: - User Response
struct UserResponse: Codable {
    let id: Int
    let email: String
    let username: String
    let subscription_type: String?
    let total_xp: Int?
    let current_level: Int?
    let is_active: Bool?
    let is_premium: Bool?
    let is_admin: Bool?
    let subscription_tier: String?
    let subscription_expires_at: String?

    // Convenience initializer for Admin/Mock users
    init(
        id: Int,
        email: String,
        username: String,
        is_active: Bool = true,
        is_premium: Bool = false,
        is_admin: Bool = false,
        subscription_tier: String? = nil,
        subscription_expires_at: String? = nil
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.subscription_type = subscription_tier
        self.total_xp = 0
        self.current_level = 1
        self.is_active = is_active
        self.is_premium = is_premium
        self.is_admin = is_admin
        self.subscription_tier = subscription_tier
        self.subscription_expires_at = subscription_expires_at
    }
}

// MARK: - Password Reset Request
struct PasswordResetRequest: Codable {
    let email: String
}

// MARK: - Password Reset Response
struct PasswordResetResponse: Codable {
    let message: String
    let success: Bool
}

// MARK: - Error Response
struct ErrorResponse: Codable {
    let detail: String?
    let message: String?
    let success: Bool?
}
