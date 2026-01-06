import SwiftUI
import SwiftQuantum

// MARK: - Presets Hub - "Saved States Library"
// Presets + Examples 통합

struct PresetsHubView: View {
    @State private var selectedCategory: PresetCategory = .basic
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Search bar
                searchBar

                // Category filter
                categoryFilter

                // Presets grid
                presetsGrid
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.5))

            TextField("Search presets...", text: $searchText)
                .foregroundColor(.white)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(PresetCategory.allCases, id: \.self) { category in
                    categoryChip(category)
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private func categoryChip(_ category: PresetCategory) -> some View {
        let isSelected = selectedCategory == category

        return Button(action: {
            withAnimation(.spring(response: 0.3)) {
                selectedCategory = category
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                Text(category.title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .black : .white.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? AnyShapeStyle(QuantumHorizonColors.quantumGreen)
                    : AnyShapeStyle(Color.white.opacity(0.1))
            )
            .clipShape(Capsule())
        }
    }

    // MARK: - Presets Grid
    private var presetsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 14),
            GridItem(.flexible(), spacing: 14)
        ], spacing: 14) {
            ForEach(filteredPresets) { preset in
                PresetCard(preset: preset)
            }
        }
    }

    private var filteredPresets: [QuantumPreset] {
        let categoryPresets = QuantumPreset.allPresets.filter { $0.category == selectedCategory }
        if searchText.isEmpty {
            return categoryPresets
        }
        return categoryPresets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Preset Category
enum PresetCategory: String, CaseIterable {
    case basic = "basic"
    case superposition = "superposition"
    case entanglement = "entanglement"
    case algorithms = "algorithms"

    var title: String {
        switch self {
        case .basic: return "Basic"
        case .superposition: return "Superposition"
        case .entanglement: return "Entanglement"
        case .algorithms: return "Algorithms"
        }
    }

    var icon: String {
        switch self {
        case .basic: return "circle"
        case .superposition: return "waveform"
        case .entanglement: return "link"
        case .algorithms: return "function"
        }
    }
}

// MARK: - Quantum Preset Model
struct QuantumPreset: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let category: PresetCategory
    let probability0: Double
    let phase: Double
    let icon: String
    let color: Color

    static let allPresets: [QuantumPreset] = [
        // Basic
        QuantumPreset(name: "|0⟩ State", description: "Ground state", category: .basic, probability0: 1.0, phase: 0, icon: "0.circle.fill", color: QuantumHorizonColors.quantumCyan),
        QuantumPreset(name: "|1⟩ State", description: "Excited state", category: .basic, probability0: 0.0, phase: 0, icon: "1.circle.fill", color: QuantumHorizonColors.quantumPink),

        // Superposition
        QuantumPreset(name: "|+⟩ State", description: "Equal superposition", category: .superposition, probability0: 0.5, phase: 0, icon: "plus.circle.fill", color: QuantumHorizonColors.quantumGold),
        QuantumPreset(name: "|-⟩ State", description: "Minus superposition", category: .superposition, probability0: 0.5, phase: .pi, icon: "minus.circle.fill", color: QuantumHorizonColors.quantumPurple),
        QuantumPreset(name: "|i⟩ State", description: "Imaginary phase", category: .superposition, probability0: 0.5, phase: .pi/2, icon: "i.circle.fill", color: QuantumHorizonColors.quantumGreen),
        QuantumPreset(name: "|-i⟩ State", description: "Negative imaginary", category: .superposition, probability0: 0.5, phase: -.pi/2, icon: "i.circle", color: .orange),

        // Entanglement examples (single qubit representation)
        QuantumPreset(name: "Bell Basis", description: "Maximally entangled", category: .entanglement, probability0: 0.5, phase: 0, icon: "bell.fill", color: QuantumHorizonColors.quantumCyan),
        QuantumPreset(name: "GHZ State", description: "3-qubit entanglement", category: .entanglement, probability0: 0.5, phase: 0, icon: "point.3.connected.trianglepath.dotted", color: QuantumHorizonColors.quantumPink),

        // Algorithms
        QuantumPreset(name: "Hadamard", description: "After H gate", category: .algorithms, probability0: 0.5, phase: 0, icon: "h.circle.fill", color: QuantumHorizonColors.quantumGold),
        QuantumPreset(name: "T Gate", description: "π/4 rotation", category: .algorithms, probability0: 1.0, phase: .pi/4, icon: "t.circle.fill", color: QuantumHorizonColors.quantumPurple),
        QuantumPreset(name: "S Gate", description: "π/2 rotation", category: .algorithms, probability0: 1.0, phase: .pi/2, icon: "s.circle.fill", color: QuantumHorizonColors.quantumGreen),
    ]
}

// MARK: - Preset Card
struct PresetCard: View {
    let preset: QuantumPreset
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            // Apply preset action
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon and probability
                HStack {
                    Image(systemName: preset.icon)
                        .font(.system(size: 24))
                        .foregroundColor(preset.color)

                    Spacer()

                    Text(String(format: "%.0f%%", preset.probability0 * 100))
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(preset.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text(preset.description)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }

                // Mini probability bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.1))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(preset.color)
                            .frame(width: geo.size.width * preset.probability0)
                    }
                }
                .frame(height: 4)
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(preset.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(SpringButtonStyle())
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
