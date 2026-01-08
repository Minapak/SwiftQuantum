import SwiftUI

// MARK: - Quantum Horizon Main View
// 2026 Modern UI/UX: Glassmorphism + Bento Grid + Miami Gradients
// 4-Hub Navigation with Apple HIG Compliant Design

struct QuantumHorizonView: View {
    @StateObject private var stateManager = QuantumStateManager()
    @StateObject private var firstLaunchManager = FirstLaunchManager()
    @State private var selectedHub: QuantumHub = .lab
    @State private var showCelebration = false
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            // Background
            QuantumHorizonBackground()
                .ignoresSafeArea()

            // Main Content
            VStack(spacing: 0) {
                // Hub Header
                HubHeader(hub: selectedHub)
                    .padding(.top, 8)

                // Hub Content
                hubContent
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            }

            // Floating Tab Bar
            VStack {
                Spacer()
                QuantumHorizonTabBar(selectedHub: $selectedHub)
            }

            // Q-Agent Floating Assistant
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    QAgentView()
                        .padding(.trailing, 20)
                        .padding(.bottom, 100)
                }
            }

            // Global Celebration Effect
            GoldParticleView(isActive: $showCelebration)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedHub)
        .preferredColorScheme(.dark)
        .onAppear {
            if firstLaunchManager.shouldShowOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
                .onDisappear {
                    firstLaunchManager.completeOnboarding()
                }
        }
    }

    // MARK: - Hub Content (4-Hub Consolidation)
    @ViewBuilder
    private var hubContent: some View {
        switch selectedHub {
        case .lab:
            LabHubView(stateManager: stateManager)

        case .presets:
            PresetsHubView()

        case .bridge:
            FactoryHubView()

        case .more:
            MoreHubView()
        }
    }
}

// QuantumPremiumColors is already defined in ErrorCorrectionView.swift

// MARK: - Preview
#Preview {
    QuantumHorizonView()
}
