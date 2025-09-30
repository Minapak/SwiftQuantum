//
//  SuperpositionVisualizerApp.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  An interactive iOS app for exploring quantum superposition
//

import SwiftUI
import SwiftQuantum

@main
struct SuperpositionVisualizerApp: App {
    var body: some Scene {
        WindowGroup {
            SuperpositionView()
                .preferredColorScheme(.dark) // Quantum theme!
        }
    }
}
