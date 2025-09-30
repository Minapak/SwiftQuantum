//
//  QubitVisualizer.swift
//  SwiftQuantum
//
//  Created by Eunmin Park on 2025-09-30.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import Foundation
import SwiftQuantum

/// Visualizes quantum states for educational and debugging purposes
///
/// QubitVisualizer provides ASCII art and text-based representations of quantum states,
/// making it easier to understand qubit behavior and measurement statistics.
///
/// ## Example Usage
/// ```swift
/// let qubit = Qubit.superposition
/// print(qubit.visualize())
/// print(qubit.measureAndVisualize(shots: 1000))
/// ```
public struct QubitVisualizer {
    
    // MARK: - Bloch Sphere Visualization
    
    /// Generates ASCII art representation of a qubit on the Bloch sphere
    ///
    /// The Bloch sphere is a geometric representation of quantum states where:
    /// - North pole (z = +1): |0⟩ state
    /// - South pole (z = -1): |1⟩ state
    /// - Equator: Superposition states
    /// - X-axis: Real superpositions
    /// - Y-axis: Complex superpositions with imaginary phase
    ///
    /// - Parameter qubit: The quantum state to visualize
    /// - Returns: Multi-line string with ASCII art Bloch sphere and state information
    public static func visualizeBlochSphere(_ qubit: Qubit) -> String {
        let (x, y, z) = qubit.blochCoordinates()
        
        var output = """
        
        🔵 Bloch Sphere Visualization
        ═══════════════════════════════
        
              |1⟩ (Z+)
               ↑
               │
               │
        ───────┼─────── (X+)
               │
               │
               ↓
              |0⟩ (Z-)
        
        📍 Current State Position:
        • X: \(String(format: "% .3f", x)) \(xAxisLabel(x))
        • Y: \(String(format: "% .3f", y)) \(yAxisLabel(y))
        • Z: \(String(format: "% .3f", z)) \(zAxisLabel(z))
        
        📊 Measurement Probabilities:
        • P(|0⟩) = \(String(format: "%.3f", qubit.probability0)) (\(String(format: "%.1f", qubit.probability0 * 100))%)
        • P(|1⟩) = \(String(format: "%.3f", qubit.probability1)) (\(String(format: "%.1f", qubit.probability1 * 100))%)
        
        📐 State Properties:
        • Entropy: \(String(format: "%.4f", qubit.entropy()))
        • Purity:  \(String(format: "%.4f", qubit.purity()))
        • Phase:   \(String(format: "%.4f", qubit.relativePhase)) rad (\(String(format: "%.1f", qubit.relativePhase * 180 / .pi))°)
        
        """
        
        return output
    }
    
    // MARK: - Helper Labels
    
    private static func xAxisLabel(_ x: Double) -> String {
        if abs(x) < 0.1 { return "" }
        return x > 0 ? "(→ |+⟩)" : "(← |−⟩)"
    }
    
    private static func yAxisLabel(_ y: Double) -> String {
        if abs(y) < 0.1 { return "" }
        return y > 0 ? "(↑ |+i⟩)" : "(↓ |−i⟩)"
    }
    
    private static func zAxisLabel(_ z: Double) -> String {
        if abs(z - 1.0) < 0.1 { return "(Pure |0⟩)" }
        if abs(z + 1.0) < 0.1 { return "(Pure |1⟩)" }
        if abs(z) < 0.1 { return "(Equator - max superposition)" }
        return z > 0 ? "(Toward |0⟩)" : "(Toward |1⟩)"
    }
    
    // MARK: - Measurement Histogram
    
    /// Creates a histogram of measurement results
    ///
    /// Performs multiple measurements on the qubit and displays the statistical
    /// distribution as an ASCII bar chart.
    ///
    /// - Parameters:
    ///   - qubit: The quantum state to measure
    ///   - shots: Number of measurements to perform (default: 1000)
    /// - Returns: ASCII bar chart showing measurement statistics
    public static func measurementHistogram(_ qubit: Qubit, shots: Int = 1000) -> String {
        let results = qubit.measureMultiple(count: shots)
        let count0 = results[0] ?? 0
        let count1 = results[1] ?? 0
        
        let maxBar = 50
        let bar0Length = min(count0 * maxBar / shots, maxBar)
        let bar1Length = min(count1 * maxBar / shots, maxBar)
        
        let bar0 = String(repeating: "█", count: bar0Length)
        let bar1 = String(repeating: "█", count: bar1Length)
        
        let percent0 = Double(count0) * 100 / Double(shots)
        let percent1 = Double(count1) * 100 / Double(shots)
        
        return """
        
        📊 Measurement Statistics (\(shots) shots)
        ═══════════════════════════════════════════════════════
        
        |0⟩: \(String(format: "%4d", count0)) (\(String(format: "%5.1f", percent0))%)
        \(bar0)
        
        |1⟩: \(String(format: "%4d", count1)) (\(String(format: "%5.1f", percent1))%)
        \(bar1)
        
        📈 Statistics:
        • Expected P(|0⟩): \(String(format: "%.3f", qubit.probability0))
        • Measured P(|0⟩): \(String(format: "%.3f", Double(count0) / Double(shots)))
        • Error: \(String(format: "%.4f", abs(qubit.probability0 - Double(count0) / Double(shots))))
        
        """
    }
    
    // MARK: - State Vector Visualization
    
    /// Displays the state vector in Dirac notation
    ///
    /// Shows the quantum state as a linear combination of basis states
    /// with complex amplitudes.
    ///
    /// - Parameter qubit: The quantum state to display
    /// - Returns: Formatted string in Dirac notation
    public static func stateVector(_ qubit: Qubit) -> String {
        let a0 = qubit.amplitude0
        let a1 = qubit.amplitude1
        
        var output = "\n📝 State Vector (Dirac Notation)\n"
        output += "═══════════════════════════════\n\n"
        output += "|ψ⟩ = "
        
        // Format amplitude0
        if abs(a0.real) > 1e-10 || abs(a0.imaginary) > 1e-10 {
            output += formatComplex(a0)
            output += "|0⟩"
        }
        
        // Format amplitude1
        if abs(a1.real) > 1e-10 || abs(a1.imaginary) > 1e-10 {
            if output.contains("|0⟩") {
                output += " + "
            }
            output += formatComplex(a1)
            output += "|1⟩"
        }
        
        if !output.contains("|0⟩") && !output.contains("|1⟩") {
            output += "0"
        }
        
        output += "\n\n"
        output += "Where:\n"
        output += "• α (amplitude0) = \(a0.description)\n"
        output += "• β (amplitude1) = \(a1.description)\n"
        output += "• |α|² + |β|² = \(String(format: "%.10f", qubit.probability0 + qubit.probability1)) ✓\n"
        
        return output
    }
    
    private static func formatComplex(_ c: Complex) -> String {
        if abs(c.imaginary) < 1e-10 {
            // Real only
            if abs(c.real - 1.0) < 1e-10 {
                return ""
            } else if abs(c.real + 1.0) < 1e-10 {
                return "-"
            } else {
                return String(format: "%.3f", c.real)
            }
        } else if abs(c.real) < 1e-10 {
            // Imaginary only
            if abs(c.imaginary - 1.0) < 1e-10 {
                return "i"
            } else if abs(c.imaginary + 1.0) < 1e-10 {
                return "-i"
            } else {
                return String(format: "%.3fi", c.imaginary)
            }
        } else {
            // Both real and imaginary
            let sign = c.imaginary >= 0 ? "+" : "-"
            return String(format: "(%.3f %@ %.3fi)", c.real, sign, abs(c.imaginary))
        }
    }
    
    // MARK: - Comparison Visualization
    
    /// Compares two quantum states side by side
    ///
    /// - Parameters:
    ///   - qubit1: First quantum state
    ///   - qubit2: Second quantum state
    ///   - label1: Label for first state (default: "State 1")
    ///   - label2: Label for second state (default: "State 2")
    /// - Returns: Side-by-side comparison of the states
    public static func compareStates(_ qubit1: Qubit, _ qubit2: Qubit,
                                    label1: String = "State 1",
                                    label2: String = "State 2") -> String {
        let (x1, y1, z1) = qubit1.blochCoordinates()
        let (x2, y2, z2) = qubit2.blochCoordinates()
        
        // Calculate fidelity between states
        let overlap = qubit1.amplitude0.conjugate * qubit2.amplitude0 +
                     qubit1.amplitude1.conjugate * qubit2.amplitude1
        let fidelity = overlap.magnitudeSquared
        
        return """
        
        🔄 State Comparison
        ═══════════════════════════════════════════════════════
        
        Property          │ \(label1.padding(toLength: 15, withPad: " ", startingAt: 0)) │ \(label2.padding(toLength: 15, withPad: " ", startingAt: 0))
        ──────────────────┼─────────────────┼─────────────────
        P(|0⟩)            │ \(String(format: "%15.3f", qubit1.probability0)) │ \(String(format: "%15.3f", qubit2.probability0))
        P(|1⟩)            │ \(String(format: "%15.3f", qubit1.probability1)) │ \(String(format: "%15.3f", qubit2.probability1))
        Bloch X           │ \(String(format: "%15.3f", x1)) │ \(String(format: "%15.3f", x2))
        Bloch Y           │ \(String(format: "%15.3f", y1)) │ \(String(format: "%15.3f", y2))
        Bloch Z           │ \(String(format: "%15.3f", z1)) │ \(String(format: "%15.3f", z2))
        Entropy           │ \(String(format: "%15.4f", qubit1.entropy())) │ \(String(format: "%15.4f", qubit2.entropy()))
        Relative Phase    │ \(String(format: "%15.4f", qubit1.relativePhase)) │ \(String(format: "%15.4f", qubit2.relativePhase))
        
        🎯 State Fidelity: \(String(format: "%.6f", fidelity))
        \(fidelityInterpretation(fidelity))
        
        """
    }
    
    private static func fidelityInterpretation(_ fidelity: Double) -> String {
        if fidelity > 0.999 {
            return "   → States are essentially identical! ✅"
        } else if fidelity > 0.95 {
            return "   → States are very similar"
        } else if fidelity > 0.75 {
            return "   → States have moderate overlap"
        } else if fidelity > 0.5 {
            return "   → States have significant differences"
        } else {
            return "   → States are quite different"
        }
    }
    
    // MARK: - Entanglement Visualization (for future multi-qubit support)
    
    /// Placeholder for future multi-qubit entanglement visualization
    public static func visualizeEntanglement(_ state: String) -> String {
        return """
        
        🔗 Entanglement Visualization
        ═══════════════════════════════
        
        ⚠️  Multi-qubit entanglement visualization coming soon!
        
        For now, SwiftQuantum focuses on single-qubit systems.
        Stay tuned for multi-qubit support in future updates.
        
        """
    }
    
    // MARK: - Color Console Output (for terminal use)
    
    /// ANSI color codes for terminal output
    private enum ANSIColor: String {
        case reset = "\u{001B}[0m"
        case red = "\u{001B}[31m"
        case green = "\u{001B}[32m"
        case yellow = "\u{001B}[33m"
        case blue = "\u{001B}[34m"
        case magenta = "\u{001B}[35m"
        case cyan = "\u{001B}[36m"
        case white = "\u{001B}[37m"
    }
    
    /// Adds color to terminal output (optional, disabled by default)
    public static func colorizeOutput(_ text: String, color: String = "blue") -> String {
        // Colors disabled by default for compatibility
        // Enable if running in color-capable terminal
        return text
    }
}

// MARK: - Qubit Extension for Easy Visualization

extension Qubit {
    /// Quick visualization of the qubit state
    ///
    /// Displays the qubit on the Bloch sphere with all relevant information.
    ///
    /// ## Example
    /// ```swift
    /// let qubit = Qubit.superposition
    /// print(qubit.visualize())
    /// ```
    ///
    /// - Returns: Formatted string with Bloch sphere visualization
    public func visualize() -> String {
        return QubitVisualizer.visualizeBlochSphere(self)
    }
    
    /// Measures the qubit multiple times and displays a histogram
    ///
    /// ## Example
    /// ```swift
    /// let qubit = Qubit.superposition
    /// print(qubit.measureAndVisualize(shots: 1000))
    /// ```
    ///
    /// - Parameter shots: Number of measurements to perform (default: 1000)
    /// - Returns: ASCII histogram of measurement results
    public func measureAndVisualize(shots: Int = 1000) -> String {
        return QubitVisualizer.measurementHistogram(self, shots: shots)
    }
    
    /// Displays the state vector in Dirac notation
    ///
    /// - Returns: Formatted state vector with amplitudes
    public func showStateVector() -> String {
        return QubitVisualizer.stateVector(self)
    }
    
    /// Compares this qubit with another
    ///
    /// - Parameters:
    ///   - other: Qubit to compare with
    ///   - label: Label for this qubit (default: "This State")
    ///   - otherLabel: Label for other qubit (default: "Other State")
    /// - Returns: Side-by-side comparison
    public func compare(with other: Qubit,
                       label: String = "This State",
                       otherLabel: String = "Other State") -> String {
        return QubitVisualizer.compareStates(self, other, label1: label, label2: otherLabel)
    }
}

// MARK: - Batch Visualization

extension QubitVisualizer {
    
    /// Visualizes multiple qubits in a grid format
    ///
    /// Useful for comparing several quantum states at once.
    ///
    /// - Parameter qubits: Array of (label, qubit) pairs
    /// - Returns: Grid visualization of all qubits
    public static func visualizeBatch(_ qubits: [(label: String, qubit: Qubit)]) -> String {
        var output = """
        
        📊 Batch Qubit Visualization
        ═══════════════════════════════════════════════════════
        
        """
        
        for (index, item) in qubits.enumerated() {
            output += "\n[\(index + 1)] \(item.label)\n"
            output += String(repeating: "─", count: 50) + "\n"
            
            let (x, y, z) = item.qubit.blochCoordinates()
            output += "Bloch: (\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z)))"
            output += " | P(|0⟩)=\(String(format: "%.2f", item.qubit.probability0))"
            output += " | Entropy=\(String(format: "%.3f", item.qubit.entropy()))\n"
        }
        
        output += String(repeating: "═", count: 50) + "\n"
        return output
    }
}
