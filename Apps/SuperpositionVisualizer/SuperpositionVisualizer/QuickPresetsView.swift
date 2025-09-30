//
//  QuickPresetsView.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  Quick access to standard quantum states
//

import SwiftUI

/// Provides quick access to standard quantum states
struct QuickPresetsView: View {
    let onSelectProb: (Double) -> Void
    let onSelectPhase: (Double) -> Void
    
    // Standard quantum states
    let presets: [(name: String, symbol: String, prob: Double, phase: Double, description: String, color: Color)] = [
        ("|0⟩", "0.circle.fill", 1.0, 0, "Ground state", .blue),
        ("|1⟩", "1.circle.fill", 0.0, 0, "Excited state", .red),
        ("|+⟩", "plus.circle.fill", 0.5, 0, "Plus state", .green),
        ("|−⟩", "minus.circle.fill", 0.5, .pi, "Minus state", .orange),
        ("|+i⟩", "i.circle.fill", 0.5, .pi/2, "Plus-i state", .purple),
        ("|−i⟩", "i.circle.fill", 0.5, 3 * .pi/2, "Minus-i state", .pink),
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Quantum States")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Tap any state to apply it instantly")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(presets, id: \.name) { preset in
                    PresetButton(
                        name: preset.name,
                        symbol: preset.symbol,
                        prob: preset.prob,
                        phase: preset.phase,
                        description: preset.description,
                        color: preset.color,
                        onSelectProb: onSelectProb,
                        onSelectPhase: onSelectPhase
                    )
                }
            }
            
            InfoBanner(
                icon: "lightbulb.fill",
                text: "These are the most common quantum states. Try each one to see how they differ on the Bloch sphere!",
                color: .yellow
            )
        }
    }
}

// MARK: - Preset Button

struct PresetButton: View {
    let name: String
    let symbol: String
    let prob: Double
    let phase: Double
    let description: String
    let color: Color
    let onSelectProb: (Double) -> Void
    let onSelectPhase: (Double) -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            withAnimation(.spring(response: 0.3)) {
                onSelectProb(prob)
                onSelectPhase(phase)
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isPressed = false
                }
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                }
                
                Text(description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("P(|0⟩):")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                        Text(String(format: "%.2f", prob))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                    }
                    
                    HStack(spacing: 4) {
                        Text("Phase:")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                        Text(String(format: "%.2fπ", phase / .pi))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isPressed ?
                        color.opacity(0.3) :
                        Color.white.opacity(0.1)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.5), lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: color.opacity(0.3), radius: isPressed ? 5 : 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Info Banner

struct InfoBanner: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(color.opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: - Preview

struct QuickPresetsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            QuickPresetsView(
                onSelectProb: { _ in },
                onSelectPhase: { _ in }
            )
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}
