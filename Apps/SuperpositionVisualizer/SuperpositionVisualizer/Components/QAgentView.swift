import SwiftUI

// MARK: - Q-Agent Floating Assistant
// 모든 화면 우측 하단에 떠 있는 AI 가이드
// 사용자가 헤매면 조언을 제공

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

    private var contextualHints: [String] = [
        "현재 설계된 회로는 노이즈가 많으니 Bridge 모드 사용을 추천합니다.",
        "Hadamard 게이트를 적용하면 완벽한 중첩 상태를 만들 수 있어요!",
        "측정 결과가 기대치와 다르다면 Error Correction을 확인해보세요.",
        "팁: Phase를 조절하면 Bloch Sphere에서 적도면 회전을 볼 수 있어요.",
        "Level 8을 완료하면 Grover's Algorithm을 배울 수 있어요!",
        "IBM Brisbane에 연결하면 실제 127큐빗 양자 컴퓨터를 사용할 수 있습니다."
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

        // Provide contextual help based on current state
        currentMessage = "안녕하세요! 양자 실험에 도움이 필요하시면 말씀해주세요. 현재 상태를 분석해드릴게요."
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
        currentMessage = "현재 회로 최적화 팁:\n• 게이트 수를 줄여 노이즈를 최소화하세요\n• 중첩 상태에서 측정 전 위상을 확인하세요\n• 실제 하드웨어에서는 에러 보정이 필수입니다"
        suggestedActions = []
    }

    func showLearningPath() {
        currentMessage = "다음 학습 추천: Level 8 'Quantum Algorithms'를 완료하면 Grover의 검색 알고리즘을 배울 수 있어요. 이 과정은 연봉 가치를 15% 높일 수 있습니다!"
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
            currentMessage = "실험실에서는 Bloch Sphere를 통해 큐빗 상태를 시각화할 수 있어요. 슬라이더로 확률과 위상을 조절해보세요!"
        case .presets:
            currentMessage = "미리 설정된 양자 상태들을 탐험해보세요. |+⟩, |-⟩, |i⟩ 등 다양한 중첩 상태를 즉시 로드할 수 있어요!"
        case .bridge:
            currentMessage = "Bridge에서는 실제 양자 컴퓨터에 회로를 배포할 수 있어요. IBM Brisbane은 현재 온라인 상태입니다."
        case .more:
            currentMessage = "Academy에서 학습하고, Industry 솔루션을 탐험하고, 프로필에서 진도를 확인하세요!"
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
