//
//  LearningLevel.swift
//  SwiftQuantum Learning App
//
//  Created by SwiftQuantum Team
//  Copyright © 2025 SwiftQuantum. All rights reserved.
//
//  MARK: - Data Model: Learning Level
//  Represents a single learning level/lesson in the quantum computing curriculum.
//  Each level contains concepts, objectives, and progress tracking.
//

import SwiftUI

// MARK: - Learning Level Model
/// Represents a single learning module in the curriculum
struct LearningLevel: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    /// Unique identifier for the level
    let id: Int
    
    /// Display number (1, 2, 3, etc.)
    let number: Int
    
    /// Level name (e.g., "Quantum Basics")
    let name: String
    
    /// Brief description of what this level covers
    let description: String
    
    /// Which track this level belongs to
    let track: Track
    
    /// List of learning objectives
    let learningObjectives: [String]
    
    /// Key concepts covered in this level
    let concepts: [String]
    
    /// Estimated time to complete in minutes
    let estimatedDurationMinutes: Int
    
    /// Difficulty level
    let difficulty: DifficultyLevel
    
    /// Icon name (SF Symbol)
    let iconName: String
    
    // MARK: - User Progress (mutable)
    /// Whether the user has completed this level
    var isCompleted: Bool = false
    
    /// Whether the user is currently working on this level
    var isInProgress: Bool = false
    
    /// Progress percentage (0-100)
    var progressPercentage: Int = 0
    
    /// Minutes the user has spent on this level
    var minutesSpent: Int = 0
    
    // MARK: - Equatable
    static func == (lhs: LearningLevel, rhs: LearningLevel) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Track Enum
/// Defines the learning tracks available
enum Track: String, Codable, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    /// Human-readable display name
    var displayName: String {
        switch self {
        case .beginner:
            return "Beginner Track"
        case .intermediate:
            return "Intermediate Track"
        case .advanced:
            return "Advanced Track"
        }
    }
    
    /// Short name for compact displays
    var shortName: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        }
    }
    
    /// Color associated with this track
    var color: Color {
        switch self {
        case .beginner:
            return .completed       // Green
        case .intermediate:
            return .inProgress      // Yellow
        case .advanced:
            return .quantumOrange   // Orange/Red
        }
    }
    
    /// Icon for this track
    var iconName: String {
        switch self {
        case .beginner:
            return "leaf.fill"
        case .intermediate:
            return "bolt.fill"
        case .advanced:
            return "flame.fill"
        }
    }
}

// MARK: - Difficulty Level Enum
/// Represents the difficulty of a level
enum DifficultyLevel: String, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    /// Color for difficulty indicator
    var color: Color {
        switch self {
        case .beginner:
            return .completed
        case .intermediate:
            return .inProgress
        case .advanced:
            return .quantumOrange
        }
    }
    
    /// Display text
    var displayText: String {
        rawValue.uppercased()
    }
}

// MARK: - Level Status
/// Represents the current status of a level for a user
enum LevelStatus: String, Codable {
    case locked
    case available
    case inProgress
    case completed
    
    /// Icon for this status
    var iconName: String {
        switch self {
        case .locked:
            return "lock.fill"
        case .available:
            return "circle"
        case .inProgress:
            return "circle.lefthalf.filled"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
    
    /// Color for this status
    var color: Color {
        switch self {
        case .locked:
            return .locked
        case .available:
            return .textSecondary
        case .inProgress:
            return .inProgress
        case .completed:
            return .completed
        }
    }
}

// MARK: - UI Helper Extensions
extension LearningLevel {
    
    /// Current status based on progress
    var status: LevelStatus {
        if isCompleted {
            return .completed
        } else if isInProgress {
            return .inProgress
        } else if progressPercentage > 0 {
            return .inProgress
        } else {
            return .available
        }
    }
    
    /// Icon name based on status
    var statusIconName: String {
        status.iconName
    }
    
    /// Color based on status
    var statusColor: Color {
        status.color
    }
    
    /// Formatted duration string
    var durationText: String {
        if estimatedDurationMinutes < 60 {
            return "\(estimatedDurationMinutes) min"
        } else {
            let hours = estimatedDurationMinutes / 60
            let mins = estimatedDurationMinutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
    }
    
    /// Progress text
    var progressText: String {
        "\(progressPercentage)%"
    }
    
    /// Time spent text
    var timeSpentText: String {
        "\(minutesSpent)/\(estimatedDurationMinutes) min"
    }
}

// MARK: - Sample Data
extension LearningLevel {
    
    /// All available learning levels
    static let allLevels: [LearningLevel] = [
        // MARK: Beginner Track
        LearningLevel(
            id: 1,
            number: 1,
            name: "Quantum Basics",
            description: "Learn what quantum bits are and how they differ from classical bits",
            track: .beginner,
            learningObjectives: [
                "Understand classical bit vs quantum bit",
                "Create |0⟩ and |1⟩ states",
                "Understand measurement concept"
            ],
            concepts: ["Qubit", "State", "Measurement"],
            estimatedDurationMinutes: 8,
            difficulty: .beginner,
            iconName: "atom"
        ),
        
        LearningLevel(
            id: 2,
            number: 2,
            name: "Superposition",
            description: "Understand how quantum bits can exist in multiple states simultaneously",
            track: .beginner,
            learningObjectives: [
                "Understand superposition principle",
                "Create superposition with Hadamard gate",
                "Visualize on Bloch sphere"
            ],
            concepts: ["Superposition", "Hadamard Gate", "Bloch Sphere"],
            estimatedDurationMinutes: 10,
            difficulty: .beginner,
            iconName: "waveform"
        ),
        
        LearningLevel(
            id: 3,
            number: 3,
            name: "Measurement",
            description: "Learn about quantum measurement and wavefunction collapse",
            track: .beginner,
            learningObjectives: [
                "Understand wavefunction collapse",
                "Understand probability distribution",
                "Perform statistical measurements"
            ],
            concepts: ["Measurement", "Probability", "Collapse"],
            estimatedDurationMinutes: 10,
            difficulty: .beginner,
            iconName: "gauge"
        ),
        
        // MARK: Intermediate Track
        LearningLevel(
            id: 4,
            number: 4,
            name: "Quantum Gates",
            description: "Master the fundamental quantum gates and their operations",
            track: .intermediate,
            learningObjectives: [
                "Apply Pauli-X, Y, Z gates",
                "Understand phase gates",
                "Combine multiple gates"
            ],
            concepts: ["Pauli Gates", "Phase Gate", "T Gate", "Rotation"],
            estimatedDurationMinutes: 15,
            difficulty: .intermediate,
            iconName: "square.grid.3x3"
        ),
        
        LearningLevel(
            id: 5,
            number: 5,
            name: "Quantum Circuits",
            description: "Build and execute quantum circuits with multiple gates",
            track: .intermediate,
            learningObjectives: [
                "Design quantum circuits",
                "Chain gate operations",
                "Analyze circuit outputs"
            ],
            concepts: ["Circuit", "Gate Sequence", "Execution"],
            estimatedDurationMinutes: 15,
            difficulty: .intermediate,
            iconName: "point.3.connected.trianglepath.dotted"
        ),
        
        LearningLevel(
            id: 6,
            number: 6,
            name: "Quantum Interference",
            description: "Explore constructive and destructive interference patterns",
            track: .intermediate,
            learningObjectives: [
                "Understand interference principle",
                "Create interference patterns",
                "Apply to algorithms"
            ],
            concepts: ["Interference", "Phase", "Amplitude"],
            estimatedDurationMinutes: 12,
            difficulty: .intermediate,
            iconName: "waveform.path.ecg"
        ),
        
        // MARK: Advanced Track
        LearningLevel(
            id: 7,
            number: 7,
            name: "Deutsch-Jozsa Algorithm",
            description: "Implement your first quantum algorithm with exponential speedup",
            track: .advanced,
            learningObjectives: [
                "Understand quantum oracles",
                "Implement the algorithm",
                "Compare quantum vs classical"
            ],
            concepts: ["Oracle", "Quantum Advantage", "Algorithm"],
            estimatedDurationMinutes: 20,
            difficulty: .advanced,
            iconName: "function"
        ),
        
        LearningLevel(
            id: 8,
            number: 8,
            name: "Quantum Applications",
            description: "Apply quantum computing to real-world problems",
            track: .advanced,
            learningObjectives: [
                "Build quantum RNG",
                "Implement optimization",
                "Create practical solutions"
            ],
            concepts: ["RNG", "Optimization", "Cryptography"],
            estimatedDurationMinutes: 25,
            difficulty: .advanced,
            iconName: "sparkles"
        )
    ]
    
    /// Get levels for a specific track
    static func levels(for track: Track) -> [LearningLevel] {
        allLevels.filter { $0.track == track }
    }
    
    /// Get a specific level by ID
    static func level(withId id: Int) -> LearningLevel? {
        allLevels.first { $0.id == id }
    }
}

// MARK: - Preview Provider
#Preview("Learning Level Card") {
    VStack(spacing: 16) {
        ForEach(LearningLevel.allLevels.prefix(3)) { level in
            HStack(spacing: 12) {
                // Status icon
                Image(systemName: level.statusIconName)
                    .font(.system(size: 24))
                    .foregroundColor(level.statusColor)
                    .frame(width: 40)
                
                // Level info
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(level.number): \(level.name)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Text(level.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Label(level.durationText, systemImage: "clock")
                        Label(level.difficulty.displayText, systemImage: "speedometer")
                    }
                    .font(.caption2)
                    .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                // Progress
                Text(level.progressText)
                    .font(.subheadline.bold())
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .background(Color.bgCard)
            .cornerRadius(12)
        }
    }
    .padding()
    .background(Color.bgDark)
}
