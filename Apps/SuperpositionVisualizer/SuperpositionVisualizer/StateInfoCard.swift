//
//  StateInfoCard.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  Displays detailed information about the quantum state
//

import SwiftUI
#if canImport(SwiftQuantum)
import SwiftQuantum
#else
// Preview를 위한 Mock Qubit
extension Qubit {
    static var previewSuperposition: Qubit {
        return Qubit.superposition
    }
}
#endif


/// Card displaying comprehensive quantum state information
struct StateInfoCard: View {
    let qubit: Qubit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundColor(.cyan)
                
                Text("Quantum State Information")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Probabilities
            probabilitiesSection
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // State properties
            propertiesSection
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Bloch coordinates
            blochSection
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
    
    // MARK: - Probabilities Section
    
    private var probabilitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Measurement Probabilities")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
            
            HStack(spacing: 20) {
                // P(|0⟩)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("P(|0⟩)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                    }
                    
                    Text(String(format: "%.6f", qubit.probability0))
                        .font(.system(.title3, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Text("(\(String(format: "%.2f", qubit.probability0 * 100))%)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(12)
                
                // P(|1⟩)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("P(|1⟩)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                    }
                    
                    Text(String(format: "%.6f", qubit.probability1))
                        .font(.system(.title3, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Text("(\(String(format: "%.2f", qubit.probability1 * 100))%)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(12)
            }
            
            // Normalization check
            let sum = qubit.probability0 + qubit.probability1
            HStack {
                Image(systemName: sum > 0.9999 && sum < 1.0001 ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(sum > 0.9999 && sum < 1.0001 ? .green : .red)
                
                Text("Normalization: \(String(format: "%.10f", sum))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                if sum > 0.9999 && sum < 1.0001 {
                    Text("✓ Valid")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Properties Section
    
    private var propertiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("State Properties")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
            
            PropertyRow(
                icon: "waveform",
                label: "Entropy",
                value: String(format: "%.6f", qubit.entropy()),
                description: "Measure of uncertainty (0 = pure, 1 = max)",
                color: .purple
            )
            
            PropertyRow(
                icon: "sparkles",
                label: "Purity",
                value: String(format: "%.6f", qubit.purity()),
                description: "1.0 for pure quantum states",
                color: .yellow
            )
            
            PropertyRow(
                icon: "arrow.triangle.2.circlepath",
                label: "Relative Phase",
                value: String(format: "%.6f rad", qubit.relativePhase),
                description: "(\(String(format: "%.2f", qubit.relativePhase * 180 / .pi))°)",
                color: .orange
            )
        }
    }
    
    // MARK: - Bloch Section
    
    private var blochSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bloch Sphere Coordinates")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
            
            let (x, y, z) = qubit.blochCoordinates()
            
            VStack(spacing: 10) {
                CoordinateRow(axis: "X", value: x, color: .red)
                CoordinateRow(axis: "Y", value: y, color: .green)
                CoordinateRow(axis: "Z", value: z, color: .blue)
            }
            
            // Verify on unit sphere
            let radius = sqrt(x*x + y*y + z*z)
            HStack {
                Image(systemName: "sphere")
                    .foregroundColor(.cyan)
                
                Text("Radius: \(String(format: "%.6f", radius))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                if abs(radius - 1.0) < 0.0001 {
                    Text("✓ On unit sphere")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Property Row

struct PropertyRow: View {
    let icon: String
    let label: String
    let value: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 25)
                
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(value)
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .padding(.leading, 35)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Coordinate Row

struct CoordinateRow: View {
    let axis: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(axis)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 30)
            
            // Visual bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.1))
                    
                    // Value bar (centered at 0)
                    let barWidth = abs(value) * geometry.size.width / 2
                    let xOffset = value >= 0 ? geometry.size.width / 2 : geometry.size.width / 2 - barWidth
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.7))
                        .frame(width: barWidth)
                        .offset(x: xOffset)
                    
                    // Center line
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 2)
                        .offset(x: geometry.size.width / 2 - 1)
                }
            }
            .frame(height: 30)
            
            Text(String(format: "% .3f", value))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 70, alignment: .trailing)
        }
    }
}

// MARK: - Amplitude Card

struct AmplitudeCard: View {
    let qubit: Qubit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "function")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Complex Amplitudes")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Amplitude α (alpha)
            VStack(alignment: .leading, spacing: 8) {
                Text("α (amplitude₀)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.cyan)
                
                Text(qubit.amplitude0.description)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                
                HStack {
                    Text("Magnitude:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(String(format: "%.6f", qubit.amplitude0.magnitude))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Phase:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(String(format: "%.4f rad", qubit.amplitude0.phase))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
            
            // Amplitude β (beta)
            VStack(alignment: .leading, spacing: 8) {
                Text("β (amplitude₁)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.pink)
                
                Text(qubit.amplitude1.description)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
                
                HStack {
                    Text("Magnitude:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(String(format: "%.6f", qubit.amplitude1.magnitude))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Phase:")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(String(format: "%.4f rad", qubit.amplitude1.phase))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
            
            // State vector notation
            Divider()
                .background(Color.white.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("State Vector (Dirac Notation)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(qubit.stateDescription())
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
}

// MARK: - Bloch Coordinates Card

struct BlochCoordinatesCard: View {
    let qubit: Qubit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "globe")
                    .font(.title2)
                    .foregroundColor(.green)
                
                Text("Bloch Sphere Analysis")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            let (x, y, z) = qubit.blochCoordinates()
            
            // 3D Coordinates
            VStack(spacing: 15) {
                CoordinateDetailRow(
                    axis: "X",
                    value: x,
                    description: "Horizontal axis (|+⟩ ↔ |−⟩)",
                    color: .red
                )
                
                CoordinateDetailRow(
                    axis: "Y",
                    value: y,
                    description: "Depth axis (|+i⟩ ↔ |−i⟩)",
                    color: .green
                )
                
                CoordinateDetailRow(
                    axis: "Z",
                    value: z,
                    description: "Vertical axis (|0⟩ ↔ |1⟩)",
                    color: .blue
                )
            }
            
            // Spherical coordinates
            Divider()
                .background(Color.white.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Spherical Coordinates")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                
                // Calculate θ and φ from Cartesian
                let theta = acos(z)
                let phi = atan2(y, x)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("θ (theta)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(String(format: "%.4f rad", theta))
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.white)
                        Text("(\(String(format: "%.1f", theta * 180 / .pi))°)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("φ (phi)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(String(format: "%.4f rad", phi))
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.white)
                        Text("(\(String(format: "%.1f", phi * 180 / .pi))°)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
}

struct CoordinateDetailRow: View {
    let axis: String
    let value: Double
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(axis)
                    .font(.system(.title3, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(String(format: "% .6f", value))
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Position indicator
                if abs(value) > 0.9 {
                    Text("Near \(axis) axis")
                        .font(.caption)
                        .foregroundColor(color)
                } else if abs(value) < 0.1 {
                    Text("Equator")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .padding(.leading, 40)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Preview

struct StateInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            ScrollView {
                VStack(spacing: 20) {
                    StateInfoCard(qubit: .superposition)
                    AmplitudeCard(qubit: .superposition)
                    BlochCoordinatesCard(qubit: .superposition)
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
    }
}
