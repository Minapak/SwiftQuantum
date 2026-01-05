//
//  QuantumDesignSystem.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  QuantumBridge-inspired design system
//

import SwiftUI

// MARK: - Quantum Colors

public struct QuantumColors {
    // Primary Palette
    public static let primary = Color(red: 0.0, green: 0.8, blue: 0.9)      // Cyan
    public static let secondary = Color(red: 0.6, green: 0.4, blue: 0.9)    // Purple
    public static let accent = Color(red: 1.0, green: 0.6, blue: 0.2)       // Orange

    // Algorithm Colors
    public static let bellState = Color(red: 0.2, green: 0.8, blue: 0.6)    // Teal
    public static let deutschJozsa = Color(red: 0.4, green: 0.6, blue: 1.0) // Blue
    public static let grover = Color(red: 1.0, green: 0.5, blue: 0.3)       // Coral
    public static let simon = Color(red: 0.9, green: 0.4, blue: 0.7)        // Pink

    // Status Colors
    public static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    public static let warning = Color(red: 1.0, green: 0.8, blue: 0.2)
    public static let error = Color(red: 1.0, green: 0.3, blue: 0.3)

    // Background Gradients
    public static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.05, blue: 0.15),
            Color(red: 0.1, green: 0.05, blue: 0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Qubit State Colors
    public static let zeroState = Color.blue
    public static let oneState = Color.red
    public static let superposition = Color.purple
}

// MARK: - Quantum Typography

public struct QuantumTypography {
    public static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    public static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    public static let headline = Font.system(size: 20, weight: .semibold, design: .rounded)
    public static let title = Font.system(size: 17, weight: .semibold, design: .default)
    public static let body = Font.system(size: 15, weight: .regular, design: .default)
    public static let caption = Font.system(size: 12, weight: .regular, design: .default)
    public static let monospace = Font.system(size: 14, weight: .medium, design: .monospaced)
    public static let monospaceLarge = Font.system(size: 24, weight: .bold, design: .monospaced)
}

// MARK: - Quantum Spacing

public struct QuantumSpacing {
    public static let xxs: CGFloat = 4
    public static let xs: CGFloat = 8
    public static let sm: CGFloat = 12
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48

    public static let cornerRadius: CGFloat = 16
    public static let cornerRadiusSmall: CGFloat = 8
    public static let cornerRadiusLarge: CGFloat = 24
}

// MARK: - Quantum Card Style

public struct QuantumCardStyle: ViewModifier {
    var padding: CGFloat = QuantumSpacing.md

    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(QuantumColors.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: QuantumSpacing.cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .cornerRadius(QuantumSpacing.cornerRadius)
    }
}

extension View {
    public func quantumCard(padding: CGFloat = QuantumSpacing.md) -> some View {
        modifier(QuantumCardStyle(padding: padding))
    }
}

// MARK: - Quantum Button Styles

public struct QuantumPrimaryButtonStyle: ButtonStyle {
    var color: Color = QuantumColors.primary

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(QuantumTypography.title)
            .foregroundColor(.white)
            .padding(.horizontal, QuantumSpacing.lg)
            .padding(.vertical, QuantumSpacing.sm)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(QuantumSpacing.cornerRadius)
            .shadow(color: color.opacity(0.4), radius: configuration.isPressed ? 2 : 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

public struct QuantumSecondaryButtonStyle: ButtonStyle {
    var color: Color = QuantumColors.secondary

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(QuantumTypography.title)
            .foregroundColor(color)
            .padding(.horizontal, QuantumSpacing.lg)
            .padding(.vertical, QuantumSpacing.sm)
            .background(color.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: QuantumSpacing.cornerRadius)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(QuantumSpacing.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - Quantum Icon Button

public struct QuantumIconButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void

    public init(icon: String, color: Color = QuantumColors.primary, size: CGFloat = 44, action: @escaping () -> Void) {
        self.icon = icon
        self.color = color
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.5, weight: .semibold))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(color.opacity(0.15))
                .cornerRadius(size / 2)
        }
    }
}

// MARK: - Quantum Badge

public struct QuantumBadge: View {
    let text: String
    let color: Color

    public init(_ text: String, color: Color = QuantumColors.primary) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(QuantumTypography.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, QuantumSpacing.xs)
            .padding(.vertical, QuantumSpacing.xxs)
            .background(color)
            .cornerRadius(QuantumSpacing.cornerRadiusSmall)
    }
}

// MARK: - Quantum Section Header

public struct QuantumSectionHeader: View {
    let title: String
    let icon: String?
    let action: (() -> Void)?

    public init(_ title: String, icon: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(QuantumColors.primary)
            }
            Text(title)
                .font(QuantumTypography.headline)
                .foregroundColor(.white)
            Spacer()
            if let action = action {
                Button(action: action) {
                    Text("See All")
                        .font(QuantumTypography.caption)
                        .foregroundColor(QuantumColors.primary)
                }
            }
        }
    }
}

// MARK: - Quantum Progress Bar

public struct QuantumProgressBar: View {
    let value: Double
    let maxValue: Double
    let color: Color
    let height: CGFloat

    public init(value: Double, maxValue: Double = 1.0, color: Color = QuantumColors.primary, height: CGFloat = 8) {
        self.value = value
        self.maxValue = maxValue
        self.color = color
        self.height = height
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.white.opacity(0.1))

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(min(value / maxValue, 1.0)))
                    .animation(.spring(response: 0.5), value: value)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Quantum Measurement Bar

public struct QuantumMeasurementBar: View {
    let label: String
    let value: Int
    let total: Int
    let color: Color

    public init(label: String, value: Int, total: Int, color: Color) {
        self.label = label
        self.value = value
        self.total = total
        self.color = color
    }

    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(value) / Double(total)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
            HStack {
                Text(label)
                    .font(QuantumTypography.monospace)
                    .foregroundColor(.white)
                Spacer()
                Text("\(value)")
                    .font(QuantumTypography.monospace)
                    .foregroundColor(color)
                Text("(\(String(format: "%.1f", percentage * 100))%)")
                    .font(QuantumTypography.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            QuantumProgressBar(value: percentage, color: color)
        }
    }
}

// MARK: - Quantum Stat Card

public struct QuantumStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    public init(title: String, value: String, icon: String, color: Color = QuantumColors.primary) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
    }

    public var body: some View {
        VStack(spacing: QuantumSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .font(QuantumTypography.monospaceLarge)
                .foregroundColor(.white)

            Text(title)
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .quantumCard()
    }
}

// MARK: - Loading Indicator

public struct QuantumLoadingView: View {
    @State private var rotation: Double = 0

    public init() {}

    public var body: some View {
        ZStack {
            Circle()
                .stroke(QuantumColors.primary.opacity(0.3), lineWidth: 4)

            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(QuantumColors.primary, lineWidth: 4)
                .rotationEffect(.degrees(rotation))
        }
        .frame(width: 40, height: 40)
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Version Badge

public struct VersionBadge: View {
    public init() {}

    public var body: some View {
        HStack(spacing: QuantumSpacing.xxs) {
            Image(systemName: "sparkles")
                .font(.caption2)
            Text("v2.0")
                .font(QuantumTypography.caption)
                .fontWeight(.bold)
        }
        .foregroundColor(QuantumColors.accent)
        .padding(.horizontal, QuantumSpacing.xs)
        .padding(.vertical, QuantumSpacing.xxs)
        .background(QuantumColors.accent.opacity(0.2))
        .cornerRadius(QuantumSpacing.cornerRadiusSmall)
    }
}
