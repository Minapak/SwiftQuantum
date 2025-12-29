//
//  AchievementViewModel.swift
//  SwiftQuantum Learning App
//
//  Created by SwiftQuantum Team
//  Copyright © 2025 SwiftQuantum. All rights reserved.
//
//  MARK: - ViewModel: Achievements
//  Manages achievement data and synchronizes with user progress.
//  Provides categorized and filtered views of achievements.
//

import SwiftUI
import Combine

// MARK: - Achievement ViewModel
/// ViewModel for managing achievements
@MainActor
class AchievementViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// All achievements with unlock status
    @Published private(set) var achievements: [Achievement] = []
    
    /// Selected category filter
    @Published var selectedCategory: Category?
    
    /// Selected rarity filter
    @Published var selectedRarity: Rarity?
    
    /// Whether to show only unlocked achievements
    @Published var showUnlockedOnly: Bool = false
    
    /// Recently unlocked achievement (for notifications)
    @Published var recentlyUnlocked: Achievement?
    
    /// Loading state
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Computed Properties
    
    /// Unlocked achievements count
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    /// Total achievements count
    var totalCount: Int {
        achievements.count
    }
    
    /// Completion percentage
    var completionPercentage: Int {
        totalCount > 0 ? (unlockedCount * 100) / totalCount : 0
    }
    
    /// Total XP from achievements
    var totalAchievementXP: Int {
        achievements.filter { $0.isUnlocked }.reduce(0) { $0 + $1.xpReward }
    }
    
    /// Potential XP (from all achievements)
    var potentialXP: Int {
        achievements.reduce(0) { $0 + $1.xpReward }
    }
    
    /// Filtered achievements based on current filters
    var filteredAchievements: [Achievement] {
        var result = achievements
        
        // Filter by category
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Filter by rarity
        if let rarity = selectedRarity {
            result = result.filter { $0.rarity == rarity }
        }
        
        // Filter by unlock status
        if showUnlockedOnly {
            result = result.filter { $0.isUnlocked }
        }
        
        return result
    }
    
    /// Achievements grouped by category
    var achievementsByCategory: [Category: [Achievement]] {
        Dictionary(grouping: achievements) { $0.category }
    }
    
    /// Achievements grouped by rarity
    var achievementsByRarity: [Rarity: [Achievement]] {
        Dictionary(grouping: achievements) { $0.rarity }
    }
    
    /// Unlocked achievements only
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    /// Locked achievements only
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    /// Most recently unlocked achievements (up to 3)
    var recentUnlocks: [Achievement] {
        unlockedAchievements
            .sorted { ($0.unlockedDate ?? .distantPast) > ($1.unlockedDate ?? .distantPast) }
            .prefix(3)
            .map { $0 }
    }
    
    /// Next achievement to unlock (lowest XP, not yet unlocked)
    var nextToUnlock: Achievement? {
        lockedAchievements
            .sorted { $0.xpReward < $1.xpReward }
            .first
    }
    
    // MARK: - Initialization
    
    init() {
        loadAchievements()
    }
    
    // MARK: - Data Loading
    
    /// Load all achievements
    func loadAchievements() {
        isLoading = true
        
        // Load base achievements
        achievements = Achievement.allAchievements
        
        isLoading = false
    }
    
    /// Sync with user progress to update unlock status
    /// - Parameter userProgress: The user's progress data
    func syncWithUserProgress(_ userProgress: UserProgress) {
        for (index, achievement) in achievements.enumerated() {
            if userProgress.isAchievementUnlocked(achievement.id) {
                // Mark as unlocked with a date
                achievements[index].unlockedDate = Date() // In real app, would store actual unlock date
            }
        }
    }
    
    /// Sync with unlocked IDs
    /// - Parameter unlockedIds: Set of unlocked achievement IDs
    func syncWithUnlockedIds(_ unlockedIds: Set<String>) {
        for (index, achievement) in achievements.enumerated() {
            if unlockedIds.contains(achievement.id) {
                achievements[index].unlockedDate = Date()
            }
        }
    }
    
    // MARK: - Filtering
    
    /// Set category filter
    /// - Parameter category: Category to filter by (nil for all)
    func filterByCategory(_ category: Category?) {
        selectedCategory = category
        QuantumTheme.Haptics.selection()
    }
    
    /// Set rarity filter
    /// - Parameter rarity: Rarity to filter by (nil for all)
    func filterByRarity(_ rarity: Rarity?) {
        selectedRarity = rarity
        QuantumTheme.Haptics.selection()
    }
    
    /// Toggle showing only unlocked
    func toggleUnlockedOnly() {
        showUnlockedOnly.toggle()
        QuantumTheme.Haptics.selection()
    }
    
    /// Clear all filters
    func clearFilters() {
        selectedCategory = nil
        selectedRarity = nil
        showUnlockedOnly = false
    }
    
    // MARK: - Achievement Lookup
    
    /// Get achievement by ID
    /// - Parameter id: Achievement ID
    /// - Returns: Achievement if found
    func achievement(withId id: String) -> Achievement? {
        achievements.first { $0.id == id }
    }
    
    /// Check if achievement is unlocked
    /// - Parameter id: Achievement ID
    /// - Returns: True if unlocked
    func isUnlocked(_ id: String) -> Bool {
        achievement(withId: id)?.isUnlocked ?? false
    }
    
    // MARK: - Statistics
    
    /// Get stats for a category
    /// - Parameter category: The category
    /// - Returns: Tuple of (unlocked, total)
    func stats(for category: Category) -> (unlocked: Int, total: Int) {
        let categoryAchievements = achievements.filter { $0.category == category }
        let unlocked = categoryAchievements.filter { $0.isUnlocked }.count
        return (unlocked, categoryAchievements.count)
    }
    
    /// Get stats for a rarity
    /// - Parameter rarity: The rarity
    /// - Returns: Tuple of (unlocked, total)
    func stats(for rarity: Rarity) -> (unlocked: Int, total: Int) {
        let rarityAchievements = achievements.filter { $0.rarity == rarity }
        let unlocked = rarityAchievements.filter { $0.isUnlocked }.count
        return (unlocked, rarityAchievements.count)
    }
}

// MARK: - Preview Helper
extension AchievementViewModel {
    /// Sample ViewModel for previews
    static var sample: AchievementViewModel {
        let vm = AchievementViewModel()
        // Unlock some achievements
        let unlockedIds: Set<String> = ["first_lesson", "week_warrior", "xp_500", "hour_scholar"]
        vm.syncWithUnlockedIds(unlockedIds)
        return vm
    }
}

// MARK: - Preview Provider
#Preview("Achievement ViewModel Demo") {
    struct AchievementDemo: View {
        @StateObject private var viewModel = AchievementViewModel.sample
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Summary Card
                        HStack(spacing: 24) {
                            VStack(spacing: 4) {
                                Text("\(viewModel.unlockedCount)")
                                    .font(.title.bold())
                                    .foregroundColor(.quantumCyan)
                                Text("Unlocked")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(viewModel.completionPercentage)%")
                                    .font(.title.bold())
                                    .foregroundColor(.completed)
                                Text("Complete")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(viewModel.totalAchievementXP)")
                                    .font(.title.bold())
                                    .foregroundColor(.quantumOrange)
                                Text("XP Earned")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.bgCard)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Category Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                CategoryButton(
                                    title: "All",
                                    isSelected: viewModel.selectedCategory == nil,
                                    color: .quantumCyan
                                ) {
                                    viewModel.filterByCategory(nil)
                                }
                                
                                ForEach(Category.allCases, id: \.self) { category in
                                    let stats = viewModel.stats(for: category)
                                    CategoryButton(
                                        title: "\(category.displayName) (\(stats.unlocked)/\(stats.total))",
                                        isSelected: viewModel.selectedCategory == category,
                                        color: category.color
                                    ) {
                                        viewModel.filterByCategory(category)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Achievement Grid
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                            ForEach(viewModel.filteredAchievements) { achievement in
                                VStack(spacing: 8) {
                                    achievement.iconView
                                    
                                    Text(achievement.title)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(achievement.isUnlocked ? .textPrimary : .textTertiary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    if achievement.isUnlocked {
                                        Text("+\(achievement.xpReward) XP")
                                            .font(.caption2)
                                            .foregroundColor(.quantumCyan)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color.bgDark)
                .navigationTitle("Achievements")
            }
        }
    }
    
    return AchievementDemo()
}

// Helper view for category buttons
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? color.opacity(0.2) : Color.bgCard)
                .foregroundColor(isSelected ? color : .textSecondary)
                .cornerRadius(8)
        }
    }
}
