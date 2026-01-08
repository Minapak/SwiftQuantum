//
//  PremiumManager.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/08.
//  Global Premium State Manager for v2.1.1
//  StoreKit 2 Integration for Production
//

import SwiftUI
import Combine
import StoreKit

/// Global Premium Manager - Singleton for managing premium subscription state
/// Integrates with StoreKit 2 for App Store subscriptions
@MainActor
class PremiumManager: ObservableObject {

    // MARK: - Singleton
    static let shared = PremiumManager()

    // MARK: - Published Properties

    /// Main premium state - when true, all premium features are unlocked
    @Published var isPremium: Bool = false {
        didSet {
            UserDefaults.standard.set(isPremium, forKey: "SwiftQuantum_isPremium")

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

    /// Subscription expiry date
    @Published var expiryDate: Date? = nil

    /// Available products from App Store
    @Published var products: [Product] = []

    /// Loading state
    @Published var isLoading: Bool = false

    /// Error message
    @Published var errorMessage: String? = nil

    // MARK: - Private Properties
    private var updateListenerTask: Task<Void, Error>? = nil

    // MARK: - Subscription Tiers

    enum SubscriptionTier: String, CaseIterable {
        case free = "Free"
        case pro = "Pro"
        case premium = "Premium"

        var price: String {
            switch self {
            case .free: return "$0"
            case .pro: return "$4.99/month"
            case .premium: return "$9.99/month"
            }
        }

        var yearlyPrice: String {
            switch self {
            case .free: return "$0"
            case .pro: return "$39.99/year"
            case .premium: return "$79.99/year"
            }
        }

        var productIdMonthly: String {
            switch self {
            case .free: return ""
            case .pro: return "com.swiftquantum.pro.monthly"
            case .premium: return "com.swiftquantum.premium.monthly"
            }
        }

        var productIdYearly: String {
            switch self {
            case .free: return ""
            case .pro: return "com.swiftquantum.pro.yearly"
            case .premium: return "com.swiftquantum.premium.yearly"
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
            }
        }
    }

    // MARK: - Product IDs
    static let productIDs: Set<String> = [
        "com.swiftquantum.pro.monthly",
        "com.swiftquantum.pro.yearly",
        "com.swiftquantum.premium.monthly",
        "com.swiftquantum.premium.yearly"
    ]

    // MARK: - Initialization

    private init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        // Check current subscription status
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - StoreKit 2 Methods

    /// Load products from App Store
    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let storeProducts = try await Product.products(for: Self.productIDs)
            products = storeProducts.sorted { $0.price < $1.price }
            isLoading = false

            DeveloperModeManager.shared.log(
                screen: "Premium",
                element: "Products loaded: \(products.count)",
                status: .success
            )
        } catch {
            isLoading = false
            errorMessage = "Failed to load products: \(error.localizedDescription)"

            DeveloperModeManager.shared.log(
                screen: "Premium",
                element: "Product load failed: \(error.localizedDescription)",
                status: .failed
            )
        }
    }

    /// Purchase a subscription product
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionStatus()
                await transaction.finish()

                isLoading = false

                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()

                DeveloperModeManager.shared.log(
                    screen: "Premium",
                    element: "Purchase successful: \(product.id)",
                    status: .success
                )

                return true

            case .userCancelled:
                isLoading = false
                DeveloperModeManager.shared.log(
                    screen: "Premium",
                    element: "Purchase cancelled by user",
                    status: .noAction
                )
                return false

            case .pending:
                isLoading = false
                errorMessage = "Purchase is pending approval"
                DeveloperModeManager.shared.log(
                    screen: "Premium",
                    element: "Purchase pending",
                    status: .comingSoon
                )
                return false

            @unknown default:
                isLoading = false
                return false
            }
        } catch {
            isLoading = false
            errorMessage = "Purchase failed: \(error.localizedDescription)"

            DeveloperModeManager.shared.log(
                screen: "Premium",
                element: "Purchase failed: \(error.localizedDescription)",
                status: .failed
            )

            return false
        }
    }

    /// Restore purchases
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil

        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
            isLoading = false

            DeveloperModeManager.shared.log(
                screen: "Premium",
                element: "Purchases restored",
                status: .success
            )
        } catch {
            isLoading = false
            errorMessage = "Restore failed: \(error.localizedDescription)"

            DeveloperModeManager.shared.log(
                screen: "Premium",
                element: "Restore failed: \(error.localizedDescription)",
                status: .failed
            )
        }
    }

    /// Update subscription status based on current entitlements
    func updateSubscriptionStatus() async {
        var hasActiveSubscription = false
        var currentTier: SubscriptionTier = .free
        var expiry: Date? = nil

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if Self.productIDs.contains(transaction.productID) {
                    hasActiveSubscription = true

                    // Determine tier from product ID
                    if transaction.productID.contains("premium") {
                        currentTier = .premium
                    } else if transaction.productID.contains("pro") {
                        if currentTier != .premium {
                            currentTier = .pro
                        }
                    }

                    // Get expiry date
                    if let expirationDate = transaction.expirationDate {
                        if expiry == nil || expirationDate > expiry! {
                            expiry = expirationDate
                        }
                    }
                }
            } catch {
                // Verification failed, skip this transaction
                continue
            }
        }

        // Update published properties
        isPremium = hasActiveSubscription && (currentTier == .pro || currentTier == .premium)
        subscriptionTier = currentTier
        expiryDate = expiry
    }

    /// Listen for transaction updates
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    // Handle verification failure
                }
            }
        }
    }

    /// Verify transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Feature Checks

    /// Check if QuantumBridge is available (Premium only)
    var canUseQuantumBridge: Bool {
        subscriptionTier == .premium
    }

    /// Check if Error Correction is available (Premium only)
    var canUseErrorCorrection: Bool {
        subscriptionTier == .premium
    }

    /// Check if all Academy courses are unlocked (Pro or Premium)
    var hasFullAcademyAccess: Bool {
        isPremium
    }

    /// Check if Industry solutions are accessible (Premium only)
    var hasIndustryAccess: Bool {
        subscriptionTier == .premium
    }

    /// Get number of unlocked Academy levels
    var unlockedAcademyLevels: Int {
        switch subscriptionTier {
        case .free: return 2
        case .pro: return 12
        case .premium: return 20
        }
    }

    // MARK: - Store Error
    enum StoreError: Error {
        case failedVerification
    }

    // MARK: - Legacy Compatibility Methods (for existing UI)

    /// Show subscription view - called when user taps upgrade button
    @Published var showSubscriptionView: Bool = false

    /// Upgrade to premium - opens subscription view
    func upgradeToPremium() {
        showSubscriptionView = true

        DeveloperModeManager.shared.log(
            screen: "Premium",
            element: "Upgrade Button - Opening Subscription View",
            status: .success
        )
    }

    /// Toggle premium status (for dev mode testing only)
    func togglePremium() {
        showSubscriptionView = true
    }

    /// Downgrade to free (manual reset for testing)
    func downgradeToFree() {
        isPremium = false
        subscriptionTier = .free
        expiryDate = nil

        DeveloperModeManager.shared.log(
            screen: "Premium",
            element: "Manual Downgrade - Free Tier",
            status: .success
        )
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
                Text(premiumManager.subscriptionTier.rawValue.uppercased())
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
                    Text("Upgrade to Premium")
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

// MARK: - Subscription View

struct SubscriptionView: View {
    @ObservedObject var premiumManager = PremiumManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)

                        Text("Unlock SwiftQuantum")
                            .font(.title.bold())
                            .foregroundColor(.white)

                        Text("Choose the plan that's right for you")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 20)

                    // Products
                    if premiumManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                            .padding()
                    } else if let error = premiumManager.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ForEach(premiumManager.products, id: \.id) { product in
                            ProductCard(product: product)
                        }
                    }

                    // Restore Purchases
                    Button(action: {
                        Task {
                            await premiumManager.restorePurchases()
                        }
                    }) {
                        Text("Restore Purchases")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 8)

                    // Terms
                    Text("Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                }
            }
        }
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let product: Product
    @ObservedObject var premiumManager = PremiumManager.shared

    var isPro: Bool {
        product.id.contains("pro")
    }

    var isYearly: Bool {
        product.id.contains("yearly")
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(isPro ? "Pro" : "Premium")
                            .font(.headline)
                            .foregroundColor(.white)

                        if isYearly {
                            Text("SAVE 33%")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .clipShape(Capsule())
                        }
                    }

                    Text(isYearly ? "Yearly" : "Monthly")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(product.displayPrice)
                        .font(.title2.bold())
                        .foregroundColor(.yellow)

                    Text(isYearly ? "/year" : "/month")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Button(action: {
                Task {
                    await premiumManager.purchase(product)
                }
            }) {
                Text("Subscribe")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isPro ? Color.blue.opacity(0.5) : Color.yellow.opacity(0.5), lineWidth: 1)
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
