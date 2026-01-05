//
//  SettingsView.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var defaultShots = 1000
    @State private var showAdvancedFeatures = true
    @State private var enableHaptics = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: QuantumSpacing.lg) {
                    // Header
                    headerSection

                    // About
                    aboutSection

                    // Simulation Settings
                    simulationSettings

                    // IBM Quantum
                    ibmQuantumSection

                    // Resources
                    resourcesSection

                    // Credits
                    creditsSection
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(QuantumTypography.displayMedium)
                    .foregroundColor(.white)

                Text("Configure your experience")
                    .font(QuantumTypography.body)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "gearshape.fill")
                .font(.system(size: 36))
                .foregroundColor(QuantumColors.primary)
        }
        .quantumCard()
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("About", icon: "info.circle.fill")

            VStack(spacing: QuantumSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
                        HStack {
                            Text("SwiftQuantum")
                                .font(QuantumTypography.headline)
                                .foregroundColor(.white)

                            VersionBadge()
                        }

                        Text("QuantumBridge Integration")
                            .font(QuantumTypography.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    Image(systemName: "atom")
                        .font(.system(size: 44))
                        .foregroundColor(QuantumColors.primary)
                }

                Divider().background(Color.white.opacity(0.1))

                VStack(spacing: QuantumSpacing.sm) {
                    SettingsInfoRow(icon: "swift", title: "Platform", value: "Swift 6.0 / iOS 14+")
                    SettingsInfoRow(icon: "cpu", title: "Simulator", value: "Up to 20 qubits")
                    SettingsInfoRow(icon: "function", title: "Algorithms", value: "4 major algorithms")
                    SettingsInfoRow(icon: "square.grid.2x2", title: "Gates", value: "15+ quantum gates")
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Simulation Settings

    private var simulationSettings: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Simulation", icon: "slider.horizontal.3")

            VStack(spacing: QuantumSpacing.md) {
                // Default shots
                VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
                    HStack {
                        Text("Default Measurement Shots")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(defaultShots)")
                            .font(QuantumTypography.monospace)
                            .foregroundColor(QuantumColors.primary)
                    }

                    Slider(value: Binding(
                        get: { Double(defaultShots) },
                        set: { defaultShots = Int($0) }
                    ), in: 100...10000, step: 100)
                    .accentColor(QuantumColors.primary)
                }

                Divider().background(Color.white.opacity(0.1))

                // Toggle settings
                Toggle(isOn: $showAdvancedFeatures) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(QuantumColors.secondary)
                        Text("Advanced Features")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)
                    }
                }
                .tint(QuantumColors.primary)

                Toggle(isOn: $enableHaptics) {
                    HStack {
                        Image(systemName: "hand.tap.fill")
                            .foregroundColor(QuantumColors.accent)
                        Text("Haptic Feedback")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)
                    }
                }
                .tint(QuantumColors.primary)
            }
            .quantumCard()
        }
    }

    // MARK: - IBM Quantum

    private var ibmQuantumSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("IBM Quantum", icon: "cloud.fill")

            VStack(spacing: QuantumSpacing.md) {
                HStack {
                    Image(systemName: "link.badge.plus")
                        .font(.system(size: 24))
                        .foregroundColor(QuantumColors.deutschJozsa)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Connect to IBM Quantum")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)

                        Text("Run circuits on real quantum hardware")
                            .font(QuantumTypography.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    QuantumBadge("Coming Soon", color: QuantumColors.warning)
                }

                Text("SwiftQuantum v2.0 includes Bridge API for IBM Quantum integration. Export circuits as QASM and connect to real quantum computers.")
                    .font(QuantumTypography.caption)
                    .foregroundColor(.white.opacity(0.7))

                HStack(spacing: QuantumSpacing.sm) {
                    FeatureBadge(icon: "checkmark.circle", text: "QASM Export")
                    FeatureBadge(icon: "checkmark.circle", text: "Error Mitigation")
                    FeatureBadge(icon: "clock", text: "Cloud Run")
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Resources

    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Resources", icon: "book.fill")

            VStack(spacing: QuantumSpacing.sm) {
                ResourceLink(
                    icon: "doc.text.fill",
                    title: "Documentation",
                    subtitle: "Learn about quantum computing",
                    url: "https://github.com/Minapak/SwiftQuantum"
                )

                ResourceLink(
                    icon: "link",
                    title: "QuantumBridge",
                    subtitle: "Python quantum framework",
                    url: "https://github.com/Minapak/QuantumBridge"
                )

                ResourceLink(
                    icon: "graduationcap.fill",
                    title: "Linear Algebra Guide",
                    subtitle: "3Blue1Brown inspired learning",
                    url: "https://eunminpark.hashnode.dev"
                )
            }
        }
    }

    // MARK: - Credits

    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Credits", icon: "person.fill")

            VStack(spacing: QuantumSpacing.md) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(QuantumColors.primary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("EUNMIN Park")
                            .font(QuantumTypography.headline)
                            .foregroundColor(.white)

                        Text("iOS Developer & Quantum Computing Enthusiast")
                            .font(QuantumTypography.caption)
                            .foregroundColor(.white.opacity(0.6))

                        HStack(spacing: QuantumSpacing.xs) {
                            QuantumBadge("5+ Years iOS", color: QuantumColors.success)
                            QuantumBadge("오픈데이터포럼 2024", color: QuantumColors.accent)
                        }
                    }

                    Spacer()
                }

                Divider().background(Color.white.opacity(0.1))

                Text("MIT License - Free to use, modify, and distribute")
                    .font(QuantumTypography.caption)
                    .foregroundColor(.white.opacity(0.5))

                Text("© 2025 iOS Quantum Engineering")
                    .font(QuantumTypography.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .quantumCard()
        }
    }
}

// MARK: - Settings Info Row

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(QuantumColors.primary)
                .frame(width: 24)

            Text(title)
                .font(QuantumTypography.body)
                .foregroundColor(.white)

            Spacer()

            Text(value)
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

// MARK: - Feature Badge

struct FeatureBadge: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundColor(.white.opacity(0.7))
        .padding(.horizontal, QuantumSpacing.xs)
        .padding(.vertical, QuantumSpacing.xxs)
        .background(Color.white.opacity(0.1))
        .cornerRadius(QuantumSpacing.cornerRadiusSmall)
    }
}

// MARK: - Resource Link

struct ResourceLink: View {
    let icon: String
    let title: String
    let subtitle: String
    let url: String

    var body: some View {
        Button(action: openURL) {
            HStack {
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

                Image(systemName: "arrow.up.right")
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(QuantumSpacing.sm)
            .background(Color.white.opacity(0.05))
            .cornerRadius(QuantumSpacing.cornerRadiusSmall)
        }
    }

    private func openURL() {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
            .background(QuantumColors.backgroundGradient)
    }
}
