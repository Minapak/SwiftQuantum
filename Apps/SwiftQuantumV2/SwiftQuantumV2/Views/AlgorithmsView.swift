//
//  AlgorithmsView.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import SwiftUI
import SwiftQuantum

struct AlgorithmsView: View {
    @State private var selectedAlgorithm: AlgorithmType = .bellState
    @State private var isRunning = false
    @State private var results: [String: Int] = [:]
    @State private var algorithmOutput: String = ""
    @State private var shots: Int = 100

    enum AlgorithmType: String, CaseIterable {
        case bellState = "Bell State"
        case deutschJozsa = "Deutsch-Jozsa"
        case grover = "Grover's Search"
        case simon = "Simon's Algorithm"

        var icon: String {
            switch self {
            case .bellState: return "link.circle.fill"
            case .deutschJozsa: return "divide.circle.fill"
            case .grover: return "magnifyingglass.circle.fill"
            case .simon: return "waveform.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .bellState: return QuantumColors.bellState
            case .deutschJozsa: return QuantumColors.deutschJozsa
            case .grover: return QuantumColors.grover
            case .simon: return QuantumColors.simon
            }
        }

        var description: String {
            switch self {
            case .bellState: return "Creates maximally entangled qubit pairs showing quantum correlations that violate classical physics."
            case .deutschJozsa: return "Determines if a function is constant or balanced with a single query - exponential speedup over classical."
            case .grover: return "Searches an unstructured database in O(√N) time instead of O(N) - quadratic speedup."
            case .simon: return "Finds hidden periods in functions with exponential speedup over classical algorithms."
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: QuantumSpacing.lg) {
                    // Header
                    headerSection

                    // Algorithm Selector
                    algorithmSelector

                    // Algorithm Info
                    algorithmInfoCard

                    // Configuration
                    configurationSection

                    // Run Button
                    runButton

                    // Results
                    if !results.isEmpty || !algorithmOutput.isEmpty {
                        resultsSection
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantum Algorithms")
                    .font(QuantumTypography.displayMedium)
                    .foregroundColor(.white)

                Text("Experience quantum advantage")
                    .font(QuantumTypography.body)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "function")
                .font(.system(size: 36))
                .foregroundColor(selectedAlgorithm.color)
        }
        .quantumCard()
    }

    // MARK: - Algorithm Selector

    private var algorithmSelector: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Select Algorithm", icon: "list.bullet")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: QuantumSpacing.sm) {
                    ForEach(AlgorithmType.allCases, id: \.self) { algorithm in
                        AlgorithmChip(
                            algorithm: algorithm,
                            isSelected: selectedAlgorithm == algorithm
                        ) {
                            withAnimation {
                                selectedAlgorithm = algorithm
                                results = [:]
                                algorithmOutput = ""
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Algorithm Info

    private var algorithmInfoCard: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            HStack {
                Image(systemName: selectedAlgorithm.icon)
                    .font(.system(size: 28))
                    .foregroundColor(selectedAlgorithm.color)

                Text(selectedAlgorithm.rawValue)
                    .font(QuantumTypography.headline)
                    .foregroundColor(.white)

                Spacer()

                QuantumBadge("Quantum", color: selectedAlgorithm.color)
            }

            Text(selectedAlgorithm.description)
                .font(QuantumTypography.body)
                .foregroundColor(.white.opacity(0.8))

            // Circuit Diagram (simplified)
            circuitDiagram
        }
        .quantumCard()
    }

    // MARK: - Circuit Diagram

    private var circuitDiagram: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
            Text("Circuit:")
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.6))

            HStack(spacing: 0) {
                Text(circuitForAlgorithm)
                    .font(QuantumTypography.monospace)
                    .foregroundColor(selectedAlgorithm.color)
            }
            .padding(QuantumSpacing.sm)
            .background(Color.black.opacity(0.3))
            .cornerRadius(QuantumSpacing.cornerRadiusSmall)
        }
    }

    private var circuitForAlgorithm: String {
        switch selectedAlgorithm {
        case .bellState:
            return """
            q0: ─[H]─●─
                     │
            q1: ─────⊕─
            """
        case .deutschJozsa:
            return """
            x: ─[H]─[Uf]─[H]─[M]
            y: ─[X]─[H]──────────
            """
        case .grover:
            return """
            |0⟩^n ─[H]^n─[Oracle]─[Diffusion]─...─[M]
            """
        case .simon:
            return """
            x: ─[H]─[Uf]─[H]─[M]
            y: ─────[Uf]─────────
            """
        }
    }

    // MARK: - Configuration

    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Configuration", icon: "slider.horizontal.3")

            VStack(spacing: QuantumSpacing.md) {
                // Shots
                VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
                    HStack {
                        Text("Measurement Shots")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(shots)")
                            .font(QuantumTypography.monospace)
                            .foregroundColor(QuantumColors.primary)
                    }

                    Slider(value: Binding(
                        get: { Double(shots) },
                        set: { shots = Int($0) }
                    ), in: 10...1000, step: 10)
                    .accentColor(selectedAlgorithm.color)
                }

                // Quick presets
                HStack(spacing: QuantumSpacing.sm) {
                    ShotsPresetButton(value: 100, current: $shots)
                    ShotsPresetButton(value: 500, current: $shots)
                    ShotsPresetButton(value: 1000, current: $shots)
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Run Button

    private var runButton: some View {
        Button(action: runAlgorithm) {
            HStack {
                if isRunning {
                    QuantumLoadingView()
                        .scaleEffect(0.5)
                } else {
                    Image(systemName: "play.fill")
                }
                Text(isRunning ? "Running..." : "Run Algorithm")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedAlgorithm.color)
            .foregroundColor(.white)
            .cornerRadius(QuantumSpacing.cornerRadius)
        }
        .disabled(isRunning)
    }

    // MARK: - Results

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Results", icon: "chart.bar.fill")

            if !results.isEmpty {
                VStack(spacing: QuantumSpacing.sm) {
                    let totalShots = results.values.reduce(0, +)
                    ForEach(results.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                        QuantumMeasurementBar(
                            label: "|\(key)⟩",
                            value: value,
                            total: totalShots,
                            color: selectedAlgorithm.color
                        )
                    }
                }
                .quantumCard()
            }

            if !algorithmOutput.isEmpty {
                VStack(alignment: .leading, spacing: QuantumSpacing.sm) {
                    Text("Analysis")
                        .font(QuantumTypography.title)
                        .foregroundColor(.white)

                    Text(algorithmOutput)
                        .font(QuantumTypography.monospace)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
                .quantumCard()
            }
        }
    }

    // MARK: - Run Algorithm

    private func runAlgorithm() {
        isRunning = true
        results = [:]
        algorithmOutput = ""

        DispatchQueue.global(qos: .userInitiated).async {
            let output: String
            let measurements: [String: Int]

            switch selectedAlgorithm {
            case .bellState:
                let result = QuantumAlgorithms.BellState.run(type: .phiPlus, shots: shots)
                measurements = result.measurements
                output = """
                Bell State: |Φ+⟩ = (|00⟩ + |11⟩)/√2
                Shots: \(shots)
                Correlation: \(String(format: "%.3f", result.correlation))

                Expected: 50% |00⟩, 50% |11⟩
                This demonstrates quantum entanglement!
                """

            case .deutschJozsa:
                let result = QuantumAlgorithms.DeutschJozsa.run(
                    numberOfQubits: 3,
                    oracleType: .balanced,
                    shots: shots
                )
                measurements = result.measurements
                output = """
                Deutsch-Jozsa Algorithm
                Input qubits: \(result.numberOfQubits)
                Oracle: \(result.oracleType.rawValue)

                Conclusion: \(result.conclusion)
                Correct: \(result.isCorrect ? "✓" : "✗")

                Quantum Advantage:
                Classical: O(2^(n-1)+1) queries
                Quantum: O(1) query
                """

            case .grover:
                let targetState = Int.random(in: 0..<8)
                let result = QuantumAlgorithms.GroverSearch.run(
                    numberOfQubits: 3,
                    targetState: targetState,
                    shots: shots
                )
                measurements = result.measurements
                output = """
                Grover's Search
                Search space: \(result.searchSpaceSize) items
                Target: |\(result.targetBinaryString)⟩ (decimal: \(result.targetState))
                Iterations: \(result.iterations)

                Success rate: \(String(format: "%.1f", result.successProbability * 100))%
                Theoretical: \(String(format: "%.1f", result.theoreticalSuccessProbability * 100))%

                Quantum Advantage:
                Classical: O(\(result.searchSpaceSize)) queries
                Quantum: O(√\(result.searchSpaceSize)) = \(result.iterations) iterations
                """

            case .simon:
                let hiddenString = Int.random(in: 1..<8)
                let result = QuantumAlgorithms.SimonAlgorithm.run(
                    numberOfQubits: 3,
                    hiddenString: hiddenString,
                    shots: shots
                )
                measurements = result.measurements
                let foundStr = result.foundBinaryString ?? "Not found"
                output = """
                Simon's Algorithm
                Input qubits: \(result.numberOfQubits)
                Hidden string: \(result.hiddenBinaryString)

                Found: \(foundStr)
                Correct: \(result.isCorrect ? "✓" : "✗")

                Quantum Advantage:
                Classical: O(2^(n/2)) queries
                Quantum: O(n) queries
                """
            }

            DispatchQueue.main.async {
                self.results = measurements
                self.algorithmOutput = output
                self.isRunning = false
            }
        }
    }
}

// MARK: - Algorithm Chip

struct AlgorithmChip: View {
    let algorithm: AlgorithmsView.AlgorithmType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: QuantumSpacing.xs) {
                Image(systemName: algorithm.icon)
                    .font(.system(size: 14))
                Text(algorithm.rawValue)
                    .font(QuantumTypography.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : algorithm.color)
            .padding(.horizontal, QuantumSpacing.md)
            .padding(.vertical, QuantumSpacing.sm)
            .background(isSelected ? algorithm.color : algorithm.color.opacity(0.15))
            .cornerRadius(QuantumSpacing.cornerRadius)
        }
    }
}

// MARK: - Shots Preset Button

struct ShotsPresetButton: View {
    let value: Int
    @Binding var current: Int

    var body: some View {
        Button(action: { current = value }) {
            Text("\(value)")
                .font(QuantumTypography.caption)
                .fontWeight(.medium)
                .foregroundColor(current == value ? .white : .white.opacity(0.6))
                .padding(.horizontal, QuantumSpacing.md)
                .padding(.vertical, QuantumSpacing.xs)
                .background(current == value ? QuantumColors.primary : Color.white.opacity(0.1))
                .cornerRadius(QuantumSpacing.cornerRadiusSmall)
        }
    }
}

// MARK: - Preview

struct AlgorithmsView_Previews: PreviewProvider {
    static var previews: some View {
        AlgorithmsView()
            .preferredColorScheme(.dark)
            .background(QuantumColors.backgroundGradient)
    }
}
