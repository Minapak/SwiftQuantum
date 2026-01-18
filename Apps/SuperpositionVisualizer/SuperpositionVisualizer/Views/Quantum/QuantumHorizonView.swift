import SwiftUI
import SwiftQuantum

// MARK: - Quantum Horizon Main View
// 2026 Modern UI/UX: Glassmorphism + Bento Grid + Miami Gradients
// 4-Hub Navigation with Apple HIG Compliant Design

struct QuantumHorizonView: View {
    @StateObject private var stateManager = QuantumStateManager()
    @StateObject private var firstLaunchManager = FirstLaunchManager()
    @StateObject private var devMode = DeveloperModeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedHub: QuantumHub = .lab
    @State private var showCelebration = false
    @State private var showOnboarding = false
    @State private var showBridgeInfo = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            // Background
            QuantumHorizonBackground()
                .ignoresSafeArea()

            // Main Content
            VStack(spacing: 0) {
                // Hub Header with optional trailing content
                HubHeader(hub: selectedHub) {
                    // Learn More button for Bridge tab (inline with header)
                    if selectedHub == .bridge {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showBridgeInfo.toggle()
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 14))
                                Text(L("bridge.learn_more"))
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundColor(showBridgeInfo ? QuantumHorizonColors.quantumCyan : .white.opacity(0.6))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(showBridgeInfo ? QuantumHorizonColors.quantumCyan.opacity(0.2) : Color.white.opacity(0.08))
                            )
                        }
                        .buttonStyle(SpringButtonStyle())
                    }
                }
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

            // Global Celebration Effect
            GoldParticleView(isActive: $showCelebration)

            // Developer Mode Badge (QA/QC Testing)
            DeveloperModeBadge()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedHub)
        .preferredColorScheme(.dark)
        .onAppear {
            // Check if onboarding should be shown
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
        .fullScreenCover(isPresented: $devMode.showLogOverlay) {
            DeveloperLogOverlay()
        }
    }

    // MARK: - Hub Content (4-Hub Consolidation)
    @ViewBuilder
    private var hubContent: some View {
        switch selectedHub {
        case .lab:
            LabHubView(stateManager: stateManager)

        case .circuits:
            PresetsHubView()

        case .bridge:
            FactoryHubView(showBridgeInfo: $showBridgeInfo)

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
