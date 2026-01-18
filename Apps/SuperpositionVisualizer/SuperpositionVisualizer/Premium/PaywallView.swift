//
//  PaywallView.swift
//  SuperpositionVisualizer
//
//  Created by SwiftQuantum on 2026/01/13.
//  Premium Subscription Paywall UI
//

import SwiftUI
import StoreKit

/// Premium subscription paywall view
struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var premiumManager = PremiumManager.shared
    @ObservedObject private var localization = LocalizationManager.shared

    @State private var selectedProduct: Product?
    @State private var selectedTier: SubscriptionTier = .premium
    @State private var selectedPeriod: SubscriptionPeriod = .yearly
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    enum SubscriptionTier {
        case pro
        case premium
    }

    enum SubscriptionPeriod {
        case monthly
        case yearly
    }

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Tier Selection (Pro vs Premium)
                    tierSelectionSection

                    // Period Selection (Monthly vs Yearly)
                    periodSelectionSection

                    // Feature List
                    featureListSection

                    // Price Display
                    priceDisplaySection

                    // Purchase button
                    purchaseButton

                    // Restore button
                    restoreButton

                    // Legal section
                    legalSection
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L("subscription.close")) { dismiss() }
                        .foregroundColor(.yellow)
                }
            }
            .onAppear {
                updateSelectedProduct()
            }
            .onChange(of: selectedTier) { _, _ in
                updateSelectedProduct()
            }
            .onChange(of: selectedPeriod) { _, _ in
                updateSelectedProduct()
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

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {
            // App icon with glow
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.yellow.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)

                Image("QuantumNativeIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }

            Text(L("subscription.title"))
                .font(.title.bold())
                .foregroundColor(.white)

            Text(L("subscription.subtitle"))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    // MARK: - Tier Selection

    private var tierSelectionSection: some View {
        VStack(spacing: 12) {
            Text(L("subscription.choose_plan"))
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                // Pro Tier Button
                tierButton(
                    tier: .pro,
                    title: L("subscription.pro"),
                    icon: "star.fill",
                    color: .blue,
                    isSelected: selectedTier == .pro
                )

                // Premium Tier Button
                tierButton(
                    tier: .premium,
                    title: L("subscription.premium"),
                    icon: "crown.fill",
                    color: .yellow,
                    isSelected: selectedTier == .premium,
                    isRecommended: true
                )
            }
        }
    }

    private func tierButton(tier: SubscriptionTier, title: String, icon: String, color: Color, isSelected: Bool, isRecommended: Bool = false) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedTier = tier
            }
        }) {
            VStack(spacing: 8) {
                if isRecommended {
                    Text(L("subscription.recommended"))
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                }

                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? color : color.opacity(0.5))

                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Period Selection

    private var periodSelectionSection: some View {
        HStack(spacing: 12) {
            // Monthly Button
            periodButton(
                period: .monthly,
                title: L("subscription.monthly"),
                isSelected: selectedPeriod == .monthly
            )

            // Yearly Button
            periodButton(
                period: .yearly,
                title: L("subscription.yearly"),
                isSelected: selectedPeriod == .yearly,
                badge: L("subscription.save_percent")
            )
        }
    }

    private func periodButton(period: SubscriptionPeriod, title: String, isSelected: Bool, badge: String? = nil) -> some View {
        let accentColor: Color = selectedTier == .premium ? .yellow : .blue

        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedPeriod = period
            }
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.6))

                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? accentColor.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? accentColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Feature List

    private var featureListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            let accentColor: Color = selectedTier == .premium ? .yellow : .blue

            if selectedTier == .pro {
                FeatureRow(icon: "graduationcap.fill", text: L("subscription.pro.feature1"), color: accentColor)
                FeatureRow(icon: "cpu", text: L("subscription.pro.feature2"), color: accentColor)
                FeatureRow(icon: "book.fill", text: L("subscription.pro.feature3"), color: accentColor)
                FeatureRow(icon: "envelope.fill", text: L("subscription.pro.feature4"), color: accentColor)
            } else {
                FeatureRow(icon: "checkmark.circle.fill", text: L("subscription.premium.feature1"), color: accentColor)
                FeatureRow(icon: "network", text: L("subscription.premium.feature2"), color: accentColor)
                FeatureRow(icon: "shield.checkered", text: L("subscription.premium.feature3"), color: accentColor)
                FeatureRow(icon: "building.2.fill", text: L("subscription.premium.feature4"), color: accentColor)
                FeatureRow(icon: "headphones", text: L("subscription.premium.feature5"), color: accentColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }

    // MARK: - Price Display

    private var priceDisplaySection: some View {
        VStack(spacing: 8) {
            if let product = selectedProduct {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(product.displayPrice)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(selectedTier == .premium ? .yellow : .blue)

                    Text(selectedPeriod == .yearly ? L("subscription.per_year") : L("subscription.per_month"))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }

                Text(selectedPeriod == .yearly
                     ? (selectedTier == .premium ? L("subscription.premium.desc_yearly") : L("subscription.pro.desc_yearly"))
                     : (selectedTier == .premium ? L("subscription.premium.desc_monthly") : L("subscription.pro.desc_monthly")))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Purchase Button

    private var purchaseButton: some View {
        let accentColor: Color = selectedTier == .premium ? .yellow : .blue

        return Button(action: purchase) {
            HStack(spacing: 8) {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else {
                    Image(systemName: selectedTier == .premium ? "crown.fill" : "star.fill")
                    Text(L("subscription.subscribe"))
                    if let product = selectedProduct {
                        Text("- \(product.displayPrice)")
                    }
                }
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                selectedProduct != nil
                    ? LinearGradient(colors: selectedTier == .premium ? [.yellow, .orange] : [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(selectedProduct == nil || isPurchasing)
    }

    // MARK: - Restore Button

    private var restoreButton: some View {
        Button(action: restore) {
            Text(L("subscription.restore"))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
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
    }

    // MARK: - Helper Methods

    private func updateSelectedProduct() {
        let productId: String

        switch (selectedTier, selectedPeriod) {
        case (.pro, .monthly):
            productId = "com.swiftquantum.pro.monthly"
        case (.pro, .yearly):
            productId = "com.swiftquantum.pro.yearly"
        case (.premium, .monthly):
            productId = "com.swiftquantum.premium.monthly"
        case (.premium, .yearly):
            productId = "com.swiftquantum.premium.yearly"
        }

        selectedProduct = premiumManager.products.first { $0.id == productId }
    }

    // MARK: - Actions

    private func purchase() {
        guard let product = selectedProduct else { return }

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
