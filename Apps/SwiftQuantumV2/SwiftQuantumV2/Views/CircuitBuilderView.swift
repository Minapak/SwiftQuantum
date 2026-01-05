//
//  CircuitBuilderView.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import SwiftUI
import SwiftQuantum

struct CircuitBuilderView: View {
    @State private var numberOfQubits = 2
    @State private var gates: [(gate: String, qubits: [Int], params: [Double]?)] = []
    @State private var results: [String: Int] = [:]
    @State private var shots = 1000
    @State private var showQASM = false
    @State private var qasmCode = ""

    private let availableGates = [
        GateInfo(name: "H", fullName: "Hadamard", qubits: 1, icon: "h.circle.fill", color: .cyan),
        GateInfo(name: "X", fullName: "Pauli-X", qubits: 1, icon: "x.circle.fill", color: .red),
        GateInfo(name: "Y", fullName: "Pauli-Y", qubits: 1, icon: "y.circle.fill", color: .green),
        GateInfo(name: "Z", fullName: "Pauli-Z", qubits: 1, icon: "z.circle.fill", color: .blue),
        GateInfo(name: "S", fullName: "S Gate", qubits: 1, icon: "s.circle.fill", color: .purple),
        GateInfo(name: "T", fullName: "T Gate", qubits: 1, icon: "t.circle.fill", color: .orange),
        GateInfo(name: "CX", fullName: "CNOT", qubits: 2, icon: "arrow.triangle.branch", color: .pink),
        GateInfo(name: "CZ", fullName: "CZ Gate", qubits: 2, icon: "link", color: .yellow),
        GateInfo(name: "SWAP", fullName: "SWAP", qubits: 2, icon: "arrow.left.arrow.right", color: .mint)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: QuantumSpacing.lg) {
                    // Header
                    headerSection

                    // Qubit Configuration
                    qubitConfigSection

                    // Gate Palette
                    gatePaletteSection

                    // Circuit Display
                    circuitDisplaySection

                    // Action Buttons
                    actionButtons

                    // Results
                    if !results.isEmpty {
                        resultsSection
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showQASM) {
                QASMView(code: qasmCode)
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Circuit Builder")
                    .font(QuantumTypography.displayMedium)
                    .foregroundColor(.white)

                Text("Design quantum circuits visually")
                    .font(QuantumTypography.body)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "cpu")
                .font(.system(size: 36))
                .foregroundColor(QuantumColors.primary)
        }
        .quantumCard()
    }

    // MARK: - Qubit Configuration

    private var qubitConfigSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Qubits", icon: "circle.hexagongrid")

            HStack {
                Text("Number of Qubits:")
                    .font(QuantumTypography.body)
                    .foregroundColor(.white)

                Spacer()

                HStack(spacing: QuantumSpacing.sm) {
                    Button(action: { if numberOfQubits > 1 { numberOfQubits -= 1; clearCircuit() } }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(numberOfQubits > 1 ? QuantumColors.primary : .gray)
                    }
                    .disabled(numberOfQubits <= 1)

                    Text("\(numberOfQubits)")
                        .font(QuantumTypography.monospaceLarge)
                        .foregroundColor(.white)
                        .frame(width: 40)

                    Button(action: { if numberOfQubits < 5 { numberOfQubits += 1; clearCircuit() } }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(numberOfQubits < 5 ? QuantumColors.primary : .gray)
                    }
                    .disabled(numberOfQubits >= 5)
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Gate Palette

    private var gatePaletteSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Gate Palette", icon: "square.grid.2x2")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: QuantumSpacing.sm) {
                ForEach(availableGates, id: \.name) { gate in
                    GatePaletteButton(gate: gate) {
                        addGate(gate)
                    }
                    .disabled(gate.qubits > numberOfQubits)
                }
            }
        }
    }

    // MARK: - Circuit Display

    private var circuitDisplaySection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            HStack {
                QuantumSectionHeader("Circuit", icon: "waveform.path")

                Spacer()

                if !gates.isEmpty {
                    Button(action: clearCircuit) {
                        HStack(spacing: 4) {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                        .font(QuantumTypography.caption)
                        .foregroundColor(QuantumColors.error)
                    }
                }
            }

            VStack(spacing: QuantumSpacing.sm) {
                if gates.isEmpty {
                    Text("Add gates from the palette above")
                        .font(QuantumTypography.body)
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, QuantumSpacing.xl)
                } else {
                    // Circuit wire visualization
                    VStack(alignment: .leading, spacing: QuantumSpacing.md) {
                        ForEach(0..<numberOfQubits, id: \.self) { qubit in
                            circuitWire(for: qubit)
                        }
                    }

                    // Gate list
                    VStack(spacing: QuantumSpacing.xs) {
                        ForEach(Array(gates.enumerated()), id: \.offset) { index, gate in
                            CircuitGateRow(
                                index: index,
                                gate: gate.gate,
                                qubits: gate.qubits,
                                onDelete: { removeGate(at: index) }
                            )
                        }
                    }
                }
            }
            .quantumCard()
        }
    }

    private func circuitWire(for qubit: Int) -> some View {
        HStack(spacing: QuantumSpacing.xs) {
            Text("q\(qubit)")
                .font(QuantumTypography.monospace)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 24)

            ZStack {
                // Wire line
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 2)

                // Gates on this wire
                HStack(spacing: QuantumSpacing.sm) {
                    ForEach(Array(gates.enumerated()), id: \.offset) { index, gate in
                        if gate.qubits.contains(qubit) {
                            Text(gate.gate)
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(4)
                                .background(gateColor(for: gate.gate))
                                .cornerRadius(4)
                        }
                    }
                    Spacer()
                }
            }
        }
    }

    private func gateColor(for gate: String) -> Color {
        availableGates.first { $0.name == gate }?.color ?? .gray
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: QuantumSpacing.md) {
            Button(action: runCircuit) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Run")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(QuantumPrimaryButtonStyle())
            .disabled(gates.isEmpty)

            Button(action: exportQASM) {
                HStack {
                    Image(systemName: "doc.text")
                    Text("QASM")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(QuantumSecondaryButtonStyle())
            .disabled(gates.isEmpty)
        }
    }

    // MARK: - Results

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Measurement Results", icon: "chart.bar.fill")

            VStack(spacing: QuantumSpacing.sm) {
                let totalShots = results.values.reduce(0, +)
                ForEach(results.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    QuantumMeasurementBar(
                        label: "|\(key)⟩",
                        value: value,
                        total: totalShots,
                        color: QuantumColors.primary
                    )
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Actions

    private func addGate(_ gate: GateInfo) {
        if gate.qubits == 1 {
            // Single qubit gate - apply to qubit 0 by default
            gates.append((gate: gate.name, qubits: [0], params: nil))
        } else {
            // Two qubit gate - apply to qubits 0 and 1
            gates.append((gate: gate.name, qubits: [0, 1], params: nil))
        }
    }

    private func removeGate(at index: Int) {
        gates.remove(at: index)
        results = [:]
    }

    private func clearCircuit() {
        gates = []
        results = [:]
    }

    private func runCircuit() {
        let builder = BridgeCircuitBuilder(numberOfQubits: numberOfQubits)

        for gate in gates {
            switch gate.gate {
            case "H": builder.h(gate.qubits[0])
            case "X": builder.x(gate.qubits[0])
            case "Y": builder.y(gate.qubits[0])
            case "Z": builder.z(gate.qubits[0])
            case "S": builder.s(gate.qubits[0])
            case "T": builder.t(gate.qubits[0])
            case "CX": builder.cx(control: gate.qubits[0], target: gate.qubits[1])
            case "CZ": builder.cz(control: gate.qubits[0], target: gate.qubits[1])
            case "SWAP": builder.swap(gate.qubits[0], gate.qubits[1])
            default: break
            }
        }

        results = builder.execute(shots: shots)
    }

    private func exportQASM() {
        let gatesForQASM = gates.map { ($0.gate.lowercased(), $0.qubits, $0.params) }
        qasmCode = QuantumBridge.toQASM(numberOfQubits: numberOfQubits, gates: gatesForQASM)
        showQASM = true
    }
}

// MARK: - Gate Info

struct GateInfo {
    let name: String
    let fullName: String
    let qubits: Int
    let icon: String
    let color: Color
}

// MARK: - Gate Palette Button

struct GatePaletteButton: View {
    let gate: GateInfo
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: QuantumSpacing.xs) {
                Image(systemName: gate.icon)
                    .font(.system(size: 24))
                    .foregroundColor(gate.color)

                Text(gate.name)
                    .font(QuantumTypography.monospace)
                    .foregroundColor(.white)

                Text("\(gate.qubits)Q")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(QuantumSpacing.sm)
            .background(gate.color.opacity(0.15))
            .cornerRadius(QuantumSpacing.cornerRadiusSmall)
        }
    }
}

// MARK: - Circuit Gate Row

struct CircuitGateRow: View {
    let index: Int
    let gate: String
    let qubits: [Int]
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text("\(index + 1).")
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 24)

            Text(gate)
                .font(QuantumTypography.monospace)
                .foregroundColor(.white)

            Text("q\(qubits.map { String($0) }.joined(separator: ", q"))")
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.6))

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(QuantumColors.error.opacity(0.7))
            }
        }
        .padding(.vertical, QuantumSpacing.xxs)
    }
}

// MARK: - QASM View

struct QASMView: View {
    let code: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                QuantumColors.backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: QuantumSpacing.md) {
                        Text("OpenQASM 2.0")
                            .font(QuantumTypography.headline)
                            .foregroundColor(.white)

                        Text(code)
                            .font(QuantumTypography.monospace)
                            .foregroundColor(QuantumColors.primary)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(QuantumSpacing.cornerRadiusSmall)

                        Button(action: copyToClipboard) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy to Clipboard")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(QuantumPrimaryButtonStyle())
                    }
                    .padding()
                }
            }
            .navigationTitle("QASM Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(QuantumColors.primary)
                }
            }
        }
    }

    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = code
        #endif
    }
}

// MARK: - Preview

struct CircuitBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        CircuitBuilderView()
            .preferredColorScheme(.dark)
            .background(QuantumColors.backgroundGradient)
    }
}
