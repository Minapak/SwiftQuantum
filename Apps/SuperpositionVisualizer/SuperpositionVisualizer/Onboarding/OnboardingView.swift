//
//  OnboardingView.swift
//  SuperpositionVisualizer
//
//  SwiftQuantum v2.1.0 - First-time User Tutorial
//  Apple HIG Compliant Onboarding Experience
//

import SwiftUI

// MARK: - Onboarding Model
struct OnboardingStep: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let accentColor: Color
    let tipTitle: String
    let tipDescription: String
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentStep = 0
    @State private var showGetStarted = false

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "Welcome to",
            subtitle: "SwiftQuantum",
            description: "Your gateway to quantum computing. Explore qubits, build circuits, and run experiments on real quantum hardware.",
            icon: "atom",
            accentColor: QuantumHorizonColors.quantumCyan,
            tipTitle: "What is a Qubit?",
            tipDescription: "Unlike classical bits (0 or 1), qubits can exist in superposition—both states simultaneously!"
        ),
        OnboardingStep(
            title: "Explore the",
            subtitle: "Lab",
            description: "Manipulate qubit states using the Bloch Sphere. Apply quantum gates and measure the results.",
            icon: "atom",
            accentColor: QuantumHorizonColors.quantumCyan,
            tipTitle: "Try This",
            tipDescription: "Tap 'H' (Hadamard) to create a perfect superposition, then measure to see probabilistic collapse."
        ),
        OnboardingStep(
            title: "Load",
            subtitle: "Presets",
            description: "Quickly explore famous quantum states like Bell pairs, GHZ states, and more.",
            icon: "list.bullet.clipboard",
            accentColor: QuantumHorizonColors.quantumGreen,
            tipTitle: "Explore Categories",
            tipDescription: "Browse Basic, Superposition, Entanglement, and Algorithm presets to learn quantum concepts."
        ),
        OnboardingStep(
            title: "Connect via",
            subtitle: "Bridge",
            description: "Deploy your circuits to real IBM Quantum computers with 127+ qubits.",
            icon: "network",
            accentColor: QuantumHorizonColors.quantumPurple,
            tipTitle: "Premium Feature",
            tipDescription: "Connect your IBM Quantum API key to run experiments on actual quantum processors."
        ),
        OnboardingStep(
            title: "Learn in",
            subtitle: "Academy",
            description: "Master quantum computing with interactive lessons, from basics to advanced algorithms.",
            icon: "graduationcap.fill",
            accentColor: QuantumHorizonColors.quantumGold,
            tipTitle: "Level Up",
            tipDescription: "Complete lessons to earn XP, unlock achievements, and track your quantum journey."
        )
    ]

    var body: some View {
        ZStack {
            // Background
            QuantumHorizonBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: { completeOnboarding() }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)

                // Content
                TabView(selection: $currentStep) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        OnboardingStepView(step: step)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)

                // Page indicator and buttons
                VStack(spacing: 24) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentStep ? steps[currentStep].accentColor : Color.white.opacity(0.2))
                                .frame(width: index == currentStep ? 24 : 8, height: 8)
                                .animation(.spring(), value: currentStep)
                        }
                    }

                    // Navigation buttons
                    HStack(spacing: 16) {
                        // Back button
                        if currentStep > 0 {
                            Button(action: { previousStep() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Capsule())
                            }
                        }

                        Spacer()

                        // Next / Get Started button
                        Button(action: {
                            if currentStep < steps.count - 1 {
                                nextStep()
                            } else {
                                completeOnboarding()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Text(currentStep < steps.count - 1 ? "Next" : "Get Started")
                                Image(systemName: currentStep < steps.count - 1 ? "chevron.right" : "arrow.right")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [steps[currentStep].accentColor, steps[currentStep].accentColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: steps[currentStep].accentColor.opacity(0.3), radius: 10, y: 5)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }

    private func nextStep() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentStep = min(currentStep + 1, steps.count - 1)
        }
    }

    private func previousStep() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentStep = max(currentStep - 1, 0)
        }
    }

    private func completeOnboarding() {
        withAnimation(.spring()) {
            isPresented = false
        }
    }
}

// MARK: - Onboarding Step View
struct OnboardingStepView: View {
    let step: OnboardingStep
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon with animation
            ZStack {
                // Outer glow rings
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(step.accentColor.opacity(0.2 - Double(index) * 0.05), lineWidth: 2)
                        .frame(width: CGFloat(140 + index * 30), height: CGFloat(140 + index * 30))
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                        .animation(
                            .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }

                // Main icon circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [step.accentColor.opacity(0.3), step.accentColor.opacity(0.1)],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)

                Circle()
                    .stroke(step.accentColor.opacity(0.5), lineWidth: 2)
                    .frame(width: 120, height: 120)

                Image(systemName: step.icon)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(step.accentColor)
                    .symbolEffect(.pulse, isActive: isAnimating)
            }
            .onAppear { isAnimating = true }

            // Title
            VStack(spacing: 8) {
                Text(step.title)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))

                Text(step.subtitle)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }

            // Description
            Text(step.description)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)

            // Tip Card
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 14))
                        .foregroundColor(step.accentColor)

                    Text(step.tipTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(step.accentColor)
                }

                Text(step.tipDescription)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(step.accentColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(step.accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Interactive Tutorial Overlay
struct TutorialOverlay: View {
    @Binding var isShowing: Bool
    let highlightFrame: CGRect
    let message: String
    let position: TutorialPosition

    enum TutorialPosition {
        case above, below
    }

    var body: some View {
        ZStack {
            // Dimmed background with cutout
            Color.black.opacity(0.7)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .frame(width: highlightFrame.width + 16, height: highlightFrame.height + 16)
                        .position(x: highlightFrame.midX, y: highlightFrame.midY)
                        .blendMode(.destinationOut)
                )
                .compositingGroup()
                .ignoresSafeArea()

            // Tutorial message
            VStack(spacing: 16) {
                if position == .below {
                    Spacer()
                        .frame(height: highlightFrame.maxY + 20)
                }

                VStack(spacing: 12) {
                    Text(message)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Button(action: { isShowing = false }) {
                        Text("Got it")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(QuantumHorizonColors.quantumGold)
                            .clipShape(Capsule())
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 32)

                if position == .above {
                    Spacer()
                }
            }
        }
        .onTapGesture { isShowing = false }
    }
}

// MARK: - First Launch Manager
class FirstLaunchManager: ObservableObject {
    @Published var shouldShowOnboarding: Bool
    @Published var hasSeenLabTutorial: Bool
    @Published var hasSeenPresetsTutorial: Bool
    @Published var hasSeenBridgeTutorial: Bool

    private let onboardingKey = "hasCompletedOnboarding"
    private let labTutorialKey = "hasSeenLabTutorial"
    private let presetsTutorialKey = "hasSeenPresetsTutorial"
    private let bridgeTutorialKey = "hasSeenBridgeTutorial"

    init() {
        let hasCompleted = UserDefaults.standard.bool(forKey: onboardingKey)
        self.shouldShowOnboarding = !hasCompleted
        self.hasSeenLabTutorial = UserDefaults.standard.bool(forKey: labTutorialKey)
        self.hasSeenPresetsTutorial = UserDefaults.standard.bool(forKey: presetsTutorialKey)
        self.hasSeenBridgeTutorial = UserDefaults.standard.bool(forKey: bridgeTutorialKey)
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
        shouldShowOnboarding = false
    }

    func markLabTutorialSeen() {
        UserDefaults.standard.set(true, forKey: labTutorialKey)
        hasSeenLabTutorial = true
    }

    func markPresetsTutorialSeen() {
        UserDefaults.standard.set(true, forKey: presetsTutorialKey)
        hasSeenPresetsTutorial = true
    }

    func markBridgeTutorialSeen() {
        UserDefaults.standard.set(true, forKey: bridgeTutorialKey)
        hasSeenBridgeTutorial = true
    }

    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: onboardingKey)
        UserDefaults.standard.set(false, forKey: labTutorialKey)
        UserDefaults.standard.set(false, forKey: presetsTutorialKey)
        UserDefaults.standard.set(false, forKey: bridgeTutorialKey)
        shouldShowOnboarding = true
        hasSeenLabTutorial = false
        hasSeenPresetsTutorial = false
        hasSeenBridgeTutorial = false
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(isPresented: .constant(true))
}
