import SwiftUI
import SwiftQuantum

// MARK: - Profile Hub - "마이클"
// 글로벌 기여 지수, 설정, 성취도

struct ProfileHubView: View {
    @StateObject private var viewModel = ProfileHubViewModel()
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var showCelebration = false
    @State private var showSettings = false
    @State private var showPremiumSheet = false
    @State private var showLanguageSheet = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header with Avatar
                profileHeader

                // Global Contribution Index
                globalContributionSection

                // Achievement Badges
                achievementSection

                // Learning Stats
                learningStatsSection

                // Settings & Preferences
                settingsSection

                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .overlay(
            GoldParticleView(isActive: $showCelebration)
        )
        .sheet(isPresented: $showPremiumSheet) {
            ProfilePremiumSheet()
        }
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSelectionSheet()
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        BentoCard(size: .medium) {
            HStack(spacing: 20) {
                // Avatar with ring
                ZStack {
                    // Level ring
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    QuantumHorizonColors.quantumCyan,
                                    QuantumHorizonColors.quantumPurple,
                                    QuantumHorizonColors.quantumPink,
                                    QuantumHorizonColors.quantumCyan
                                ],
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 88, height: 88)

                    // Avatar
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    QuantumHorizonColors.quantumPurple.opacity(0.3),
                                    QuantumHorizonColors.quantumPink.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 76, height: 76)

                    Text(viewModel.userInitials)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Level badge
                    Text("Lv.\(viewModel.level)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(QuantumHorizonColors.quantumGold)
                        .clipShape(Capsule())
                        .offset(y: 38)

                    // Premium crown badge
                    if premiumManager.isPremium {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                            .padding(4)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Circle())
                            .offset(x: 28, y: -28)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(viewModel.username)
                            .font(QuantumHorizonTypography.sectionTitle(24))
                            .foregroundColor(.white)

                        if premiumManager.isPremium {
                            Text("PREMIUM")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
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

                    Text(premiumManager.isPremium ? L("profile.premium_explorer") : viewModel.title)
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(premiumManager.isPremium ? QuantumHorizonColors.quantumGold : QuantumHorizonColors.quantumPurple)

                    // Member since
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                        Text("\(L("profile.member_since")) \(viewModel.memberSince)")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                // Edit button
                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings Button", status: .success)
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
    }

    // MARK: - Global Contribution Section
    private var globalContributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(L("profile.gci.title"))
                    .font(QuantumHorizonTypography.sectionTitle(18))
                    .foregroundColor(.white)

                Spacer()

                // World rank
                HStack(spacing: 4) {
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 12))
                    Text("#\(viewModel.worldRank)")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(QuantumHorizonColors.quantumGold)
            }

            BentoCard(size: .medium) {
                VStack(spacing: 20) {
                    // GCI Score
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L("profile.gci.score"))
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))

                            Text("\(viewModel.gciScore)")
                                .font(QuantumHorizonTypography.heroTitle(48))
                                .foregroundStyle(QuantumHorizonColors.goldCelebration)
                        }

                        Spacer()

                        // Progress circle
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 8)
                                .frame(width: 80, height: 80)

                            Circle()
                                .trim(from: 0, to: CGFloat(viewModel.gciScore) / 10000)
                                .stroke(
                                    QuantumHorizonColors.miamiSunset,
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-90))

                            VStack(spacing: 2) {
                                Text(L("profile.gci.top"))
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("\(viewModel.topPercentile)%")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    Divider()
                        .background(Color.white.opacity(0.1))

                    // Contribution breakdown
                    HStack(spacing: 20) {
                        contributionItem(icon: "flask.fill", value: "\(viewModel.experimentsRun)", label: L("profile.gci.experiments"))
                        contributionItem(icon: "book.fill", value: "\(viewModel.lessonsCompleted)", label: L("profile.gci.lessons"))
                        contributionItem(icon: "cpu", value: "\(viewModel.qpuMinutes)", label: L("profile.gci.qpu_min"))
                    }
                }
            }
        }
    }

    private func contributionItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(QuantumHorizonColors.quantumCyan)

            Text(value)
                .font(QuantumHorizonTypography.statNumber(20))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Achievement Section
    private var achievementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(L("profile.achievements"))
                    .font(QuantumHorizonTypography.sectionTitle(18))
                    .foregroundColor(.white)

                Spacer()

                Text("\(viewModel.unlockedAchievements)/\(viewModel.totalAchievements)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementBadge(achievement: achievement)
                            .onTapGesture {
                                DeveloperModeManager.shared.log(
                                    screen: "Profile",
                                    element: "Achievement: \(achievement.name)",
                                    status: achievement.isUnlocked ? .success : .comingSoon
                                )
                                if achievement.isUnlocked {
                                    showCelebration = true
                                }
                            }
                    }
                }
            }
        }
    }

    // MARK: - Learning Stats Section
    private var learningStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("profile.learning_progress"))
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            HStack(spacing: 12) {
                LearningStatCard(
                    value: "\(viewModel.streakDays)",
                    label: L("profile.day_streak"),
                    icon: "flame.fill",
                    color: .orange
                )

                LearningStatCard(
                    value: "\(viewModel.totalXP)",
                    label: L("profile.total_xp"),
                    icon: "star.fill",
                    color: QuantumHorizonColors.quantumGold
                )

                LearningStatCard(
                    value: formatTime(viewModel.totalStudyTime),
                    label: L("profile.study_time"),
                    icon: "clock.fill",
                    color: QuantumHorizonColors.quantumCyan
                )
            }

            // Weekly activity chart
            BentoCard(title: L("profile.this_week"), icon: "chart.bar.fill", accentColor: QuantumHorizonColors.quantumGreen, size: .medium) {
                WeeklyActivityChart(data: viewModel.weeklyActivity)
                    .frame(height: 100)
            }
        }
    }

    private func formatTime(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        let hours = minutes / 60
        return "\(hours)h"
    }

    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("profile.settings"))
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            VStack(spacing: 2) {
                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Notifications Toggle", status: .success)
                    viewModel.notificationsEnabled.toggle()
                }) {
                    SettingsRow(icon: "bell.fill", title: L("profile.notifications"), color: .red) {
                        Toggle("", isOn: $viewModel.notificationsEnabled)
                            .tint(QuantumHorizonColors.quantumPurple)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Dark Mode Toggle", status: .success)
                    viewModel.darkModeEnabled.toggle()
                }) {
                    SettingsRow(icon: "moon.fill", title: L("profile.dark_mode"), color: .purple) {
                        Toggle("", isOn: $viewModel.darkModeEnabled)
                            .tint(QuantumHorizonColors.quantumPurple)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Language", status: .success)
                    showLanguageSheet = true
                }) {
                    SettingsRow(icon: "globe", title: localization.string(for: .language), color: .blue) {
                        HStack(spacing: 6) {
                            Text(localization.currentLanguage.flag)
                                .font(.system(size: 14))
                            Text(localization.currentLanguage.displayName)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: IBM Quantum API", status: .comingSoon)
                }) {
                    SettingsRow(icon: "key.fill", title: L("profile.api_key"), color: QuantumHorizonColors.quantumCyan) {
                        Text(viewModel.apiKeyConfigured ? L("profile.configured") : L("profile.not_set"))
                            .font(.system(size: 14))
                            .foregroundColor(viewModel.apiKeyConfigured ? QuantumHorizonColors.quantumGreen : .white.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    if premiumManager.isPremium {
                        // Toggle off premium (for testing)
                        DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Premium Status - Toggle OFF", status: .success)
                        premiumManager.togglePremium()
                    } else {
                        // Show premium sheet to upgrade
                        DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Premium Status - Upgrade", status: .success)
                        showPremiumSheet = true
                    }
                }) {
                    SettingsRow(icon: "crown.fill", title: L("profile.premium_status"), color: QuantumHorizonColors.quantumGold) {
                        HStack(spacing: 6) {
                            if premiumManager.isPremium {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                            }
                            Text(premiumManager.isPremium ? L("profile.active") : L("profile.free"))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(premiumManager.isPremium ? QuantumHorizonColors.quantumGold : .white.opacity(0.5))
                        }
                        Image(systemName: premiumManager.isPremium ? "xmark.circle" : "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(premiumManager.isPremium ? .red.opacity(0.6) : .white.opacity(0.3))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .glassmorphism(intensity: 0.06, cornerRadius: 16)
        }
    }
}

// MARK: - Achievement Badge
struct AchievementBadge: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Badge background
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        achievement.color.opacity(0.2) :
                        Color.white.opacity(0.05)
                    )
                    .frame(width: 64, height: 64)

                Circle()
                    .stroke(
                        achievement.isUnlocked ?
                        achievement.color.opacity(0.5) :
                        Color.white.opacity(0.1),
                        lineWidth: 2
                    )
                    .frame(width: 64, height: 64)

                // Icon
                Image(systemName: achievement.icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(
                        achievement.isUnlocked ?
                        achievement.color :
                        .white.opacity(0.2)
                    )
            }

            Text(achievement.name)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(
                    achievement.isUnlocked ?
                    .white :
                    .white.opacity(0.4)
                )
                .lineLimit(1)
        }
        .frame(width: 80)
        .opacity(achievement.isUnlocked ? 1 : 0.6)
    }
}

// MARK: - Learning Stat Card
struct LearningStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            Text(value)
                .font(QuantumHorizonTypography.statNumber(22))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassmorphism(intensity: 0.08, cornerRadius: 16)
    }
}

// MARK: - Weekly Activity Chart
struct WeeklyActivityChart: View {
    let data: [Int]
    let days = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                VStack(spacing: 8) {
                    // Bar
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                value > 0 ?
                                AnyShapeStyle(QuantumHorizonColors.miamiSunset) :
                                AnyShapeStyle(Color.white.opacity(0.1))
                            )
                            .frame(height: CGFloat(value) / CGFloat(data.max() ?? 1) * 60)
                    }
                    .frame(height: 70)

                    // Day label
                    Text(days[index])
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Settings Row
struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    @ViewBuilder let trailing: Content

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)

                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            trailing
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Models
struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

// MARK: - Profile Premium Sheet
struct ProfilePremiumSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var showSuccessView = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            if showSuccessView {
                UpgradeSuccessView(isPresented: $showSuccessView)
                    .transition(.opacity)
                    .onDisappear {
                        dismiss()
                    }
            } else {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: {
                            DeveloperModeManager.shared.log(screen: "Profile Premium", element: "Close Button", status: .success)
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Crown icon
                    Image(systemName: "crown.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(QuantumHorizonColors.goldCelebration)

                    Text(L("profile.upgrade_premium"))
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(.white)

                    Text(L("profile.unlock_features"))
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)

                    // Features list
                    VStack(alignment: .leading, spacing: 12) {
                        premiumFeatureRow(L("profile.feature.bridge"))
                        premiumFeatureRow(L("profile.feature.academy"))
                        premiumFeatureRow(L("profile.feature.industry"))
                        premiumFeatureRow(L("profile.feature.error"))
                        premiumFeatureRow(L("profile.feature.badge"))
                        premiumFeatureRow(L("profile.feature.support"))
                    }
                    .padding()
                    .glassmorphism(intensity: 0.08, cornerRadius: 16)

                    // Upgrade button
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Profile Premium", element: "Upgrade Button - ACTIVATED", status: .success)
                        premiumManager.upgradeToPremium()
                        withAnimation {
                            showSuccessView = true
                        }
                    }) {
                        Text(L("profile.upgrade_btn"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(QuantumHorizonColors.goldCelebration)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Text(L("profile.trial"))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))

                    Spacer()
                }
                .padding(24)
            }
        }
    }

    private func premiumFeatureRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(QuantumHorizonColors.quantumGold)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - Profile Hub ViewModel
@MainActor
class ProfileHubViewModel: ObservableObject {
    // User Info
    @Published var username = "Quantum Pioneer"
    @Published var userInitials = "QP"
    @Published var title = "Quantum Explorer"
    @Published var level = 1
    @Published var memberSince = "Jan 2026"

    // Global Contribution Index
    @Published var gciScore = 0
    @Published var worldRank = 0
    @Published var topPercentile = 100
    @Published var experimentsRun = 0
    @Published var lessonsCompleted = 0
    @Published var qpuMinutes = 0

    // Learning Stats
    @Published var streakDays = 0
    @Published var totalXP = 0
    @Published var totalStudyTime = 0 // minutes
    @Published var weeklyActivity = [0, 0, 0, 0, 0, 0, 0] // minutes per day

    // Achievements
    @Published var achievements: [Achievement] = []
    var unlockedAchievements: Int { achievements.filter { $0.isUnlocked }.count }
    var totalAchievements: Int { achievements.count }

    // Settings
    @Published var notificationsEnabled = true
    @Published var darkModeEnabled = true
    @Published var language = "English"
    @Published var apiKeyConfigured = false
    // isPremium now managed by PremiumManager.shared

    // Loading state
    @Published var isLoading = false

    init() {
        setupAchievements()
        loadFromCache()
        Task {
            await loadProfile()
        }
    }

    // MARK: - Load from Cache (UserDefaults)
    private func loadFromCache() {
        let defaults = UserDefaults.standard

        // User info
        if let name = defaults.string(forKey: "SwiftQuantum_Username"), !name.isEmpty {
            username = name
            userInitials = String(name.prefix(2)).uppercased()
        }

        // Stats
        level = max(1, defaults.integer(forKey: "SwiftQuantum_Level"))
        totalXP = defaults.integer(forKey: "SwiftQuantum_XPPoints")
        lessonsCompleted = defaults.integer(forKey: "SwiftQuantum_LessonsCompleted")
        streakDays = defaults.integer(forKey: "SwiftQuantum_Streak")
        experimentsRun = defaults.integer(forKey: "SwiftQuantum_ExperimentsRun")

        // Calculate derived values
        gciScore = calculateGCI()
        title = titleForLevel(level)
    }

    // MARK: - Load from Backend
    func loadProfile() async {
        isLoading = true

        do {
            let profile: UserProfileResponse = try await APIClient.shared.get("/api/v1/users/profile")

            // Update user info
            username = profile.username
            userInitials = String(profile.username.prefix(2)).uppercased()
            level = profile.level
            memberSince = formatMemberSince(profile.createdAt)

            // Update stats
            totalXP = profile.xpPoints
            lessonsCompleted = profile.lessonsCompleted
            streakDays = profile.streak
            experimentsRun = profile.experimentsRun
            qpuMinutes = profile.qpuMinutes
            totalStudyTime = profile.totalStudyTime

            // Calculate GCI
            gciScore = calculateGCI()
            worldRank = profile.worldRank ?? calculateWorldRank()
            topPercentile = profile.topPercentile ?? calculateTopPercentile()

            // Weekly activity
            if let activity = profile.weeklyActivity, activity.count == 7 {
                weeklyActivity = activity
            }

            // Update achievements
            updateAchievements(from: profile.achievements ?? [])

            // Derived values
            title = titleForLevel(level)
            apiKeyConfigured = profile.apiKeyConfigured ?? false

            // Cache to UserDefaults
            saveToCache()

        } catch {
            // Use cached values on error - already loaded in init
            print("Failed to load profile: \(error.localizedDescription)")
        }

        isLoading = false
    }

    // MARK: - Save to Cache
    private func saveToCache() {
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "SwiftQuantum_Username")
        defaults.set(level, forKey: "SwiftQuantum_Level")
        defaults.set(totalXP, forKey: "SwiftQuantum_XPPoints")
        defaults.set(lessonsCompleted, forKey: "SwiftQuantum_LessonsCompleted")
        defaults.set(streakDays, forKey: "SwiftQuantum_Streak")
        defaults.set(experimentsRun, forKey: "SwiftQuantum_ExperimentsRun")
    }

    // MARK: - GCI Calculation
    private func calculateGCI() -> Int {
        // Formula: (lessons * 50) + (experiments * 10) + (xp / 10) + (qpu_minutes * 5)
        return (lessonsCompleted * 50) + (experimentsRun * 10) + (totalXP / 10) + (qpuMinutes * 5)
    }

    private func calculateWorldRank() -> Int {
        // Estimate based on GCI score
        let baseUsers = 10000
        let rank = max(1, baseUsers - (gciScore / 3))
        return rank
    }

    private func calculateTopPercentile() -> Int {
        let rank = Double(worldRank)
        let totalUsers = 10000.0
        return max(1, Int((rank / totalUsers) * 100))
    }

    // MARK: - Title for Level
    private func titleForLevel(_ level: Int) -> String {
        switch level {
        case 1...2: return "Quantum Novice"
        case 3...5: return "Quantum Learner"
        case 6...10: return "Quantum Explorer"
        case 11...20: return "Quantum Adept"
        case 21...50: return "Quantum Master"
        case 51...100: return "Quantum Expert"
        default: return "Quantum Legend"
        }
    }

    // MARK: - Format Member Since
    private func formatMemberSince(_ date: Date?) -> String {
        guard let date = date else { return "Jan 2026" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Update Achievements
    private func updateAchievements(from serverAchievements: [String]) {
        let unlocked = Set(serverAchievements)
        achievements = [
            Achievement(name: "First Qubit", icon: "atom", color: QuantumHorizonColors.quantumCyan, isUnlocked: unlocked.contains("first_qubit") || experimentsRun > 0),
            Achievement(name: "Superposition", icon: "plus.forwardslash.minus", color: QuantumHorizonColors.quantumGreen, isUnlocked: unlocked.contains("superposition") || lessonsCompleted >= 1),
            Achievement(name: "Gate Master", icon: "rectangle.3.group", color: QuantumHorizonColors.quantumPurple, isUnlocked: unlocked.contains("gate_master") || lessonsCompleted >= 5),
            Achievement(name: "Entangled", icon: "link", color: QuantumHorizonColors.quantumPink, isUnlocked: unlocked.contains("entangled") || lessonsCompleted >= 10),
            Achievement(name: "Bridge Builder", icon: "cpu", color: .orange, isUnlocked: unlocked.contains("bridge_builder") || qpuMinutes > 0),
            Achievement(name: "Algorithm Pro", icon: "function", color: QuantumHorizonColors.quantumGold, isUnlocked: unlocked.contains("algorithm_pro") || experimentsRun >= 100),
            Achievement(name: "Error Buster", icon: "shield.checkered", color: .red, isUnlocked: unlocked.contains("error_buster")),
            Achievement(name: "Quantum Legend", icon: "crown.fill", color: QuantumHorizonColors.quantumGold, isUnlocked: unlocked.contains("quantum_legend") || level >= 50)
        ]
    }

    private func setupAchievements() {
        updateAchievements(from: [])
    }
}

// MARK: - API Response Models for Profile
struct UserProfileResponse: Decodable {
    let username: String
    let level: Int
    let xpPoints: Int
    let lessonsCompleted: Int
    let streak: Int
    let experimentsRun: Int
    let qpuMinutes: Int
    let totalStudyTime: Int
    let worldRank: Int?
    let topPercentile: Int?
    let weeklyActivity: [Int]?
    let achievements: [String]?
    let apiKeyConfigured: Bool?
    let createdAt: Date?
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        ProfileHubView()
    }
    .preferredColorScheme(.dark)
}
