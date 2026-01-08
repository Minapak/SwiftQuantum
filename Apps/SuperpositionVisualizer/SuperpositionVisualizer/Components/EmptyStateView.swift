//
//  EmptyStateView.swift
//  SuperpositionVisualizer
//
//  Reusable Empty State Component
//  Apple HIG Compliant Design
//

import SwiftUI

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    var accentColor: Color = QuantumHorizonColors.quantumCyan

    var body: some View {
        VStack(spacing: 20) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.1))
                    .frame(width: 100, height: 100)

                Circle()
                    .stroke(accentColor.opacity(0.3), lineWidth: 2)
                    .frame(width: 100, height: 100)

                Image(systemName: icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(accentColor.opacity(0.6))
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 32)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(accentColor.opacity(0.3))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(accentColor.opacity(0.5), lineWidth: 1)
                        )
                }
                .buttonStyle(SpringButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Loading State View
struct LoadingStateView: View {
    let message: String
    var accentColor: Color = QuantumHorizonColors.quantumCyan

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            // Animated loading rings
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(accentColor.opacity(0.3 - Double(index) * 0.1), lineWidth: 2)
                        .frame(width: CGFloat(60 + index * 20), height: CGFloat(60 + index * 20))
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 2 + Double(index) * 0.5)
                            .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }

                Image(systemName: "atom")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(accentColor)
                    .symbolEffect(.pulse, isActive: isAnimating)
            }
            .onAppear { isAnimating = true }

            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Error State View
struct ErrorStateView: View {
    let title: String
    let message: String
    var retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 80, height: 80)

                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.red.opacity(0.8))
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            if let retryAction = retryAction {
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.3))
                    .clipShape(Capsule())
                }
                .buttonStyle(SpringButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - No Results View
struct NoResultsView: View {
    let searchTerm: String
    var clearAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.white.opacity(0.3))

            VStack(spacing: 6) {
                Text("No results for \"\(searchTerm)\"")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text("Try a different search term")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
            }

            if let clearAction = clearAction {
                Button(action: clearAction) {
                    Text("Clear Search")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(QuantumHorizonColors.quantumCyan)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()

        ScrollView {
            VStack(spacing: 40) {
                EmptyStateView(
                    icon: "waveform.path.ecg",
                    title: "No Measurements",
                    message: "Run a measurement to see quantum state collapse results here.",
                    actionTitle: "Measure Now",
                    action: {}
                )

                LoadingStateView(message: "Connecting to IBM Quantum...")

                ErrorStateView(
                    title: "Connection Failed",
                    message: "Unable to connect to quantum backend. Please check your network connection.",
                    retryAction: {}
                )

                NoResultsView(
                    searchTerm: "Grover",
                    clearAction: {}
                )
            }
            .padding()
        }
    }
    .preferredColorScheme(.dark)
}
