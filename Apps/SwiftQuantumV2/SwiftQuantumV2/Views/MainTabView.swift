//
//  MainTabView.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Background
            QuantumColors.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Content
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)

                    AlgorithmsView()
                        .tag(1)

                    CircuitBuilderView()
                        .tag(2)

                    ExploreView()
                        .tag(3)

                    SettingsView()
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private let tabs = [
        TabItem(icon: "house.fill", title: "Home"),
        TabItem(icon: "function", title: "Algorithms"),
        TabItem(icon: "cpu", title: "Circuit"),
        TabItem(icon: "atom", title: "Explore"),
        TabItem(icon: "gearshape.fill", title: "Settings")
    ]

    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    item: tabs[index],
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal, QuantumSpacing.sm)
        .padding(.top, QuantumSpacing.sm)
        .padding(.bottom, QuantumSpacing.md)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct TabItem {
    let icon: String
    let title: String
}

struct TabBarButton: View {
    let item: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? QuantumColors.primary : .white.opacity(0.5))

                Text(item.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? QuantumColors.primary : .white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
