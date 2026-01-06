import SwiftUI
import SceneKit
import SwiftQuantum

// MARK: - Lab Hub - "The Core"
// Controls + Measure + Info 통합 - 벤토 그리드 기반 단일 화면

struct LabHubView: View {
    @ObservedObject var stateManager: QuantumStateManager
    @State private var measurementResults: [Int: Int] = [0: 0, 1: 0]
    @State private var lastMeasurementResult: Int?
    @State private var showCelebration = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 상단: 3D Bloch Sphere (40% 영역)
                blochSphereSection

                // 게이트 컨트롤 (가로 스크롤)
                gateControlStrip

                // 벤토 그리드 영역
                bentoGridSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
        .overlay(
            GoldParticleView(isActive: $showCelebration)
        )
    }

    // MARK: - Bloch Sphere Section (상단 40%)
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
                .frame(height: 280)
                .shadow(color: QuantumHorizonColors.quantumCyan.opacity(0.3), radius: 20, x: 0, y: 10)

            // Coordinates overlay
            VStack {
                Spacer()
                coordinatesBar
            }
        }
        .frame(height: 300)
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

    // MARK: - Gate Control Strip (가로 스크롤)
    private var gateControlStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
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
                gateButton("φ", label: "Phase", color: QuantumHorizonColors.quantumPurple) {
                    // Phase gate
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private func gateButton(_ symbol: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: 6) {
                Text(symbol)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.4), lineWidth: 1)
                    )

                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .buttonStyle(SpringButtonStyle())
    }

    // MARK: - Bento Grid Section
    private var bentoGridSection: some View {
        VStack(spacing: 14) {
            // Row 1: Probability Control (wide)
            probabilityCard

            // Row 2: Measurement + Qubit Info
            HStack(spacing: 14) {
                measurementCard
                qubitInfoCard
            }

            // Row 3: Results + Reset
            HStack(spacing: 14) {
                resultsCard
                resetCard
            }
        }
    }

    // MARK: - Probability Card
    private var probabilityCard: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                Text("Probability Control")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }

            HStack(spacing: 16) {
                // Big percentage display
                Text(String(format: "%.0f%%", stateManager.probability0 * 100))
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundColor(QuantumHorizonColors.quantumCyan)

                VStack(spacing: 8) {
                    // Slider
                    Slider(value: Binding(
                        get: { stateManager.probability0 },
                        set: { stateManager.updateState(probability0: $0, phase: stateManager.phase) }
                    ), in: 0...1)
                    .tint(QuantumHorizonColors.quantumCyan)

                    // Probability bars
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

            Text(String(format: "%.1f%%", value * 100))
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.5))
        }
    }

    // MARK: - Measurement Card
    private var measurementCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(QuantumHorizonColors.quantumPurple)
                Text("Measure")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }

            VStack(spacing: 10) {
                // Single measurement
                Button(action: performSingleMeasurement) {
                    HStack {
                        Image(systemName: "scope")
                        Text("Single")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(QuantumHorizonColors.quantumPurple.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // Statistical measurement
                Button(action: performStatisticalMeasurement) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("1000x")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [QuantumHorizonColors.quantumPurple, QuantumHorizonColors.quantumPink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Qubit Info Card
    private var qubitInfoCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                Text("State")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                // State notation
                Text("|ψ⟩ = \(stateNotation)")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                Divider().background(Color.white.opacity(0.1))

                HStack {
                    statItem("Entropy", value: String(format: "%.2f", entropy))
                    Spacer()
                    statItem("Purity", value: "1.00")
                }
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
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

    private func statItem(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.5))
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }

    // MARK: - Results Card
    private var resultsCard: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(QuantumHorizonColors.quantumCyan)
                Text("Results")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }

            let total = (measurementResults[0] ?? 0) + (measurementResults[1] ?? 0)

            HStack(spacing: 16) {
                resultItem("|0⟩", count: measurementResults[0] ?? 0, total: total, color: QuantumHorizonColors.quantumCyan)
                resultItem("|1⟩", count: measurementResults[1] ?? 0, total: total, color: QuantumHorizonColors.quantumPink)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func resultItem(_ label: String, count: Int, total: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            Text("\(count)")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            if total > 0 {
                Text(String(format: "%.1f%%", Double(count) / Double(total) * 100))
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Reset Card
    private var resetCard: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                    .foregroundColor(.orange)
                Text("Reset")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }

            VStack(spacing: 8) {
                Button(action: {
                    stateManager.reset()
                }) {
                    Text("Reset Qubit")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: {
                    measurementResults = [0: 0, 1: 0]
                }) {
                    Text("Clear Stats")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
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
