import SwiftUI
import SafariServices

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
    @State private var showWebView = false
    @State private var webViewURL: URL?
    @StateObject private var firstLaunchManager = FirstLaunchManager()
    @StateObject private var statsManager = UserStatsManager()

    // Backend webapp base URL
    #if DEBUG
    private let webAppBaseURL = "http://localhost:3000"
    #else
    private let webAppBaseURL = "https://swiftquantum.tech"
    #endif

    private func openWebApp(path: String) {
        if let url = URL(string: webAppBaseURL + path) {
            webViewURL = url
            showWebView = true
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Quick Stats Card
                quickStatsCard

                // Navigation Cards
                VStack(spacing: 12) {
                    moreNavigationCard(
                        title: LocalizationManager.shared.string(for: .academy),
                        subtitle: "Learn Quantum Computing",
                        icon: "graduationcap.fill",
                        color: QuantumHorizonColors.quantumCyan,
                        badge: statsManager.lessonsCompleted > 0 ? "\(statsManager.lessonsCompleted) Done" : nil
                    ) {
                        DeveloperModeManager.shared.log(screen: "More", element: "Academy Card", status: .success)
                        // Open QuantumNative app via deep link
                        if let url = URL(string: "quantumnative://academy") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                // Fallback to in-app Academy if QuantumNative not installed
                                showAcademy = true
                            }
                        }
                    }

                    moreNavigationCard(
                        title: LocalizationManager.shared.string(for: .industry),
                        subtitle: "Enterprise Solutions",
                        icon: "building.2.fill",
                        color: QuantumHorizonColors.quantumPurple,
                        badge: "Premium"
                    ) {
                        DeveloperModeManager.shared.log(screen: "More", element: "Industry Card", status: .success)
                        showIndustry = true
                    }

                    moreNavigationCard(
                        title: LocalizationManager.shared.string(for: .profile),
                        subtitle: "Your Quantum Journey",
                        icon: "person.circle.fill",
                        color: QuantumHorizonColors.quantumGold,
                        badge: nil
                    ) {
                        DeveloperModeManager.shared.log(screen: "More", element: "Profile Card", status: .success)
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
        .sheet(isPresented: $showWebView) {
            if let url = webViewURL {
                SafariWebView(url: url)
            }
        }
        .task {
            await statsManager.loadStats()
        }
    }

    // MARK: - Quick Stats Card
    private var quickStatsCard: some View {
        HStack(spacing: 0) {
            quickStatItem(value: "\(statsManager.lessonsCompleted)", label: "Lessons", color: QuantumHorizonColors.quantumCyan)

            Divider()
                .background(Color.white.opacity(0.1))
                .frame(height: 40)

            quickStatItem(value: "\(statsManager.xpPoints)", label: "XP Points", color: QuantumHorizonColors.quantumGold)

            Divider()
                .background(Color.white.opacity(0.1))
                .frame(height: 40)

            quickStatItem(value: "Level \(statsManager.level)", label: "Rank", color: QuantumHorizonColors.quantumPurple)
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
        let localization = LocalizationManager.shared
        return VStack(alignment: .leading, spacing: 12) {
            Text(localization.string(for: .settings))
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                // Language - Working
                settingsRowButton(icon: "globe", title: localization.string(for: .language), color: QuantumHorizonColors.quantumCyan, showValue: localization.currentLanguage.displayName, isComingSoon: false) {
                    showLanguageSheet = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Notifications - Opens Web Settings
                settingsRowButton(icon: "bell.fill", title: localization.string(for: .notifications), color: .orange, isComingSoon: false) {
                    openWebApp(path: "/settings/notifications")
                }

                Divider().background(Color.white.opacity(0.1))

                // Appearance - Opens Web Settings
                settingsRowButton(icon: "paintbrush.fill", title: "Appearance", color: QuantumHorizonColors.quantumPurple, isComingSoon: false) {
                    openWebApp(path: "/settings/appearance")
                }

                Divider().background(Color.white.opacity(0.1))

                // Privacy - Opens Privacy Policy
                settingsRowButton(icon: "lock.fill", title: "Privacy", color: QuantumHorizonColors.quantumGreen, isComingSoon: false) {
                    openWebApp(path: "/privacy")
                }

                Divider().background(Color.white.opacity(0.1))

                // Reset Tutorial - Working
                settingsRowButton(icon: "arrow.counterclockwise", title: "Reset Tutorial", color: .orange, isComingSoon: false) {
                    showResetConfirm = true
                }

                Divider().background(Color.white.opacity(0.1))

                // Help & Support - Opens Support Page
                settingsRowButton(icon: "questionmark.circle.fill", title: "Help & Support", color: QuantumHorizonColors.quantumCyan, isComingSoon: false) {
                    openWebApp(path: "/support")
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

    private func settingsRowButton(icon: String, title: String, color: Color, showValue: String? = nil, isComingSoon: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            DeveloperModeManager.shared.log(
                screen: "More",
                element: "Settings: \(title)",
                status: isComingSoon ? .comingSoon : .success
            )
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

            Text("Version \(AppInfo.version)")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// MARK: - App Info Helper
enum AppInfo {
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.2.0"
    }

    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

// MARK: - Language Selection Sheet
// Note: LanguageSelectionSheet is now defined in LocalizationManager.swift
// to avoid duplicate definitions. Use LocalizationManager for all language-related functionality.

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
                    Button("Done") {
                        DeveloperModeManager.shared.log(screen: "Academy", element: "Done Button", status: .success)
                        dismiss()
                    }
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
                    Button("Done") {
                        DeveloperModeManager.shared.log(screen: "Industry", element: "Done Button", status: .success)
                        dismiss()
                    }
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
                    Button("Done") {
                        DeveloperModeManager.shared.log(screen: "Profile", element: "Done Button", status: .success)
                        dismiss()
                    }
                    .foregroundColor(QuantumHorizonColors.quantumGold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Safari WebView for Settings
struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        config.barCollapsingEnabled = true

        let controller = SFSafariViewController(url: url, configuration: config)
        controller.preferredControlTintColor = UIColor(QuantumHorizonColors.quantumCyan)
        controller.preferredBarTintColor = UIColor.black
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - User Stats Manager (Backend Connected)
@MainActor
class UserStatsManager: ObservableObject {
    @Published var lessonsCompleted: Int = 0
    @Published var xpPoints: Int = 0
    @Published var level: Int = 1
    @Published var streak: Int = 0
    @Published var isLoading: Bool = false
    @Published var error: String?

    func loadStats() async {
        isLoading = true
        error = nil

        do {
            let stats: UserStatsResponse = try await APIClient.shared.get("/api/v1/users/stats")
            lessonsCompleted = stats.lessonsCompleted
            xpPoints = stats.xpPoints
            level = stats.level
            streak = stats.streak
        } catch {
            // Use cached/default values on error
            self.error = error.localizedDescription

            // Load from UserDefaults as fallback
            lessonsCompleted = UserDefaults.standard.integer(forKey: "SwiftQuantum_LessonsCompleted")
            xpPoints = UserDefaults.standard.integer(forKey: "SwiftQuantum_XPPoints")
            level = max(1, UserDefaults.standard.integer(forKey: "SwiftQuantum_Level"))
            streak = UserDefaults.standard.integer(forKey: "SwiftQuantum_Streak")
        }

        isLoading = false
    }

    func addXP(_ points: Int) async {
        xpPoints += points
        UserDefaults.standard.set(xpPoints, forKey: "SwiftQuantum_XPPoints")

        // Calculate level (every 500 XP = 1 level)
        level = max(1, xpPoints / 500 + 1)
        UserDefaults.standard.set(level, forKey: "SwiftQuantum_Level")

        // Sync with backend
        do {
            let _: EmptyResponse = try await APIClient.shared.post("/api/v1/users/xp", body: AddXPRequest(points: points))
        } catch {
            // Local update succeeded, backend sync can retry later
        }
    }

    func completeLesson(_ lessonId: String) async {
        lessonsCompleted += 1
        UserDefaults.standard.set(lessonsCompleted, forKey: "SwiftQuantum_LessonsCompleted")

        // Add XP for completing lesson
        await addXP(100)

        // Sync with backend
        do {
            let _: EmptyResponse = try await APIClient.shared.post("/api/v1/users/lessons/complete", body: CompleteLessonRequest(lessonId: lessonId))
        } catch {
            // Local update succeeded
        }
    }
}

// MARK: - API Models for Stats
struct UserStatsResponse: Decodable {
    let lessonsCompleted: Int
    let xpPoints: Int
    let level: Int
    let streak: Int
}

struct AddXPRequest: Encodable {
    let points: Int
}

struct CompleteLessonRequest: Encodable {
    let lessonId: String
}

struct EmptyResponse: Decodable {}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        MoreHubView()
    }
    .preferredColorScheme(.dark)
}
