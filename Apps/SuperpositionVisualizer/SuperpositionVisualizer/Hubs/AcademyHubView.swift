import SwiftUI

// MARK: - Academy Hub - "The Learning Journey"
// 행성계를 탐험하는 듯한 노드(Node)형 지도 스타일
// MIT/Harvard 커리큘럼 기반의 Quantum Odyssey 맵

struct AcademyHubView: View {
    @StateObject private var viewModel = AcademyViewModel()
    @ObservedObject var premiumManager = PremiumManager.shared
    @Namespace private var animation
    @State private var selectedLevel: LearningLevel?
    @State private var showLevelDetail = false
    @State private var showPremiumSheet = false

    var body: some View {
        ZStack {
            // Odyssey Map (Node-based navigation)
            odysseyMapView

            // Level Detail Popup
            if let level = selectedLevel, showLevelDetail {
                levelDetailPopup(level: level)
            }

            // AI Agent Message Bubble
            if viewModel.showAgentMessage {
                agentMessageBubble
            }
        }
        .sheet(isPresented: $showPremiumSheet) {
            AcademyPremiumSheet()
        }
        .onChange(of: premiumManager.isPremium) { _, newValue in
            if newValue {
                viewModel.unlockAllLevels()
            }
        }
        .onAppear {
            if premiumManager.isPremium {
                viewModel.unlockAllLevels()
            }
        }
    }

    // MARK: - Odyssey Map View
    private var odysseyMapView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header with XP Progress
                progressHeader

                // Learning Path (Node Graph)
                learningPathView

                // Stats Section
                statsSection

                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }

    // MARK: - Progress Header
    private var progressHeader: some View {
        BentoCard(size: .medium) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Level \(viewModel.currentLevel)")
                            .font(QuantumHorizonTypography.heroTitle(36))
                            .foregroundStyle(QuantumHorizonColors.miamiSunset)

                        Text("Quantum Explorer")
                            .font(QuantumHorizonTypography.body(14))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    // XP Badge
                    VStack(spacing: 4) {
                        Text("\(viewModel.totalXP)")
                            .font(QuantumHorizonTypography.statNumber(28))
                            .foregroundColor(QuantumHorizonColors.quantumGold)

                        Text("Total XP")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(QuantumHorizonColors.quantumGold.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Next Level")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))

                        Spacer()

                        Text("\(viewModel.xpToNextLevel) XP remaining")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(QuantumHorizonColors.quantumGreen)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.1))

                            RoundedRectangle(cornerRadius: 4)
                                .fill(QuantumHorizonColors.miamiSunset)
                                .frame(width: geo.size.width * viewModel.levelProgress)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding(.bottom, 16)
    }

    // MARK: - Learning Path View
    private var learningPathView: some View {
        VStack(spacing: 0) {
            Text("Quantum Odyssey")
                .font(QuantumHorizonTypography.sectionTitle(20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)

            // Node Map
            ForEach(Array(viewModel.learningPath.enumerated()), id: \.element.id) { index, level in
                VStack(spacing: 0) {
                    // Connection line from previous node
                    if index > 0 {
                        connectionLine(isCompleted: level.status == .completed)
                    }

                    // Node
                    LearningNodeView(
                        level: level,
                        index: index + 1,
                        isSelected: selectedLevel?.id == level.id,
                        isPremiumUser: premiumManager.isPremium
                    )
                    .onTapGesture {
                        // If level is locked and user is not premium, show premium sheet
                        if level.status == .locked && !premiumManager.isPremium {
                            DeveloperModeManager.shared.log(
                                screen: "Academy",
                                element: "Level: \(level.title) (Premium Required)",
                                status: .comingSoon
                            )
                            showPremiumSheet = true
                        } else {
                            DeveloperModeManager.shared.log(
                                screen: "Academy",
                                element: "Level: \(level.title)",
                                status: .success
                            )
                            selectLevel(level)
                        }
                    }
                }
            }

            // Locked levels teaser (손실 회피 기법)
            lockedLevelsTeaser
        }
    }

    private func connectionLine(isCompleted: Bool) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .fill(isCompleted ? QuantumHorizonColors.quantumGreen : Color.white.opacity(0.2))
                    .frame(width: 6, height: 6)
                    .padding(.vertical, 4)
            }
        }
        .frame(height: 40)
    }

    private var lockedLevelsTeaser: some View {
        VStack(spacing: 16) {
            connectionLine(isCompleted: false)

            // Locked Level 12
            LockedLevelNode(levelNumber: 12, title: "Quantum Machine Learning")

            connectionLine(isCompleted: false)

            // Locked Level 13
            LockedLevelNode(levelNumber: 13, title: "Quantum Cryptography")

            // AI Message for loss aversion
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 18))
                    .foregroundColor(QuantumHorizonColors.quantumGold)

                Text("Complete this course to increase your market value by 23%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
            .padding(16)
            .glassmorphism(intensity: 0.1, cornerRadius: 16)
            .padding(.top, 16)
        }
        .padding(.top, 16)
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(QuantumHorizonTypography.sectionTitle(18))
                .foregroundColor(.white)

            HStack(spacing: 12) {
                StatCard(
                    value: "\(viewModel.completedLevels)",
                    label: "Completed",
                    icon: "checkmark.circle.fill",
                    color: QuantumHorizonColors.quantumGreen
                )

                StatCard(
                    value: "\(viewModel.streakDays)",
                    label: "Day Streak",
                    icon: "flame.fill",
                    color: .orange
                )

                StatCard(
                    value: formatTime(viewModel.totalLearningTime),
                    label: "Study Time",
                    icon: "clock.fill",
                    color: QuantumHorizonColors.quantumCyan
                )
            }
        }
        .padding(.top, 24)
    }

    private func formatTime(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        return "\(minutes / 60)h"
    }

    // MARK: - Level Detail Popup
    private func levelDetailPopup(level: LearningLevel) -> some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    closeLevelDetail()
                }

            // Card with matched geometry effect
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Level \(viewModel.learningPath.firstIndex(where: { $0.id == level.id })! + 1)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(level.color.opacity(0.8))

                        Text(level.title)
                            .font(QuantumHorizonTypography.sectionTitle(22))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Academy", element: "Level Detail: Close", status: .success)
                        closeLevelDetail()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                // Description
                Text(level.description)
                    .font(QuantumHorizonTypography.body(14))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(4)

                // Topics
                VStack(alignment: .leading, spacing: 12) {
                    Text("Topics")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))

                    ForEach(level.topics, id: \.self) { topic in
                        HStack(spacing: 10) {
                            Image(systemName: "atom")
                                .font(.system(size: 12))
                                .foregroundColor(level.color)

                            Text(topic)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.1))

                // XP and Duration
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reward")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))

                        Text("\(level.xpReward) XP")
                            .font(QuantumHorizonTypography.statNumber(20))
                            .foregroundColor(QuantumHorizonColors.quantumGold)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Duration")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))

                        Text("\(level.estimatedMinutes) min")
                            .font(QuantumHorizonTypography.statNumber(20))
                            .foregroundColor(QuantumHorizonColors.quantumCyan)
                    }
                }

                // Action Button
                Button(action: {
                    DeveloperModeManager.shared.log(
                        screen: "Academy",
                        element: "Level: \(level.title) - \(level.status == .completed ? "Review" : "Start")",
                        status: .success
                    )
                    startLevel(level)
                }) {
                    HStack {
                        Image(systemName: level.status == .completed ? "arrow.clockwise" : "play.fill")
                        Text(level.status == .completed ? "Review" : "Start Learning")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(level.color)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(SpringButtonStyle())
            }
            .padding(24)
            .glassmorphism(intensity: 0.15, cornerRadius: 28)
            .padding(.horizontal, 24)
            .matchedGeometryEffect(id: "levelCard-\(level.id)", in: animation)
            .transition(.asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .scale(scale: 0.9).combined(with: .opacity)
            ))
        }
    }

    // MARK: - Agent Message Bubble
    private var agentMessageBubble: some View {
        VStack {
            Spacer()

            HStack(alignment: .bottom, spacing: 12) {
                // Agent Avatar
                ZStack {
                    Circle()
                        .fill(QuantumHorizonColors.quantumPurple.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 20))
                        .foregroundColor(QuantumHorizonColors.quantumPurple)
                }

                // Message Bubble
                VStack(alignment: .leading, spacing: 8) {
                    Text("Q-Agent")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(QuantumHorizonColors.quantumPurple)

                    Text(viewModel.agentMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(3)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(QuantumHorizonColors.quantumPurple.opacity(0.3), lineWidth: 1)
                        )
                )

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 140)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    // MARK: - Actions
    private func selectLevel(_ level: LearningLevel) {
        // Allow selection for premium users even if locked (will be unlocked)
        guard level.status != .locked || premiumManager.isPremium else { return }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedLevel = level
            showLevelDetail = true
        }

        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    private func closeLevelDetail() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            showLevelDetail = false
            selectedLevel = nil
        }
    }

    private func startLevel(_ level: LearningLevel) {
        closeLevelDetail()
        // Navigate to learning content
    }
}

// MARK: - Learning Node View
struct LearningNodeView: View {
    let level: LearningLevel
    let index: Int
    let isSelected: Bool
    var isPremiumUser: Bool = false

    @State private var brightness: Double = 1.0

    // Computed property to determine actual status (unlocked for premium)
    var effectiveStatus: LevelStatus {
        if isPremiumUser && level.status == .locked {
            return .current  // Show as available for premium users
        }
        return level.status
    }

    var body: some View {
        HStack(spacing: 16) {
            // Node (Atom shape)
            ZStack {
                // Outer glow ring
                Circle()
                    .stroke(level.color.opacity(effectiveStatus == .completed ? 0.5 : 0.2), lineWidth: 2)
                    .frame(width: 72, height: 72)

                // Inner circle
                Circle()
                    .fill(level.color.opacity(effectiveStatus == .completed ? 0.3 : 0.1))
                    .frame(width: 64, height: 64)

                // Icon or number
                if effectiveStatus == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(level.color)
                } else if effectiveStatus == .current || (isPremiumUser && level.status == .locked) {
                    Text("\(index)")
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(level.color)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.3))
                }

                // Orbiting electrons (for current level or unlocked premium levels)
                if effectiveStatus == .current || (isPremiumUser && level.status == .locked) {
                    OrbitingElectron(color: level.color, radius: 36, duration: 3)
                    OrbitingElectron(color: level.color, radius: 36, duration: 3, offset: .pi)
                }
            }
            .brightness(brightness)
            .onAppear {
                if effectiveStatus == .current || (isPremiumUser && level.status == .locked) {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        brightness = 1.2
                    }
                }
            }

            // Level Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(level.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(effectiveStatus == .locked ? .white.opacity(0.4) : .white)

                    if effectiveStatus == .current && level.status == .current {
                        Text("CURRENT")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(level.color)
                            .clipShape(Capsule())
                    }

                    // Premium unlock badge
                    if isPremiumUser && level.status == .locked {
                        HStack(spacing: 2) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 8))
                            Text("UNLOCKED")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(QuantumHorizonColors.quantumGold)
                        .clipShape(Capsule())
                    }
                }

                Text(level.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(2)

                // XP indicator
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(QuantumHorizonColors.quantumGold)

                    Text("\(level.xpReward) XP")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(QuantumHorizonColors.quantumGold)
                }
            }

            Spacer()

            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(effectiveStatus == .locked ? .clear : .white.opacity(0.4))
        }
        .padding(16)
        .glassmorphism(intensity: isSelected ? 0.15 : 0.08, cornerRadius: 20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? level.color : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Orbiting Electron
struct OrbitingElectron: View {
    let color: Color
    let radius: CGFloat
    let duration: Double
    var offset: Double = 0

    @State private var angle: Double = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .offset(x: radius * cos(angle + offset), y: radius * sin(angle + offset))
            .shadow(color: color, radius: 4)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    angle = 2 * .pi
                }
            }
    }
}

// MARK: - Locked Level Node
struct LockedLevelNode: View {
    let levelNumber: Int
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            // Blurred/dimmed node
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 64, height: 64)

                Image(systemName: "lock.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.2))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Level \(levelNumber)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))

                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.2))
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.02))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .blur(radius: 1)
        .opacity(0.6)
    }
}

// MARK: - Stat Card
struct StatCard: View {
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
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassmorphism(intensity: 0.08, cornerRadius: 16)
    }
}

// MARK: - Models
struct LearningLevel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let topics: [String]
    let xpReward: Int
    let estimatedMinutes: Int
    let color: Color
    var status: LevelStatus
}

enum LevelStatus {
    case completed
    case current
    case locked
}

// MARK: - Academy ViewModel
@MainActor
class AcademyViewModel: ObservableObject {
    @Published var currentLevel = 8
    @Published var totalXP = 2450
    @Published var xpToNextLevel = 550
    @Published var levelProgress: CGFloat = 0.82
    @Published var completedLevels = 7
    @Published var streakDays = 12
    @Published var totalLearningTime = 340 // minutes

    @Published var showAgentMessage = false
    @Published var agentMessage = ""

    @Published var learningPath: [LearningLevel] = []

    init() {
        setupLearningPath()
        showAgentHint()
    }

    private func setupLearningPath() {
        learningPath = [
            LearningLevel(
                title: "Quantum Basics",
                subtitle: "Bits vs Qubits",
                description: "Learn the fundamental difference between classical bits and quantum bits. Understand superposition and how it enables quantum computing.",
                topics: ["Classical vs Quantum", "Superposition", "Probability Amplitudes"],
                xpReward: 100,
                estimatedMinutes: 15,
                color: QuantumHorizonColors.quantumCyan,
                status: .completed
            ),
            LearningLevel(
                title: "Bloch Sphere",
                subtitle: "Visualizing Qubits",
                description: "Master the Bloch sphere representation and understand how any single-qubit state can be visualized in 3D space.",
                topics: ["Spherical Coordinates", "State Vectors", "Rotations"],
                xpReward: 150,
                estimatedMinutes: 20,
                color: QuantumHorizonColors.quantumGreen,
                status: .completed
            ),
            LearningLevel(
                title: "Quantum Gates",
                subtitle: "Pauli & Hadamard",
                description: "Explore the fundamental quantum gates that manipulate qubits: Pauli-X, Y, Z and the crucial Hadamard gate.",
                topics: ["Pauli Gates", "Hadamard Gate", "Gate Matrices"],
                xpReward: 200,
                estimatedMinutes: 25,
                color: QuantumHorizonColors.quantumPurple,
                status: .completed
            ),
            LearningLevel(
                title: "Measurement",
                subtitle: "Collapsing Superposition",
                description: "Understand quantum measurement, wave function collapse, and the probabilistic nature of quantum outcomes.",
                topics: ["Measurement Postulate", "Born Rule", "Collapse"],
                xpReward: 200,
                estimatedMinutes: 20,
                color: .orange,
                status: .completed
            ),
            LearningLevel(
                title: "Entanglement",
                subtitle: "Spooky Action",
                description: "Dive into quantum entanglement, Bell states, and how entangled particles maintain correlations across any distance.",
                topics: ["Bell States", "EPR Paradox", "Quantum Correlations"],
                xpReward: 300,
                estimatedMinutes: 30,
                color: QuantumHorizonColors.quantumPink,
                status: .completed
            ),
            LearningLevel(
                title: "Multi-Qubit Gates",
                subtitle: "CNOT & CZ",
                description: "Learn controlled gates that create entanglement and form the basis for quantum circuits.",
                topics: ["CNOT Gate", "Controlled-Z", "Entangling Operations"],
                xpReward: 300,
                estimatedMinutes: 30,
                color: .teal,
                status: .completed
            ),
            LearningLevel(
                title: "Quantum Circuits",
                subtitle: "Building Algorithms",
                description: "Combine gates to build quantum circuits and understand circuit depth, width, and optimization.",
                topics: ["Circuit Design", "Gate Decomposition", "Circuit Optimization"],
                xpReward: 350,
                estimatedMinutes: 35,
                color: .indigo,
                status: .completed
            ),
            LearningLevel(
                title: "Quantum Algorithms",
                subtitle: "Deutsch-Jozsa",
                description: "Implement your first quantum algorithm and experience quantum speedup firsthand.",
                topics: ["Oracle Problems", "Interference", "Quantum Speedup"],
                xpReward: 400,
                estimatedMinutes: 40,
                color: QuantumHorizonColors.quantumGold,
                status: .current
            ),
            LearningLevel(
                title: "Grover's Algorithm",
                subtitle: "Quantum Search",
                description: "Master Grover's search algorithm and understand amplitude amplification.",
                topics: ["Unstructured Search", "Amplitude Amplification", "Quadratic Speedup"],
                xpReward: 450,
                estimatedMinutes: 45,
                color: .mint,
                status: .locked
            ),
            LearningLevel(
                title: "Error Correction",
                subtitle: "Fault Tolerance",
                description: "Learn how quantum computers protect against noise and errors using redundancy and clever encoding.",
                topics: ["Bit Flip Code", "Phase Flip Code", "Shor Code"],
                xpReward: 500,
                estimatedMinutes: 50,
                color: .red,
                status: .locked
            ),
            LearningLevel(
                title: "Shor's Algorithm",
                subtitle: "Breaking RSA",
                description: "Understand the famous algorithm that can factor large numbers exponentially faster than classical computers.",
                topics: ["Period Finding", "Quantum Fourier Transform", "Factoring"],
                xpReward: 600,
                estimatedMinutes: 60,
                color: .purple,
                status: .locked
            )
        ]
    }

    private func showAgentHint() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.agentMessage = "You're making great progress! Complete Level 8 to unlock Grover's Algorithm and boost your quantum skills by 15%."
            withAnimation(.spring()) {
                self.showAgentMessage = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                withAnimation(.spring()) {
                    self.showAgentMessage = false
                }
            }
        }
    }

    /// Unlock all levels for premium users
    func unlockAllLevels() {
        for index in learningPath.indices {
            if learningPath[index].status == .locked {
                // Keep the original status but the UI will show as unlocked via isPremiumUser
                // This allows tracking which levels were originally locked
            }
        }

        // Show premium celebration message
        agentMessage = "All 12+ courses unlocked! You now have full access to the Quantum Academy including Grover's Algorithm, Error Correction, and Shor's Algorithm."
        withAnimation(.spring()) {
            showAgentMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.spring()) {
                self.showAgentMessage = false
            }
        }
    }
}

// MARK: - Academy Premium Sheet
struct AcademyPremiumSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var showSuccessView = false

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
                            DeveloperModeManager.shared.log(screen: "Academy Premium", element: "Close Button", status: .success)
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Graduation cap icon
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(QuantumHorizonColors.goldCelebration)

                    Text("Quantum Academy Premium")
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(.white)

                    Text("Unlock all 12+ courses and master quantum computing")
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)

                    // Features list
                    VStack(alignment: .leading, spacing: 12) {
                        premiumFeatureRow("Grover's Algorithm - Quantum Search")
                        premiumFeatureRow("Error Correction & Fault Tolerance")
                        premiumFeatureRow("Shor's Algorithm - Breaking RSA")
                        premiumFeatureRow("Quantum Machine Learning")
                        premiumFeatureRow("MIT/Harvard-style Curriculum")
                    }
                    .padding()
                    .glassmorphism(intensity: 0.08, cornerRadius: 16)

                    // Upgrade button
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Academy Premium", element: "Upgrade Button - ACTIVATED", status: .success)
                        premiumManager.upgradeToPremium()
                        withAnimation {
                            showSuccessView = true
                        }
                    }) {
                        Text("Upgrade - $9.99/month")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(QuantumHorizonColors.goldCelebration)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Text("7-day free trial included")
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

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        AcademyHubView()
    }
    .preferredColorScheme(.dark)
}
