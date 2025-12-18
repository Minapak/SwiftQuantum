//
//  SuperpositionView.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  Main view for exploring quantum superposition interactively
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


/// Main view for the Superposition Visualizer app
///
/// Provides interactive controls to:
/// - Adjust qubit probability
/// - Change relative phase
/// - Visualize on Bloch sphere
/// - Perform measurements
/// - Compare with standard states
struct SuperpositionView: View {
    // MARK: - State
    
    @State private var probability0: Double = 0.5
    @State private var phase: Double = 0.0
    @State private var measurementResults: [Int] = []
    @State private var isAnimating = false
    @State private var showingInfo = false
    @State private var selectedTab = 0
    
    // MARK: - Computed Properties
    
    private var qubit: Qubit {
        let alpha = sqrt(probability0)
        let beta = sqrt(1 - probability0)
        
        return Qubit(
            amplitude0: Complex(alpha, 0),
            amplitude1: Complex(beta * cos(phase), beta * sin(phase))
        )
    }
    
    private var measurementStats: (count0: Int, count1: Int) {
        let count0 = measurementResults.filter { $0 == 0 }.count
        let count1 = measurementResults.filter { $0 == 1 }.count
        return (count0, count1)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.3),
                        Color(red: 0.2, green: 0.1, blue: 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Main content
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        headerSection
                        
                        // Bloch Sphere
                        BlochSphereView3D(qubit: qubit)
                            .frame(height: 320)
                            .padding(.horizontal)
                        
                        // Tab selector
                        tabSelector
                        
                        // Tab content
                        Group {
                            switch selectedTab {
                            case 0:
                                controlsTab
                            case 1:
                                measurementTab
                            case 2:
                                presetsTab
                            case 3:
                                infoTab
                            default:
                                controlsTab
                            }
                        }
                        .animation(.easeInOut, value: selectedTab)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "atom")
                    .font(.system(size: 30))
                    .foregroundColor(.cyan)
                
                Text("Superposition Explorer")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingInfo.toggle() }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.cyan)
                }
            }
            
            Text("Explore the quantum realm")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .sheet(isPresented: $showingInfo) {
            InfoView()
        }
    }
    
    // MARK: - Tab Selector
    
    private var tabSelector: some View {
        HStack(spacing: 15) {
            TabButton(title: "Controls", icon: "slider.horizontal.3", isSelected: selectedTab == 0) {
                withAnimation { selectedTab = 0 }
            }
            TabButton(title: "Measure", icon: "waveform.path.ecg", isSelected: selectedTab == 1) {
                withAnimation { selectedTab = 1 }
            }
            TabButton(title: "Presets", icon: "star.fill", isSelected: selectedTab == 2) {
                withAnimation { selectedTab = 2 }
            }
            TabButton(title: "Info", icon: "chart.bar.fill", isSelected: selectedTab == 3) {
                withAnimation { selectedTab = 3 }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Controls Tab
    
    private var controlsTab: some View {
        VStack(spacing: 25) {
            // Probability Control
            ControlCard(
                title: "Probability P(|0⟩)",
                value: probability0,
                icon: "0.circle.fill"
            ) {
                VStack(spacing: 15) {
                    HStack {
                        Text(String(format: "%.3f", probability0))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.cyan)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("P(|0⟩): \(String(format: "%.1f%%", probability0 * 100))")
                                .font(.caption)
                            Text("P(|1⟩): \(String(format: "%.1f%%", (1-probability0) * 100))")
                                .font(.caption)
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(value: $probability0, in: 0...1)
                        .accentColor(.cyan)
                        .padding(.horizontal)
                    
                    // Visual probability bars
                    HStack(spacing: 10) {
                        ProbabilityBar(
                            value: probability0,
                            color: .blue,
                            label: "|0⟩"
                        )
                        
                        ProbabilityBar(
                            value: 1 - probability0,
                            color: .red,
                            label: "|1⟩"
                        )
                    }
                    .frame(height: 60)
                }
            }
            
            // Phase Control
            ControlCard(
                title: "Relative Phase",
                value: phase,
                icon: "waveform.circle.fill"
            ) {
                VStack(spacing: 15) {
                    HStack {
                        Text(String(format: "%.3f", phase))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.purple)
                        
                        Text("rad")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", phase * 180 / .pi))°")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(value: $phase, in: 0...(2 * .pi))
                        .accentColor(.purple)
                        .padding(.horizontal)
                    
                    // Phase visualization circle
                    PhaseCircleView(phase: phase)
                        .frame(height: 100)
                }
            }
            
            // State Summary
            StateInfoCard(qubit: qubit)
        }
    }
    
    // MARK: - Measurement Tab
    
    private var measurementTab: some View {
        VStack(spacing: 20) {
            // Single measurement button
            Button(action: performSingleMeasurement) {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                        .font(.title2)
                    Text("Single Measurement")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.spring(response: 0.3), value: isAnimating)
            }
            
            // Multiple measurements button
            Button(action: performMultipleMeasurements) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                    Text("Measure 1000 Times")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.green, .teal],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            // Clear button
            if !measurementResults.isEmpty {
                Button(action: clearMeasurements) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear Results")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(15)
                }
            }
            
            // Measurement results
            if !measurementResults.isEmpty {
                MeasurementHistogram(
                    results: measurementResults,
                    expectedProb0: qubit.probability0
                )
                .transition(.scale.combined(with: .opacity))
                
                MeasurementStatsCard(
                    results: measurementResults,
                    expectedProb0: qubit.probability0
                )
            } else {
                EmptyMeasurementView()
            }
        }
    }
    
    // MARK: - Presets Tab
    
    private var presetsTab: some View {
        VStack(spacing: 20) {
            Text("Quick Quantum States")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Tap any state to apply it instantly")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            QuickPresetsView(
                onSelectProb: { prob in
                    withAnimation(.spring()) {
                        probability0 = prob
                    }
                },
                onSelectPhase: { ph in
                    withAnimation(.spring()) {
                        phase = ph
                    }
                }
            )
        }
    }
    
    // MARK: - Info Tab
    
    private var infoTab: some View {
        VStack(spacing: 20) {
            StateInfoCard(qubit: qubit)
            
            AmplitudeCard(qubit: qubit)
            
            BlochCoordinatesCard(qubit: qubit)
        }
    }
    
    // MARK: - Actions
    
    private func performSingleMeasurement() {
        withAnimation(.spring(response: 0.3)) {
            isAnimating = true
        }
        
        // Simulate quantum measurement delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let result = qubit.measure()
            measurementResults = [result]
            
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            withAnimation {
                isAnimating = false
            }
        }
    }
    
    private func performMultipleMeasurements() {
        withAnimation {
            let results = qubit.measureMultiple(count: 1000)
            var allResults: [Int] = []
            
            for _ in 0..<(results[0] ?? 0) {
                allResults.append(0)
            }
            for _ in 0..<(results[1] ?? 0) {
                allResults.append(1)
            }
            
            measurementResults = allResults
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    private func clearMeasurements() {
        withAnimation {
            measurementResults = []
        }
    }
}

// MARK: - Tab Button

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .cyan : .white.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ?
                Color.cyan.opacity(0.2) :
                Color.white.opacity(0.05)
            )
            .cornerRadius(12)
        }
    }
}

// MARK: - Control Card

struct ControlCard<Content: View>: View {
    let title: String
    let value: Double
    let icon: String
    let content: Content
    
    init(
        title: String,
        value: Double,
        icon: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.cyan)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
}

// MARK: - Probability Bar

struct ProbabilityBar: View {
    let value: Double
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                
                // Fill
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.6), color],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: geometry.size.height * value)
                        .animation(.spring(), value: value)
                }
            }
            
            VStack(spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(String(format: "%.1f%%", value * 100))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

// MARK: - Phase Circle View

struct PhaseCircleView: View {
    let phase: Double
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 * 0.8
            
            ZStack {
                // Circle
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: radius * 2, height: radius * 2)
                
                // Reference line (0 phase)
                Path { path in
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
                }
                .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                
                // Phase arrow
                Path { path in
                    path.move(to: center)
                    path.addLine(to: CGPoint(
                        x: center.x + radius * cos(phase),
                        y: center.y + radius * sin(phase)
                    ))
                }
                .stroke(Color.purple, lineWidth: 3)
                
                // Phase marker
                Circle()
                    .fill(Color.purple)
                    .frame(width: 12, height: 12)
                    .position(
                        x: center.x + radius * cos(phase),
                        y: center.y + radius * sin(phase)
                    )
                    .shadow(color: .purple, radius: 10)
                
                // Labels
                Text("0")
                    .foregroundColor(.white.opacity(0.7))
                    .position(x: center.x + radius + 15, y: center.y)
                
                Text("π/2")
                    .foregroundColor(.white.opacity(0.7))
                    .position(x: center.x, y: center.y + radius + 15)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: - Empty Measurement View

struct EmptyMeasurementView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "waveform.path")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No measurements yet")
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))
            
            Text("Tap the buttons above to measure the quantum state")
                .font(.caption)
                .foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}

// MARK: - Preview

struct SuperpositionView_Previews: PreviewProvider {
    static var previews: some View {
        SuperpositionView()
            .preferredColorScheme(.dark)
    }
}
