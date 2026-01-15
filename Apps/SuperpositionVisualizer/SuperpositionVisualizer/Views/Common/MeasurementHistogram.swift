//
//  MeasurementHistogram.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-09-30.
//  Animated histogram for measurement results
//

import SwiftUI

/// Displays measurement results as an animated histogram
struct MeasurementHistogram: View {
    let results: [Int]
    let expectedProb0: Double
    
    private var counts: (count0: Int, count1: Int) {
        let count0 = results.filter { $0 == 0 }.count
        let count1 = results.filter { $0 == 1 }.count
        return (count0, count1)
    }
    
    private var probabilities: (prob0: Double, prob1: Double) {
        let total = Double(results.count)
        return (
            prob0: Double(counts.count0) / total,
            prob1: Double(counts.count1) / total
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Measurement Results")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("\(results.count) measurements")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            // Histogram bars
            HStack(alignment: .bottom, spacing: 30) {
                // Bar for |0⟩
                VStack(spacing: 12) {
                    Text("\(counts.count0)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.cyan)
                    
                    ZStack(alignment: .bottom) {
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 100, height: 200)
                        
                        // Fill
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.6), .cyan],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(
                                width: 100,
                                height: 200 * probabilities.prob0
                            )
                            .animation(.spring(response: 0.6), value: results.count)
                    }
                    .shadow(color: .cyan.opacity(0.5), radius: 10)
                    
                    VStack(spacing: 4) {
                        Text("|0⟩")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(String(format: "%.1f%%", probabilities.prob0 * 100))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Bar for |1⟩
                VStack(spacing: 12) {
                    Text("\(counts.count1)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.pink)
                    
                    ZStack(alignment: .bottom) {
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 100, height: 200)
                        
                        // Fill
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.red.opacity(0.6), .pink],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(
                                width: 100,
                                height: 200 * probabilities.prob1
                            )
                            .animation(.spring(response: 0.6), value: results.count)
                    }
                    .shadow(color: .pink.opacity(0.5), radius: 10)
                    
                    VStack(spacing: 4) {
                        Text("|1⟩")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(String(format: "%.1f%%", probabilities.prob1 * 100))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            // Expected vs Measured
            comparisonView
        }
        .padding(25)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
    
    private var comparisonView: some View {
        VStack(spacing: 12) {
            Text("Expected vs Measured")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                // Expected
                VStack(alignment: .leading, spacing: 8) {
                    Label("Expected P(|0⟩)", systemImage: "chart.line.uptrend.xyaxis")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(String(format: "%.3f", expectedProb0))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                // Measured
                VStack(alignment: .trailing, spacing: 8) {
                    Label("Measured P(|0⟩)", systemImage: "waveform.path.ecg")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(String(format: "%.3f", probabilities.prob0))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.cyan)
                }
            }
            
            // Error
            let error = abs(expectedProb0 - probabilities.prob0)
            HStack {
                Text("Error:")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(String(format: "%.4f", error))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(error < 0.02 ? .green : .orange)
                
                Spacer()
                
                if error < 0.02 {
                    Label("Excellent!", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if error < 0.05 {
                    Label("Good", systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundColor(.yellow)
                } else {
                    Label("Need more measurements", systemImage: "exclamationmark.circle")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

// MARK: - Measurement Stats Card

struct MeasurementStatsCard: View {
    let results: [Int]
    let expectedProb0: Double
    
    private var entropy: Double {
        let count0 = results.filter { $0 == 0 }.count
        let count1 = results.filter { $0 == 1 }.count
        let total = Double(results.count)
        
        let p0 = Double(count0) / total
        let p1 = Double(count1) / total
        
        guard p0 > 0 && p1 > 0 else { return 0 }
        
        return -(p0 * log2(p0) + p1 * log2(p1))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.white)
            
            StatRow(
                icon: "chart.bar.fill",
                title: "Total Measurements",
                value: "\(results.count)"
            )
            
            StatRow(
                icon: "shuffle",
                title: "Entropy",
                value: String(format: "%.4f", entropy)
            )
            
            StatRow(
                icon: "arrow.triangle.2.circlepath",
                title: "Balance",
                value: String(format: "%.2f%%", abs(0.5 - Double(results.filter { $0 == 0 }.count) / Double(results.count)) * 100)
            )
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.cyan)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .font(.subheadline)
    }
}
