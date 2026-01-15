//
//  AdvancedExamplesView.swift
//  SuperpositionVisualizer
//
//  Advanced examples tab - Simple and clean
//

import SwiftUI

struct AdvancedExamplesView: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab selector
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    Button(action: { selectedTab = index }) {
                        Text(["Basic", "Algo", "Apps", "Play", "Tuts"][index])
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTab == index ? .cyan : .white.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(selectedTab == index ? Color.cyan.opacity(0.2) : Color.white.opacity(0.05))
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            
            Divider().background(Color.white.opacity(0.2))
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    switch selectedTab {
                    case 0:
                        AdvBasicTab()
                    case 1:
                        AdvAlgoTab()
                    case 2:
                        AdvAppsTab()
                    case 3:
                        AdvPlayTab()
                    case 4:
                        AdvTutsTab()
                    default:
                        AdvBasicTab()
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Advanced Basic Tab

struct AdvBasicTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "cube.fill")
                        .foregroundColor(.blue)
                    Text("Advanced Operations")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Probability Control").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("P(|0⟩):")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(String(format: "%.1f%%", stateManager.probability0 * 100))
                            .foregroundColor(.cyan).fontWeight(.bold)
                    }
                    
                    Slider(value: Binding(
                        get: { stateManager.probability0 },
                        set: { stateManager.setSuperposition($0) }
                    ), in: 0...1)
                        .accentColor(.cyan)
                }
                .padding(12)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Gate Operations").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Button(action: { stateManager.applyHadamard() }) {
                            Text("H")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(10)
                        }
                        
                        Button(action: { stateManager.applyPauliX() }) {
                            Text("X")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(10)
                        }
                        
                        Button(action: { stateManager.applyPauliZ() }) {
                            Text("Z")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.purple.opacity(0.3))
                                .cornerRadius(10)
                        }
                        
                        Button(action: { stateManager.applyPauliY() }) {
                            Text("Y")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.pink.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: { stateManager.performMeasurement() }) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Measure")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Advanced Algorithm Tab

struct AdvAlgoTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    @State private var isRunning = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "function")
                        .foregroundColor(.purple)
                    Text("Quantum Algorithms")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Available Algorithms").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Button(action: {
                        isRunning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            stateManager.setState(.plus)
                            stateManager.displayText = "Deutsch-Jozsa\n✓ Balanced"
                            withAnimation { stateManager.showDisplay = true }
                            isRunning = false
                        }
                    }) {
                        HStack {
                            Text("Deutsch-Jozsa").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: isRunning ? "hourglass.tophalf.filled" : "play.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .disabled(isRunning)
                    
                    Button(action: {
                        isRunning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            stateManager.setState(.zero)
                            stateManager.displayText = "Grover Search\n✓ Found: |0⟩"
                            withAnimation { stateManager.showDisplay = true }
                            isRunning = false
                        }
                    }) {
                        HStack {
                            Text("Grover Search").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "play.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        isRunning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            stateManager.setSuperposition(0.3)
                            stateManager.displayText = "QFT\n✓ Complete"
                            withAnimation { stateManager.showDisplay = true }
                            isRunning = false
                        }
                    }) {
                        HStack {
                            Text("Quantum Fourier").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "play.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Advanced Apps Tab

struct AdvAppsTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.orange)
                    Text("Applications")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Use Cases").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Button(action: {
                        stateManager.setState(.zero)
                        stateManager.displayText = "Quantum ML\n✓ 94.5% Accuracy"
                        withAnimation { stateManager.showDisplay = true }
                    }) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Machine Learning")
                                .font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        stateManager.setState(.plus)
                        stateManager.displayText = "Chemistry Sim\n✓ H₂O Molecule"
                        withAnimation { stateManager.showDisplay = true }
                    }) {
                        HStack {
                            Image(systemName: "flask.fill")
                            Text("Chemistry")
                                .font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        stateManager.setSuperposition(0.6)
                        stateManager.displayText = "Finance\n✓ Portfolio Opt"
                        withAnimation { stateManager.showDisplay = true }
                    }) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Finance")
                                .font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Advanced Playground Tab

struct AdvPlayTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    @State private var isRunning = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.green)
                    Text("Playground")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Quick Experiments").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Button(action: {
                        isRunning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            stateManager.applyHadamard()
                            isRunning = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("Create Superposition")
                                .font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: isRunning ? "hourglass.tophalf.filled" : "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .disabled(isRunning)
                    
                    Button(action: {
                        isRunning = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            stateManager.performMeasurement()
                            isRunning = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("Measurement")
                                .font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        stateManager.reset()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                            Text("Reset")
                                .font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Advanced Tutorials Tab

struct AdvTutsTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    @State private var selectedTut = 0
    
    let tutorials = [
        ("Superposition", "Equal superposition"),
        ("Interference", "Wave-like behavior"),
        ("Entanglement", "Multi-qubit states"),
        ("Measurement", "State collapse")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.pink)
                    Text("Tutorials")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Learn Quantum Concepts").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(spacing: 8) {
                    ForEach(0..<tutorials.count, id: \.self) { index in
                        Button(action: {
                            selectedTut = index
                            selectTutorial(index)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(tutorials[index].0)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Text(tutorials[index].1)
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Image(systemName: selectedTut == index ? "checkmark.circle.fill" : "chevron.right")
                                    .foregroundColor(.pink)
                            }
                            .padding(12)
                            .background(selectedTut == index ? Color.pink.opacity(0.2) : Color.white.opacity(0.05))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
    
    private func selectTutorial(_ index: Int) {
        switch index {
        case 0:
            stateManager.setState(.plus)
            stateManager.displayText = "Superposition\n|+⟩ = (|0⟩+|1⟩)/√2"
        case 1:
            stateManager.setSuperposition(0.5)
            stateManager.displayText = "Interference\nWave properties"
        case 2:
            stateManager.setState(.zero)
            stateManager.displayText = "Entanglement\nMulti-qubit"
        case 3:
            stateManager.performMeasurement()
            stateManager.displayText = "Measurement\nCollapse"
        default:
            break
        }
        
        withAnimation {
            stateManager.showDisplay = true
        }
    }
}

// MARK: - Preview

struct AdvancedExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedExamplesView()
            .environmentObject(QuantumStateManager())
            .preferredColorScheme(.dark)
    }
}
