//
//  PremiumManager.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/08.
//  Global Premium State Manager for v2.1.1
//

import SwiftUI
import Combine

// MARK: - Admin Credentials (Development/Testing Only)
struct AdminCredentials {
    static let email = "admin@swiftquantum.io"
    static let password = "QuantumAdmin2026!"
    static let username = "SwiftQuantum Admin"
}

/// Global Premium Manager - Singleton for managing premium subscription state
/// Used across all views to unlock premium features when upgrade button is pressed
@MainActor
class PremiumManager: ObservableObject {

    // MARK: - Singleton
    static let shared = PremiumManager()

    // MARK: - Published Properties

    /// Main premium state - when true, all premium features are unlocked
    @Published var isPremium: Bool = false {
        didSet {
            // Save to UserDefaults for persistence
            UserDefaults.standard.set(isPremium, forKey: "SwiftQuantum_isPremium")

            // Log status change
            if isPremium {
                DeveloperModeManager.shared.log(
                    screen: "Premium",
                    element: "Premium Status: ACTIVATED",
                    status: .success
                )
            } else {
                DeveloperModeManager.shared.log(
                    screen: "Premium",
                    element: "Premium Status: DEACTIVATED",
                    status: .success
                )
            }
        }
    }

    /// Subscription tier
    @Published var subscriptionTier: SubscriptionTier = .free

    /// Subscription expiry date (for display purposes)
    @Published var expiryDate: Date? = nil

    /// Admin mode flag - bypasses all subscription checks
    @Published var isAdmin: Bool = false {
        didSet {
            UserDefaults.standard.set(isAdmin, forKey: "SwiftQuantum_isAdmin")
        }
    }

    // MARK: - UserDefaults Keys
    private let isAdminKey = "SwiftQuantum_isAdmin"

    // MARK: - Subscription Tiers

    enum SubscriptionTier: String, CaseIterable {
        case free = "Free"
        case pro = "Pro"
        case premium = "Premium"
        case enterprise = "Enterprise"

        var price: String {
            switch self {
            case .free: return "$0"
            case .pro: return "$4.99/month"
            case .premium: return "$9.99/month"
            case .enterprise: return "Contact Sales"
            }
        }

        var yearlyPrice: String {
            switch self {
            case .free: return "$0"
            case .pro: return "$39.99/year"
            case .premium: return "$79.99/year"
            case .enterprise: return "Contact Sales"
            }
        }

        var productIdMonthly: String {
            switch self {
            case .free: return ""
            case .pro: return "com.swiftquantum.pro.monthly"
            case .premium: return "com.swiftquantum.premium.monthly"
            case .enterprise: return ""
            }
        }

        var productIdYearly: String {
            switch self {
            case .free: return ""
            case .pro: return "com.swiftquantum.pro.yearly"
            case .premium: return "com.swiftquantum.premium.yearly"
            case .enterprise: return ""
            }
        }

        var features: [String] {
            switch self {
            case .free:
                return [
                    "20 Qubit Local Simulation",
                    "All 15+ Quantum Gates",
                    "Basic Examples",
                    "2 Free Academy Courses"
                ]
            case .pro:
                return [
                    "Everything in Free",
                    "40 Qubit Local Simulation",
                    "All 12+ Academy Courses",
                    "Advanced Examples",
                    "Email Support"
                ]
            case .premium:
                return [
                    "Everything in Pro",
                    "QuantumBridge QPU Connection",
                    "Error Correction Simulation",
                    "Industry Solutions Access",
                    "Priority Support"
                ]
            case .enterprise:
                return [
                    "Everything in Premium",
                    "Unlimited Team Members",
                    "Custom QPU Allocation",
                    "Dedicated Support",
                    "SLA Guarantee"
                ]
            }
        }
    }

    // MARK: - Initialization

    private init() {
        // Load saved admin status
        isAdmin = UserDefaults.standard.bool(forKey: isAdminKey)

        // Load saved premium status
        isPremium = UserDefaults.standard.bool(forKey: "SwiftQuantum_isPremium")

        if isAdmin {
            // Admin always has full premium access
            isPremium = true
            subscriptionTier = .enterprise
            expiryDate = Calendar.current.date(byAdding: .year, value: 73, to: Date()) // 2099
        } else if isPremium {
            subscriptionTier = .premium
            // Set expiry to 1 year from now for demo
            expiryDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        }
    }

    // MARK: - Premium Actions

    /// Upgrade to premium - Called when user taps upgrade button
    func upgradeToPremium() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isPremium = true
            subscriptionTier = .premium
            expiryDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        }

        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        DeveloperModeManager.shared.log(
            screen: "Premium",
            element: "Upgrade Button - Premium Activated",
            status: .success
        )
    }

    /// Downgrade to free (for testing/toggle purposes)
    func downgradeToFree() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isPremium = false
            subscriptionTier = .free
            expiryDate = nil
        }

        DeveloperModeManager.shared.log(
            screen: "Premium",
            element: "Downgrade - Free Tier",
            status: .success
        )
    }

    /// Toggle premium status (for dev mode testing)
    func togglePremium() {
        if isPremium {
            downgradeToFree()
        } else {
            upgradeToPremium()
        }
    }

    // MARK: - Admin Login

    /// Validate admin credentials and login
    /// - Parameters:
    ///   - email: Admin email
    ///   - password: Admin password
    /// - Returns: true if login successful
    func loginAsAdmin(email: String, password: String) -> Bool {
        if email == AdminCredentials.email && password == AdminCredentials.password {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                isAdmin = true
                isPremium = true
                subscriptionTier = .enterprise
                expiryDate = Calendar.current.date(byAdding: .year, value: 73, to: Date()) // 2099
            }

            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()

            DeveloperModeManager.shared.log(
                screen: "Premium",
                element: "Admin Login - Full Access Enabled",
                status: .success
            )

            print("✅ Admin login successful - Full premium access enabled")
            return true
        }

        DeveloperModeManager.shared.log(
            screen: "Premium",
            element: "Admin Login Failed - Invalid Credentials",
            status: .failed
        )

        return false
    }

    /// Logout from admin mode
    func logoutAdmin() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isAdmin = false
            isPremium = false
            subscriptionTier = .free
            expiryDate = nil
        }

        UserDefaults.standard.set(false, forKey: isAdminKey)
        UserDefaults.standard.set(false, forKey: "SwiftQuantum_isPremium")

        DeveloperModeManager.shared.log(
            screen: "Premium",
            element: "Admin Logout",
            status: .success
        )

        print("✅ Admin logged out")
    }

    // MARK: - Feature Checks

    /// Check if QuantumBridge is available
    var canUseQuantumBridge: Bool {
        isPremium
    }

    /// Check if Error Correction is available
    var canUseErrorCorrection: Bool {
        isPremium
    }

    /// Check if all Academy courses are unlocked
    var hasFullAcademyAccess: Bool {
        isPremium
    }

    /// Check if Industry solutions are accessible
    var hasIndustryAccess: Bool {
        isPremium
    }

    /// Get number of unlocked Academy levels
    var unlockedAcademyLevels: Int {
        isPremium ? 20 : 8  // Free users get levels 1-8, Premium get all
    }
}

// MARK: - Premium Badge View

struct PremiumBadge: View {
    @ObservedObject var premiumManager = PremiumManager.shared

    var body: some View {
        if premiumManager.isPremium {
            HStack(spacing: 4) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 10))
                Text("PREMIUM")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
            }
            .foregroundColor(.yellow)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
        }
    }
}

// MARK: - Premium Required Overlay

struct PremiumRequiredOverlay: View {
    let featureName: String
    let onUpgrade: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(.yellow)

            Text("Premium Feature")
                .font(.headline)
                .foregroundColor(.white)

            Text(featureName)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)

            Button(action: onUpgrade) {
                HStack {
                    Image(systemName: "crown.fill")
                    Text("Upgrade - $9.99/month")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Upgrade Success View

struct UpgradeSuccessView: View {
    @Binding var isPresented: Bool
    @State private var showCheckmark = false
    @State private var showText = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(showCheckmark ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showCheckmark)

                    Image(systemName: "crown.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.black)
                        .scaleEffect(showCheckmark ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: showCheckmark)
                }

                VStack(spacing: 8) {
                    Text("Welcome to Premium!")
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text("All features are now unlocked")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: showText)

                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "bolt.fill", text: "QuantumBridge QPU Connection")
                    FeatureRow(icon: "checkmark.shield.fill", text: "Error Correction Simulation")
                    FeatureRow(icon: "graduationcap.fill", text: "All Academy Courses")
                    FeatureRow(icon: "building.2.fill", text: "Industry Solutions")
                }
                .opacity(showText ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.6), value: showText)

                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 8)
                .opacity(showText ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.8), value: showText)
            }
            .padding(32)
        }
        .onAppear {
            showCheckmark = true
            showText = true
        }
    }

    struct FeatureRow: View {
        let icon: String
        let text: String

        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.yellow)
                    .frame(width: 24)

                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
}
