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
    @State private var showAuthView = false
    @State private var pendingAction: PendingAction?
    @StateObject private var firstLaunchManager = FirstLaunchManager()
    @StateObject private var statsManager = UserStatsManager()
    @ObservedObject private var authService = AuthService.shared

    enum PendingAction {
        case academy
        case profile
    }

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
                        badge: authService.isLoggedIn ? (statsManager.lessonsCompleted > 0 ? "\(statsManager.lessonsCompleted) Done" : nil) : "Login"
                    ) {
                        DeveloperModeManager.shared.log(screen: "More", element: "Academy Card", status: .success)
                        // Always show Academy marketing page (redirects to QuantumNative)
                        showAcademy = true
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
                        badge: authService.isLoggedIn ? (authService.isAdmin ? "Admin" : nil) : "Login"
                    ) {
                        DeveloperModeManager.shared.log(screen: "More", element: "Profile Card", status: .success)
                        if authService.isLoggedIn {
                            showProfile = true
                        } else {
                            pendingAction = .profile
                            showAuthView = true
                        }
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
            AcademyMarketingView()
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
        .sheet(isPresented: $showAuthView) {
            AuthenticationView()
        }
        .onChange(of: authService.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn, let action = pendingAction {
                pendingAction = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    switch action {
                    case .profile:
                        showProfile = true
                    case .academy:
                        showAcademy = true
                    }
                }
            }
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

// MARK: - Academy Marketing View (QuantumNative App Promotion)
struct AcademyMarketingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateGradient = false

    // QuantumNative App Store URL (Replace with actual App Store ID)
    private let quantumNativeAppStoreURL = "https://apps.apple.com/app/quantumnative/id6740513054"

    var body: some View {
        NavigationView {
            ZStack {
                // Animated Background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.15),
                        Color(red: 0.1, green: 0.05, blue: 0.2),
                        Color(red: 0.05, green: 0.1, blue: 0.2)
                    ],
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }

                ScrollView {
                    VStack(spacing: 32) {
                        // Hero Section
                        heroSection

                        // Features Section
                        featuresSection

                        // Course Preview
                        coursePreviewSection

                        // Testimonial
                        testimonialSection

                        // CTA Button
                        ctaSection

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 20) {
            // App Icon
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [QuantumHorizonColors.quantumCyan, QuantumHorizonColors.quantumPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: QuantumHorizonColors.quantumCyan.opacity(0.5), radius: 20)

                Image(systemName: "atom")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.white)
            }

            VStack(spacing: 8) {
                Text("QuantumNative")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Master Quantum Computing")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(QuantumHorizonColors.quantumCyan)

                HStack(spacing: 4) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                    }
                    Text("4.9")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text("(2.4K Reviews)")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 4)
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: 16) {
            Text("Why Learn with QuantumNative?")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                featureRow(
                    icon: "brain.head.profile",
                    title: "Interactive Learning",
                    description: "Hands-on quantum circuits with real-time visualization"
                )

                featureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Track Progress",
                    description: "XP points, achievements, and learning streaks"
                )

                featureRow(
                    icon: "person.2.fill",
                    title: "Synced Account",
                    description: "Your progress syncs across SwiftQuantum apps"
                )

                featureRow(
                    icon: "certificate.fill",
                    title: "Career Passport",
                    description: "Earn verifiable quantum computing credentials"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(QuantumHorizonColors.quantumCyan.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
    }

    // MARK: - Course Preview Section
    private var coursePreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("12+ Courses Available")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    courseCard(
                        title: "Quantum Basics",
                        lessons: 8,
                        duration: "2h",
                        color: QuantumHorizonColors.quantumCyan,
                        isFree: true
                    )

                    courseCard(
                        title: "Quantum Gates",
                        lessons: 12,
                        duration: "3h",
                        color: QuantumHorizonColors.quantumPurple,
                        isFree: true
                    )

                    courseCard(
                        title: "Entanglement",
                        lessons: 10,
                        duration: "2.5h",
                        color: QuantumHorizonColors.quantumPink,
                        isFree: false
                    )

                    courseCard(
                        title: "Algorithms",
                        lessons: 15,
                        duration: "4h",
                        color: QuantumHorizonColors.quantumGold,
                        isFree: false
                    )
                }
            }
        }
    }

    private func courseCard(title: String, lessons: Int, duration: String, color: Color, isFree: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                if isFree {
                    Text("FREE")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(QuantumHorizonColors.quantumGreen)
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 10))
                    Text("\(lessons) lessons")
                        .font(.system(size: 11))
                }
                .foregroundColor(.white.opacity(0.6))

                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                    Text(duration)
                        .font(.system(size: 11))
                }
                .foregroundColor(.white.opacity(0.6))
            }

            // Progress bar placeholder
            RoundedRectangle(cornerRadius: 2)
                .fill(color.opacity(0.3))
                .frame(height: 4)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: isFree ? 60 : 0)
                }
        }
        .padding(16)
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Testimonial Section
    private var testimonialSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "quote.opening")
                .font(.system(size: 24))
                .foregroundColor(QuantumHorizonColors.quantumGold.opacity(0.5))

            Text("QuantumNative made quantum computing accessible. I went from zero to building quantum algorithms in just 2 weeks!")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .italic()

            HStack(spacing: 8) {
                Circle()
                    .fill(QuantumHorizonColors.quantumPurple)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("JK")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("James K.")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)

                    Text("Software Engineer")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
        )
    }

    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                if let url = URL(string: quantumNativeAppStoreURL) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.down.app.fill")
                        .font(.system(size: 20))

                    Text("Download QuantumNative")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [QuantumHorizonColors.quantumCyan, QuantumHorizonColors.quantumPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: QuantumHorizonColors.quantumCyan.opacity(0.4), radius: 10, y: 5)
            }

            Text("Free download · Premium courses available")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

// MARK: - Academy Detail View (Legacy - Redirect to Marketing)
struct AcademyDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        AcademyMarketingView()
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
