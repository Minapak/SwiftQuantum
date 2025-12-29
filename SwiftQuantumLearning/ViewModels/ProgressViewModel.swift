//
//  ProgressViewModel.swift
//  SwiftQuantum Learning App
//
//  Created by SwiftQuantum Team
//  Copyright © 2025 SwiftQuantum. All rights reserved.
//
//  MARK: - ViewModel: Progress
//  Manages user progress state and provides computed properties
//  for the UI. Acts as the source of truth for progress data.
//

import SwiftUI
import Combine

// MARK: - Progress ViewModel
/// ViewModel for managing and exposing user progress
@MainActor
class ProgressViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The underlying user progress data
    @Published private(set) var userProgress: UserProgress
    
    /// Current level the user is working on
    @Published private(set) var currentLevel: LearningLevel?
    
    /// Today's daily challenge
    @Published private(set) var dailyChallenge: DailyChallenge
    
    /// Latest unlocked achievement (for showing notifications)
    @Published var latestAchievement: Achievement?
    
    /// Whether to show achievement notification
    @Published var showAchievementNotification: Bool = false
    
    /// Loading state
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Computed Properties
    
    /// User's display name
    var userName: String {
        userProgress.userName
    }
    
    /// Current streak count
    var streak: Int {
        userProgress.currentStreak
    }
    
    /// Streak emoji
    var streakEmoji: String {
        userProgress.streakEmoji
    }
    
    /// Total XP
    var totalXP: Int {
        userProgress.totalXP
    }
    
    /// User level
    var userLevel: Int {
        userProgress.userLevel
    }
    
    /// Progress within current level (0.0 - 1.0)
    var levelProgress: Double {
        userProgress.levelProgress
    }
    
    /// XP until next level
    var xpUntilNextLevel: Int {
        userProgress.xpUntilNextLevel
    }
    
    /// Current level name
    var currentLevelName: String {
        currentLevel?.name ?? "Complete!"
    }
    
    /// Current level progress percentage
    var currentLevelProgressPercent: Int {
        userProgress.currentLevelProgress
    }
    
    /// Minutes completed in current level
    var minutesCompleted: Int {
        userProgress.totalStudyMinutes
    }
    
    /// Estimated total minutes for current level
    var minutesTotal: Int {
        currentLevel?.estimatedDurationMinutes ?? 10
    }
    
    /// Whether daily challenge is completed
    var isDailyChallengeCompleted: Bool {
        userProgress.dailyChallengeCompletedToday
    }
    
    /// Number of completed levels
    var completedLevelsCount: Int {
        userProgress.completedLevelsCount
    }
    
    /// Total number of levels
    var totalLevelsCount: Int {
        userProgress.totalLevelsCount
    }
    
    /// Total study time text
    var studyTimeText: String {
        userProgress.studyTimeText
    }
    
    // MARK: - Initialization
    
    init() {
        // Initialize with stored progress or new progress
        self.userProgress = UserProgress()
        self.dailyChallenge = DailyChallenge.todaysChallenge()
        
        // Load data
        loadProgress()
    }
    
    // MARK: - Data Loading
    
    /// Load progress from storage
    func loadProgress() {
        isLoading = true
        
        // Load user progress (already loads from UserDefaults in init)
        userProgress.load()
        
        // Update current level
        updateCurrentLevel()
        
        // Update daily challenge
        updateDailyChallenge()
        
        isLoading = false
    }
    
    /// Update the current level reference
    private func updateCurrentLevel() {
        if let currentId = userProgress.currentLevelId,
           let level = LearningLevel.level(withId: currentId) {
            currentLevel = level
        } else {
            // Find first incomplete level
            currentLevel = LearningLevel.allLevels.first { level in
                !userProgress.isLevelCompleted(level.id)
            }
            
            // Update the stored current level ID
            if let level = currentLevel {
                userProgress.currentLevelId = level.id
                userProgress.save()
            }
        }
    }
    
    /// Update daily challenge
    private func updateDailyChallenge() {
        dailyChallenge = DailyChallenge.todaysChallenge()
        userProgress.checkDailyChallengeReset()
    }
    
    // MARK: - User Actions
    
    /// Add XP to user progress
    /// - Parameter amount: Amount of XP to add
    func addXP(_ amount: Int) {
        let leveledUp = userProgress.addXP(amount)
        
        if leveledUp {
            // Could trigger level up animation/notification
            QuantumTheme.Haptics.success()
        } else {
            QuantumTheme.Haptics.light()
        }
    }
    
    /// Complete the current level
    func completeCurrentLevel() {
        guard let level = currentLevel else { return }
        
        userProgress.completeLevel(level.id)
        updateCurrentLevel()
        
        QuantumTheme.Haptics.success()
        
        // Check for new achievements
        checkForNewAchievements()
    }
    
    /// Update current level progress
    /// - Parameter progress: Progress percentage (0-100)
    func updateLevelProgress(_ progress: Int) {
        userProgress.updateLevelProgress(progress)
        
        if progress >= 100 {
            completeCurrentLevel()
        }
    }
    
    /// Start a specific level
    /// - Parameter level: The level to start
    func startLevel(_ level: LearningLevel) {
        userProgress.startLevel(level.id)
        currentLevel = level
        
        QuantumTheme.Haptics.selection()
    }
    
    /// Complete daily challenge
    func completeDailyChallenge() {
        guard !isDailyChallengeCompleted else { return }
        
        userProgress.completeDailyChallenge()
        
        QuantumTheme.Haptics.success()
        
        // Check for new achievements
        checkForNewAchievements()
    }
    
    /// Add study time
    /// - Parameter minutes: Minutes to add
    func addStudyTime(_ minutes: Int) {
        userProgress.addStudyTime(minutes)
    }
    
    /// Update user name
    /// - Parameter name: New user name
    func updateUserName(_ name: String) {
        userProgress.userName = name
        userProgress.save()
    }
    
    // MARK: - Achievement Checking
    
    /// Check for newly unlocked achievements
    private func checkForNewAchievements() {
        let previousAchievements = userProgress.unlockedAchievementIds
        
        // Trigger achievement check in UserProgress
        // (This happens automatically in addXP, completeLevel, etc.)
        
        // Find newly unlocked achievements
        let newAchievements = userProgress.unlockedAchievementIds.subtracting(previousAchievements)
        
        if let newId = newAchievements.first,
           let achievement = Achievement.achievement(withId: newId) {
            showAchievementNotification(achievement)
        }
    }
    
    /// Show achievement notification
    /// - Parameter achievement: The achievement to show
    private func showAchievementNotification(_ achievement: Achievement) {
        latestAchievement = achievement
        showAchievementNotification = true
        
        // Hide after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.showAchievementNotification = false
        }
    }
    
    // MARK: - Level Queries
    
    /// Check if a level is completed
    /// - Parameter levelId: ID of the level
    /// - Returns: True if completed
    func isLevelCompleted(_ levelId: Int) -> Bool {
        userProgress.isLevelCompleted(levelId)
    }
    
    /// Check if a level is unlocked
    /// - Parameter level: The level to check
    /// - Returns: True if unlocked
    func isLevelUnlocked(_ level: LearningLevel) -> Bool {
        userProgress.isLevelUnlocked(level)
    }
    
    /// Get status for a level
    /// - Parameter level: The level to check
    /// - Returns: The level's status
    func statusFor(_ level: LearningLevel) -> LevelStatus {
        if isLevelCompleted(level.id) {
            return .completed
        } else if level.id == currentLevel?.id {
            return .inProgress
        } else if isLevelUnlocked(level) {
            return .available
        } else {
            return .locked
        }
    }
    
    // MARK: - Reset (for testing)
    
    /// Reset all progress
    func resetProgress() {
        userProgress.reset()
        updateCurrentLevel()
        updateDailyChallenge()
    }
}

// MARK: - Preview Helper
extension ProgressViewModel {
    /// Sample ViewModel for previews
    static var sample: ProgressViewModel {
        let vm = ProgressViewModel()
        vm.userProgress.userName = "Alex"
        vm.userProgress.totalXP = 750
        vm.userProgress.currentStreak = 5
        vm.userProgress.completedLevelIds = [1, 2]
        vm.userProgress.totalStudyMinutes = 45
        vm.userProgress.currentLevelId = 3
        vm.userProgress.currentLevelProgress = 35
        vm.updateCurrentLevel()
        return vm
    }
}

// MARK: - Preview Provider
#Preview("Progress ViewModel Demo") {
    struct ProgressDemo: View {
        @StateObject private var viewModel = ProgressViewModel.sample
        
        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    // XP & Level Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Level \(viewModel.userLevel)")
                            .font(.headline)
                            .foregroundColor(.quantumCyan)
                        
                        HStack {
                            Text("\(viewModel.totalXP) XP")
                                .font(.title2.bold())
                            
                            Spacer()
                            
                            Text("\(viewModel.xpUntilNextLevel) to next")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        ProgressView(value: viewModel.levelProgress)
                            .tint(.quantumCyan)
                    }
                    .padding()
                    .background(Color.bgCard)
                    .cornerRadius(12)
                    
                    // Current Level
                    if let level = viewModel.currentLevel {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Level")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text(level.name)
                                .font(.headline)
                            
                            Text("\(viewModel.currentLevelProgressPercent)% complete")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.bgCard)
                        .cornerRadius(12)
                    }
                    
                    // Stats
                    HStack(spacing: 16) {
                        StatCard(title: "Streak", value: "\(viewModel.streak)", icon: "flame.fill", color: .orange)
                        StatCard(title: "Levels", value: "\(viewModel.completedLevelsCount)/\(viewModel.totalLevelsCount)", icon: "checkmark.circle.fill", color: .completed)
                    }
                    
                    // Actions
                    VStack(spacing: 12) {
                        Button("Add 50 XP") {
                            viewModel.addXP(50)
                        }
                        .buttonStyle(.quantumPrimary)
                        
                        Button("Complete Daily Challenge") {
                            viewModel.completeDailyChallenge()
                        }
                        .buttonStyle(.quantumSecondary)
                        .disabled(viewModel.isDailyChallengeCompleted)
                    }
                }
                .padding()
            }
            .background(Color.bgDark)
        }
    }
    
    return ProgressDemo()
}

// Helper view for preview
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.bgCard)
        .cornerRadius(12)
    }
}
