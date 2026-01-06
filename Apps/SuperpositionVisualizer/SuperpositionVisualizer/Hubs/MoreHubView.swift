import SwiftUI

// MARK: - More Hub - "Ecosystem"
// Academy + Industry + Profile 통합 - NavigationView List 스타일

struct MoreHubView: View {
    @State private var showAcademy = false
    @State private var showIndustry = false
    @State private var showProfile = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Quick Stats Card
                quickStatsCard

                // Navigation Cards
                VStack(spacing: 12) {
                    moreNavigationCard(
                        title: "Academy",
                        subtitle: "Learn Quantum Computing",
                        icon: "graduationcap.fill",
                        color: QuantumHorizonColors.quantumCyan,
                        badge: "5 Lessons"
                    ) {
                        showAcademy = true
                    }

                    moreNavigationCard(
                        title: "Industry",
                        subtitle: "Enterprise Solutions",
                        icon: "building.2.fill",
                        color: QuantumHorizonColors.quantumPurple,
                        badge: "Premium"
                    ) {
                        showIndustry = true
                    }

                    moreNavigationCard(
                        title: "Profile",
                        subtitle: "Your Quantum Journey",
                        icon: "person.circle.fill",
                        color: QuantumHorizonColors.quantumGold,
                        badge: nil
                    ) {
                        showProfile = true
                    }
                }

                // Additional Options
                additionalOptionsSection

                // App Info
                appInfoSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
        .sheet(isPresented: $showAcademy) {
            AcademyDetailView()
        }
        .sheet(isPresented: $showIndustry) {
            IndustryDetailView()
        }
        .sheet(isPresented: $showProfile) {
            ProfileDetailView()
        }
    }

    // MARK: - Quick Stats Card
    private var quickStatsCard: some View {
        HStack(spacing: 0) {
            quickStatItem(value: "12", label: "Lessons", color: QuantumHorizonColors.quantumCyan)

            Divider()
                .background(Color.white.opacity(0.1))
                .frame(height: 40)

            quickStatItem(value: "847", label: "XP Points", color: QuantumHorizonColors.quantumGold)

            Divider()
                .background(Color.white.opacity(0.1))
                .frame(height: 40)

            quickStatItem(value: "Level 5", label: "Rank", color: QuantumHorizonColors.quantumPurple)
        }
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func quickStatItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Navigation Card
    private func moreNavigationCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        badge: String?,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }

                // Title & Subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                // Badge
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.15))
                        .clipShape(Capsule())
                }

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Additional Options
    private var additionalOptionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                settingsRow(icon: "bell.fill", title: "Notifications", color: .orange)
                Divider().background(Color.white.opacity(0.1))
                settingsRow(icon: "paintbrush.fill", title: "Appearance", color: QuantumHorizonColors.quantumPurple)
                Divider().background(Color.white.opacity(0.1))
                settingsRow(icon: "lock.fill", title: "Privacy", color: QuantumHorizonColors.quantumGreen)
                Divider().background(Color.white.opacity(0.1))
                settingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: QuantumHorizonColors.quantumCyan)
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    private func settingsRow(icon: String, title: String, color: Color) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - App Info
    private var appInfoSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "atom")
                .font(.system(size: 32))
                .foregroundColor(QuantumHorizonColors.quantumCyan.opacity(0.5))

            Text("SwiftQuantum")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

            Text("Version 2.1.0")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Academy Detail View (Sheet)
struct AcademyDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                QuantumHorizonBackground()
                    .ignoresSafeArea()

                AcademyHubView()
            }
            .navigationTitle("Academy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(QuantumHorizonColors.quantumCyan)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Industry Detail View (Sheet)
struct IndustryDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                QuantumHorizonBackground()
                    .ignoresSafeArea()

                IndustryHubView()
            }
            .navigationTitle("Industry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(QuantumHorizonColors.quantumPurple)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Profile Detail View (Sheet)
struct ProfileDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                QuantumHorizonBackground()
                    .ignoresSafeArea()

                ProfileHubView()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(QuantumHorizonColors.quantumGold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        MoreHubView()
    }
    .preferredColorScheme(.dark)
}
