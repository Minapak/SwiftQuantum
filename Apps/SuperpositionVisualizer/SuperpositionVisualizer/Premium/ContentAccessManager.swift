//
//  ContentAccessManager.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/13.
//  Content Access Control for Premium Features
//

import SwiftUI
import Combine

/// Manages access to premium content based on subscription tier
@MainActor
class ContentAccessManager: ObservableObject {
    static let shared = ContentAccessManager()

    // MARK: - Published Properties

    @Published var currentTier: PremiumManager.SubscriptionTier = .free

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let premiumManager = PremiumManager.shared

    // MARK: - Initialization

    private init() {
        // Observe premium manager changes
        premiumManager.$subscriptionTier
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tier in
                self?.currentTier = tier
            }
            .store(in: &cancellables)

        // Initialize with current tier
        currentTier = premiumManager.subscriptionTier
    }

    // MARK: - Level Access

    /// Check if user can access a specific academy level
    func canAccessLevel(_ level: Int) -> Bool {
        switch currentTier {
        case .free:
            return level <= 2  // Levels 1-2 only
        case .pro:
            return level <= 12  // Levels 1-12
        case .premium:
            return true  // All levels
        }
    }

    /// Get the number of unlocked levels
    var unlockedLevelCount: Int {
        switch currentTier {
        case .free: return 2
        case .pro: return 12
        case .premium: return 20
        }
    }

    // MARK: - Feature Access

    /// Check if QuantumBridge is accessible
    var canAccessQuantumBridge: Bool {
        currentTier == .premium
    }

    /// Check if Error Correction simulation is accessible
    var canAccessErrorCorrection: Bool {
        currentTier == .premium
    }

    /// Check if Industry Solutions are accessible
    var canAccessIndustrySolutions: Bool {
        currentTier == .premium
    }

    /// Check if Advanced Examples are accessible
    var canAccessAdvancedExamples: Bool {
        currentTier == .pro || currentTier == .premium
    }

    /// Check if all Academy courses are accessible
    var hasFullAcademyAccess: Bool {
        currentTier == .pro || currentTier == .premium
    }

    // MARK: - Qubit Limits

    /// Maximum number of qubits for simulation
    var maxQubits: Int {
        switch currentTier {
        case .free: return 20
        case .pro: return 40
        case .premium: return 100
        }
    }

    // MARK: - Monthly Credits (for cloud execution)

    var monthlyCredits: Int {
        switch currentTier {
        case .free: return 0
        case .pro: return 100
        case .premium: return 1000
        }
    }

    // MARK: - Feature Check by Name

    /// Check access for a named feature
    func canAccess(feature: String) -> Bool {
        switch feature.lowercased() {
        // Free features
        case "basic_simulation", "basic_gates", "academy_intro":
            return true

        // Pro features
        case "advanced_examples", "academy_intermediate", "pro_gates":
            return currentTier == .pro || currentTier == .premium

        // Premium features
        case "quantum_bridge", "error_correction", "industry_solutions",
             "academy_advanced", "cloud_execution":
            return currentTier == .premium

        default:
            return false
        }
    }

    /// Get required tier for a feature
    func requiredTier(for feature: String) -> PremiumManager.SubscriptionTier {
        switch feature.lowercased() {
        case "basic_simulation", "basic_gates", "academy_intro":
            return .free
        case "advanced_examples", "academy_intermediate", "pro_gates":
            return .pro
        case "quantum_bridge", "error_correction", "industry_solutions",
             "academy_advanced", "cloud_execution":
            return .premium
        default:
            return .free
        }
    }
}

// MARK: - Lock Overlay View

struct LockedFeatureOverlay: View {
    let featureName: String
    let requiredTier: String
    let onUpgrade: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Lock icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 100, height: 100)

                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.orange)
            }

            // Title
            Text("\(featureName)")
                .font(.title2.bold())
                .foregroundColor(.white)

            // Description
            Text("\(requiredTier) subscription required")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))

            // Upgrade button
            Button(action: onUpgrade) {
                HStack {
                    Image(systemName: "crown.fill")
                    Text("Upgrade to \(requiredTier)")
                }
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
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
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.85))
    }
}

// MARK: - Locked Level Card

struct LockedLevelCard: View {
    let levelNumber: Int
    let levelName: String
    let xpReward: Int
    @State private var showPaywall = false

    @ObservedObject private var accessManager = ContentAccessManager.shared

    private var isLocked: Bool {
        !accessManager.canAccessLevel(levelNumber)
    }

    var body: some View {
        Button(action: {
            if isLocked {
                showPaywall = true
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    // Level icon
                    Image(systemName: "atom")
                        .font(.system(size: 32))
                        .foregroundStyle(isLocked ? .gray : .cyan)

                    // Lock badge
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.orange)
                            .offset(x: 16, y: 16)
                    }
                }

                Text(levelName)
                    .font(.headline)
                    .foregroundStyle(isLocked ? .secondary : .primary)

                Text("\(xpReward) XP")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if isLocked {
                    Text("Pro Required")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isLocked ? Color.gray.opacity(0.1) : Color.cyan.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isLocked ? Color.gray.opacity(0.3) : Color.cyan.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .opacity(isLocked ? 0.7 : 1.0)
        .sheet(isPresented: $showPaywall) {
            SubscriptionView()
        }
    }
}

// MARK: - View Modifier for Premium Content

struct PremiumContentModifier: ViewModifier {
    let feature: String
    @ObservedObject private var accessManager = ContentAccessManager.shared
    @State private var showPaywall = false

    private var hasAccess: Bool {
        accessManager.canAccess(feature: feature)
    }

    private var requiredTier: String {
        accessManager.requiredTier(for: feature).rawValue
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(!hasAccess)
                .blur(radius: hasAccess ? 0 : 3)

            if !hasAccess {
                LockedFeatureOverlay(
                    featureName: feature.replacingOccurrences(of: "_", with: " ").capitalized,
                    requiredTier: requiredTier,
                    onUpgrade: { showPaywall = true }
                )
            }
        }
        .sheet(isPresented: $showPaywall) {
            SubscriptionView()
        }
    }
}

extension View {
    /// Apply premium content lock based on feature name
    func premiumContent(feature: String) -> some View {
        modifier(PremiumContentModifier(feature: feature))
    }
}
