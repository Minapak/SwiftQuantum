//
//  QuantumNativeView.swift
//  SuperpositionVisualizer - SwiftQuantum v2.1.0
//
//  Created by Eunmin Park on 2026-01-06.
//  Copyright (c) 2026 iOS Quantum Engineering. All rights reserved.
//
//  Quantum Native - MIT/Harvard-style Learning Experience
//  Premium subscription feature with psychological engagement techniques
//

import SwiftUI

// MARK: - Quantum Native Main View

struct QuantumNativeView: View {
    @StateObject private var viewModel = QuantumNativeViewModel()
    @State private var showSubscriptionSheet = false
    @State private var selectedCourse: QuantumCourse?

    var body: some View {
        NavigationView {
            ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.15),
                        Color(red: 0.1, green: 0.05, blue: 0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Premium header with MIT/Harvard branding
                        academyHeader

                        // Loss aversion banner
                        securityWarningBanner

                        // Learning tracks
                        learningTracks

                        // Featured courses
                        featuredCourses

                        // Progress tracking
                        if viewModel.isSubscribed {
                            progressSection
                        }

                        // Subscription CTA
                        if !viewModel.isSubscribed {
                            subscriptionCTA
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showSubscriptionSheet) {
            SubscriptionSheetView(viewModel: viewModel)
        }
        .sheet(item: $selectedCourse) { course in
            CourseDetailView(course: course, viewModel: viewModel)
        }
    }

    // MARK: - Academy Header

    private var academyHeader: some View {
        VStack(spacing: 16) {
            // Logo and title
            HStack {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 32))
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Quantum Native")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("MIT/Harvard Research-Based Curriculum")
                        .font(.caption)
                        .foregroundColor(QuantumPremiumColors.neonGreen)
                }

                Spacer()

                // Premium badge
                if viewModel.isSubscribed {
                    premiumBadge
                }
            }

            // Tagline with authority principle
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.yellow)
                Text("Based on Nature 2025 Publications")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    QuantumPremiumColors.cyberneticBlue.opacity(0.2),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }

    private var premiumBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.caption)
            Text("PRO")
                .font(.caption)
                .fontWeight(.bold)
        }
        .foregroundColor(.black)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            LinearGradient(
                colors: [.yellow, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }

    // MARK: - Security Warning Banner (Loss Aversion)

    private var securityWarningBanner: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.title2)
                    .foregroundColor(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Post-Quantum Security Alert")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text("Quantum computers may break current encryption by 2030")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }

            // Loss aversion message
            Text("Without quantum-resistant algorithms, your data could be vulnerable in the quantum era. Learn to protect your systems now.")
                .font(.caption)
                .foregroundColor(.orange.opacity(0.9))
                .multilineTextAlignment(.leading)

            Button(action: {
                selectedCourse = viewModel.courses.first { $0.title.contains("Security") }
            }) {
                HStack {
                    Image(systemName: "lock.shield")
                    Text("Start Security Course")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [.orange, .yellow],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Learning Tracks

    private var learningTracks: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning Tracks")
                .font(.headline)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.learningTracks) { track in
                        LearningTrackCard(track: track, isLocked: !viewModel.isSubscribed && track.isPremium)
                            .onTapGesture {
                                if viewModel.isSubscribed || !track.isPremium {
                                    // Navigate to track
                                } else {
                                    showSubscriptionSheet = true
                                }
                            }
                    }
                }
            }
        }
    }

    // MARK: - Featured Courses

    private var featuredCourses: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Featured Courses")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Text("See All")
                    .font(.subheadline)
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)
            }

            ForEach(viewModel.courses.prefix(4)) { course in
                CourseCard(course: course, isLocked: !viewModel.isSubscribed && course.isPremium)
                    .onTapGesture {
                        if viewModel.isSubscribed || !course.isPremium {
                            selectedCourse = course
                        } else {
                            showSubscriptionSheet = true
                        }
                    }
            }
        }
    }

    // MARK: - Progress Section

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 16) {
                ProgressStatCard(
                    title: "Courses",
                    value: "\(viewModel.completedCourses)",
                    total: "\(viewModel.totalCourses)",
                    icon: "book.fill",
                    color: QuantumPremiumColors.cyberneticBlue
                )

                ProgressStatCard(
                    title: "Streak",
                    value: "\(viewModel.streakDays)",
                    total: "days",
                    icon: "flame.fill",
                    color: .orange
                )

                ProgressStatCard(
                    title: "Points",
                    value: "\(viewModel.totalPoints)",
                    total: "XP",
                    icon: "star.fill",
                    color: .yellow
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    // MARK: - Subscription CTA

    private var subscriptionCTA: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock Premium")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Access all courses and features")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Image(systemName: "crown.fill")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
            }

            // Features list
            VStack(alignment: .leading, spacing: 8) {
                FeatureRow(text: "1000+ qubit simulations", icon: "cpu")
                FeatureRow(text: "Harvard-MIT research curriculum", icon: "graduationcap")
                FeatureRow(text: "QuantumBridge QPU access", icon: "link")
                FeatureRow(text: "Industry solution templates", icon: "briefcase")
            }

            // Price and CTA
            Button(action: { showSubscriptionSheet = true }) {
                HStack {
                    Text("Start Free Trial")
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }

            Text("7-day free trial, then $9.99/month")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.3),
                    Color.blue.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.yellow.opacity(0.5), .orange.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(20)
    }
}

// MARK: - Learning Track Card

struct LearningTrackCard: View {
    let track: LearningTrack
    let isLocked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(track.color.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: track.icon)
                    .font(.title2)
                    .foregroundColor(track.color)

                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .offset(x: 20, y: -20)
                }
            }

            Text(track.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("\(track.courseCount) courses")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(track.color)
                        .frame(width: geometry.size.width * track.progress, height: 4)
                }
            }
            .frame(height: 4)
        }
        .frame(width: 140)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .opacity(isLocked ? 0.7 : 1.0)
    }
}

// MARK: - Course Card

struct CourseCard: View {
    let course: QuantumCourse
    let isLocked: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Course icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(course.color.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: course.icon)
                    .font(.title2)
                    .foregroundColor(course.color)
            }

            // Course info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(course.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    if course.isPremium {
                        Text("PRO")
                            .font(.system(size: 9))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.yellow)
                            .cornerRadius(4)
                    }
                }

                Text(course.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)

                HStack {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(course.duration)
                        .font(.caption2)

                    Spacer()

                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text(String(format: "%.1f", course.rating))
                            .font(.caption2)
                    }
                }
                .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            // Lock or arrow
            Image(systemName: isLocked ? "lock.fill" : "chevron.right")
                .foregroundColor(isLocked ? .orange : .white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .opacity(isLocked ? 0.8 : 1.0)
    }
}

// MARK: - Progress Stat Card

struct ProgressStatCard: View {
    let title: String
    let value: String
    let total: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(total)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))

            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(QuantumPremiumColors.neonGreen)

            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 20)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

// MARK: - Subscription Sheet View

struct SubscriptionSheetView: View {
    @ObservedObject var viewModel: QuantumNativeViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                // Header
                VStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)

                    Text("Quantum Native Pro")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Unlock the full potential of quantum learning")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }

                // Plan options
                VStack(spacing: 12) {
                    SubscriptionPlanCard(
                        name: "Monthly",
                        price: "$9.99",
                        period: "per month",
                        isPopular: false
                    )

                    SubscriptionPlanCard(
                        name: "Annual",
                        price: "$79.99",
                        period: "per year",
                        isPopular: true,
                        savings: "Save 33%"
                    )
                }

                // Subscribe button
                Button(action: {
                    viewModel.subscribe()
                    dismiss()
                }) {
                    Text("Start 7-Day Free Trial")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }

                // Terms
                Text("Cancel anytime. Terms and conditions apply.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))

                Spacer()
            }
            .padding()
        }
    }
}

struct SubscriptionPlanCard: View {
    let name: String
    let price: String
    let period: String
    let isPopular: Bool
    var savings: String? = nil

    @State private var isSelected = false

    var body: some View {
        Button(action: { isSelected.toggle() }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(name)
                            .font(.headline)
                            .foregroundColor(.white)

                        if isPopular {
                            Text("BEST VALUE")
                                .font(.system(size: 9))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.yellow)
                                .cornerRadius(4)
                        }
                    }

                    if let savings = savings {
                        Text(savings)
                            .font(.caption)
                            .foregroundColor(QuantumPremiumColors.neonGreen)
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(price)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(period)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? QuantumPremiumColors.neonGreen : .white.opacity(0.3))
                    .font(.title2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? QuantumPremiumColors.cyberneticBlue : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
    }
}

// MARK: - Course Detail View

struct CourseDetailView: View {
    let course: QuantumCourse
    @ObservedObject var viewModel: QuantumNativeViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Course header
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: course.icon)
                                .font(.system(size: 40))
                                .foregroundColor(course.color)

                            Text(course.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(course.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()

                        // Course modules
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Course Modules")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            ForEach(course.modules) { module in
                                ModuleRow(module: module)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct ModuleRow: View {
    let module: CourseModule

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(module.isCompleted ? Color.green : Color.white.opacity(0.1))
                    .frame(width: 32, height: 32)

                if module.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundColor(.white)
                } else {
                    Text("\(module.order)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(module.title)
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text(module.duration)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Image(systemName: module.isLocked ? "lock.fill" : "play.fill")
                .foregroundColor(module.isLocked ? .orange : QuantumPremiumColors.cyberneticBlue)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - View Model

@MainActor
class QuantumNativeViewModel: ObservableObject {
    @Published var isSubscribed = false
    @Published var completedCourses = 2
    @Published var totalCourses = 12
    @Published var streakDays = 5
    @Published var totalPoints = 1250
    @Published var learningTracks: [LearningTrack] = []
    @Published var courses: [QuantumCourse] = []

    init() {
        setupData()
    }

    func setupData() {
        learningTracks = [
            LearningTrack(name: "Fundamentals", icon: "atom", color: .blue, courseCount: 4, progress: 0.75, isPremium: false),
            LearningTrack(name: "Algorithms", icon: "function", color: .purple, courseCount: 3, progress: 0.33, isPremium: true),
            LearningTrack(name: "Hardware", icon: "cpu", color: .orange, courseCount: 2, progress: 0.0, isPremium: true),
            LearningTrack(name: "Security", icon: "lock.shield", color: .red, courseCount: 3, progress: 0.0, isPremium: true)
        ]

        courses = [
            QuantumCourse(
                title: "Quantum Basics",
                description: "Learn the fundamentals of quantum mechanics and qubits",
                icon: "atom",
                color: .blue,
                duration: "2h 30m",
                rating: 4.8,
                isPremium: false,
                modules: [
                    CourseModule(title: "What is a Qubit?", duration: "15 min", order: 1, isCompleted: true, isLocked: false),
                    CourseModule(title: "Superposition", duration: "20 min", order: 2, isCompleted: false, isLocked: false),
                    CourseModule(title: "Entanglement", duration: "25 min", order: 3, isCompleted: false, isLocked: false)
                ]
            ),
            QuantumCourse(
                title: "Grover's Algorithm",
                description: "Master quantum search with quadratic speedup",
                icon: "magnifyingglass",
                color: .purple,
                duration: "1h 45m",
                rating: 4.9,
                isPremium: true,
                modules: [
                    CourseModule(title: "Classical vs Quantum Search", duration: "15 min", order: 1, isCompleted: false, isLocked: true),
                    CourseModule(title: "Oracle Construction", duration: "20 min", order: 2, isCompleted: false, isLocked: true)
                ]
            ),
            QuantumCourse(
                title: "Post-Quantum Security",
                description: "Prepare for the quantum-resistant cryptography era",
                icon: "lock.shield",
                color: .red,
                duration: "3h 15m",
                rating: 4.7,
                isPremium: true,
                modules: [
                    CourseModule(title: "Quantum Threat Landscape", duration: "20 min", order: 1, isCompleted: false, isLocked: true),
                    CourseModule(title: "Lattice-Based Cryptography", duration: "30 min", order: 2, isCompleted: false, isLocked: true)
                ]
            ),
            QuantumCourse(
                title: "Error Correction",
                description: "Harvard-MIT research on fault-tolerant computing",
                icon: "shield.checkered",
                color: .cyan,
                duration: "2h 00m",
                rating: 4.9,
                isPremium: true,
                modules: [
                    CourseModule(title: "Surface Codes", duration: "25 min", order: 1, isCompleted: false, isLocked: true),
                    CourseModule(title: "Magic State Distillation", duration: "30 min", order: 2, isCompleted: false, isLocked: true)
                ]
            )
        ]
    }

    func subscribe() {
        isSubscribed = true
    }
}

// MARK: - Models

struct LearningTrack: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let courseCount: Int
    let progress: Double
    let isPremium: Bool
}

struct QuantumCourse: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let duration: String
    let rating: Double
    let isPremium: Bool
    let modules: [CourseModule]
}

struct CourseModule: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let order: Int
    let isCompleted: Bool
    let isLocked: Bool
}

// MARK: - Preview

struct QuantumNativeView_Previews: PreviewProvider {
    static var previews: some View {
        QuantumNativeView()
            .preferredColorScheme(.dark)
    }
}
