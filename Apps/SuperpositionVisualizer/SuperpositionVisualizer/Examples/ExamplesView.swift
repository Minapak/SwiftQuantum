//
//  ExamplesView.swift
//  SuperpositionVisualizer
//
//  Examples tab - Simple and clean
//

import SwiftUI

struct ExamplesView: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab selector
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    Button(action: { selectedTab = index }) {
                        Text(["Basic", "Gates", "Random", "Algorithm", "Apps"][index])
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
                        BasicTab()
                    case 1:
                        GatesTab()
                    case 2:
                        RandomTab()
                    case 3:
                        AlgorithmTab()
                    case 4:
                        AppsTab()
                    default:
                        BasicTab()
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Basic Tab

struct BasicTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "0.circle.fill")
                        .foregroundColor(.cyan)
                    Text("Basic States")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Quantum States").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Button(action: { stateManager.setState(.zero) }) {
                            Text("|0⟩")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(10)
                        }
                        
                        Button(action: { stateManager.setState(.one) }) {
                            Text("|1⟩")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.red.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: { stateManager.setState(.plus) }) {
                            Text("|+⟩")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(10)
                        }
                        
                        Button(action: { stateManager.setState(.minus) }) {
                            Text("|−⟩")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Current State").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                HStack {
                    Text(String(format: "P(|0⟩): %.1f%%", stateManager.probability0 * 100))
                        .font(.caption).foregroundColor(.cyan)
                    Spacer()
                    Text(String(format: "P(|1⟩): %.1f%%", (1 - stateManager.probability0) * 100))
                        .font(.caption).foregroundColor(.red)
                }
                .padding(10)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Gates Tab

struct GatesTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "square.and.line.vertical.and.square")
                        .foregroundColor(.orange)
                    Text("Quantum Gates")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Gate Operations").font(.subheadline).fontWeight(.bold).foregroundColor(.orange)
                
                VStack(spacing: 8) {
                    Button(action: { stateManager.applyHadamard() }) {
                        HStack {
                            Text("Hadamard").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "h.square.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: { stateManager.applyPauliX() }) {
                        HStack {
                            Text("Pauli-X (Bit Flip)").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: { stateManager.applyPauliZ() }) {
                        HStack {
                            Text("Pauli-Z (Phase Flip)").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "z.circle.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: { stateManager.applyPauliY() }) {
                        HStack {
                            Text("Pauli-Y").font(.caption).fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "y.circle.fill")
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.pink.opacity(0.2))
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

// MARK: - Random Tab

struct RandomTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "dice.fill")
                        .foregroundColor(.purple)
                    Text("Random States")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Generate Random State").font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                
                Button(action: {
                    let randomProb = Double.random(in: 0...1)
                    stateManager.setSuperposition(randomProb)
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Random")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("P(|0⟩):")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(String(format: "%.1f%%", stateManager.probability0 * 100))
                            .foregroundColor(.purple).fontWeight(.bold)
                    }
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.purple)
                            .frame(width: CGFloat(stateManager.probability0) * 100)
                    }
                    .frame(height: 10)
                }
                .padding(12)
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Algorithm Tab

struct AlgorithmTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    @State private var isRunning = false
    @State private var isConstant = true
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "function")
                        .foregroundColor(.green)
                    Text("Deutsch-Jozsa")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            HStack(spacing: 12) {
                Button(action: { isConstant = true }) {
                    VStack(spacing: 6) {
                        Image(systemName: "rectangle.fill").font(.title3)
                        Text("Constant").font(.caption2)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(isConstant ? Color.cyan.opacity(0.3) : Color.white.opacity(0.05))
                    .cornerRadius(10)
                }
                
                Button(action: { isConstant = false }) {
                    VStack(spacing: 6) {
                        Image(systemName: "square.split.diagonal").font(.title3)
                        Text("Balanced").font(.caption2)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(!isConstant ? Color.green.opacity(0.3) : Color.white.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            
            Button(action: {
                isRunning = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    stateManager.setState(isConstant ? .zero : .plus)
                    isRunning = false
                }
            }) {
                HStack {
                    Image(systemName: isRunning ? "hourglass.tophalf.filled" : "play.fill")
                    Text(isRunning ? "Running..." : "Run Algorithm")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.green.opacity(0.6))
                .cornerRadius(12)
            }
            .disabled(isRunning)
            
            Spacer()
        }
    }
}

// MARK: - Apps Tab

struct AppsTab: View {
    @EnvironmentObject var stateManager: QuantumStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.red)
                    Text("Applications")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(15)
            .background(Color.white.opacity(0.08))
            .cornerRadius(15)
            
            VStack(spacing: 10) {
                Button(action: { stateManager.setState(.zero) }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        Text("Machine Learning")
                            .font(.caption).fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: { stateManager.setState(.plus) }) {
                    HStack {
                        Image(systemName: "flask.fill")
                        Text("Chemistry Simulation")
                            .font(.caption).fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: { stateManager.performStatisticalMeasurement(100) }) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Optimization")
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
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            
            Spacer()
        }
    }
}

// MARK: - Preview

struct ExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        ExamplesView()
            .environmentObject(QuantumStateManager())
            .preferredColorScheme(.dark)
    }
}
