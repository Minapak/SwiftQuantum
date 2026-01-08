import SwiftUI

// MARK: - Profile Hub - "마이클"
// 글로벌 기여 지수, 설정, 성취도

struct ProfileHubView: View {
    @StateObject private var viewModel = ProfileHubViewModel()
    @State private var showCelebration = false
    @State private var showSettings = false

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
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.username)
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(.white)

                    Text(viewModel.title)
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(QuantumHorizonColors.quantumPurple)

                    // Member since
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                        Text("Member since \(viewModel.memberSince)")
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
                Text("Global Contribution Index")
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
                            Text("GCI Score")
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
                                Text("Top")
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
                        contributionItem(icon: "flask.fill", value: "\(viewModel.experimentsRun)", label: "Experiments")
                        contributionItem(icon: "book.fill", value: "\(viewModel.lessonsCompleted)", label: "Lessons")
                        contributionItem(icon: "cpu", value: "\(viewModel.qpuMinutes)", label: "QPU Min")
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
                Text("Achievements")
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
            Text("Learning Progress")
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            HStack(spacing: 12) {
                LearningStatCard(
                    value: "\(viewModel.streakDays)",
                    label: "Day Streak",
                    icon: "flame.fill",
                    color: .orange
                )

                LearningStatCard(
                    value: "\(viewModel.totalXP)",
                    label: "Total XP",
                    icon: "star.fill",
                    color: QuantumHorizonColors.quantumGold
                )

                LearningStatCard(
                    value: formatTime(viewModel.totalStudyTime),
                    label: "Study Time",
                    icon: "clock.fill",
                    color: QuantumHorizonColors.quantumCyan
                )
            }

            // Weekly activity chart
            BentoCard(title: "This Week", icon: "chart.bar.fill", accentColor: QuantumHorizonColors.quantumGreen, size: .medium) {
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
            Text("Settings")
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            VStack(spacing: 2) {
                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Notifications Toggle", status: .success)
                    viewModel.notificationsEnabled.toggle()
                }) {
                    SettingsRow(icon: "bell.fill", title: "Notifications", color: .red) {
                        Toggle("", isOn: $viewModel.notificationsEnabled)
                            .tint(QuantumHorizonColors.quantumPurple)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Dark Mode Toggle", status: .success)
                    viewModel.darkModeEnabled.toggle()
                }) {
                    SettingsRow(icon: "moon.fill", title: "Dark Mode", color: .purple) {
                        Toggle("", isOn: $viewModel.darkModeEnabled)
                            .tint(QuantumHorizonColors.quantumPurple)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Language", status: .comingSoon)
                }) {
                    SettingsRow(icon: "globe", title: "Language", color: .blue) {
                        Text(viewModel.language)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: IBM Quantum API", status: .comingSoon)
                }) {
                    SettingsRow(icon: "key.fill", title: "IBM Quantum API", color: QuantumHorizonColors.quantumCyan) {
                        Text(viewModel.apiKeyConfigured ? "Configured" : "Not set")
                            .font(.system(size: 14))
                            .foregroundColor(viewModel.apiKeyConfigured ? QuantumHorizonColors.quantumGreen : .white.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    DeveloperModeManager.shared.log(screen: "Profile", element: "Settings: Premium Status", status: .comingSoon)
                }) {
                    SettingsRow(icon: "crown.fill", title: "Premium Status", color: QuantumHorizonColors.quantumGold) {
                        Text(viewModel.isPremium ? "Active" : "Free")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(viewModel.isPremium ? QuantumHorizonColors.quantumGold : .white.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
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

// MARK: - Profile Hub ViewModel
@MainActor
class ProfileHubViewModel: ObservableObject {
    // User Info
    @Published var username = "Quantum Pioneer"
    @Published var userInitials = "QP"
    @Published var title = "Quantum Explorer"
    @Published var level = 8
    @Published var memberSince = "Jan 2025"

    // Global Contribution Index
    @Published var gciScore = 2847
    @Published var worldRank = 1247
    @Published var topPercentile = 12
    @Published var experimentsRun = 342
    @Published var lessonsCompleted = 28
    @Published var qpuMinutes = 156

    // Learning Stats
    @Published var streakDays = 12
    @Published var totalXP = 4580
    @Published var totalStudyTime = 840 // minutes
    @Published var weeklyActivity = [45, 60, 30, 75, 90, 0, 20] // minutes per day

    // Achievements
    @Published var achievements: [Achievement] = []
    var unlockedAchievements: Int { achievements.filter { $0.isUnlocked }.count }
    var totalAchievements: Int { achievements.count }

    // Settings
    @Published var notificationsEnabled = true
    @Published var darkModeEnabled = true
    @Published var language = "English"
    @Published var apiKeyConfigured = false
    @Published var isPremium = false

    init() {
        setupAchievements()
    }

    private func setupAchievements() {
        achievements = [
            Achievement(name: "First Qubit", icon: "atom", color: QuantumHorizonColors.quantumCyan, isUnlocked: true),
            Achievement(name: "Superposition", icon: "plus.forwardslash.minus", color: QuantumHorizonColors.quantumGreen, isUnlocked: true),
            Achievement(name: "Gate Master", icon: "rectangle.3.group", color: QuantumHorizonColors.quantumPurple, isUnlocked: true),
            Achievement(name: "Entangled", icon: "link", color: QuantumHorizonColors.quantumPink, isUnlocked: true),
            Achievement(name: "Bridge Builder", icon: "cpu", color: .orange, isUnlocked: false),
            Achievement(name: "Algorithm Pro", icon: "function", color: QuantumHorizonColors.quantumGold, isUnlocked: false),
            Achievement(name: "Error Buster", icon: "shield.checkered", color: .red, isUnlocked: false),
            Achievement(name: "Quantum Legend", icon: "crown.fill", color: QuantumHorizonColors.quantumGold, isUnlocked: false)
        ]
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        ProfileHubView()
    }
    .preferredColorScheme(.dark)
}
