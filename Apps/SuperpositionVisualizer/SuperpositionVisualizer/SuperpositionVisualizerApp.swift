//
//  SuperpositionVisualizerApp.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  An interactive iOS app for exploring quantum superposition
//
//  Updated 2026-01-06: Quantum Horizon UI/UX Redesign
//  - Glassmorphism + Bento Grid + Miami Gradients
//  - 5-Hub Navigation (Lab, Factory, Academy, Industry, Profile)
//

import SwiftUI
import SwiftQuantum

@main
struct SuperpositionVisualizerApp: App {
    @AppStorage("useNewUI") private var useNewUI = true

    var body: some Scene {
        WindowGroup {
            if useNewUI {
                QuantumHorizonView()
            } else {
                SuperpositionView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
