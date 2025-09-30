//
//  BlochSphereView.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  3D-inspired Bloch sphere visualization
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

/// Visualizes a qubit state on the Bloch sphere
///
/// The Bloch sphere is a geometric representation where:
/// - North pole: |0⟩ state
/// - South pole: |1⟩ state
/// - Surface: All valid quantum states
struct BlochSphereView: View {
    let qubit: Qubit
    
    @State private var rotation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient sphere
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.4),
                                Color.purple.opacity(0.6),
                                Color.indigo.opacity(0.8)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: geometry.size.width / 2
                        )
                    )
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                    .blur(radius: 20)
                
                // Main sphere
                ZStack {
                    // Axes
                    axesView(in: geometry)
                    
                    // Equator circle
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: geometry.size.width * 0.7)
                    
                    // State vector arrow and marker
                    stateVectorView(in: geometry)
                }
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
                
                // Labels
                labelsView(in: geometry)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // MARK: - Axes
    
    private func axesView(in geometry: GeometryProxy) -> some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = geometry.size.width * 0.35
        
        return ZStack {
            // Z-axis (vertical)
            Path { path in
                path.move(to: CGPoint(x: center.x, y: center.y - radius))
                path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
            }
            .stroke(
                LinearGradient(
                    colors: [.cyan, .white.opacity(0.5), .red],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 3
            )
            
            // X-axis (horizontal)
            Path { path in
                path.move(to: CGPoint(x: center.x - radius, y: center.y))
                path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
            }
            .stroke(Color.white.opacity(0.4), lineWidth: 2)
            
            // Y-axis (depth - simulated)
            Path { path in
                let offset: CGFloat = 30
                path.move(to: CGPoint(x: center.x - offset, y: center.y - offset))
                path.addLine(to: CGPoint(x: center.x + offset, y: center.y + offset))
            }
            .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
        }
    }
    
    // MARK: - State Vector
    
    private func stateVectorView(in geometry: GeometryProxy) -> some View {
        let (x, y, z) = qubit.blochCoordinates()
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = geometry.size.width * 0.35
        
        // Project 3D coordinates to 2D
        let posX = center.x + CGFloat(x) * radius
        let posY = center.y - CGFloat(z) * radius // Inverted because screen Y is down
        
        return ZStack {
            // Arrow from center to point
            Path { path in
                path.move(to: center)
                path.addLine(to: CGPoint(x: posX, y: posY))
            }
            .stroke(
                LinearGradient(
                    colors: [.white.opacity(0.5), .yellow],
                    startPoint: .init(x: 0, y: 0),
                    endPoint: .init(x: 1, y: 1)
                ),
                style: StrokeStyle(lineWidth: 4, lineCap: .round)
            )
            .shadow(color: .yellow.opacity(0.5), radius: 10)
            
            // Arrowhead
            ArrowheadShape()
                .fill(Color.yellow)
                .frame(width: 20, height: 20)
                .position(x: posX, y: posY)
                .rotationEffect(.degrees(atan2(Double(posY - center.y), Double(posX - center.x)) * 180 / .pi))
            
            // State marker
            ZStack {
                // Glow
                Circle()
                    .fill(Color.yellow.opacity(0.3))
                    .frame(width: 35, height: 35)
                    .blur(radius: 10)
                
                // Main circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, .yellow],
                            center: .center,
                            startRadius: 0,
                            endRadius: 15
                        )
                    )
                    .frame(width: 25, height: 25)
            }
            .position(x: posX, y: posY)
            .shadow(color: .yellow, radius: 15)
            
            // Coordinate display
            VStack(spacing: 4) {
                Text("(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z)))")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
            }
            .position(x: posX, y: posY - 40)
        }
    }
    
    // MARK: - Labels
    
    private func labelsView(in geometry: GeometryProxy) -> some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = geometry.size.width * 0.35
        
        return ZStack {
            // |1⟩ label (top)
            StateLabel(text: "|1⟩", color: .cyan)
                .position(x: center.x, y: center.y - radius - 30)
            
            // |0⟩ label (bottom)
            StateLabel(text: "|0⟩", color: .red)
                .position(x: center.x, y: center.y + radius + 30)
            
            // |+⟩ label (right)
            StateLabel(text: "|+⟩", color: .white)
                .position(x: center.x + radius + 30, y: center.y)
            
            // |−⟩ label (left)
            StateLabel(text: "|−⟩", color: .white)
                .position(x: center.x - radius - 30, y: center.y)
        }
    }
}

// MARK: - Arrowhead Shape

struct ArrowheadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - State Label

struct StateLabel: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(color)
            .shadow(color: color.opacity(0.5), radius: 10)
    }
}

// MARK: - Preview

struct BlochSphereView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            BlochSphereView(qubit: .superposition)
                .frame(height: 300)
                .padding()
        }
    }
}
