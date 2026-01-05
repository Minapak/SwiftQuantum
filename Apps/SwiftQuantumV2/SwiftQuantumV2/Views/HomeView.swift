//
//  HomeView.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: QuantumSpacing.lg) {
                    // Header
                    headerSection

                    // Quick Stats
                    quickStatsSection

                    // Featured Algorithms
                    featuredAlgorithmsSection

                    // Recent Activity
                    recentActivitySection

                    // About Section
                    aboutSection
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: QuantumSpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("SwiftQuantum")
                            .font(QuantumTypography.displayMedium)
                            .foregroundColor(.white)

                        VersionBadge()
                    }

                    Text("Quantum Computing Framework")
                        .font(QuantumTypography.body)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Image(systemName: "atom")
                    .font(.system(size: 40))
                    .foregroundColor(QuantumColors.primary)
            }
        }
        .quantumCard()
    }

    // MARK: - Quick Stats Section

    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Quick Stats", icon: "chart.bar.fill")

            HStack(spacing: QuantumSpacing.md) {
                QuantumStatCard(
                    title: "Algorithms",
                    value: "4",
                    icon: "function",
                    color: QuantumColors.primary
                )

                QuantumStatCard(
                    title: "Gates",
                    value: "15+",
                    icon: "square.grid.2x2",
                    color: QuantumColors.secondary
                )

                QuantumStatCard(
                    title: "Max Qubits",
                    value: "20",
                    icon: "circle.hexagongrid",
                    color: QuantumColors.accent
                )
            }
        }
    }

    // MARK: - Featured Algorithms Section

    private var featuredAlgorithmsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Featured Algorithms", icon: "star.fill")

            VStack(spacing: QuantumSpacing.sm) {
                AlgorithmFeatureCard(
                    name: "Bell State",
                    description: "Quantum entanglement demonstration",
                    icon: "link.circle.fill",
                    color: QuantumColors.bellState,
                    speedup: "50% |00⟩ + 50% |11⟩"
                )

                AlgorithmFeatureCard(
                    name: "Deutsch-Jozsa",
                    description: "Constant vs balanced function discrimination",
                    icon: "divide.circle.fill",
                    color: QuantumColors.deutschJozsa,
                    speedup: "10^9× speedup"
                )

                AlgorithmFeatureCard(
                    name: "Grover's Search",
                    description: "Unstructured database search",
                    icon: "magnifyingglass.circle.fill",
                    color: QuantumColors.grover,
                    speedup: "O(√N) speedup"
                )

                AlgorithmFeatureCard(
                    name: "Simon's Algorithm",
                    description: "Hidden period finding",
                    icon: "waveform.circle.fill",
                    color: QuantumColors.simon,
                    speedup: "Exponential speedup"
                )
            }
        }
    }

    // MARK: - Recent Activity Section

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Capabilities", icon: "sparkles")

            VStack(spacing: QuantumSpacing.sm) {
                CapabilityRow(icon: "cpu", title: "Multi-Qubit Support", subtitle: "Up to 20 qubits with tensor product states")
                CapabilityRow(icon: "rectangle.3.group", title: "15+ Quantum Gates", subtitle: "H, X, Y, Z, CNOT, CZ, SWAP, Toffoli, and more")
                CapabilityRow(icon: "arrow.triangle.branch", title: "Circuit Builder", subtitle: "Visual circuit composition with QASM export")
                CapabilityRow(icon: "link", title: "IBM Quantum Ready", subtitle: "Bridge API for Qiskit integration")
            }
            .quantumCard()
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("About", icon: "info.circle.fill")

            VStack(alignment: .leading, spacing: QuantumSpacing.sm) {
                Text("SwiftQuantum v2.0 integrates the power of QuantumBridge with native iOS performance. Experience quantum computing with educational visualizations and real algorithm implementations.")
                    .font(QuantumTypography.body)
                    .foregroundColor(.white.opacity(0.8))

                HStack(spacing: QuantumSpacing.md) {
                    InfoBadge(icon: "swift", text: "Swift 6.0")
                    InfoBadge(icon: "apple.logo", text: "iOS 14+")
                    InfoBadge(icon: "doc.text", text: "MIT License")
                }
            }
            .quantumCard()
        }
    }
}

// MARK: - Algorithm Feature Card

struct AlgorithmFeatureCard: View {
    let name: String
    let description: String
    let icon: String
    let color: Color
    let speedup: String

    var body: some View {
        HStack(spacing: QuantumSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(QuantumTypography.title)
                    .foregroundColor(.white)

                Text(description)
                    .font(QuantumTypography.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            QuantumBadge(speedup, color: color)
        }
        .quantumCard(padding: QuantumSpacing.sm)
    }
}

// MARK: - Capability Row

struct CapabilityRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: QuantumSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(QuantumColors.primary)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(QuantumTypography.body)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(QuantumTypography.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(QuantumColors.success)
        }
        .padding(.vertical, QuantumSpacing.xs)
    }
}

// MARK: - Info Badge

struct InfoBadge: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(QuantumTypography.caption)
        }
        .foregroundColor(.white.opacity(0.7))
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .background(QuantumColors.backgroundGradient)
    }
}
