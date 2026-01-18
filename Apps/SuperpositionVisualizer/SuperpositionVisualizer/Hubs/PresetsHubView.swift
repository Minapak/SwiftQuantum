import SwiftUI
import SwiftQuantum

// MARK: - Circuits Hub - "Circuit Builder"
// Interactive quantum circuit builder with predefined templates
// Replaces the old Presets tab with more practical functionality

struct PresetsHubView: View {
    @StateObject private var viewModel = CircuitsHubViewModel()
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var selectedCircuit: QuantumCircuitTemplate?
    @State private var showCircuitDetail = false
    @State private var showRunResult = false
    @State private var showPremiumSheet = false

    // Helper for localized strings
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section - Quick Circuit Builder
                heroSection

                // Quick Actions - Popular Circuits
                quickCircuitsSection

                // Featured Circuits
                featuredCircuitsSection

                // Circuit Templates by Category
                circuitTemplatesSection

                // Recent Runs (if any)
                if !viewModel.recentRuns.isEmpty {
                    recentRunsSection
                }

                Spacer(minLength: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .sheet(isPresented: $showCircuitDetail) {
            if let circuit = selectedCircuit {
                CircuitDetailSheet(circuit: circuit, viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showPremiumSheet) {
            CircuitsPremiumSheet()
        }
    }

    // MARK: - Handle Circuit Selection
    private func handleCircuitSelection(_ circuit: QuantumCircuitTemplate) {
        if circuit.isPremium && !premiumManager.isPremium {
            // Show premium sheet for non-premium users clicking premium circuits
            DeveloperModeManager.shared.log(screen: "Circuits", element: "\(circuit.name) (Premium Required)", status: .comingSoon)
            showPremiumSheet = true
        } else {
            // Show circuit detail for free circuits or premium users
            DeveloperModeManager.shared.log(screen: "Circuits", element: circuit.name, status: .success)
            selectedCircuit = circuit
            showCircuitDetail = true
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        BentoCard(size: .medium) {
            VStack(spacing: 16) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(QuantumHorizonColors.quantumPurple.opacity(0.2))
                            .frame(width: 56, height: 56)
                        Image(systemName: "cpu")
                            .font(.system(size: 26))
                            .foregroundStyle(QuantumHorizonColors.miamiSunset)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(L("circuits.title"))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text(L("circuits.subtitle"))
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()
                }

                // Key Benefits Row - Intuitive description
                VStack(spacing: 8) {
                    heroBenefitRow(
                        icon: "waveform.path.ecg",
                        text: L("circuits.hero.benefit1"),
                        color: QuantumHorizonColors.quantumCyan
                    )
                    heroBenefitRow(
                        icon: "doc.on.doc",
                        text: L("circuits.hero.benefit2"),
                        color: QuantumHorizonColors.quantumPurple
                    )
                    heroBenefitRow(
                        icon: "play.circle",
                        text: L("circuits.hero.benefit3"),
                        color: QuantumHorizonColors.quantumGold
                    )
                }
            }
        }
    }

    private func heroBenefitRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
                .frame(width: 18)

            Text(text)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 11))
                .foregroundColor(QuantumHorizonColors.quantumGreen.opacity(0.7))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Quick Circuits Section
    private var quickCircuitsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L("circuits.quick.title"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.quickCircuits) { circuit in
                        QuickCircuitCard(circuit: circuit) {
                            handleCircuitSelection(circuit)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Featured Circuits Section
    private var featuredCircuitsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(L("circuits.featured.title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(QuantumHorizonColors.goldCelebration)
                    .font(.system(size: 14))
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.featuredCircuits) { circuit in
                    FeaturedCircuitCard(circuit: circuit) {
                        handleCircuitSelection(circuit)
                    }
                }
            }
        }
    }

    // MARK: - Circuit Templates Section
    private var circuitTemplatesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L("circuits.templates.title"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            ForEach(CircuitCategory.allCases, id: \.self) { category in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: category.icon)
                            .font(.system(size: 14))
                            .foregroundColor(category.color)
                        Text(category.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.circuits(for: category)) { circuit in
                                CircuitTemplateCard(circuit: circuit) {
                                    handleCircuitSelection(circuit)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }

    // MARK: - Recent Runs Section
    private var recentRunsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(L("circuits.recent.title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    viewModel.clearRecentRuns()
                }) {
                    Text(L("circuits.recent.clear"))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            ForEach(viewModel.recentRuns) { run in
                RecentRunCard(run: run)
            }
        }
    }
}

// MARK: - Circuit Category
enum CircuitCategory: String, CaseIterable {
    case basic = "basic"
    case entanglement = "entanglement"
    case algorithms = "algorithms"
    case errorCorrection = "error_correction"

    var title: String {
        switch self {
        case .basic: return "circuits.category.basic".quantumLocalized
        case .entanglement: return "circuits.category.entanglement".quantumLocalized
        case .algorithms: return "circuits.category.algorithms".quantumLocalized
        case .errorCorrection: return "circuits.category.error".quantumLocalized
        }
    }

    var icon: String {
        switch self {
        case .basic: return "square.on.circle"
        case .entanglement: return "link"
        case .algorithms: return "function"
        case .errorCorrection: return "checkmark.shield"
        }
    }

    var color: Color {
        switch self {
        case .basic: return QuantumHorizonColors.quantumCyan
        case .entanglement: return QuantumHorizonColors.quantumPink
        case .algorithms: return QuantumHorizonColors.quantumGold
        case .errorCorrection: return QuantumHorizonColors.quantumGreen
        }
    }
}

// MARK: - Quantum Circuit Template Model
struct QuantumCircuitTemplate: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let category: CircuitCategory
    let qubits: Int
    let gates: [String]
    let icon: String
    let color: Color
    let difficulty: Difficulty
    let isPremium: Bool

    enum Difficulty: String {
        case beginner = "circuits.difficulty.beginner"
        case intermediate = "circuits.difficulty.intermediate"
        case advanced = "circuits.difficulty.advanced"

        var localizedName: String {
            return rawValue.quantumLocalized
        }

        var color: Color {
            switch self {
            case .beginner: return .green
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
}

// MARK: - Circuit Run History
struct CircuitRun: Identifiable {
    let id = UUID()
    let circuitName: String
    let timestamp: Date
    let result: [String: Int]
    let shots: Int
}

// MARK: - Circuits Hub ViewModel
@MainActor
class CircuitsHubViewModel: ObservableObject {
    @Published var recentRuns: [CircuitRun] = []
    @Published var favoriteCount = 3
    @Published var totalRuns = 24

    var totalCircuits: Int { allCircuits.count }

    var quickCircuits: [QuantumCircuitTemplate] {
        [
            QuantumCircuitTemplate(
                name: "Bell State",
                description: "circuits.bell.desc".quantumLocalized,
                category: .entanglement,
                qubits: 2,
                gates: ["H", "CNOT"],
                icon: "bell.fill",
                color: QuantumHorizonColors.quantumCyan,
                difficulty: .beginner,
                isPremium: false
            ),
            QuantumCircuitTemplate(
                name: "GHZ State",
                description: "circuits.ghz.desc".quantumLocalized,
                category: .entanglement,
                qubits: 3,
                gates: ["H", "CNOT", "CNOT"],
                icon: "point.3.connected.trianglepath.dotted",
                color: QuantumHorizonColors.quantumPink,
                difficulty: .intermediate,
                isPremium: true
            ),
            QuantumCircuitTemplate(
                name: "Grover 2-qubit",
                description: "circuits.grover.desc".quantumLocalized,
                category: .algorithms,
                qubits: 2,
                gates: ["H", "H", "Oracle", "H", "H"],
                icon: "magnifyingglass",
                color: QuantumHorizonColors.quantumGold,
                difficulty: .advanced,
                isPremium: true
            )
        ]
    }

    var featuredCircuits: [QuantumCircuitTemplate] {
        [
            QuantumCircuitTemplate(
                name: "Quantum Teleportation",
                description: "circuits.teleport.desc".quantumLocalized,
                category: .algorithms,
                qubits: 3,
                gates: ["H", "CNOT", "CNOT", "H", "Measure", "X", "Z"],
                icon: "arrow.right.arrow.left",
                color: QuantumHorizonColors.quantumPurple,
                difficulty: .advanced,
                isPremium: true
            ),
            QuantumCircuitTemplate(
                name: "Deutsch-Jozsa",
                description: "circuits.dj.desc".quantumLocalized,
                category: .algorithms,
                qubits: 2,
                gates: ["X", "H", "H", "Oracle", "H", "Measure"],
                icon: "questionmark.circle",
                color: QuantumHorizonColors.quantumGreen,
                difficulty: .intermediate,
                isPremium: true
            ),
            QuantumCircuitTemplate(
                name: "Surface Code",
                description: "circuits.surface.desc".quantumLocalized,
                category: .errorCorrection,
                qubits: 9,
                gates: ["H", "CNOT", "Stabilizer", "Measure"],
                icon: "square.grid.3x3",
                color: QuantumHorizonColors.quantumCyan,
                difficulty: .advanced,
                isPremium: true
            ),
            QuantumCircuitTemplate(
                name: "QAOA",
                description: "circuits.qaoa.desc".quantumLocalized,
                category: .algorithms,
                qubits: 4,
                gates: ["H", "RZZ", "RX", "Measure"],
                icon: "chart.bar",
                color: .orange,
                difficulty: .advanced,
                isPremium: true
            )
        ]
    }

    var allCircuits: [QuantumCircuitTemplate] {
        var circuits = quickCircuits + featuredCircuits

        // Basic circuits
        circuits.append(contentsOf: [
            QuantumCircuitTemplate(
                name: "Single Hadamard",
                description: "circuits.hadamard.desc".quantumLocalized,
                category: .basic,
                qubits: 1,
                gates: ["H"],
                icon: "h.circle.fill",
                color: QuantumHorizonColors.quantumCyan,
                difficulty: .beginner,
                isPremium: false
            ),
            QuantumCircuitTemplate(
                name: "X Gate (NOT)",
                description: "circuits.xgate.desc".quantumLocalized,
                category: .basic,
                qubits: 1,
                gates: ["X"],
                icon: "x.circle.fill",
                color: QuantumHorizonColors.quantumPink,
                difficulty: .beginner,
                isPremium: false
            ),
            QuantumCircuitTemplate(
                name: "Phase Gates",
                description: "circuits.phase.desc".quantumLocalized,
                category: .basic,
                qubits: 1,
                gates: ["S", "T"],
                icon: "rotate.right",
                color: QuantumHorizonColors.quantumGold,
                difficulty: .beginner,
                isPremium: false
            )
        ])

        // Error correction circuits
        circuits.append(contentsOf: [
            QuantumCircuitTemplate(
                name: "Bit Flip Code",
                description: "circuits.bitflip.desc".quantumLocalized,
                category: .errorCorrection,
                qubits: 3,
                gates: ["CNOT", "CNOT", "Toffoli"],
                icon: "shield.checkered",
                color: QuantumHorizonColors.quantumGreen,
                difficulty: .intermediate,
                isPremium: true
            ),
            QuantumCircuitTemplate(
                name: "Phase Flip Code",
                description: "circuits.phaseflip.desc".quantumLocalized,
                category: .errorCorrection,
                qubits: 3,
                gates: ["H", "CNOT", "H", "Measure"],
                icon: "shield.lefthalf.filled",
                color: QuantumHorizonColors.quantumPurple,
                difficulty: .intermediate,
                isPremium: true
            )
        ])

        return circuits
    }

    func circuits(for category: CircuitCategory) -> [QuantumCircuitTemplate] {
        allCircuits.filter { $0.category == category }
    }

    func clearRecentRuns() {
        recentRuns.removeAll()
    }

    func runCircuit(_ circuit: QuantumCircuitTemplate, shots: Int = 1000) {
        // Simulate circuit run
        let result = simulateCircuitRun(qubits: circuit.qubits, shots: shots)
        let run = CircuitRun(circuitName: circuit.name, timestamp: Date(), result: result, shots: shots)
        recentRuns.insert(run, at: 0)
        if recentRuns.count > 5 {
            recentRuns.removeLast()
        }
        totalRuns += 1
    }

    private func simulateCircuitRun(qubits: Int, shots: Int) -> [String: Int] {
        // Simple simulation for demo
        let states = (0..<(1 << qubits)).map { String($0, radix: 2).leftPadding(toLength: qubits, withPad: "0") }
        var result: [String: Int] = [:]
        for _ in 0..<shots {
            let randomState = states.randomElement() ?? "0"
            result[randomState, default: 0] += 1
        }
        return result
    }
}

extension String {
    func leftPadding(toLength: Int, withPad: String) -> String {
        let newLength = self.count
        if newLength < toLength {
            return String(repeating: withPad, count: toLength - newLength) + self
        }
        return self
    }
}

// MARK: - Quick Circuit Card
struct QuickCircuitCard: View {
    let circuit: QuantumCircuitTemplate
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: circuit.icon)
                        .font(.system(size: 24))
                        .foregroundColor(circuit.color)
                    Spacer()
                    Text("\(circuit.qubits)Q")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                }

                Text(circuit.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Text(circuit.description)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(2)

                // Gates preview
                HStack(spacing: 4) {
                    ForEach(circuit.gates.prefix(4), id: \.self) { gate in
                        Text(gate)
                            .font(.system(size: 9, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(circuit.color.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    if circuit.gates.count > 4 {
                        Text("+\(circuit.gates.count - 4)")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
            }
            .padding(14)
            .frame(width: 160)
            .glassmorphism(intensity: 0.08, cornerRadius: 16)
        }
        .buttonStyle(SpringButtonStyle())
    }
}

// MARK: - Featured Circuit Card
struct FeaturedCircuitCard: View {
    let circuit: QuantumCircuitTemplate
    let action: () -> Void
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: circuit.icon)
                        .font(.system(size: 20))
                        .foregroundColor(circuit.color)

                    Spacer()

                    if circuit.isPremium && !premiumManager.isPremium {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    }

                    Text(circuit.difficulty.localizedName)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(circuit.difficulty.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(circuit.difficulty.color.opacity(0.2))
                        .clipShape(Capsule())
                }

                Text(circuit.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(circuit.description)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(2)

                HStack {
                    Text("\(circuit.qubits) \(L("circuits.qubits"))")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                    Spacer()
                    Text("\(circuit.gates.count) \(L("circuits.gates"))")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(12)
            .glassmorphism(intensity: 0.08, cornerRadius: 14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(circuit.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(SpringButtonStyle())
        .opacity(circuit.isPremium && !premiumManager.isPremium ? 0.7 : 1.0)
    }
}

// MARK: - Circuit Template Card
struct CircuitTemplateCard: View {
    let circuit: QuantumCircuitTemplate
    let action: () -> Void
    @ObservedObject var localization = LocalizationManager.shared

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(circuit.color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: circuit.icon)
                        .font(.system(size: 18))
                        .foregroundColor(circuit.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(circuit.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                    Text("\(circuit.qubits)Q · \(circuit.gates.count) \(L("circuits.gates"))")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(10)
            .glassmorphism(intensity: 0.06, cornerRadius: 12)
        }
        .buttonStyle(SpringButtonStyle())
    }
}

// MARK: - Recent Run Card
struct RecentRunCard: View {
    let run: CircuitRun

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 16))
                .foregroundColor(QuantumHorizonColors.quantumCyan)

            VStack(alignment: .leading, spacing: 2) {
                Text(run.circuitName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Text("\(run.shots) shots · \(run.timestamp.formatted(.relative(presentation: .numeric)))")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            // Mini result
            Text(run.result.keys.sorted().first ?? "")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(QuantumHorizonColors.quantumGreen)
        }
        .padding(12)
        .glassmorphism(intensity: 0.06, cornerRadius: 12)
    }
}

// MARK: - Circuit Detail Sheet
struct CircuitDetailSheet: View {
    let circuit: QuantumCircuitTemplate
    @ObservedObject var viewModel: CircuitsHubViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var isRunning = false
    @State private var runResult: [String: Int]?
    @State private var shots = 1000

    // Helper for localized strings
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        ZStack {
                            Circle()
                                .fill(circuit.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Image(systemName: circuit.icon)
                                .font(.system(size: 28))
                                .foregroundColor(circuit.color)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(circuit.name)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)

                            HStack(spacing: 8) {
                                Text("\(circuit.qubits) \(L("circuits.qubits"))")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))

                                Text(circuit.difficulty.localizedName)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(circuit.difficulty.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(circuit.difficulty.color.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }

                        Spacer()

                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L("circuits.detail.about"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text(circuit.description)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Gates
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("circuits.detail.gates"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                            ForEach(circuit.gates, id: \.self) { gate in
                                Text(gate)
                                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(circuit.color.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Run Circuit
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("circuits.detail.run"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        // Shots selector
                        HStack {
                            Text(L("circuits.shots"))
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                            Spacer()
                            ForEach([100, 1000, 4000], id: \.self) { shotCount in
                                Button(action: { shots = shotCount }) {
                                    Text("\(shotCount)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(shots == shotCount ? .black : .white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            shots == shotCount ?
                                            circuit.color :
                                            Color.white.opacity(0.1)
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }

                        // Run button
                        Button(action: runCircuit) {
                            HStack {
                                if isRunning {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "play.fill")
                                }
                                Text(isRunning ? L("circuits.running") : L("circuits.run"))
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(circuit.color.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(isRunning || (circuit.isPremium && !premiumManager.isPremium))
                    }
                    .padding()
                    .glassmorphism(intensity: 0.06, cornerRadius: 16)

                    // Result
                    if let result = runResult {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(QuantumHorizonColors.quantumGreen)
                                Text(L("circuits.result"))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            ForEach(result.sorted(by: { $0.value > $1.value }).prefix(4), id: \.key) { state, count in
                                HStack {
                                    Text("|\(state)⟩")
                                        .font(.system(size: 14, design: .monospaced))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(count)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(QuantumHorizonColors.quantumCyan)
                                    Text("(\(String(format: "%.1f", Double(count) / Double(shots) * 100))%)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                        }
                        .padding()
                        .glassmorphism(intensity: 0.08, cornerRadius: 16)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 50)
                }
                .padding(24)
            }
        }
    }

    private func runCircuit() {
        isRunning = true
        DeveloperModeManager.shared.log(screen: "Circuit Detail", element: "Run: \(circuit.name)", status: .success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring()) {
                viewModel.runCircuit(circuit, shots: shots)
                runResult = viewModel.recentRuns.first?.result
                isRunning = false
            }
        }
    }
}

// MARK: - Circuits Premium Sheet
struct CircuitsPremiumSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State private var showSuccessView = false

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            if showSuccessView {
                UpgradeSuccessView(isPresented: $showSuccessView)
                    .transition(.opacity)
                    .onDisappear {
                        dismiss()
                    }
            } else {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: {
                            DeveloperModeManager.shared.log(screen: "Circuits Premium", element: "Close Button", status: .success)
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    // Crown icon
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(QuantumHorizonColors.miamiSunset)

                    Text(L("circuits.premium.title"))
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(.white)

                    Text(L("circuits.premium.desc"))
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)

                    // Features list
                    VStack(alignment: .leading, spacing: 12) {
                        premiumFeatureRow(L("circuits.premium.feat1"))
                        premiumFeatureRow(L("circuits.premium.feat2"))
                        premiumFeatureRow(L("circuits.premium.feat3"))
                        premiumFeatureRow(L("circuits.premium.feat4"))
                        premiumFeatureRow(L("circuits.premium.feat5"))
                    }
                    .padding()
                    .glassmorphism(intensity: 0.08, cornerRadius: 16)

                    // Upgrade button
                    Button(action: {
                        DeveloperModeManager.shared.log(screen: "Circuits Premium", element: "Upgrade Button", status: .success)
                        premiumManager.upgradeToPremium()
                        withAnimation {
                            showSuccessView = true
                        }
                    }) {
                        Text(L("circuits.premium.upgrade"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(QuantumHorizonColors.miamiSunset)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Text(L("circuits.premium.trial"))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))

                    Spacer()
                }
                .padding(24)
            }
        }
    }

    private func premiumFeatureRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(QuantumHorizonColors.quantumGreen)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        PresetsHubView()
    }
    .preferredColorScheme(.dark)
}
