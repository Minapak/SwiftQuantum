//
//  SuperpositionView.swift
//  SuperpositionVisualizer
//
//  Main view with centered XYZ coordinates

import SwiftUI

struct SuperpositionView: View {
    @StateObject private var stateManager = QuantumStateManager()
    @State private var showingInfo = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.3),
                        Color(red: 0.2, green: 0.1, blue: 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Bloch Sphere - Smaller height to avoid overlapping
                        VStack(spacing: 16) {
                            // Title
                            Text("Bloch Vector")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // 3D Sphere
                            BlochSphereView3D(qubit: stateManager.qubit)
                                .frame(height: 260)
                            
                            // Coordinates display - CENTERED VERTICAL (DYNAMIC)
                            let (x, y, z) = stateManager.qubit.blochCoordinates()
                            
                            HStack(spacing: 12) {
                                // X Coordinate
                                VStack(spacing: 6) {
                                    Text("X")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(String(format: "%.3f", x))
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundColor(.red)
                                }
                                
                                // Y Coordinate
                                VStack(spacing: 6) {
                                    Text("Y")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(String(format: "%.3f", y))
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundColor(.green)
                                }
                                
                                // Z Coordinate
                                VStack(spacing: 6) {
                                    Text("Z")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(String(format: "%.3f", z))
                                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cyan)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            
                            // State display
                            if stateManager.showDisplay {
                                VStack(spacing: 8) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text("Superposition Set")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Spacer()
                                    }
                                    
                                    Divider().background(Color.white.opacity(0.2))
                                    
                                    HStack {
                                        Text("P(|0⟩):")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text(String(format: "%.1f%%", stateManager.probability0 * 100))
                                            .foregroundColor(.green).fontWeight(.bold)
                                    }
                                    
                                    HStack {
                                        Text("P(|1⟩):")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text(String(format: "%.1f%%", (1 - stateManager.probability0) * 100))
                                            .foregroundColor(.red).fontWeight(.bold)
                                    }
                                }
                                .padding(12)
                                .background(Color.green.opacity(0.15))
                                .cornerRadius(10)
                                .transition(.moveAndFade)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(20)
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
                            case 4:
                                ExamplesView()
                                    .environmentObject(stateManager)
                            case 5:
                                AdvancedExamplesView()
                                    .environmentObject(stateManager)
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
                    .font(.system(size: 28))
                    .foregroundColor(.cyan)
                
                Text("Quantum Explorer")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingInfo.toggle() }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.cyan)
                }
            }
            
            Text("Control • Measure • Examples • Advanced")
                .font(.caption)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
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
                TabButton(title: "Examples", icon: "flask.fill", isSelected: selectedTab == 4) {
                    withAnimation { selectedTab = 4 }
                }
                TabButton(title: "Advanced", icon: "sparkles", isSelected: selectedTab == 5) {
                    withAnimation { selectedTab = 5 }
                }
                
                Spacer()
                    .frame(width: 8)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Controls Tab
    
    private var controlsTab: some View {
        VStack(spacing: 20) {
            ControlCard(
                title: "Probability P(|0⟩)",
                value: stateManager.probability0,
                icon: "0.circle.fill"
            ) {
                VStack(spacing: 15) {
                    HStack {
                        Text(String(format: "%.3f", stateManager.probability0))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.cyan)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("P(|0⟩): \(String(format: "%.1f%%", stateManager.probability0 * 100))")
                                .font(.caption)
                            Text("P(|1⟩): \(String(format: "%.1f%%", (1-stateManager.probability0) * 100))")
                                .font(.caption)
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(value: Binding(
                        get: { stateManager.probability0 },
                        set: { stateManager.setSuperposition($0) }
                    ), in: 0...1)
                        .accentColor(.cyan)
                    
                    HStack(spacing: 10) {
                        ProbabilityBar(
                            value: stateManager.probability0,
                            color: .blue,
                            label: "|0⟩"
                        )
                        
                        ProbabilityBar(
                            value: 1 - stateManager.probability0,
                            color: .red,
                            label: "|1⟩"
                        )
                    }
                    .frame(height: 60)
                }
            }
            
            ControlCard(
                title: "Relative Phase",
                value: stateManager.phase,
                icon: "waveform.circle.fill"
            ) {
                VStack(spacing: 15) {
                    HStack {
                        Text(String(format: "%.3f", stateManager.phase))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.purple)
                        
                        Text("rad")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", stateManager.phase * 180 / .pi))°")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(value: Binding(
                        get: { stateManager.phase },
                        set: { stateManager.updateState(probability0: stateManager.probability0, phase: $0) }
                    ), in: 0...(2 * .pi))
                        .accentColor(.purple)
                    
                    PhaseCircleView(phase: stateManager.phase)
                        .frame(height: 120)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Measurement Tab
    
    private var measurementTab: some View {
        VStack(spacing: 20) {
            VStack(spacing: 15) {
                Button(action: { stateManager.performMeasurement() }) {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("Single Measurement")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: { stateManager.performStatisticalMeasurement(1000) }) {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("1000 Measurements")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: { stateManager.reset() }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset State")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.cyan)
                    Text("Current State Information")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Divider().background(Color.white.opacity(0.2))
                
                HStack {
                    Text("P(|0⟩):")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(String(format: "%.1f%%", stateManager.probability0 * 100))
                        .foregroundColor(.cyan)
                }
                
                HStack {
                    Text("P(|1⟩):")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(String(format: "%.1f%%", (1 - stateManager.probability0) * 100))
                        .foregroundColor(.red)
                }
                
                HStack {
                    Text("Phase:")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(String(format: "%.3f rad", stateManager.phase))
                        .foregroundColor(.purple)
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Presets Tab
    
    private var presetsTab: some View {
        VStack(spacing: 15) {
            ForEach(BasicQuantumState.allCases, id: \.self) { state in
                Button(action: { stateManager.setState(state) }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(state.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(stateDescription(for: state))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.cyan)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func stateDescription(for state: BasicQuantumState) -> String {
        switch state {
        case .zero: return "Ground state"
        case .one: return "Excited state"
        case .plus: return "Equal superposition"
        case .minus: return "Phase inverted"
        case .iState: return "Complex phase"
        }
    }
    
    // MARK: - Info Tab
    
    private var infoTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Quantum State Details")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                HStack {
                    Text("|ψ⟩ = ")
                        .foregroundColor(.white)
                    Text(String(format: "%.3f", sqrt(stateManager.probability0)))
                        .foregroundColor(.cyan)
                    Text("|0⟩ + ")
                        .foregroundColor(.white)
                    Text(String(format: "%.3f", sqrt(1 - stateManager.probability0)))
                        .foregroundColor(.red)
                    Text("e^(i\(String(format: "%.2f", stateManager.phase)))|1⟩")
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Entanglement: ")
                        .foregroundColor(.white)
                    Text(String(format: "%.2f", stateManager.probability0 * (1 - stateManager.probability0)))
                        .foregroundColor(.purple)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("About Quantum Superposition")
                    .font(.headline)
                    .foregroundColor(.cyan)
                
                Text("A quantum qubit can exist in a superposition of both |0⟩ and |1⟩ states simultaneously until measured. Select states from the Presets or Examples tabs to see real-time updates on the 3D Bloch sphere.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

// MARK: - Animation Extension

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .top)
            .combined(with: .opacity)
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
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
                    .font(.system(size: 16))
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .cyan : .white.opacity(0.6))
            .frame(minWidth: 65)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
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
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                
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
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: radius * 2, height: radius * 2)
                
                Path { path in
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
                }
                .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                
                Path { path in
                    path.move(to: center)
                    path.addLine(to: CGPoint(
                        x: center.x + radius * cos(phase),
                        y: center.y + radius * sin(phase)
                    ))
                }
                .stroke(Color.purple, lineWidth: 3)
                
                Circle()
                    .fill(Color.purple)
                    .frame(width: 12, height: 12)
                    .position(
                        x: center.x + radius * cos(phase),
                        y: center.y + radius * sin(phase)
                    )
                    .shadow(color: .purple, radius: 10)
                
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

// MARK: - Preview

struct SuperpositionView_Previews: PreviewProvider {
    static var previews: some View {
        SuperpositionView()
            .preferredColorScheme(.dark)
    }
}
