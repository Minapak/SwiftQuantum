//
//  InfoView.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  Educational information about quantum superposition
//

import SwiftUI

/// Educational modal about quantum superposition
struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header
                    headerSection
                    
                    // What is Superposition
                    whatIsSection
                    
                    // Bloch Sphere
                    blochSphereSection
                    
                    // Measurement
                    measurementSection
                    
                    // Mathematics
                    mathematicsSection
                    
                    // Applications
                    applicationsSection
                    
                    // Resources
                    resourcesSection
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.3),
                        Color(red: 0.2, green: 0.1, blue: 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 15) {
            Image(systemName: "atom")
                .font(.system(size: 60))
                .foregroundColor(.cyan)
            
            Text("Quantum Superposition")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("The Heart of Quantum Computing")
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    // MARK: - What Is Section
    
    private var whatIsSection: some View {
        InfoCard(
            icon: "questionmark.circle.fill",
            title: "What is Superposition?",
            color: .blue
        ) {
            VStack(alignment: .leading, spacing: 15) {
                Text("In classical computing, a bit is either 0 OR 1. But in quantum computing, a qubit can be in a **superposition** - existing in both states simultaneously!")
                    .foregroundColor(.white.opacity(0.9))
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 10) {
                    InfoFeatureRow(
                        icon: "0.circle.fill",
                        text: "Classical Bit: Either 0 OR 1",
                        color: .gray
                    )
                    
                    InfoFeatureRow(
                        icon: "atom",
                        text: "Quantum Qubit: Both 0 AND 1 at once!",
                        color: .cyan
                    )
                }
                
                Text("This isn't just 'we don't know which' - the qubit literally exists in both states until measured. This is the foundation of quantum computing's power!")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.7))
                    .italic()
            }
        }
    }
    
    // MARK: - Bloch Sphere Section
    
    private var blochSphereSection: some View {
        InfoCard(
            icon: "globe",
            title: "The Bloch Sphere",
            color: .green
        ) {
            VStack(alignment: .leading, spacing: 15) {
                Text("The Bloch sphere is a beautiful geometric representation of quantum states:")
                    .foregroundColor(.white.opacity(0.9))
                
                VStack(alignment: .leading, spacing: 12) {
                    BlochPoint(
                        position: "North Pole",
                        state: "|0⟩",
                        description: "Pure ground state",
                        color: .blue
                    )
                    
                    BlochPoint(
                        position: "South Pole",
                        state: "|1⟩",
                        description: "Pure excited state",
                        color: .red
                    )
                    
                    BlochPoint(
                        position: "Equator",
                        state: "|+⟩, |−⟩, |±i⟩",
                        description: "Maximum superposition (50-50)",
                        color: .green
                    )
                    
                    BlochPoint(
                        position: "Surface",
                        state: "All valid states",
                        description: "Every point is a valid quantum state",
                        color: .cyan
                    )
                }
                
                InfoBanner(
                    icon: "exclamationmark.circle.fill",
                    text: "Phase (φ) determines position around the sphere but doesn't affect measurement probabilities directly!",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Measurement Section
    
    private var measurementSection: some View {
        InfoCard(
            icon: "waveform.path.ecg",
            title: "Quantum Measurement",
            color: .purple
        ) {
            VStack(alignment: .leading, spacing: 15) {
                Text("When you measure a quantum state, something dramatic happens:")
                    .foregroundColor(.white.opacity(0.9))
                
                VStack(spacing: 12) {
                    MeasurementStep(
                        step: 1,
                        title: "Before Measurement",
                        description: "Qubit exists in superposition - both states at once",
                        icon: "infinity",
                        color: .cyan
                    )
                    
                    MeasurementStep(
                        step: 2,
                        title: "Measurement",
                        description: "Observe the quantum state",
                        icon: "eye.fill",
                        color: .yellow
                    )
                    
                    MeasurementStep(
                        step: 3,
                        title: "Collapse",
                        description: "State randomly collapses to |0⟩ or |1⟩",
                        icon: "exclamationmark.triangle.fill",
                        color: .red
                    )
                    
                    MeasurementStep(
                        step: 4,
                        title: "After Measurement",
                        description: "Superposition destroyed - now classical!",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                }
                
                InfoBanner(
                    icon: "exclamationmark.triangle.fill",
                    text: "Measurement is IRREVERSIBLE. Once collapsed, you cannot recover the original superposition!",
                    color: .red
                )
            }
        }
    }
    
    // MARK: - Mathematics Section
    
    private var mathematicsSection: some View {
        InfoCard(
            icon: "function",
            title: "The Mathematics",
            color: .pink
        ) {
            VStack(alignment: .leading, spacing: 15) {
                Text("A quantum state is mathematically represented as:")
                    .foregroundColor(.white.opacity(0.9))
                
                // State equation
                VStack(spacing: 8) {
                    Text("|ψ⟩ = α|0⟩ + β|1⟩")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    
                    Text("where |α|² + |β|² = 1")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 10) {
                    MathSymbol(
                        symbol: "α, β",
                        description: "Complex amplitudes (magnitude + phase)"
                    )
                    
                    MathSymbol(
                        symbol: "|α|²",
                        description: "Probability of measuring |0⟩"
                    )
                    
                    MathSymbol(
                        symbol: "|β|²",
                        description: "Probability of measuring |1⟩"
                    )
                    
                    MathSymbol(
                        symbol: "|ψ⟩",
                        description: "Dirac notation for quantum state"
                    )
                }
            }
        }
    }
    
    // MARK: - Applications Section
    
    private var applicationsSection: some View {
        InfoCard(
            icon: "star.fill",
            title: "Why It Matters",
            color: .yellow
        ) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Superposition enables quantum computing's power:")
                    .foregroundColor(.white.opacity(0.9))
                
                VStack(spacing: 12) {
                    ApplicationRow(
                        icon: "bolt.fill",
                        title: "Quantum Parallelism",
                        description: "Process all inputs simultaneously",
                        color: .orange
                    )
                    
                    ApplicationRow(
                        icon: "lock.shield.fill",
                        title: "Quantum Cryptography",
                        description: "Unbreakable encryption using quantum states",
                        color: .blue
                    )
                    
                    ApplicationRow(
                        icon: "cpu.fill",
                        title: "Quantum Algorithms",
                        description: "Solve problems exponentially faster",
                        color: .green
                    )
                    
                    ApplicationRow(
                        icon: "atom",
                        title: "Quantum Simulation",
                        description: "Model complex quantum systems",
                        color: .purple
                    )
                }
            }
        }
    }
    
    // MARK: - Resources Section
    
    private var resourcesSection: some View {
        InfoCard(
            icon: "book.fill",
            title: "Learn More",
            color: .indigo
        ) {
            VStack(alignment: .leading, spacing: 12) {
                ResourceLink(
                    icon: "swift",
                    title: "SwiftQuantum GitHub",
                    subtitle: "Explore the source code",
                    color: .orange
                )
                
                ResourceLink(
                    icon: "doc.text.fill",
                    title: "Tutorial Series",
                    subtitle: "Step-by-step quantum computing guide",
                    color: .blue
                )
                
                ResourceLink(
                    icon: "play.circle.fill",
                    title: "Video Tutorials",
                    subtitle: "Visual explanations and demos",
                    color: .red
                )
                
                ResourceLink(
                    icon: "message.fill",
                    title: "Community",
                    subtitle: "Join the discussion and ask questions",
                    color: .green
                )
            }
        }
    }
}

// MARK: - Info Card

struct InfoCard<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    let content: Content
    
    init(
        icon: String,
        title: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.title = title
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            content
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
}

// MARK: - Supporting Views

struct InfoFeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)

            Text(text)
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

struct BlochPoint: View {
    let position: String
    let state: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(position)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(state)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(color)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 4)
    }
}

struct MeasurementStep: View {
    let step: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(step). \(title)")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct MathSymbol: View {
    let symbol: String
    let description: String
    
    var body: some View {
        HStack {
            Text(symbol)
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .frame(width: 80, alignment: .leading)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

struct ApplicationRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.15))
        .cornerRadius(12)
    }
}

struct ResourceLink: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Preview

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
