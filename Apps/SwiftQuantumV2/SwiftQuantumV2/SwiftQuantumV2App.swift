//
//  SwiftQuantumV2App.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  Main application entry point for SwiftQuantum v2.0
//  Integrates QuantumBridge features with native iOS experience
//

import SwiftUI
import SwiftQuantum

@main
struct SwiftQuantumV2App: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                // Hide splash after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}

// MARK: - Splash View

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            QuantumColors.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: QuantumSpacing.lg) {
                // Animated atom icon
                ZStack {
                    // Orbits
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(QuantumColors.primary.opacity(0.3), lineWidth: 1)
                            .frame(width: CGFloat(60 + i * 30), height: CGFloat(60 + i * 30))
                            .rotationEffect(.degrees(Double(i) * 30 + rotation))
                    }

                    // Center atom
                    Image(systemName: "atom")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(QuantumColors.primary)
                }
                .scaleEffect(scale)

                VStack(spacing: QuantumSpacing.xs) {
                    HStack(spacing: QuantumSpacing.xs) {
                        Text("SwiftQuantum")
                            .font(QuantumTypography.displayLarge)
                            .foregroundColor(.white)

                        Text("v2.0")
                            .font(QuantumTypography.headline)
                            .foregroundColor(QuantumColors.accent)
                            .padding(.horizontal, QuantumSpacing.xs)
                            .padding(.vertical, QuantumSpacing.xxs)
                            .background(QuantumColors.accent.opacity(0.2))
                            .cornerRadius(QuantumSpacing.cornerRadiusSmall)
                    }

                    Text("QuantumBridge Integration")
                        .font(QuantumTypography.body)
                        .foregroundColor(.white.opacity(0.6))
                }
                .opacity(opacity)

                // Loading indicator
                HStack(spacing: QuantumSpacing.xs) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(QuantumColors.primary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(scale)
                            .animation(
                                .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                                value: scale
                            )
                    }
                }
                .padding(.top, QuantumSpacing.xl)
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                opacity = 1.0
            }
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - App Constants

struct AppConstants {
    static let appName = "SwiftQuantum"
    static let version = "2.0.0"
    static let buildNumber = "1"

    static let githubURL = "https://github.com/Minapak/SwiftQuantum"
    static let bridgeURL = "https://github.com/Minapak/QuantumBridge"

    static let maxQubits = 20
    static let defaultShots = 1000
}

// MARK: - Preview

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
