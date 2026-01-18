//
//  AuthService.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/18.
//  Authentication Service - Compatible with QuantumNative & Backend
//

import Foundation
import Combine

// MARK: - Auth Service
@MainActor
class AuthService: ObservableObject {

    // MARK: - Singleton
    static let shared = AuthService()

    // MARK: - Published Properties
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var currentUser: UserResponse?
    @Published var isAdmin = false

    // MARK: - Private Properties
    private let keychainService = KeychainService.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UserDefaults Keys
    private let isAdminKey = "SwiftQuantum_isAdmin"
    private let userEmailKey = "SwiftQuantum_userEmail"
    private let usernameKey = "SwiftQuantum_username"

    // MARK: - Initialization
    private init() {
        isAdmin = UserDefaults.standard.bool(forKey: isAdminKey)
        checkAuthStatus()
    }

    // MARK: - Check Auth Status
    func checkAuthStatus() {
        if let token = keychainService.getToken(), !token.isEmpty {
            Task {
                await APIClient.shared.setAuthToken(token)
            }
            isLoggedIn = true

            // Load user profile
            Task {
                await loadUserProfile()
            }
        } else if isAdmin {
            // Admin mode without backend token
            isLoggedIn = true
            setupAdminUser()
        } else {
            isLoggedIn = false
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, username: String, password: String) async -> Bool {
        guard validateSignUp(email: email, username: username, password: password) else {
            return false
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            let request = SignUpRequest(email: email, username: username, password: password)
            let response: AuthResponse = try await APIClient.shared.post("/api/v1/auth/signup", body: request)

            // Save token
            keychainService.saveToken(response.access_token)
            await APIClient.shared.setAuthToken(response.access_token)

            if let userId = response.user_id {
                keychainService.saveUserId(userId)
            }

            // Save user info
            UserDefaults.standard.set(email, forKey: userEmailKey)
            if let username = response.username {
                UserDefaults.standard.set(username, forKey: usernameKey)
            }

            isLoggedIn = true
            isLoading = false
            successMessage = "Account created successfully!"

            // Load full profile
            await loadUserProfile()

            print("[Auth] Sign up successful: \(email)")
            return true
        } catch let error as APIError {
            isLoading = false
            errorMessage = mapAPIError(error)
            print("[Auth] Sign up error: \(errorMessage ?? "Unknown")")
            return false
        } catch {
            isLoading = false
            errorMessage = "Sign up failed. Please try again."
            print("[Auth] Sign up error: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async -> Bool {
        guard validateLogin(email: email, password: password) else {
            return false
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        // Check for Admin login
        if email == AdminCredentials.email && password == AdminCredentials.password {
            return await loginAsAdmin()
        }

        do {
            let request = LoginRequest(email: email, password: password)
            let response: AuthResponse = try await APIClient.shared.post("/api/v1/auth/login", body: request)

            // Save token
            keychainService.saveToken(response.access_token)
            await APIClient.shared.setAuthToken(response.access_token)

            if let userId = response.user_id {
                keychainService.saveUserId(userId)
            }

            // Save user info
            UserDefaults.standard.set(email, forKey: userEmailKey)
            if let username = response.username {
                UserDefaults.standard.set(username, forKey: usernameKey)
            }

            isLoggedIn = true
            isAdmin = false
            UserDefaults.standard.set(false, forKey: isAdminKey)
            isLoading = false
            successMessage = "Welcome back!"

            // Load full profile and sync subscription
            await loadUserProfile()
            await syncSubscriptionWithBackend()

            print("[Auth] Login successful: \(email)")
            return true
        } catch let error as APIError {
            isLoading = false
            errorMessage = mapAPIError(error)
            print("[Auth] Login error: \(errorMessage ?? "Unknown")")
            return false
        } catch {
            isLoading = false
            errorMessage = "Login failed. Please check your connection."
            print("[Auth] Login error: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Admin Login
    private func loginAsAdmin() async -> Bool {
        // Create mock admin user
        let adminUser = UserResponse(
            id: 999999,
            email: AdminCredentials.email,
            username: "SwiftQuantum Admin",
            is_active: true,
            is_premium: true,
            is_admin: true,
            subscription_tier: "premium",
            subscription_expires_at: "2099-12-31T23:59:59Z"
        )

        currentUser = adminUser
        isLoggedIn = true
        isAdmin = true
        isLoading = false
        UserDefaults.standard.set(true, forKey: isAdminKey)
        successMessage = "Admin mode activated - Full access enabled"

        // Activate premium in PremiumManager
        PremiumManager.shared.isAdmin = true

        print("[Auth] Admin login successful - Full premium access enabled")
        return true
    }

    // MARK: - Logout
    func logout() {
        keychainService.clearAll()
        Task {
            await APIClient.shared.clearAuthToken()
        }

        isLoggedIn = false
        isAdmin = false
        currentUser = nil
        errorMessage = nil
        successMessage = nil

        UserDefaults.standard.set(false, forKey: isAdminKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: usernameKey)

        // Reset premium status
        PremiumManager.shared.logoutAdmin()

        print("[Auth] Logged out")
    }

    // MARK: - Password Reset Request
    func requestPasswordReset(email: String) async -> Bool {
        guard !email.isEmpty, email.contains("@") else {
            errorMessage = "Please enter a valid email address"
            return false
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            let request = PasswordResetRequest(email: email)
            let _: PasswordResetResponse = try await APIClient.shared.post("/api/v1/auth/reset-password-request", body: request)

            isLoading = false
            successMessage = "If an account exists with this email, a password reset link has been sent."

            print("[Auth] Password reset requested for: \(email)")
            return true
        } catch {
            isLoading = false
            // Always show success message for security
            successMessage = "If an account exists with this email, a password reset link has been sent."
            return true
        }
    }

    // MARK: - Load User Profile
    func loadUserProfile() async {
        do {
            let user: UserResponse = try await APIClient.shared.get("/api/v1/users/me")
            currentUser = user

            // Check if user is admin
            if user.is_admin == true {
                isAdmin = true
                UserDefaults.standard.set(true, forKey: isAdminKey)
            }

            print("[Auth] User profile loaded: \(user.username)")
        } catch {
            print("[Auth] Failed to load user profile: \(error.localizedDescription)")
        }
    }

    // MARK: - Sync Subscription with Backend
    private func syncSubscriptionWithBackend() async {
        do {
            let status = try await APIClient.shared.getSubscriptionStatus()

            if status.isActive {
                if status.subscriptionType == "premium" {
                    PremiumManager.shared.subscriptionTier = .premium
                    PremiumManager.shared.isPremium = true
                } else if status.subscriptionType == "pro" {
                    PremiumManager.shared.subscriptionTier = .pro
                    PremiumManager.shared.isPremium = true
                }

                if let expiry = status.expiresAt {
                    PremiumManager.shared.expiryDate = expiry
                }
            }

            print("[Auth] Subscription synced: \(status.subscriptionType)")
        } catch {
            print("[Auth] Failed to sync subscription: \(error.localizedDescription)")
        }
    }

    // MARK: - Setup Admin User
    private func setupAdminUser() {
        currentUser = UserResponse(
            id: 999999,
            email: AdminCredentials.email,
            username: "SwiftQuantum Admin",
            is_active: true,
            is_premium: true,
            is_admin: true,
            subscription_tier: "premium"
        )
        PremiumManager.shared.isAdmin = true
    }

    // MARK: - Validation
    private func validateSignUp(email: String, username: String, password: String) -> Bool {
        errorMessage = nil

        if email.isEmpty {
            errorMessage = "Email is required"
            return false
        }

        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address"
            return false
        }

        if username.isEmpty {
            errorMessage = "Username is required"
            return false
        }

        if username.count < 3 {
            errorMessage = "Username must be at least 3 characters"
            return false
        }

        if password.isEmpty {
            errorMessage = "Password is required"
            return false
        }

        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            return false
        }

        return true
    }

    private func validateLogin(email: String, password: String) -> Bool {
        errorMessage = nil

        if email.isEmpty {
            errorMessage = "Email is required"
            return false
        }

        if !email.contains("@") {
            errorMessage = "Please enter a valid email address"
            return false
        }

        if password.isEmpty {
            errorMessage = "Password is required"
            return false
        }

        return true
    }

    // MARK: - Error Mapping
    private func mapAPIError(_ error: APIError) -> String {
        switch error {
        case .unauthorized:
            return "Invalid email or password"
        case .forbidden:
            return "Access denied. Please contact support."
        case .notFound:
            return "Account not found"
        case .serverError:
            return "Server error. Please try again later."
        case .networkError:
            return "Network error. Please check your connection."
        case .decodingError:
            return "Unexpected response. Please try again."
        default:
            return "Something went wrong. Please try again."
        }
    }

    // MARK: - Helper Properties
    var userEmail: String? {
        return currentUser?.email ?? UserDefaults.standard.string(forKey: userEmailKey)
    }

    var username: String? {
        return currentUser?.username ?? UserDefaults.standard.string(forKey: usernameKey)
    }
}
