import SwiftUI

// MARK: - Q-Agent Floating Assistant
// AI-powered quantum computing guide that appears on all screens
// Provides contextual help and tips based on user activity

struct QAgentView: View {
    @StateObject private var agent = QAgentViewModel()
    @State private var isExpanded = false
    @State private var showMessageBubble = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Message Bubble (appears above the agent)
            if showMessageBubble && !agent.currentMessage.isEmpty {
                messageBubble
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8, anchor: .bottomTrailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }

            // Floating Agent Button
            floatingAgentButton
        }
        .offset(dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3)) {
                        dragOffset = .zero
                    }
                }
        )
        .onAppear {
            agent.startObserving()
        }
        .onChange(of: agent.currentMessage) { _, newMessage in
            if !newMessage.isEmpty {
                withAnimation(.spring()) {
                    showMessageBubble = true
                }

                // Auto-dismiss after 8 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    withAnimation(.spring()) {
                        showMessageBubble = false
                    }
                }
            }
        }
    }

    // MARK: - Message Bubble
    private var messageBubble: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                        .foregroundColor(QuantumHorizonColors.quantumPurple)

                    Text("Q-Agent")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(QuantumHorizonColors.quantumPurple)

                    Spacer()

                    Button(action: dismissMessage) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }

                Text(agent.currentMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)

                // Quick action buttons (if available)
                if !agent.suggestedActions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(agent.suggestedActions, id: \.title) { action in
                            Button(action: { executeAction(action) }) {
                                Text(action.title)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(QuantumHorizonColors.quantumPurple.opacity(0.3))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: 280)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)

                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))

                    RoundedRectangle(cornerRadius: 16)
                        .stroke(QuantumHorizonColors.quantumPurple.opacity(0.3), lineWidth: 1)
                }
            )
            .shadow(color: QuantumHorizonColors.quantumPurple.opacity(0.2), radius: 20)
        }
    }

    // MARK: - Floating Agent Button
    private var floatingAgentButton: some View {
        Button(action: toggleExpand) {
            ZStack {
                // Outer glow ring (animated)
                Circle()
                    .stroke(
                        QuantumHorizonColors.quantumPurple.opacity(agent.isActive ? 0.5 : 0.2),
                        lineWidth: 2
                    )
                    .frame(width: 56, height: 56)
                    .scaleEffect(agent.isActive ? 1.15 : 1.0)
                    .opacity(agent.isActive ? 0.6 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: agent.isActive)

                // Inner circle with glass effect
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 52, height: 52)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                QuantumHorizonColors.quantumPurple.opacity(0.3),
                                QuantumHorizonColors.quantumPink.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)

                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .frame(width: 52, height: 52)

                // Agent icon
                Image(systemName: agent.isActive ? "brain.head.profile" : "brain")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(QuantumHorizonColors.quantumPurple)
                    .symbolEffect(.pulse, isActive: agent.isActive)

                // Notification badge
                if agent.hasNewMessage {
                    Circle()
                        .fill(QuantumHorizonColors.quantumGold)
                        .frame(width: 12, height: 12)
                        .offset(x: 18, y: -18)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 12, height: 12)
                                .offset(x: 18, y: -18)
                        )
                }
            }
        }
        .buttonStyle(SpringButtonStyle())
        .shadow(color: QuantumHorizonColors.quantumPurple.opacity(0.3), radius: 15, x: 0, y: 8)
    }

    // MARK: - Actions
    private func toggleExpand() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            isExpanded.toggle()
            if isExpanded {
                showMessageBubble = true
                agent.requestHelp()
            } else {
                showMessageBubble = false
            }
        }
    }

    private func dismissMessage() {
        withAnimation(.spring()) {
            showMessageBubble = false
            agent.clearMessage()
        }
    }

    private func executeAction(_ action: QAgentAction) {
        action.handler()
        dismissMessage()
    }
}

// MARK: - Q-Agent Action
struct QAgentAction {
    let title: String
    let handler: () -> Void
}

// MARK: - Q-Agent ViewModel
@MainActor
class QAgentViewModel: ObservableObject {
    @Published var currentMessage = ""
    @Published var suggestedActions: [QAgentAction] = []
    @Published var isActive = false
    @Published var hasNewMessage = false

    // Default language is English - all hints in English
    private var contextualHints: [String] = [
        "Your current circuit has some noise. Consider using Bridge mode for better results.",
        "Apply a Hadamard gate to create a perfect superposition state!",
        "If measurement results differ from expectations, check Error Correction settings.",
        "Tip: Adjust the Phase to see equatorial rotation on the Bloch Sphere.",
        "Complete Level 8 to unlock Grover's Search Algorithm!",
        "Connect to IBM Brisbane to use an actual 127-qubit quantum computer."
    ]

    func startObserving() {
        // Simulate periodic hints
        Timer.scheduledTimer(withTimeInterval: 45, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.showRandomHint()
            }
        }
    }

    func showRandomHint() {
        guard currentMessage.isEmpty else { return }

        if let hint = contextualHints.randomElement() {
            currentMessage = hint
            hasNewMessage = true
            isActive = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hasNewMessage = false
            }
        }
    }

    func requestHelp() {
        isActive = true

        // Provide contextual help based on current state (English default)
        currentMessage = "Hello! Need help with quantum experiments? I can analyze your current state and provide tips."
        suggestedActions = [
            QAgentAction(title: "Circuit Tips") { [weak self] in
                self?.showCircuitTips()
            },
            QAgentAction(title: "Learn More") { [weak self] in
                self?.showLearningPath()
            }
        ]
    }

    func showCircuitTips() {
        currentMessage = "Circuit Optimization Tips:\n• Reduce gate count to minimize noise\n• Verify phase before measurement in superposition\n• Error correction is essential for real hardware"
        suggestedActions = []
    }

    func showLearningPath() {
        currentMessage = "Recommended: Complete Level 8 'Quantum Algorithms' to learn Grover's Search. This knowledge can increase your market value by 15%!"
        suggestedActions = []
    }

    func clearMessage() {
        currentMessage = ""
        suggestedActions = []
        isActive = false
    }

    // Context-aware messages for different hubs (4-Hub Consolidation)
    func showHubSpecificHint(hub: QuantumHub) {
        switch hub {
        case .lab:
            currentMessage = "In the Lab, visualize qubit states on the Bloch Sphere. Use sliders to adjust probability and phase!"
        case .presets:
            currentMessage = "Explore preset quantum states. Instantly load |+⟩, |-⟩, |i⟩ and other superposition states!"
        case .bridge:
            currentMessage = "Deploy circuits to real quantum computers via Bridge. IBM Brisbane is currently online."
        case .more:
            currentMessage = "Learn in Academy, explore Industry solutions, and track your progress in Profile!"
        }
        hasNewMessage = true
        isActive = true
    }
}

// MARK: - Q-Agent Modifier (for easy attachment to views)
struct QAgentModifier: ViewModifier {
    @StateObject private var agent = QAgentViewModel()
    let currentHub: QuantumHub

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content

            QAgentView()
                .padding(.trailing, 20)
                .padding(.bottom, 100)
        }
        .onChange(of: currentHub) { _, newHub in
            // Show hub-specific hint when changing tabs
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                agent.showHubSpecificHint(hub: newHub)
            }
        }
    }
}

extension View {
    func withQAgent(currentHub: QuantumHub) -> some View {
        modifier(QAgentModifier(currentHub: currentHub))
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()

        VStack {
            Spacer()
            Text("Main Content")
                .foregroundColor(.white)
            Spacer()
        }

        VStack {
            Spacer()
            HStack {
                Spacer()
                QAgentView()
                    .padding(.trailing, 20)
                    .padding(.bottom, 100)
            }
        }
    }
    .preferredColorScheme(.dark)
}
