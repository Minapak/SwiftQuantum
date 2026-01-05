//
//  ErrorCorrectionView.swift
//  SuperpositionVisualizer - SwiftQuantum v2.1.0
//
//  Created by Eunmin Park on 2026-01-06.
//  Copyright (c) 2026 iOS Quantum Engineering. All rights reserved.
//
//  Premium Error Correction Visualization based on Harvard-MIT 2025 Research
//  Visualizes fault-tolerant quantum computing concepts for educational purposes
//
//  Research References:
//  - Harvard-MIT Nature 2025: "448-qubit fault-tolerant quantum architecture"
//  - Harvard-MIT Nature 2025: "Continuous operation of a coherent 3,000-qubit system"
//

import SwiftUI

// MARK: - Error Correction Layer View

/// Visualizes quantum error correction layers based on Harvard-MIT research
struct ErrorCorrectionView: View {
    @ObservedObject var viewModel: ErrorCorrectionViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Header with research attribution
            headerSection

            // Fidelity gauge
            fidelityGauge

            // Error correction layers visualization
            errorCorrectionLayers

            // Surface code visualization
            surfaceCodeGrid

            // Statistics
            statisticsSection
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    QuantumPremiumColors.cyberneticBlue.opacity(0.1),
                    QuantumPremiumColors.neonGreen.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "shield.checkered")
                    .font(.title2)
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)

                Text("Error Correction Layer")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                // Research badge
                HStack(spacing: 4) {
                    Image(systemName: "book.closed.fill")
                        .font(.caption2)
                    Text("MIT/Harvard 2025")
                        .font(.caption2)
                }
                .foregroundColor(QuantumPremiumColors.neonGreen)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(QuantumPremiumColors.neonGreen.opacity(0.2))
                .cornerRadius(8)
            }

            Text("Fault-tolerant quantum architecture based on 3,000+ qubit research")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }

    // MARK: - Fidelity Gauge

    private var fidelityGauge: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Circuit Fidelity")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                Text(String(format: "%.2f%%", viewModel.fidelity * 100))
                    .font(.system(.title2, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(fidelityColor)
            }

            // Animated fidelity bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))

                    // Fidelity fill
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    fidelityColor.opacity(0.7),
                                    fidelityColor
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * viewModel.fidelity)
                        .animation(.spring(response: 0.6), value: viewModel.fidelity)

                    // Threshold marker (99.5% from Harvard research)
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 2)
                        .offset(x: geometry.size.width * 0.995 - 1)
                        .opacity(0.8)
                }
            }
            .frame(height: 24)

            // Threshold label
            HStack {
                Spacer()
                Text("Fault-tolerant threshold: 99.5%")
                    .font(.caption2)
                    .foregroundColor(.yellow.opacity(0.8))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }

    private var fidelityColor: Color {
        if viewModel.fidelity >= 0.995 {
            return QuantumPremiumColors.neonGreen
        } else if viewModel.fidelity >= 0.99 {
            return .yellow
        } else if viewModel.fidelity >= 0.95 {
            return .orange
        } else {
            return .red
        }
    }

    // MARK: - Error Correction Layers

    private var errorCorrectionLayers: some View {
        VStack(spacing: 12) {
            Text("Error Correction Layers")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            HStack(spacing: 16) {
                ForEach(viewModel.errorCorrectionLayers) { layer in
                    ErrorCorrectionLayerCard(layer: layer)
                }
            }
        }
    }

    // MARK: - Surface Code Grid

    private var surfaceCodeGrid: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Surface Code Visualization")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                Text("Distance: \(viewModel.codeDistance)")
                    .font(.caption)
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)
            }

            // Interactive surface code grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: viewModel.codeDistance * 2 - 1), spacing: 4) {
                ForEach(0..<((viewModel.codeDistance * 2 - 1) * (viewModel.codeDistance * 2 - 1)), id: \.self) { index in
                    surfaceCodeCell(at: index)
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
    }

    private func surfaceCodeCell(at index: Int) -> some View {
        let gridSize = viewModel.codeDistance * 2 - 1
        let row = index / gridSize
        let col = index % gridSize

        // Determine cell type (data qubit, X stabilizer, Z stabilizer)
        let isDataQubit = (row + col) % 2 == 0
        let hasError = viewModel.errorPositions.contains(index)

        return ZStack {
            if isDataQubit {
                // Data qubit
                Circle()
                    .fill(hasError ? Color.red : QuantumPremiumColors.cyberneticBlue)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            } else {
                // Stabilizer (X or Z)
                let isXStabilizer = row % 2 == 0
                RoundedRectangle(cornerRadius: 4)
                    .fill(isXStabilizer ? Color.orange.opacity(0.6) : Color.green.opacity(0.6))
                    .frame(width: 16, height: 16)
            }

            if hasError {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.yellow)
                    .offset(x: 8, y: -8)
            }
        }
        .frame(width: 24, height: 24)
        .animation(.easeInOut(duration: 0.3), value: hasError)
    }

    // MARK: - Statistics Section

    private var statisticsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Error Correction Statistics")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatisticCard(
                    title: "Physical Qubits",
                    value: "\(viewModel.physicalQubits)",
                    icon: "cpu",
                    color: QuantumPremiumColors.cyberneticBlue
                )

                StatisticCard(
                    title: "Logical Qubits",
                    value: "\(viewModel.logicalQubits)",
                    icon: "waveform.path.badge.plus",
                    color: QuantumPremiumColors.neonGreen
                )

                StatisticCard(
                    title: "Error Rate",
                    value: String(format: "%.3f%%", viewModel.logicalErrorRate * 100),
                    icon: "exclamationmark.circle",
                    color: .orange
                )

                StatisticCard(
                    title: "Overhead",
                    value: String(format: "%.1fx", viewModel.overheadRatio),
                    icon: "arrow.up.arrow.down",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Error Correction Layer Card

struct ErrorCorrectionLayerCard: View {
    let layer: ErrorCorrectionLayer

    var body: some View {
        VStack(spacing: 8) {
            // Layer visualization
            ZStack {
                Circle()
                    .fill(layer.color.opacity(0.2))
                    .frame(width: 50, height: 50)

                Circle()
                    .strokeBorder(layer.color, lineWidth: 2)
                    .frame(width: 50, height: 50)

                Image(systemName: layer.icon)
                    .font(.title3)
                    .foregroundColor(layer.color)
            }

            Text(layer.name)
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)

            Text(layer.status)
                .font(.system(size: 9))
                .foregroundColor(layer.statusColor)
        }
        .frame(width: 80)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Statistic Card

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(10)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Error Correction View Model

@MainActor
class ErrorCorrectionViewModel: ObservableObject {
    @Published var fidelity: Double = 0.997
    @Published var codeDistance: Int = 3
    @Published var physicalQubits: Int = 448
    @Published var logicalQubits: Int = 12
    @Published var logicalErrorRate: Double = 0.005
    @Published var overheadRatio: Double = 17.0
    @Published var errorPositions: Set<Int> = []
    @Published var errorCorrectionLayers: [ErrorCorrectionLayer] = []

    init() {
        setupLayers()
        simulateErrors()
    }

    private func setupLayers() {
        errorCorrectionLayers = [
            ErrorCorrectionLayer(
                name: "ZNE",
                icon: "waveform.badge.minus",
                color: .cyan,
                status: "Active",
                statusColor: .green
            ),
            ErrorCorrectionLayer(
                name: "M3",
                icon: "cube.transparent",
                color: .purple,
                status: "Active",
                statusColor: .green
            ),
            ErrorCorrectionLayer(
                name: "DD",
                icon: "arrow.triangle.2.circlepath",
                color: .orange,
                status: "Standby",
                statusColor: .yellow
            ),
            ErrorCorrectionLayer(
                name: "Magic",
                icon: "sparkles",
                color: .pink,
                status: "Ready",
                statusColor: .cyan
            )
        ]
    }

    func simulateErrors() {
        // Simulate random error positions
        let gridSize = (codeDistance * 2 - 1) * (codeDistance * 2 - 1)
        let errorCount = Int.random(in: 0...2)

        errorPositions = Set((0..<gridSize).shuffled().prefix(errorCount))
    }

    func updateFidelity(gateCount: Int, errorCorrectionEnabled: Bool) {
        let baseError = 0.001 * Double(gateCount)

        if errorCorrectionEnabled {
            // Apply error correction (90% reduction based on Harvard-MIT research)
            let correctedError = baseError * 0.1
            fidelity = max(0.9, 1.0 - correctedError)
        } else {
            fidelity = max(0.0, 1.0 - baseError)
        }

        // Update statistics
        physicalQubits = codeDistance * codeDistance * logicalQubits
        overheadRatio = Double(physicalQubits) / Double(logicalQubits)
        logicalErrorRate = (1.0 - fidelity) / Double(gateCount + 1)
    }
}

// MARK: - Error Correction Layer Model

struct ErrorCorrectionLayer: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let status: String
    let statusColor: Color
}

// MARK: - Quantum Premium Colors

struct QuantumPremiumColors {
    /// Miami Beach Cybernetic Blue
    static let cyberneticBlue = Color(red: 0.0, green: 0.8, blue: 1.0)

    /// Neon Green for highlights
    static let neonGreen = Color(red: 0.2, green: 1.0, blue: 0.4)

    /// Deep space background
    static let deepSpace = Color(red: 0.05, green: 0.05, blue: 0.15)

    /// Quantum purple
    static let quantumPurple = Color(red: 0.6, green: 0.2, blue: 1.0)

    /// Warning orange
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
}

// MARK: - Preview

struct ErrorCorrectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ErrorCorrectionView(viewModel: ErrorCorrectionViewModel())
                .padding()
        }
        .preferredColorScheme(.dark)
    }
}
