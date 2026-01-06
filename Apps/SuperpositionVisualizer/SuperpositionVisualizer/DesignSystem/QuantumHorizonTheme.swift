import SwiftUI

// MARK: - Quantum Horizon Design System
// 2026 Modern UI/UX: Glassmorphism + Bento Grid + Miami Gradients

// MARK: - Color Palette
struct QuantumHorizonColors {
    // Miami Sunset Gradients (화 기운 보충)
    static let miamiSunrise = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.6, blue: 0.2),   // Warm Orange
            Color(red: 1.0, green: 0.4, blue: 0.5),   // Coral Pink
            Color(red: 0.9, green: 0.3, blue: 0.6)    // Hot Pink
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let miamiSunset = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.85, blue: 0.4),  // Golden Yellow
            Color(red: 1.0, green: 0.55, blue: 0.2),  // Miami Orange
            Color(red: 0.95, green: 0.3, blue: 0.4)   // Sunset Red
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let goldCelebration = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.84, blue: 0.0),  // Pure Gold
            Color(red: 1.0, green: 0.65, blue: 0.0),  // Deep Gold
            Color(red: 0.85, green: 0.55, blue: 0.0)  // Bronze
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Primary Colors
    static let quantumCyan = Color(red: 0.0, green: 0.9, blue: 1.0)
    static let quantumPurple = Color(red: 0.6, green: 0.3, blue: 1.0)
    static let quantumPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let quantumGold = Color(red: 1.0, green: 0.75, blue: 0.3)
    static let quantumGreen = Color(red: 0.3, green: 1.0, blue: 0.6)

    // Background Gradients
    static let deepSpace = LinearGradient(
        colors: [
            Color(red: 0.03, green: 0.03, blue: 0.08),
            Color(red: 0.08, green: 0.05, blue: 0.15),
            Color(red: 0.05, green: 0.02, blue: 0.1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cosmicDark = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.05, blue: 0.12),
            Color(red: 0.1, green: 0.05, blue: 0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Glassmorphism Colors
    static let glassWhite = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.15)
    static let glassHighlight = Color.white.opacity(0.25)

    // Success/Error Colors
    static let successGreen = Color(red: 0.2, green: 0.9, blue: 0.5)
    static let errorRed = Color(red: 1.0, green: 0.35, blue: 0.35)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
}

// MARK: - Typography
struct QuantumHorizonTypography {
    // Bold Headlines
    static func heroTitle(_ size: CGFloat = 48) -> Font {
        .system(size: size, weight: .black, design: .rounded)
    }

    static func sectionTitle(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func cardTitle(_ size: CGFloat = 18) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    // Body Text
    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func caption(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    // Numeric Display
    static func largeNumber(_ size: CGFloat = 56) -> Font {
        .system(size: size, weight: .bold, design: .monospaced)
    }

    static func statNumber(_ size: CGFloat = 32) -> Font {
        .system(size: size, weight: .bold, design: .monospaced)
    }
}

// MARK: - Glassmorphism Modifier
struct GlassmorphismModifier: ViewModifier {
    var intensity: Double
    var cornerRadius: CGFloat
    var borderWidth: CGFloat

    init(intensity: Double = 0.1, cornerRadius: CGFloat = 24, borderWidth: CGFloat = 1) {
        self.intensity = intensity
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Blur background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(intensity))
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(.ultraThinMaterial)
                        )

                    // Glass gradient overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05),
                                    Color.white.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Glassmorphism View Extension
extension View {
    func glassmorphism(
        intensity: Double = 0.1,
        cornerRadius: CGFloat = 24,
        borderWidth: CGFloat = 1
    ) -> some View {
        self.modifier(GlassmorphismModifier(
            intensity: intensity,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth
        ))
    }
}

// MARK: - Bento Box Card
struct BentoCard<Content: View>: View {
    let title: String?
    let icon: String?
    let accentColor: Color
    let size: BentoSize
    @ViewBuilder let content: Content

    enum BentoSize {
        case small      // 1x1
        case medium     // 2x1
        case large      // 2x2
        case wide       // 3x1
        case tall       // 1x2

        var minHeight: CGFloat {
            switch self {
            case .small: return 140
            case .medium: return 140
            case .large: return 300
            case .wide: return 120
            case .tall: return 300
            }
        }
    }

    init(
        title: String? = nil,
        icon: String? = nil,
        accentColor: Color = QuantumHorizonColors.quantumCyan,
        size: BentoSize = .medium,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.accentColor = accentColor
        self.size = size
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if title != nil || icon != nil {
                HStack(spacing: 10) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(accentColor)
                    }
                    if let title = title {
                        Text(title)
                            .font(QuantumHorizonTypography.cardTitle())
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }

            content
        }
        .padding(20)
        .frame(minHeight: size.minHeight)
        .glassmorphism(intensity: 0.08, cornerRadius: 20)
        .shadow(color: accentColor.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Floating Glass Button
struct GlassButton: View {
    let title: String
    let icon: String?
    let accentGradient: LinearGradient
    let action: () -> Void

    @State private var isPressed = false

    init(
        title: String,
        icon: String? = nil,
        accentGradient: LinearGradient = QuantumHorizonColors.miamiSunset,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.accentGradient = accentGradient
        self.action = action
    }

    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(QuantumHorizonTypography.cardTitle(16))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(accentGradient)
                        .opacity(0.8)

                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .opacity(0.3)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: Color.orange.opacity(0.3), radius: isPressed ? 5 : 15, x: 0, y: isPressed ? 2 : 8)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Large Stat Display
struct StatDisplay: View {
    let value: String
    let label: String
    let accentColor: Color
    let showProgressiveDisclosure: Bool
    let detailContent: AnyView?

    @State private var showDetail = false

    init(
        value: String,
        label: String,
        accentColor: Color = QuantumHorizonColors.quantumCyan,
        showProgressiveDisclosure: Bool = false,
        detailContent: AnyView? = nil
    ) {
        self.value = value
        self.label = label
        self.accentColor = accentColor
        self.showProgressiveDisclosure = showProgressiveDisclosure
        self.detailContent = detailContent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(QuantumHorizonTypography.largeNumber())
                .foregroundStyle(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            HStack {
                Text(label)
                    .font(QuantumHorizonTypography.body(14))
                    .foregroundColor(.white.opacity(0.6))

                if showProgressiveDisclosure {
                    Spacer()
                    Button(action: { showDetail.toggle() }) {
                        Image(systemName: showDetail ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .foregroundColor(accentColor.opacity(0.6))
                    }
                }
            }

            if showDetail, let detail = detailContent {
                detail
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showDetail)
    }
}

// MARK: - Tab Bar Item
struct HubTabItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(accentColor.opacity(0.2))
                            .frame(width: 48, height: 48)

                        Circle()
                            .stroke(accentColor.opacity(0.5), lineWidth: 1)
                            .frame(width: 48, height: 48)
                    }

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? accentColor : .white.opacity(0.5))
                }
                .frame(width: 48, height: 48)

                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? accentColor : .white.opacity(0.5))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Miami Wave Animation
struct MiamiWaveAnimation: View {
    @State private var phase: CGFloat = 0
    let color: Color
    let amplitude: CGFloat
    let frequency: CGFloat

    init(color: Color = QuantumHorizonColors.quantumCyan, amplitude: CGFloat = 20, frequency: CGFloat = 2) {
        self.color = color
        self.amplitude = amplitude
        self.frequency = frequency
    }

    var body: some View {
        Canvas { context, size in
            var path = Path()
            let width = size.width
            let height = size.height
            let midHeight = height / 2

            path.move(to: CGPoint(x: 0, y: midHeight))

            for x in stride(from: 0, through: width, by: 1) {
                let relativeX = x / width
                let y = midHeight + sin((relativeX * frequency * .pi * 2) + phase) * amplitude
                path.addLine(to: CGPoint(x: x, y: y))
            }

            context.stroke(
                path,
                with: .linearGradient(
                    Gradient(colors: [color.opacity(0.8), color.opacity(0.3)]),
                    startPoint: CGPoint(x: 0, y: size.height / 2),
                    endPoint: CGPoint(x: size.width, y: size.height / 2)
                ),
                lineWidth: 2
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

// MARK: - Pulsing Glow Effect
struct PulsingGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isPulsing ? 0.8 : 0.3), radius: isPulsing ? radius * 1.5 : radius, x: 0, y: 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulsingGlow(color: Color = QuantumHorizonColors.quantumCyan, radius: CGFloat = 15) -> some View {
        modifier(PulsingGlow(color: color, radius: radius))
    }
}

// MARK: - Spring Button Style
struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

// MARK: - Gold Particle Celebration Effect
struct GoldParticleView: View {
    @State private var particles: [Particle] = []
    @Binding var isActive: Bool

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var rotation: Double
        var opacity: Double
        var velocity: CGPoint
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Image(systemName: "sparkle")
                        .font(.system(size: 12))
                        .foregroundStyle(QuantumHorizonColors.goldCelebration)
                        .scaleEffect(particle.scale)
                        .rotationEffect(.degrees(particle.rotation))
                        .opacity(particle.opacity)
                        .position(x: particle.x, y: particle.y)
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    createExplosion(in: geometry.size)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isActive = false
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func createExplosion(in size: CGSize) {
        let centerX = size.width / 2
        let centerY = size.height / 2

        particles = (0..<50).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 100...300)
            return Particle(
                x: centerX,
                y: centerY,
                scale: CGFloat.random(in: 0.5...1.5),
                rotation: Double.random(in: 0...360),
                opacity: 1.0,
                velocity: CGPoint(
                    x: cos(angle) * speed,
                    y: sin(angle) * speed
                )
            )
        }

        // Animate particles
        for i in particles.indices {
            withAnimation(.easeOut(duration: 1.5)) {
                particles[i].x += particles[i].velocity.x
                particles[i].y += particles[i].velocity.y
                particles[i].opacity = 0
                particles[i].scale *= 0.3
                particles[i].rotation += Double.random(in: 180...360)
            }
        }
    }
}

// MARK: - Neon Line Effect
struct NeonLine: View {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let color: Color
    @State private var pulsePhase: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.move(to: startPoint)
            path.addLine(to: endPoint)

            // Outer glow
            context.stroke(
                path,
                with: .color(color.opacity(0.3)),
                lineWidth: 8
            )

            // Middle glow
            context.stroke(
                path,
                with: .color(color.opacity(0.6)),
                lineWidth: 4
            )

            // Core line
            context.stroke(
                path,
                with: .color(color),
                lineWidth: 2
            )
        }
        .blur(radius: 1)
    }
}

// MARK: - Gradient Background
struct QuantumHorizonBackground: View {
    var body: some View {
        ZStack {
            // Deep space base
            QuantumHorizonColors.deepSpace
                .ignoresSafeArea()

            // Subtle grid pattern
            GeometryReader { geometry in
                Canvas { context, size in
                    let gridSize: CGFloat = 40

                    for x in stride(from: 0, through: size.width, by: gridSize) {
                        var path = Path()
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                        context.stroke(path, with: .color(.white.opacity(0.02)), lineWidth: 0.5)
                    }

                    for y in stride(from: 0, through: size.height, by: gridSize) {
                        var path = Path()
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                        context.stroke(path, with: .color(.white.opacity(0.02)), lineWidth: 0.5)
                    }
                }
            }

            // Ambient glow spots
            Circle()
                .fill(QuantumHorizonColors.quantumCyan.opacity(0.08))
                .frame(width: 400, height: 400)
                .blur(radius: 100)
                .offset(x: -100, y: -200)

            Circle()
                .fill(QuantumHorizonColors.quantumPurple.opacity(0.06))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: 150, y: 300)

            Circle()
                .fill(QuantumHorizonColors.quantumPink.opacity(0.05))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(x: 100, y: -100)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()

        VStack(spacing: 20) {
            BentoCard(title: "Success Rate", icon: "checkmark.circle.fill", accentColor: QuantumHorizonColors.quantumGreen) {
                StatDisplay(
                    value: "99.8%",
                    label: "Quantum Fidelity",
                    accentColor: QuantumHorizonColors.quantumGreen
                )
            }

            GlassButton(title: "Execute", icon: "play.fill") {
                print("Execute tapped")
            }

            MiamiWaveAnimation()
                .frame(height: 60)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
