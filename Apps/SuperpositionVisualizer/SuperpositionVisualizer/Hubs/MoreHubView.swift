import SwiftUI

// MARK: - More Hub - "Ecosystem"
// Academy + Industry + Profile + Settings

struct MoreHubView: View {
    @State private var showAcademy = false
    @State private var showIndustry = false
    @State private var showProfile = false
    @State private var showLanguageSheet = false
    @State private var showComingSoon = false
    @State private var comingSoonFeature = ""
    @State private var showResetConfirm = false
    @StateObject private var firstLaunchManager = FirstLaunchManager()

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

                // Settings Section
                settingsSection

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
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSelectionSheet()
        }
        .alert("Coming Soon", isPresented: $showComingSoon) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(comingSoonFeature) will be available in a future update.")
        }
        .alert("Reset Tutorial", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                firstLaunchManager.resetOnboarding()
            }
        } message: {
            Text("This will show the onboarding tutorial again when you restart the app.")
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
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.15))
                        .clipShape(Capsule())
                }

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

    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                // Language - Working
                settingsRowButton(icon: "globe", title: "Language", color: QuantumHorizonColors.quantumCyan, showValue: "English") {
                    showLanguageSheet = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Notifications - Coming Soon
                settingsRowButton(icon: "bell.fill", title: "Notifications", color: .orange) {
                    comingSoonFeature = "Notifications"
                    showComingSoon = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Appearance - Coming Soon
                settingsRowButton(icon: "paintbrush.fill", title: "Appearance", color: QuantumHorizonColors.quantumPurple) {
                    comingSoonFeature = "Appearance settings"
                    showComingSoon = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Privacy - Coming Soon
                settingsRowButton(icon: "lock.fill", title: "Privacy", color: QuantumHorizonColors.quantumGreen) {
                    comingSoonFeature = "Privacy settings"
                    showComingSoon = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Reset Tutorial - Working
                settingsRowButton(icon: "arrow.counterclockwise", title: "Reset Tutorial", color: .orange) {
                    showResetConfirm = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Help & Support - Coming Soon
                settingsRowButton(icon: "questionmark.circle.fill", title: "Help & Support", color: QuantumHorizonColors.quantumCyan) {
                    comingSoonFeature = "Help & Support"
                    showComingSoon = true
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }

    private func settingsRowButton(icon: String, title: String, color: Color, showValue: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Spacer()

                if let value = showValue {
                    Text(value)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }

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

            Text("Version 2.1.1")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - Language Selection Sheet
struct LanguageSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"

    private let languages = [
        ("en", "English", "🇺🇸"),
        ("ko", "한국어", "🇰🇷"),
        ("ja", "日本語", "🇯🇵"),
        ("zh-Hans", "简体中文", "🇨🇳")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                QuantumHorizonBackground()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(languages, id: \.0) { code, name, flag in
                            languageRow(code: code, name: name, flag: flag)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Language")
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

    private func languageRow(code: String, name: String, flag: String) -> some View {
        Button(action: {
            selectedLanguage = code
        }) {
            HStack(spacing: 16) {
                Text(flag)
                    .font(.system(size: 28))

                Text(name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                if selectedLanguage == code {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(QuantumHorizonColors.quantumCyan)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedLanguage == code ? QuantumHorizonColors.quantumCyan.opacity(0.15) : Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selectedLanguage == code ? QuantumHorizonColors.quantumCyan.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
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
