//
//  QuantumBridgeConnectionView.swift
//  SuperpositionVisualizer - SwiftQuantum v2.1.0
//
//  Created by Eunmin Park on 2026-01-06.
//  Copyright (c) 2026 iOS Quantum Engineering. All rights reserved.
//
//  Premium QuantumBridge Connection UI - Real QPU Connectivity
//  Tab 4: QuantumBridge Connection (Premium Feature)
//

import SwiftUI

// MARK: - QuantumBridge Connection View

struct QuantumBridgeConnectionView: View {
    @StateObject private var viewModel = QuantumBridgeConnectionViewModel()
    @State private var showApiKeySheet = false
    @State private var showPremiumSheet = false

    var body: some View {
        ZStack {
            // Premium gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.08, green: 0.02, blue: 0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    connectionHeader

                    // Connection status
                    connectionStatusCard

                    // Backend selector
                    backendSelector

                    // Queue status
                    if viewModel.isConnected {
                        queueStatusCard
                    }

                    // Active jobs
                    if !viewModel.activeJobs.isEmpty {
                        activeJobsSection
                    }

                    // Quick actions
                    quickActionsSection

                    // Premium upsell (if not subscribed)
                    if !viewModel.isPremium {
                        premiumUpsellCard
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showApiKeySheet) {
            ApiKeyInputSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showPremiumSheet) {
            PremiumFeatureSheet()
        }
    }

    // MARK: - Connection Header

    private var connectionHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(viewModel.isConnected ? QuantumPremiumColors.neonGreen : .gray)

                VStack(alignment: .leading, spacing: 2) {
                    Text("QuantumBridge")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Real Quantum Hardware Connection")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                // Connection indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(viewModel.isConnected ? Color.green.opacity(0.5) : Color.red.opacity(0.5), lineWidth: 4)
                                .scaleEffect(viewModel.isConnected ? 1.5 : 1.0)
                                .opacity(viewModel.isConnected ? 0.5 : 0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: viewModel.isConnected)
                        )

                    Text(viewModel.isConnected ? "Connected" : "Disconnected")
                        .font(.caption)
                        .foregroundColor(viewModel.isConnected ? .green : .red)
                }
            }

            // IBM Quantum badge
            HStack(spacing: 8) {
                Image(systemName: "cpu")
                    .foregroundColor(QuantumPremiumColors.cyberneticBlue)
                Text("IBM Quantum Compatible")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                Text("Powered by Qiskit Runtime")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    viewModel.isConnected ? QuantumPremiumColors.neonGreen.opacity(0.15) : Color.gray.opacity(0.1),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }

    // MARK: - Connection Status Card

    private var connectionStatusCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Connection Status")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            if viewModel.isConnected {
                // Connected state
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Backend", systemImage: "server.rack")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))

                        Text(viewModel.selectedBackend.displayName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }

                    Divider()
                        .frame(height: 40)
                        .background(Color.white.opacity(0.3))

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Qubits", systemImage: "cpu")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))

                        Text("\(viewModel.selectedBackend.qubits)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(QuantumPremiumColors.cyberneticBlue)
                    }

                    Divider()
                        .frame(height: 40)
                        .background(Color.white.opacity(0.3))

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Status", systemImage: "checkmark.circle")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))

                        Text(viewModel.selectedBackend.status)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }

                Button(action: { viewModel.disconnect() }) {
                    Text("Disconnect")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
            } else {
                // Disconnected state
                VStack(spacing: 12) {
                    Image(systemName: "antenna.radiowaves.left.and.right.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)

                    Text("Not connected to quantum hardware")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))

                    Button(action: {
                        if viewModel.isPremium {
                            showApiKeySheet = true
                        } else {
                            showPremiumSheet = true
                        }
                    }) {
                        HStack {
                            Image(systemName: viewModel.isPremium ? "link" : "crown.fill")
                            Text(viewModel.isPremium ? "Connect to IBM Quantum" : "Unlock Premium")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [QuantumPremiumColors.cyberneticBlue, QuantumPremiumColors.neonGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    // MARK: - Backend Selector

    private var backendSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Backend")
                .font(.headline)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.availableBackends) { backend in
                        BackendCard(
                            backend: backend,
                            isSelected: viewModel.selectedBackend.id == backend.id,
                            isPremium: viewModel.isPremium
                        )
                        .onTapGesture {
                            if viewModel.isPremium || !backend.isPremium {
                                viewModel.selectBackend(backend)
                            } else {
                                showPremiumSheet = true
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Queue Status Card

    private var queueStatusCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Queue Status")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Button(action: { viewModel.refreshQueueStatus() }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(QuantumPremiumColors.cyberneticBlue)
                }
            }

            HStack(spacing: 20) {
                QueueStatItem(
                    title: "Pending",
                    value: "\(viewModel.queueStatus.pendingJobs)",
                    icon: "hourglass",
                    color: .orange
                )

                QueueStatItem(
                    title: "Running",
                    value: "\(viewModel.queueStatus.runningJobs)",
                    icon: "play.fill",
                    color: .green
                )

                QueueStatItem(
                    title: "Wait Time",
                    value: formatTime(viewModel.queueStatus.averageWaitTime),
                    icon: "clock",
                    color: QuantumPremiumColors.cyberneticBlue
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }

    private func formatTime(_ seconds: Double) -> String {
        if seconds < 60 {
            return "\(Int(seconds))s"
        } else if seconds < 3600 {
            return "\(Int(seconds / 60))m"
        } else {
            return "\(Int(seconds / 3600))h"
        }
    }

    // MARK: - Active Jobs Section

    private var activeJobsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Active Jobs")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Text("\(viewModel.activeJobs.count) jobs")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

            ForEach(viewModel.activeJobs) { job in
                JobCard(job: job, onCancel: {
                    viewModel.cancelJob(job.id)
                })
            }
        }
    }

    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickActionButton(
                    title: "Run Bell State",
                    icon: "link",
                    color: .purple,
                    isPremium: !viewModel.isPremium
                ) {
                    if viewModel.isPremium {
                        viewModel.runBellState()
                    } else {
                        showPremiumSheet = true
                    }
                }

                QuickActionButton(
                    title: "Run GHZ State",
                    icon: "network",
                    color: .blue,
                    isPremium: !viewModel.isPremium
                ) {
                    if viewModel.isPremium {
                        viewModel.runGHZState()
                    } else {
                        showPremiumSheet = true
                    }
                }

                QuickActionButton(
                    title: "Export QASM",
                    icon: "square.and.arrow.up",
                    color: .green,
                    isPremium: false
                ) {
                    viewModel.exportQASM()
                }

                QuickActionButton(
                    title: "View History",
                    icon: "clock.arrow.circlepath",
                    color: .orange,
                    isPremium: false
                ) {
                    // Show history
                }
            }
        }
    }

    // MARK: - Premium Upsell Card

    private var premiumUpsellCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "crown.fill")
                    .font(.title)
                    .foregroundColor(.yellow)

                VStack(alignment: .leading, spacing: 2) {
                    Text("QuantumBridge Premium")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Unlock real quantum hardware access")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                PremiumFeatureItem(text: "IBM Quantum hardware access")
                PremiumFeatureItem(text: "1000+ qubit simulations")
                PremiumFeatureItem(text: "Priority queue placement")
                PremiumFeatureItem(text: "Advanced error mitigation")
            }

            Button(action: { showPremiumSheet = true }) {
                Text("Upgrade to Premium")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

// MARK: - Backend Card

struct BackendCard: View {
    let backend: QuantumBackend
    let isSelected: Bool
    let isPremium: Bool

    var body: some View {
        VStack(spacing: 10) {
            // Backend icon
            ZStack {
                Circle()
                    .fill(backend.color.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: backend.icon)
                    .font(.title2)
                    .foregroundColor(backend.color)

                if backend.isPremium && !isPremium {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .offset(x: 18, y: -18)
                }
            }

            Text(backend.displayName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)

            Text("\(backend.qubits) qubits")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(width: 100)
        .padding(.vertical, 12)
        .background(isSelected ? backend.color.opacity(0.2) : Color.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? backend.color : Color.clear, lineWidth: 2)
        )
        .cornerRadius(12)
        .opacity(backend.isPremium && !isPremium ? 0.7 : 1.0)
    }
}

// MARK: - Queue Stat Item

struct QueueStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Job Card

struct JobCard: View {
    let job: QuantumJobInfo
    let onCancel: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(job.statusColor)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(job.name)
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text("ID: \(job.id.prefix(8))...")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Text(job.status)
                .font(.caption)
                .foregroundColor(job.statusColor)

            if job.status == "Queued" || job.status == "Running" {
                Button(action: onCancel) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red.opacity(0.7))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let isPremium: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)

                    if isPremium {
                        Image(systemName: "crown.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                            .offset(x: 15, y: -15)
                    }
                }

                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Premium Feature Item

struct PremiumFeatureItem: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.yellow)
                .font(.caption)

            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - API Key Input Sheet

struct ApiKeyInputSheet: View {
    @ObservedObject var viewModel: QuantumBridgeConnectionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var apiKey = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 24) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 50))
                        .foregroundColor(QuantumPremiumColors.cyberneticBlue)

                    Text("Enter IBM Quantum API Key")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Get your API key from quantum-computing.ibm.com")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)

                    SecureField("API Key", text: $apiKey)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    Button(action: {
                        viewModel.connect(apiKey: apiKey)
                        dismiss()
                    }) {
                        Text("Connect")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(QuantumPremiumColors.cyberneticBlue)
                            .cornerRadius(12)
                    }
                    .disabled(apiKey.isEmpty)

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Premium Feature Sheet

struct PremiumFeatureSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)

                Text("Premium Feature")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Unlock QuantumBridge Premium to access real quantum hardware and advanced features")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 12) {
                    PremiumFeatureItem(text: "Connect to IBM Quantum hardware")
                    PremiumFeatureItem(text: "Run circuits on 127-qubit systems")
                    PremiumFeatureItem(text: "Advanced error mitigation")
                    PremiumFeatureItem(text: "Priority queue placement")
                    PremiumFeatureItem(text: "Unlimited job submissions")
                }

                Button(action: { dismiss() }) {
                    Text("Upgrade to Premium - $9.99/month")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }

                Text("7-day free trial included")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))

                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - View Model

@MainActor
class QuantumBridgeConnectionViewModel: ObservableObject {
    @Published var isConnected = false
    @Published var isPremium = false
    @Published var selectedBackend: QuantumBackend
    @Published var availableBackends: [QuantumBackend] = []
    @Published var queueStatus = QueueStatusInfo(pendingJobs: 0, runningJobs: 0, averageWaitTime: 0)
    @Published var activeJobs: [QuantumJobInfo] = []

    init() {
        selectedBackend = QuantumBackend(
            id: "simulator",
            displayName: "Simulator",
            qubits: 20,
            status: "Online",
            icon: "desktopcomputer",
            color: .blue,
            isPremium: false
        )

        setupBackends()
    }

    private func setupBackends() {
        availableBackends = [
            QuantumBackend(
                id: "simulator",
                displayName: "Simulator",
                qubits: 20,
                status: "Online",
                icon: "desktopcomputer",
                color: .blue,
                isPremium: false
            ),
            QuantumBackend(
                id: "ibm_brisbane",
                displayName: "IBM Brisbane",
                qubits: 127,
                status: "Online",
                icon: "cpu",
                color: .purple,
                isPremium: true
            ),
            QuantumBackend(
                id: "ibm_osaka",
                displayName: "IBM Osaka",
                qubits: 127,
                status: "Online",
                icon: "cpu",
                color: .cyan,
                isPremium: true
            ),
            QuantumBackend(
                id: "ibm_kyoto",
                displayName: "IBM Kyoto",
                qubits: 127,
                status: "Maintenance",
                icon: "cpu",
                color: .orange,
                isPremium: true
            )
        ]
    }

    func connect(apiKey: String) {
        // Simulate connection
        isConnected = true
        isPremium = true

        // Update queue status
        queueStatus = QueueStatusInfo(
            pendingJobs: Int.random(in: 10...50),
            runningJobs: Int.random(in: 1...5),
            averageWaitTime: Double.random(in: 300...1800)
        )
    }

    func disconnect() {
        isConnected = false
    }

    func selectBackend(_ backend: QuantumBackend) {
        selectedBackend = backend
    }

    func refreshQueueStatus() {
        queueStatus = QueueStatusInfo(
            pendingJobs: Int.random(in: 10...50),
            runningJobs: Int.random(in: 1...5),
            averageWaitTime: Double.random(in: 300...1800)
        )
    }

    func cancelJob(_ id: String) {
        activeJobs.removeAll { $0.id == id }
    }

    func runBellState() {
        let job = QuantumJobInfo(
            id: UUID().uuidString,
            name: "Bell State",
            status: "Queued",
            statusColor: .orange
        )
        activeJobs.append(job)
    }

    func runGHZState() {
        let job = QuantumJobInfo(
            id: UUID().uuidString,
            name: "GHZ State (3 qubits)",
            status: "Queued",
            statusColor: .orange
        )
        activeJobs.append(job)
    }

    func exportQASM() {
        // Export QASM
    }
}

// MARK: - Models

struct QuantumBackend: Identifiable {
    let id: String
    let displayName: String
    let qubits: Int
    let status: String
    let icon: String
    let color: Color
    let isPremium: Bool
    var description: String = ""
}

struct QueueStatusInfo {
    let pendingJobs: Int
    let runningJobs: Int
    let averageWaitTime: Double
}

struct QuantumJobInfo: Identifiable {
    let id: String
    let name: String
    let status: String
    let statusColor: Color
}

// MARK: - Preview

struct QuantumBridgeConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuantumBridgeConnectionView()
            .preferredColorScheme(.dark)
    }
}
