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

    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    headerSection

                    // Feature comparison
                    featureComparisonSection

                    // Products
                    productsSection

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
                    Button("Close") { dismiss() }
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

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {
            // Crown icon with glow
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

                Image(systemName: "crown.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }

            Text("Unlock SwiftQuantum")
                .font(.title.bold())
                .foregroundColor(.white)

            Text("Access the full power of quantum computing")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    // MARK: - Feature Comparison Section

    private var featureComparisonSection: some View {
        VStack(spacing: 16) {
            // Pro features
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.blue)
                    Text("Pro")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                FeatureRow(icon: "graduationcap.fill", text: "All 12 Academy Courses", color: .blue)
                FeatureRow(icon: "cpu", text: "40 Qubit Local Simulation", color: .blue)
                FeatureRow(icon: "book.fill", text: "Advanced Examples", color: .blue)
                FeatureRow(icon: "envelope.fill", text: "Email Support", color: .blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )

            // Premium features
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    Text("Premium")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("RECOMMENDED")
                        .font(.caption2.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                }

                FeatureRow(icon: "checkmark.circle.fill", text: "Everything in Pro", color: .yellow)
                FeatureRow(icon: "network", text: "QuantumBridge QPU Connection", color: .yellow)
                FeatureRow(icon: "shield.checkered", text: "Error Correction Simulation", color: .yellow)
                FeatureRow(icon: "building.2.fill", text: "Industry Solutions Access", color: .yellow)
                FeatureRow(icon: "headphones", text: "Priority Support", color: .yellow)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.yellow.opacity(0.15), Color.orange.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
            )
        }
    }

    // MARK: - Products Section

    private var productsSection: some View {
        VStack(spacing: 12) {
            if premiumManager.isLoading && premiumManager.products.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                    .padding()
            } else {
                ForEach(premiumManager.products.sorted { $0.price > $1.price }, id: \.id) { product in
                    ProductRow(
                        product: product,
                        isSelected: selectedProduct?.id == product.id,
                        onSelect: { selectedProduct = product }
                    )
                }
            }
        }
    }

    // MARK: - Purchase Button

    private var purchaseButton: some View {
        Button(action: purchase) {
            HStack(spacing: 8) {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else {
                    Image(systemName: "crown.fill")
                    Text("Subscribe")
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
                    ? LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(selectedProduct == nil || isPurchasing)
    }

    // MARK: - Restore Button

    private var restoreButton: some View {
        Button(action: restore) {
            Text("Restore Purchases")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
    }

    // MARK: - Legal Section

    private var legalSection: some View {
        VStack(spacing: 8) {
            Text("Subscription auto-renews unless cancelled 24 hours before the end of the current period.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Link("Terms of Use", destination: URL(string: "https://swiftquantum.app/terms")!)
                Text("•")
                Link("Privacy Policy", destination: URL(string: "https://swiftquantum.app/privacy")!)
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .padding(.top, 8)
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

// MARK: - Product Row

private struct ProductRow: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void

    private var isPremium: Bool {
        product.id.contains("premium")
    }

    private var isYearly: Bool {
        product.id.contains("yearly")
    }

    private var tierName: String {
        isPremium ? "Premium" : "Pro"
    }

    private var periodName: String {
        isYearly ? "Yearly" : "Monthly"
    }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                // Radio button
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? (isPremium ? .yellow : .blue) : .gray)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tierName)
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(periodName)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))

                        if isYearly {
                            Text("SAVE 33%")
                                .font(.caption2.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .clipShape(Capsule())
                        }
                    }

                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(product.displayPrice)
                        .font(.headline)
                        .foregroundStyle(isPremium ? .yellow : .blue)

                    Text(isYearly ? "/year" : "/month")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected
                                    ? (isPremium ? Color.yellow : Color.blue)
                                    : Color.white.opacity(0.1),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    PaywallView()
}
