//
//  PaywallView.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/13.
//  Premium Subscription Paywall UI - Tab-based comparison view
//

import SwiftUI
import StoreKit

/// Premium subscription paywall view with tab-based plan comparison
struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var premiumManager = PremiumManager.shared
    @ObservedObject private var localization = LocalizationManager.shared

    @State private var selectedTab: Int = 0 // 0: Compare, 1: Pro, 2: Premium
    @State private var selectedPlan: SubscriptionPlan = .premiumYearly
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    enum SubscriptionPlan: String, CaseIterable {
        case proMonthly = "com.swiftquantum.pro.monthly"
        case proYearly = "com.swiftquantum.pro.yearly"
        case premiumMonthly = "com.swiftquantum.premium.monthly"
        case premiumYearly = "com.swiftquantum.premium.yearly"

        var isPro: Bool {
            self == .proMonthly || self == .proYearly
        }

        var isYearly: Bool {
            self == .proYearly || self == .premiumYearly
        }
    }

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Picker
                tabPicker

                // Content
                TabView(selection: $selectedTab) {
                    // Tab 0: Compare All Plans
                    compareAllPlansView
                        .tag(0)

                    // Tab 1: Pro Plans
                    proPlansView
                        .tag(1)

                    // Tab 2: Premium Plans
                    premiumPlansView
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L("subscription.close")) { dismiss() }
                        .foregroundColor(.yellow)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showSuccess) {
            UpgradeSuccessView(isPresented: $showSuccess)
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            tabButton(title: L("subscription.tab.compare"), index: 0)
            tabButton(title: L("subscription.tab.pro"), index: 1)
            tabButton(title: L("subscription.tab.premium"), index: 2)
        }
        .padding(4)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedTab = index
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(selectedTab == index ? .black : .white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    selectedTab == index
                        ? (index == 2 ? Color.yellow : (index == 1 ? Color.blue : Color.white))
                        : Color.clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Compare All Plans View

    private var compareAllPlansView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection

                // Comparison Table
                comparisonTable

                // Plan Selection Cards
                planSelectionCards

                // Purchase Button
                purchaseSection

                // Legal
                legalSection
            }
            .padding()
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.yellow.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)

                Image("QuantumNativeIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text(L("subscription.title"))
                .font(.title2.bold())
                .foregroundColor(.white)

            Text(L("subscription.subtitle"))
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Comparison Table

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            // Header Row
            HStack(spacing: 0) {
                Text(L("subscription.features"))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(L("subscription.free"))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 50)

                Text("Pro")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.blue)
                    .frame(width: 50)

                Text("Premium")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.yellow)
                    .frame(width: 60)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.05))

            // Feature Rows
            comparisonRow(feature: L("subscription.compare.circuits"), free: true, pro: true, premium: true)
            comparisonRow(feature: L("subscription.compare.simulation"), free: true, pro: true, premium: true)
            comparisonRow(feature: L("subscription.compare.academy_basic"), free: true, pro: true, premium: true)
            comparisonRow(feature: L("subscription.compare.academy_full"), free: false, pro: true, premium: true)
            comparisonRow(feature: L("subscription.compare.qpu_access"), free: false, pro: false, premium: true)
            comparisonRow(feature: L("subscription.compare.industry"), free: false, pro: false, premium: true)
            comparisonRow(feature: L("subscription.compare.support"), free: false, pro: true, premium: true)
            comparisonRow(feature: L("subscription.compare.priority"), free: false, pro: false, premium: true)
        }
        .background(Color.white.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func comparisonRow(feature: String, free: Bool, pro: Bool, premium: Bool) -> some View {
        HStack(spacing: 0) {
            Text(feature)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            checkIcon(included: free)
                .frame(width: 50)

            checkIcon(included: pro)
                .frame(width: 50)

            checkIcon(included: premium)
                .frame(width: 60)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private func checkIcon(included: Bool) -> some View {
        Image(systemName: included ? "checkmark.circle.fill" : "minus.circle")
            .font(.system(size: 14))
            .foregroundColor(included ? .green : .white.opacity(0.2))
    }

    // MARK: - Plan Selection Cards

    private var planSelectionCards: some View {
        VStack(spacing: 12) {
            Text(L("subscription.select_plan"))
                .font(.headline)
                .foregroundColor(.white)

            // Pro Plans Row
            HStack(spacing: 10) {
                planCard(
                    plan: .proMonthly,
                    title: L("subscription.pro"),
                    period: L("subscription.monthly"),
                    color: .blue
                )

                planCard(
                    plan: .proYearly,
                    title: L("subscription.pro"),
                    period: L("subscription.yearly"),
                    color: .blue,
                    badge: L("subscription.save_percent")
                )
            }

            // Premium Plans Row
            HStack(spacing: 10) {
                planCard(
                    plan: .premiumMonthly,
                    title: L("subscription.premium"),
                    period: L("subscription.monthly"),
                    color: .yellow
                )

                planCard(
                    plan: .premiumYearly,
                    title: L("subscription.premium"),
                    period: L("subscription.yearly"),
                    color: .yellow,
                    badge: L("subscription.save_percent"),
                    isRecommended: true
                )
            }
        }
    }

    private func planCard(plan: SubscriptionPlan, title: String, period: String, color: Color, badge: String? = nil, isRecommended: Bool = false) -> some View {
        let isSelected = selectedPlan == plan
        let product = premiumManager.products.first { $0.id == plan.rawValue }

        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedPlan = plan
            }
        }) {
            VStack(spacing: 6) {
                if isRecommended {
                    Text(L("subscription.recommended"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                }

                HStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.7))

                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }
                }

                Text(period)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.5))

                if let product = product {
                    Text(product.displayPrice)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isSelected ? color : color.opacity(0.7))
                } else {
                    Text("--")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? color : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Purchase Section

    private var purchaseSection: some View {
        VStack(spacing: 12) {
            let product = premiumManager.products.first { $0.id == selectedPlan.rawValue }
            let color: Color = selectedPlan.isPro ? .blue : .yellow

            Button(action: purchase) {
                HStack(spacing: 8) {
                    if isPurchasing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Image(systemName: selectedPlan.isPro ? "star.fill" : "crown.fill")
                        Text(L("subscription.subscribe"))
                        if let product = product {
                            Text("- \(product.displayPrice)")
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    product != nil
                        ? LinearGradient(colors: selectedPlan.isPro ? [.blue, .cyan] : [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(product == nil || isPurchasing)

            Button(action: restore) {
                Text(L("subscription.restore"))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }

    // MARK: - Pro Plans View

    private var proPlansView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pro Header
                VStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)

                    Text(L("subscription.pro"))
                        .font(.title.bold())
                        .foregroundColor(.white)

                    Text(L("subscription.pro.subtitle"))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                // Pro Features
                proFeatureList

                // Pro Plan Selection
                VStack(spacing: 12) {
                    planDetailCard(plan: .proMonthly, color: .blue)
                    planDetailCard(plan: .proYearly, color: .blue, badge: L("subscription.save_percent"))
                }

                // Purchase Button
                purchaseSectionForTier(isPro: true)

                legalSection
            }
            .padding()
        }
    }

    private var proFeatureList: some View {
        VStack(alignment: .leading, spacing: 12) {
            FeatureRow(icon: "graduationcap.fill", text: L("subscription.pro.feature1"), color: .blue)
            FeatureRow(icon: "cpu", text: L("subscription.pro.feature2"), color: .blue)
            FeatureRow(icon: "book.fill", text: L("subscription.pro.feature3"), color: .blue)
            FeatureRow(icon: "envelope.fill", text: L("subscription.pro.feature4"), color: .blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Premium Plans View

    private var premiumPlansView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Premium Header
                VStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)

                    Text(L("subscription.premium"))
                        .font(.title.bold())
                        .foregroundColor(.white)

                    Text(L("subscription.premium.subtitle"))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                // Premium Features
                premiumFeatureList

                // Premium Plan Selection
                VStack(spacing: 12) {
                    planDetailCard(plan: .premiumMonthly, color: .yellow)
                    planDetailCard(plan: .premiumYearly, color: .yellow, badge: L("subscription.save_percent"), isRecommended: true)
                }

                // Purchase Button
                purchaseSectionForTier(isPro: false)

                legalSection
            }
            .padding()
        }
    }

    private var premiumFeatureList: some View {
        VStack(alignment: .leading, spacing: 12) {
            FeatureRow(icon: "checkmark.circle.fill", text: L("subscription.premium.feature1"), color: .yellow)
            FeatureRow(icon: "network", text: L("subscription.premium.feature2"), color: .yellow)
            FeatureRow(icon: "shield.checkered", text: L("subscription.premium.feature3"), color: .yellow)
            FeatureRow(icon: "building.2.fill", text: L("subscription.premium.feature4"), color: .yellow)
            FeatureRow(icon: "headphones", text: L("subscription.premium.feature5"), color: .yellow)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Plan Detail Card

    private func planDetailCard(plan: SubscriptionPlan, color: Color, badge: String? = nil, isRecommended: Bool = false) -> some View {
        let isSelected = selectedPlan == plan
        let product = premiumManager.products.first { $0.id == plan.rawValue }

        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedPlan = plan
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(plan.isYearly ? L("subscription.yearly") : L("subscription.monthly"))
                            .font(.headline)
                            .foregroundColor(.white)

                        if let badge = badge {
                            Text(badge)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .clipShape(Capsule())
                        }

                        if isRecommended {
                            Text(L("subscription.recommended"))
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(color)
                                .clipShape(Capsule())
                        }
                    }

                    Text(plan.isYearly
                         ? (plan.isPro ? L("subscription.pro.desc_yearly") : L("subscription.premium.desc_yearly"))
                         : (plan.isPro ? L("subscription.pro.desc_monthly") : L("subscription.premium.desc_monthly")))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    if let product = product {
                        Text(product.displayPrice)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(color)
                    }

                    Text(plan.isYearly ? L("subscription.per_year") : L("subscription.per_month"))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? color : .white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? color.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? color : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Purchase Section for Tier

    private func purchaseSectionForTier(isPro: Bool) -> some View {
        VStack(spacing: 12) {
            let filteredPlans = SubscriptionPlan.allCases.filter { $0.isPro == isPro }
            let currentPlan = filteredPlans.contains(selectedPlan) ? selectedPlan : (isPro ? .proYearly : .premiumYearly)
            let product = premiumManager.products.first { $0.id == currentPlan.rawValue }
            let color: Color = isPro ? .blue : .yellow

            Button(action: {
                selectedPlan = currentPlan
                purchase()
            }) {
                HStack(spacing: 8) {
                    if isPurchasing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Image(systemName: isPro ? "star.fill" : "crown.fill")
                        Text(L("subscription.subscribe"))
                        if let product = product {
                            Text("- \(product.displayPrice)")
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(colors: isPro ? [.blue, .cyan] : [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(isPurchasing)

            Button(action: restore) {
                Text(L("subscription.restore"))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }

    // MARK: - Legal Section

    private var legalSection: some View {
        VStack(spacing: 8) {
            Text(L("subscription.legal"))
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Link(L("subscription.terms"), destination: URL(string: "https://swiftquantum.app/terms")!)
                Text("•")
                Link(L("subscription.privacy"), destination: URL(string: "https://swiftquantum.app/privacy")!)
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
    }

    // MARK: - Actions

    private func purchase() {
        guard let product = premiumManager.products.first(where: { $0.id == selectedPlan.rawValue }) else { return }

        isPurchasing = true

        Task {
            let success = await premiumManager.purchase(product)

            await MainActor.run {
                isPurchasing = false

                if success {
                    showSuccess = true
                } else if let error = premiumManager.errorMessage {
                    errorMessage = error
                    showError = true
                }
            }
        }
    }

    private func restore() {
        Task {
            await premiumManager.restorePurchases()

            if premiumManager.isPremium {
                showSuccess = true
            }
        }
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Image(systemName: "checkmark")
                .foregroundStyle(.green)
                .font(.caption)
        }
    }
}

// MARK: - Preview

#Preview {
    PaywallView()
}
