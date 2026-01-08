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
    let isLanguageStep: Bool

    init(title: String, subtitle: String, description: String, icon: String, accentColor: Color, isLanguageStep: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.icon = icon
        self.accentColor = accentColor
        self.isLanguageStep = isLanguageStep
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @Binding var isPresented: Bool
    @ObservedObject var localization = LocalizationManager.shared
    @State private var currentStep = 0

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "Select Your",
            subtitle: "Language",
            description: "Choose your preferred language. You can change it anytime in Settings.",
            icon: "globe",
            accentColor: QuantumHorizonColors.quantumGreen,
            isLanguageStep: true
        ),
        OnboardingStep(
            title: "Welcome to",
            subtitle: "SwiftQuantum",
            description: "Explore quantum computing with interactive visualizations and real hardware connections.",
            icon: "atom",
            accentColor: QuantumHorizonColors.quantumCyan
        ),
        OnboardingStep(
            title: "Experiment in",
            subtitle: "Lab",
            description: "Manipulate qubits on the Bloch Sphere. Apply gates like Hadamard (H) and measure results.",
            icon: "atom",
            accentColor: QuantumHorizonColors.quantumCyan
        ),
        OnboardingStep(
            title: "Load",
            subtitle: "Presets",
            description: "Explore famous quantum states like Bell pairs and GHZ states with one tap.",
            icon: "list.bullet.clipboard",
            accentColor: QuantumHorizonColors.quantumGreen
        ),
        OnboardingStep(
            title: "Connect via",
            subtitle: "Bridge",
            description: "Deploy circuits to real IBM Quantum computers with 127+ qubits.",
            icon: "network",
            accentColor: QuantumHorizonColors.quantumPurple
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
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Onboarding", element: "Skip Button", status: .success)
                        completeOnboarding()
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.top, 8)

                Spacer()

                // Icon
                iconSection

                Spacer()
                    .frame(height: 32)

                // Text Content
                textSection

                Spacer()

                // Bottom Controls
                bottomControls
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Icon Section
    private var iconSection: some View {
        Group {
            if steps[currentStep].isLanguageStep {
                languageSelectionGrid
            } else {
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(steps[currentStep].accentColor.opacity(0.15))
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)

                    // Main circle
                    Circle()
                        .fill(steps[currentStep].accentColor.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Circle()
                        .stroke(steps[currentStep].accentColor.opacity(0.4), lineWidth: 2)
                        .frame(width: 120, height: 120)

                    Image(systemName: steps[currentStep].icon)
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(steps[currentStep].accentColor)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }

    // MARK: - Language Selection Grid
    private var languageSelectionGrid: some View {
        VStack(spacing: 12) {
            ForEach(AppLanguage.allCases) { language in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        localization.setLanguage(language)
                    }
                    DeveloperModeManager.shared.log(screen: "Onboarding", element: "Language: \(language.displayName)", status: .success)
                }) {
                    HStack(spacing: 14) {
                        Text(language.flag)
                            .font(.system(size: 24))

                        Text(language.displayName)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)

                        Spacer()

                        if localization.currentLanguage == language {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(QuantumHorizonColors.quantumGreen)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(localization.currentLanguage == language ?
                                  Color.white.opacity(0.12) :
                                  Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(localization.currentLanguage == language ?
                                            QuantumHorizonColors.quantumGreen.opacity(0.5) :
                                            Color.clear, lineWidth: 1.5)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Text Section
    private var textSection: some View {
        VStack(spacing: 16) {
            // Title
            VStack(spacing: 4) {
                Text(steps[currentStep].title)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))

                Text(steps[currentStep].subtitle)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }

            // Description
            Text(steps[currentStep].description)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }

    // MARK: - Bottom Controls
    private var bottomControls: some View {
        VStack(spacing: 24) {
            // Page dots
            HStack(spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentStep ? steps[currentStep].accentColor : Color.white.opacity(0.3))
                        .frame(width: index == currentStep ? 24 : 8, height: 8)
                }
            }
            .animation(.spring(response: 0.3), value: currentStep)

            // Buttons
            HStack(spacing: 16) {
                if currentStep > 0 {
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Onboarding", element: "Previous Button (Step \(currentStep + 1))", status: .success)
                        previousStep()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 50, height: 50)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }

                Spacer()

                Button(action: {
                    if currentStep < steps.count - 1 {
                        DeveloperModeManager.shared.log(screen: "Onboarding", element: "Next Button (Step \(currentStep + 1))", status: .success)
                        nextStep()
                    } else {
                        DeveloperModeManager.shared.log(screen: "Onboarding", element: "Get Started Button", status: .success)
                        completeOnboarding()
                    }
                }) {
                    HStack(spacing: 8) {
                        Text(currentStep < steps.count - 1 ? "Next" : "Get Started")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: currentStep < steps.count - 1 ? "chevron.right" : "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(steps[currentStep].accentColor)
                    .clipShape(Capsule())
                }
            }
        }
    }

    private func nextStep() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentStep = min(currentStep + 1, steps.count - 1)
        }
    }

    private func previousStep() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentStep = max(currentStep - 1, 0)
        }
    }

    private func completeOnboarding() {
        isPresented = false
    }
}

// MARK: - First Launch Manager
class FirstLaunchManager: ObservableObject {
    @Published var shouldShowOnboarding: Bool

    private let onboardingKey = "hasCompletedOnboarding"

    init() {
        let hasCompleted = UserDefaults.standard.bool(forKey: onboardingKey)
        self.shouldShowOnboarding = !hasCompleted
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
        shouldShowOnboarding = false
    }

    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: onboardingKey)
        shouldShowOnboarding = true
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(isPresented: .constant(true))
}
