import SwiftUI
import SceneKit
import SwiftQuantum

// MARK: - Lab Hub - "The Core"
// Simplified Apple HIG Compliant Design
// Clean, focused interface for quantum state manipulation

struct LabHubView: View {
    @ObservedObject var stateManager: QuantumStateManager
    @State private var measurementResults: [Int: Int] = [0: 0, 1: 0]
    @State private var lastMeasurementResult: Int?
    @State private var showCelebration = false
    @State private var selectedMode = 0  // 0: Control, 1: Measure

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Main Visualization: 3D Bloch Sphere
                blochSphereSection

                // Simplified Mode Selector
                modeSelector

                // Context-aware Content based on selected mode
                if selectedMode == 0 {
                    controlSection
                } else {
                    measureSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
        .overlay(
            GoldParticleView(isActive: $showCelebration)
        )
    }

    // MARK: - Mode Selector (Apple HIG Style)
    private var modeSelector: some View {
        HStack(spacing: 0) {
            modeButton(title: "Control", icon: "slider.horizontal.3", index: 0)
            modeButton(title: "Measure", icon: "waveform.path.ecg", index: 1)
        }
        .padding(4)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func modeButton(title: String, icon: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedMode = index
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(selectedMode == index ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                selectedMode == index ?
                AnyShapeStyle(QuantumHorizonColors.quantumCyan.opacity(0.3)) :
                AnyShapeStyle(Color.clear)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Bloch Sphere Section
    private var blochSphereSection: some View {
        ZStack {
            // Ambient glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            QuantumHorizonColors.quantumCyan.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: 30)

            // 3D Bloch Sphere
            BlochSphereView3D(qubit: stateManager.qubit)
                .frame(height: 260)
                .shadow(color: QuantumHorizonColors.quantumCyan.opacity(0.3), radius: 20, x: 0, y: 10)

            // Coordinates overlay
            VStack {
                Spacer()
                coordinatesBar
            }
        }
        .frame(height: 280)
    }

    private var coordinatesBar: some View {
        let bloch = stateManager.qubit.blochCoordinates()
        return HStack(spacing: 20) {
            coordinateLabel("X", value: bloch.x, color: .red)
            coordinateLabel("Y", value: bloch.y, color: .green)
            coordinateLabel("Z", value: bloch.z, color: .blue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func coordinateLabel(_ axis: String, value: Double, color: Color) -> some View {
        HStack(spacing: 4) {
            Text(axis)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            Text(String(format: "%+.2f", value))
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))
        }
    }

    // MARK: - Control Section (Simplified)
    private var controlSection: some View {
        VStack(spacing: 16) {
            // Probability Control Card
            probabilityCard

            // Gate Buttons - Clean Grid
            gateGridCard

            // State Info
            stateInfoCard
        }
    }

    // MARK: - Probability Card
    private var probabilityCard: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                Text("Probability")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text("|0⟩")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }

            HStack(spacing: 16) {
                // Percentage display
                Text(String(format: "%.0f%%", stateManager.probability0 * 100))
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                    .frame(width: 100)

                VStack(spacing: 10) {
                    // Slider
                    Slider(value: Binding(
                        get: { stateManager.probability0 },
                        set: { stateManager.updateState(probability0: $0, phase: stateManager.phase) }
                    ), in: 0...1)
                    .tint(QuantumHorizonColors.quantumCyan)

                    // Visual probability bars
                    HStack(spacing: 8) {
                        probBar("|0⟩", value: stateManager.probability0, color: QuantumHorizonColors.quantumCyan)
                        probBar("|1⟩", value: 1 - stateManager.probability0, color: QuantumHorizonColors.quantumPink)
                    }
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func probBar(_ label: String, value: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundColor(color)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * value)
                }
            }
            .frame(height: 6)

            Text(String(format: "%.0f%%", value * 100))
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.5))
        }
    }

    // MARK: - Gate Grid Card (Simplified 2x2)
    private var gateGridCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cube.transparent")
                    .foregroundColor(QuantumHorizonColors.quantumGold)
                Text("Quantum Gates")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                gateButton("H", label: "Hadamard", color: QuantumHorizonColors.quantumGold) {
                    stateManager.applyHadamard()
                }
                gateButton("X", label: "Pauli-X", color: .red) {
                    stateManager.applyPauliX()
                }
                gateButton("Y", label: "Pauli-Y", color: .green) {
                    stateManager.applyPauliY()
                }
                gateButton("Z", label: "Pauli-Z", color: .blue) {
                    stateManager.applyPauliZ()
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func gateButton(_ symbol: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: 6) {
                Text(symbol)
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .buttonStyle(SpringButtonStyle())
    }

    // MARK: - State Info Card
    private var stateInfoCard: some View {
        HStack(spacing: 16) {
            // State notation
            VStack(alignment: .leading, spacing: 4) {
                Text("State")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))

                Text("|ψ⟩ = \(stateNotation)")
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer()

            // Entropy
            VStack(alignment: .trailing, spacing: 4) {
                Text("Entropy")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))

                Text(String(format: "%.2f", entropy))
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }

            // Purity
            VStack(alignment: .trailing, spacing: 4) {
                Text("Purity")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))

                Text("1.00")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private var stateNotation: String {
        let alpha = sqrt(stateManager.probability0)
        let beta = sqrt(1 - stateManager.probability0)
        if stateManager.probability0 > 0.99 { return "|0⟩" }
        if stateManager.probability0 < 0.01 { return "|1⟩" }
        return String(format: "%.2f|0⟩ + %.2f|1⟩", alpha, beta)
    }

    private var entropy: Double {
        let p0 = stateManager.probability0
        let p1 = 1 - p0
        if p0 <= 0 || p1 <= 0 { return 0 }
        return -p0 * log2(p0) - p1 * log2(p1)
    }

    // MARK: - Measure Section (Simplified)
    private var measureSection: some View {
        VStack(spacing: 16) {
            // Measurement Buttons
            HStack(spacing: 14) {
                measureButton(
                    title: "Single",
                    subtitle: "Collapse state",
                    icon: "scope",
                    color: QuantumHorizonColors.quantumPurple
                ) {
                    performSingleMeasurement()
                }

                measureButton(
                    title: "1000x",
                    subtitle: "Statistics",
                    icon: "chart.bar.fill",
                    color: QuantumHorizonColors.quantumCyan
                ) {
                    performStatisticalMeasurement()
                }
            }

            // Results Card
            resultsCard

            // Reset Button
            resetButton
        }
    }

    private func measureButton(title: String, subtitle: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)

                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(SpringButtonStyle())
    }

    // MARK: - Results Card
    private var resultsCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                Text("Results")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()

                let total = (measurementResults[0] ?? 0) + (measurementResults[1] ?? 0)
                if total > 0 {
                    Text("\(total) measurements")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            let total = (measurementResults[0] ?? 0) + (measurementResults[1] ?? 0)

            if total == 0 {
                // Empty state
                VStack(spacing: 8) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.2))

                    Text("No measurements yet")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.4))

                    Text("Tap Single or 1000x to measure")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.3))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                HStack(spacing: 20) {
                    resultItem("|0⟩", count: measurementResults[0] ?? 0, total: total, color: QuantumHorizonColors.quantumCyan)
                    resultItem("|1⟩", count: measurementResults[1] ?? 0, total: total, color: QuantumHorizonColors.quantumPink)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func resultItem(_ label: String, count: Int, total: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(color)

            Text("\(count)")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            Text(String(format: "%.1f%%", Double(count) / Double(total) * 100))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))

            // Visual bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * (Double(count) / Double(total)))
                }
            }
            .frame(height: 6)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring()) {
                stateManager.reset()
                measurementResults = [0: 0, 1: 0]
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.counterclockwise")
                Text("Reset All")
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white.opacity(0.7))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Actions
    private func performSingleMeasurement() {
        let result = stateManager.qubit.measure()
        measurementResults[result, default: 0] += 1
        showCelebration = true

        if result == 0 {
            stateManager.setQubit(Qubit.zero)
        } else {
            stateManager.setQubit(Qubit.one)
        }
    }

    private func performStatisticalMeasurement() {
        let results = stateManager.qubit.measureMultiple(count: 1000)
        measurementResults[0, default: 0] += results[0] ?? 0
        measurementResults[1, default: 0] += results[1] ?? 0
        showCelebration = true
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        LabHubView(stateManager: QuantumStateManager())
    }
    .preferredColorScheme(.dark)
}
