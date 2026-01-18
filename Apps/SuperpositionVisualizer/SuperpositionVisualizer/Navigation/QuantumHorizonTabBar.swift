import SwiftUI

// MARK: - Hub Navigation (4-Hub Consolidation - Apple HIG Compliant)
enum QuantumHub: Int, CaseIterable {
    case lab = 0       // Controls + Measure + Info 통합
    case circuits = 1  // Circuits Builder (회로 빌더)
    case bridge = 2    // Bridge (핵심 기능 독립)
    case more = 3      // Academy + Industry + Profile 통합

    var title: String {
        switch self {
        case .lab: return LocalizedStringKey.lab.defaultValue
        case .circuits: return LocalizedStringKey.circuits.defaultValue
        case .bridge: return LocalizedStringKey.onboardingBridge.defaultValue
        case .more: return LocalizedStringKey.more.defaultValue
        }
    }

    // Localized title for SwiftUI views (use this in View contexts)
    @MainActor
    var localizedTitle: String {
        let localization = LocalizationManager.shared
        switch self {
        case .lab: return localization.string(for: .lab)
        case .circuits: return localization.string(for: .circuits)
        case .bridge: return localization.string(for: .onboardingBridge)
        case .more: return localization.string(for: .more)
        }
    }

    var icon: String {
        switch self {
        case .lab: return "atom"
        case .circuits: return "cpu"
        case .bridge: return "network"
        case .more: return "square.grid.2x2"
        }
    }

    var accentColor: Color {
        switch self {
        case .lab: return QuantumHorizonColors.quantumCyan
        case .circuits: return QuantumHorizonColors.quantumGreen
        case .bridge: return QuantumHorizonColors.quantumPurple
        case .more: return QuantumHorizonColors.quantumGold
        }
    }

    var description: String {
        switch self {
        case .lab: return LocalizedStringKey.labDescription.defaultValue
        case .circuits: return LocalizedStringKey.circuitsDescription.defaultValue
        case .bridge: return LocalizedStringKey.bridgeDescription.defaultValue
        case .more: return LocalizedStringKey.moreDescription.defaultValue
        }
    }

    // Localized description for SwiftUI views
    @MainActor
    var localizedDescription: String {
        let localization = LocalizationManager.shared
        switch self {
        case .lab: return localization.string(for: .labDescription)
        case .circuits: return localization.string(for: .circuitsDescription)
        case .bridge: return localization.string(for: .bridgeDescription)
        case .more: return localization.string(for: .moreDescription)
        }
    }
}

// MARK: - Main Tab Bar View (4 Tabs - Glassmorphism)
struct QuantumHorizonTabBar: View {
    @Binding var selectedHub: QuantumHub
    @Namespace private var animation

    // Miami Sunset Gradient for selected state
    private let sunsetGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.55, blue: 0.2),  // Orange
            Color(red: 1.0, green: 0.4, blue: 0.5)    // Pink
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        HStack(spacing: 0) {
            ForEach(QuantumHub.allCases, id: \.rawValue) { hub in
                TabBarButton(
                    hub: hub,
                    isSelected: selectedHub == hub,
                    namespace: animation,
                    sunsetGradient: sunsetGradient
                ) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedHub = hub
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            ZStack {
                // Ultra thin glass background
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.black.opacity(0.3))

                // Top highlight border
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

// MARK: - Tab Bar Button (Miami Sunset Highlight)
struct TabBarButton: View {
    let hub: QuantumHub
    let isSelected: Bool
    let namespace: Namespace.ID
    let sunsetGradient: LinearGradient
    let action: () -> Void

    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            DeveloperModeManager.shared.log(screen: "TabBar", element: "Tab: \(hub.title)", status: .success)
            action()
        }) {
            VStack(spacing: 6) {
                ZStack {
                    // Selection indicator with sunset gradient
                    if isSelected {
                        Capsule()
                            .fill(sunsetGradient.opacity(0.2))
                            .frame(width: 52, height: 32)
                            .matchedGeometryEffect(id: "tabBackground", in: namespace)

                        Capsule()
                            .stroke(sunsetGradient, lineWidth: 1.5)
                            .frame(width: 52, height: 32)
                            .matchedGeometryEffect(id: "tabBorder", in: namespace)
                    }

                    Image(systemName: hub.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? sunsetGradient : LinearGradient(colors: [.white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                        .symbolEffect(.bounce, value: isSelected)
                }
                .frame(height: 32)

                Text(hub.localizedTitle)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? sunsetGradient : LinearGradient(colors: [.white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Floating Tab Bar Modifier
struct FloatingTabBarModifier<Hub: View>: ViewModifier {
    let tabBar: Hub

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            VStack {
                Spacer()
                tabBar
            }
        }
    }
}

extension View {
    func floatingTabBar<Hub: View>(@ViewBuilder tabBar: () -> Hub) -> some View {
        modifier(FloatingTabBarModifier(tabBar: tabBar()))
    }
}

// MARK: - Hub Container View
struct HubContainerView<Content: View>: View {
    let hub: QuantumHub
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            ScrollView {
                VStack(spacing: 0) {
                    HubHeader(hub: hub)
                        .padding(.top, 8)

                    content
                        .padding(.horizontal, 16)
                        .padding(.bottom, 120)
                }
            }
        }
    }
}

// MARK: - Hub Header
struct HubHeader: View {
    let hub: QuantumHub
    @State private var isAnimating = false

    private let sunsetGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.55, blue: 0.2),
            Color(red: 1.0, green: 0.4, blue: 0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Animated hub icon with sunset gradient
            ZStack {
                Circle()
                    .fill(hub.accentColor.opacity(0.15))
                    .frame(width: 52, height: 52)

                Circle()
                    .stroke(hub.accentColor.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 52, height: 52)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.5 : 1.0)

                Image(systemName: hub.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(hub.accentColor)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(hub.localizedTitle)
                    .font(QuantumHorizonTypography.sectionTitle(24))
                    .foregroundColor(.white)

                Text(hub.localizedDescription)
                    .font(QuantumHorizonTypography.caption(13))
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var selectedHub: QuantumHub = .lab

        var body: some View {
            ZStack {
                QuantumHorizonBackground()

                VStack {
                    HubHeader(hub: selectedHub)
                    Spacer()
                }
            }
            .floatingTabBar {
                QuantumHorizonTabBar(selectedHub: $selectedHub)
            }
            .preferredColorScheme(.dark)
        }
    }

    return PreviewWrapper()
}
