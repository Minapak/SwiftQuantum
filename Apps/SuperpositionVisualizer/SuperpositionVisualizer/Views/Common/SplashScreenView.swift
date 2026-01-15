//
//  SplashScreenView.swift
//  SuperpositionVisualizer
//
//  SwiftQuantum Splash Screen
//  Displays app logo on launch
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Background - Miami gradient
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.06, blue: 0.15),
                    Color(red: 0.02, green: 0.03, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // App Logo from Assets
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 36))
                    .scaleEffect(scale)
                    .opacity(opacity)

                // App Name
                Text("SwiftQuantum")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0, green: 0.8, blue: 1),
                                Color(red: 0.6, green: 0.4, blue: 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(opacity)

                // Tagline
                Text("Quantum Computing on iOS")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
