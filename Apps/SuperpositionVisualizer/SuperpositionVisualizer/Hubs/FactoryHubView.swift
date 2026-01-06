import SwiftUI

// MARK: - Factory Hub - "The Deployment"
// Execution Command Center: QuantumBridge 연결 및 실무 알고리즘 배포
// 네온 라인으로 양자-고전 연결 통로를 시각화

struct FactoryHubView: View {
    @StateObject private var viewModel = FactoryHubViewModel()
    @State private var showApiKeySheet = false
    @State private var showPremiumSheet = false
    @State private var deployButtonProgress: CGFloat = 0
    @State private var isLongPressing = false
    @State private var showErrorCorrection = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Central Connection Visualization
                connectionVisualization

                // Backend Selection
                backendSelectionSection

                // Queue Status (if connected)
                if viewModel.isConnected {
                    queueStatusSection
                }

                // Deploy Button (Long Press)
                deploySection

                // Active Jobs
                if !viewModel.activeJobs.isEmpty {
                    activeJobsSection
                }

                // Quick Actions Grid
                quickActionsGrid

                // Error Correction Visualization (if active)
                if showErrorCorrection {
                    errorCorrectionVisualization
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 120)
        }
        .sheet(isPresented: $showApiKeySheet) {
            FactoryApiKeySheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showPremiumSheet) {
            FactoryPremiumSheet()
        }
    }

    // MARK: - Connection Visualization
    private var connectionVisualization: some View {
        BentoCard(size: .large) {
            ZStack {
                // Background pulse animation
                connectionPulseBackground

                VStack(spacing: 20) {
                    // Local Device
                    HStack {
                        deviceNode(
                            icon: "iphone",
                            label: "Local",
                            color: QuantumHorizonColors.quantumCyan,
                            isActive: true
                        )

                        Spacer()

                        // Connection line with pulsing animation
                        connectionLine

                        Spacer()

                        // QPU Node
                        deviceNode(
                            icon: "cpu.fill",
                            label: viewModel.selectedBackend.displayName,
                            color: viewModel.isConnected ? QuantumHorizonColors.quantumGreen : .gray,
                            isActive: viewModel.isConnected
                        )
                    }
                    .padding(.horizontal, 8)

                    // Connection status text
                    HStack(spacing: 8) {
                        Circle()
                            .fill(viewModel.isConnected ? QuantumHorizonColors.quantumGreen : .red)
                            .frame(width: 8, height: 8)
                            .pulsingGlow(color: viewModel.isConnected ? .green : .red, radius: 5)

                        Text(viewModel.isConnected ? "Bridge Active" : "Bridge Disconnected")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(viewModel.isConnected ? QuantumHorizonColors.quantumGreen : .red)
                    }

                    // Connect/Disconnect button
                    Button(action: {
                        if viewModel.isConnected {
                            viewModel.disconnect()
                        } else {
                            if viewModel.isPremium {
                                showApiKeySheet = true
                            } else {
                                showPremiumSheet = true
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.isConnected ? "link.badge.minus" : "link.badge.plus")
                            Text(viewModel.isConnected ? "Disconnect" : "Connect to QPU")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.isConnected ?
                            AnyShapeStyle(Color.red.opacity(0.3)) :
                            AnyShapeStyle(QuantumHorizonColors.miamiSunset)
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(SpringButtonStyle())
                }
            }
        }
    }

    private var connectionPulseBackground: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2

            ZStack {
                // Pulse circles
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(
                            viewModel.isConnected ?
                            QuantumHorizonColors.quantumGreen.opacity(0.3) :
                            Color.gray.opacity(0.1),
                            lineWidth: 1
                        )
                        .frame(width: CGFloat(100 + index * 50), height: CGFloat(100 + index * 50))
                        .position(x: centerX, y: centerY)
                        .opacity(viewModel.isConnected ? 1 : 0.3)
                        .animation(
                            .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                            value: viewModel.isConnected
                        )
                }
            }
        }
    }

    private func deviceNode(icon: String, label: String, color: Color, isActive: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 60, height: 60)

                Circle()
                    .stroke(color.opacity(0.5), lineWidth: 2)
                    .frame(width: 60, height: 60)

                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            .pulsingGlow(color: isActive ? color : .clear, radius: isActive ? 10 : 0)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
    }

    private var connectionLine: some View {
        GeometryReader { geometry in
            ZStack {
                // Base line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 2)

                // Animated pulse line
                if viewModel.isConnected {
                    ConnectionPulseLine()
                        .frame(height: 4)
                }

                // Data particles (flowing dots)
                if viewModel.isConnected {
                    FlowingParticles()
                        .frame(height: 20)
                }
            }
        }
        .frame(height: 30)
        .frame(maxWidth: 120)
    }

    // MARK: - Backend Selection
    private var backendSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Backend")
                .font(QuantumHorizonTypography.cardTitle(16))
                .foregroundColor(.white)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.availableBackends) { backend in
                        BackendSelectionCard(
                            backend: backend,
                            isSelected: viewModel.selectedBackend.id == backend.id,
                            isPremiumUser: viewModel.isPremium
                        )
                        .onTapGesture {
                            if viewModel.isPremium || !backend.isPremium {
                                withAnimation(.spring()) {
                                    viewModel.selectBackend(backend)
                                }
                            } else {
                                showPremiumSheet = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Queue Status
    private var queueStatusSection: some View {
        BentoCard(title: "Queue Status", icon: "clock.fill", accentColor: QuantumHorizonColors.quantumPurple, size: .medium) {
            HStack(spacing: 0) {
                queueStatItem(
                    value: "\(viewModel.queueStatus.pendingJobs)",
                    label: "Pending",
                    icon: "hourglass",
                    color: .orange
                )

                Divider()
                    .frame(height: 50)
                    .background(Color.white.opacity(0.1))

                queueStatItem(
                    value: "\(viewModel.queueStatus.runningJobs)",
                    label: "Running",
                    icon: "play.fill",
                    color: QuantumHorizonColors.quantumGreen
                )

                Divider()
                    .frame(height: 50)
                    .background(Color.white.opacity(0.1))

                queueStatItem(
                    value: formatWaitTime(viewModel.queueStatus.averageWaitTime),
                    label: "Est. Wait",
                    icon: "timer",
                    color: QuantumHorizonColors.quantumCyan
                )
            }
        }
    }

    private func queueStatItem(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)

            Text(value)
                .font(QuantumHorizonTypography.statNumber(24))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    private func formatWaitTime(_ seconds: Double) -> String {
        if seconds < 60 { return "\(Int(seconds))s" }
        else if seconds < 3600 { return "\(Int(seconds / 60))m" }
        else { return "\(Int(seconds / 3600))h" }
    }

    // MARK: - Deploy Section
    private var deploySection: some View {
        VStack(spacing: 16) {
            Text("Deploy Circuit")
                .font(QuantumHorizonTypography.cardTitle(16))
                .foregroundColor(.white)

            // Long press deploy button (fingerprint-style)
            ZStack {
                // Background progress ring
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 6)
                    .frame(width: 120, height: 120)

                // Progress ring
                Circle()
                    .trim(from: 0, to: deployButtonProgress)
                    .stroke(
                        QuantumHorizonColors.miamiSunset,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: deployButtonProgress)

                // Inner button
                Circle()
                    .fill(
                        isLongPressing ?
                        AnyShapeStyle(QuantumHorizonColors.miamiSunset) :
                        AnyShapeStyle(Color.white.opacity(0.08))
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )

                // Fingerprint icon
                VStack(spacing: 4) {
                    Image(systemName: "touchid")
                        .font(.system(size: 36, weight: .light))
                        .foregroundColor(isLongPressing ? .white : QuantumHorizonColors.quantumGold)

                    Text(isLongPressing ? "Deploying..." : "Hold to Deploy")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .scaleEffect(isLongPressing ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: isLongPressing)
            .gesture(
                LongPressGesture(minimumDuration: 2.0)
                    .onChanged { _ in
                        isLongPressing = true
                        startDeployProgress()
                    }
                    .onEnded { _ in
                        completeDeployment()
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        if deployButtonProgress < 1.0 {
                            cancelDeployment()
                        }
                    }
            )

            Text("Long press for 2 seconds to deploy")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.vertical, 20)
    }

    private func startDeployProgress() {
        withAnimation(.linear(duration: 2.0)) {
            deployButtonProgress = 1.0
        }
    }

    private func cancelDeployment() {
        isLongPressing = false
        withAnimation(.spring()) {
            deployButtonProgress = 0
        }
    }

    private func completeDeployment() {
        isLongPressing = false
        viewModel.deployCircuit()

        // Show error correction animation
        withAnimation(.spring()) {
            showErrorCorrection = true
        }

        // Reset after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.spring()) {
                deployButtonProgress = 0
                showErrorCorrection = false
            }
        }
    }

    // MARK: - Active Jobs
    private var activeJobsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Active Jobs")
                    .font(QuantumHorizonTypography.cardTitle(16))
                    .foregroundColor(.white)

                Spacer()

                Text("\(viewModel.activeJobs.count) jobs")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }

            ForEach(viewModel.activeJobs) { job in
                ActiveJobCard(job: job) {
                    viewModel.cancelJob(job.id)
                }
            }
        }
    }

    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(QuantumHorizonTypography.cardTitle(16))
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                FactoryActionButton(
                    title: "Bell State",
                    icon: "link.circle.fill",
                    gradient: LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                    isPremium: !viewModel.isPremium
                ) {
                    if viewModel.isPremium {
                        viewModel.runBellState()
                    } else {
                        showPremiumSheet = true
                    }
                }

                FactoryActionButton(
                    title: "GHZ State",
                    icon: "network",
                    gradient: LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
                    isPremium: !viewModel.isPremium
                ) {
                    if viewModel.isPremium {
                        viewModel.runGHZState()
                    } else {
                        showPremiumSheet = true
                    }
                }

                FactoryActionButton(
                    title: "Export QASM",
                    icon: "square.and.arrow.up.fill",
                    gradient: LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing),
                    isPremium: false
                ) {
                    viewModel.exportQASM()
                }

                FactoryActionButton(
                    title: "Continuous Mode",
                    icon: "infinity",
                    gradient: QuantumHorizonColors.miamiSunset,
                    isPremium: !viewModel.isPremium
                ) {
                    if viewModel.isPremium {
                        viewModel.toggleContinuousMode()
                    } else {
                        showPremiumSheet = true
                    }
                }
            }
        }
    }

    // MARK: - Error Correction Visualization
    private var errorCorrectionVisualization: some View {
        BentoCard(title: "Error Correction", icon: "shield.checkered", accentColor: QuantumHorizonColors.quantumGreen, size: .medium) {
            VStack(spacing: 16) {
                // Error correction progress
                ErrorCorrectionBar()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ECC Status")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))

                        Text("Auto-correcting...")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(QuantumHorizonColors.quantumGreen)
                    }

                    Spacer()

                    // Fidelity indicator
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Fidelity")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))

                        Text("99.2%")
                            .font(QuantumHorizonTypography.statNumber(20))
                            .foregroundColor(QuantumHorizonColors.quantumGreen)
                    }
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}

// MARK: - Connection Pulse Line
struct ConnectionPulseLine: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base glow
                Rectangle()
                    .fill(QuantumHorizonColors.quantumGreen.opacity(0.3))
                    .frame(height: 2)

                // Pulse
                Rectangle()
                    .fill(QuantumHorizonColors.quantumGreen)
                    .frame(width: 30, height: 2)
                    .offset(x: offset - geometry.size.width / 2)
            }
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    offset = geometry.size.width
                }
            }
        }
    }
}

// MARK: - Flowing Particles
struct FlowingParticles: View {
    @State private var particles: [ParticleData] = []

    struct ParticleData: Identifiable {
        let id = UUID()
        var offset: CGFloat
        var opacity: Double
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(QuantumHorizonColors.quantumCyan)
                        .frame(width: 4, height: 4)
                        .offset(x: particle.offset - geometry.size.width / 2)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                startParticleAnimation(width: geometry.size.width)
            }
        }
    }

    private func startParticleAnimation(width: CGFloat) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let newParticle = ParticleData(offset: 0, opacity: 1)
            particles.append(newParticle)

            withAnimation(.linear(duration: 1.5)) {
                if let index = particles.firstIndex(where: { $0.id == newParticle.id }) {
                    particles[index].offset = width
                    particles[index].opacity = 0
                }
            }

            // Clean up old particles
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                particles.removeAll { $0.offset >= width }
            }
        }
    }
}

// MARK: - Backend Selection Card
struct BackendSelectionCard: View {
    let backend: QuantumBackend
    let isSelected: Bool
    let isPremiumUser: Bool

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(backend.color.opacity(isSelected ? 0.3 : 0.15))
                    .frame(width: 56, height: 56)

                Circle()
                    .stroke(isSelected ? backend.color : Color.clear, lineWidth: 2)
                    .frame(width: 56, height: 56)

                Image(systemName: backend.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(backend.color)

                // Lock badge for premium backends
                if backend.isPremium && !isPremiumUser {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                        .padding(4)
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 20, y: -20)
                }
            }

            Text(backend.displayName)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)

            Text("\(backend.qubits) qubits")
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white.opacity(0.5))

            // Status indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(backend.status == "Online" ? Color.green : Color.orange)
                    .frame(width: 6, height: 6)

                Text(backend.status)
                    .font(.system(size: 8))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(width: 100)
        .padding(.vertical, 14)
        .glassmorphism(intensity: isSelected ? 0.12 : 0.06, cornerRadius: 16)
        .opacity(backend.isPremium && !isPremiumUser ? 0.6 : 1)
    }
}

// MARK: - Active Job Card
struct ActiveJobCard: View {
    let job: QuantumJobInfo
    let onCancel: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Status indicator with pulse
            ZStack {
                Circle()
                    .fill(job.statusColor.opacity(0.2))
                    .frame(width: 36, height: 36)

                Circle()
                    .fill(job.statusColor)
                    .frame(width: 10, height: 10)
            }
            .pulsingGlow(color: job.statusColor, radius: 5)

            VStack(alignment: .leading, spacing: 4) {
                Text(job.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Text("ID: \(job.id.prefix(8))...")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
            }

            Spacer()

            Text(job.status)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(job.statusColor)

            if job.status == "Queued" || job.status == "Running" {
                Button(action: onCancel) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red.opacity(0.6))
                }
            }
        }
        .padding(14)
        .glassmorphism(intensity: 0.06, cornerRadius: 14)
    }
}

// MARK: - Factory Action Button
struct FactoryActionButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    let isPremium: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(gradient.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(gradient)

                    if isPremium {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 10))
                            .foregroundColor(QuantumHorizonColors.quantumGold)
                            .offset(x: 16, y: -16)
                    }
                }

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassmorphism(intensity: 0.06, cornerRadius: 16)
        }
        .buttonStyle(SpringButtonStyle())
    }
}

// MARK: - Error Correction Bar
struct ErrorCorrectionBar: View {
    @State private var progress: CGFloat = 0
    @State private var color: Color = .red

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))

                // Progress (animates from red to green)
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: geometry.size.width * progress)
                    .animation(.easeInOut(duration: 2), value: progress)
            }
        }
        .frame(height: 8)
        .onAppear {
            // Animate from red to blue to green
            withAnimation(.easeInOut(duration: 1)) {
                progress = 0.5
                color = .blue
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    progress = 1.0
                    color = QuantumHorizonColors.quantumGreen
                }
            }
        }
    }
}

// MARK: - Factory Hub ViewModel
@MainActor
class FactoryHubViewModel: ObservableObject {
    @Published var isConnected = false
    @Published var isPremium = false
    @Published var isContinuousModeActive = false
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
            QuantumBackend(id: "simulator", displayName: "Simulator", qubits: 20, status: "Online", icon: "desktopcomputer", color: .blue, isPremium: false),
            QuantumBackend(id: "ibm_brisbane", displayName: "IBM Brisbane", qubits: 127, status: "Online", icon: "cpu", color: .purple, isPremium: true),
            QuantumBackend(id: "ibm_osaka", displayName: "IBM Osaka", qubits: 127, status: "Online", icon: "cpu", color: .cyan, isPremium: true),
            QuantumBackend(id: "ibm_kyoto", displayName: "IBM Kyoto", qubits: 127, status: "Maintenance", icon: "cpu", color: .orange, isPremium: true)
        ]
    }

    func connect(apiKey: String) {
        isConnected = true
        isPremium = true
        queueStatus = QueueStatusInfo(
            pendingJobs: Int.random(in: 10...50),
            runningJobs: Int.random(in: 1...5),
            averageWaitTime: Double.random(in: 300...1800)
        )
    }

    func disconnect() { isConnected = false }
    func selectBackend(_ backend: QuantumBackend) { selectedBackend = backend }

    func deployCircuit() {
        let job = QuantumJobInfo(id: UUID().uuidString, name: "Custom Circuit", status: "Running", statusColor: .green)
        activeJobs.append(job)
    }

    func cancelJob(_ id: String) { activeJobs.removeAll { $0.id == id } }
    func runBellState() {
        let job = QuantumJobInfo(id: UUID().uuidString, name: "Bell State", status: "Queued", statusColor: .orange)
        activeJobs.append(job)
    }
    func runGHZState() {
        let job = QuantumJobInfo(id: UUID().uuidString, name: "GHZ State", status: "Queued", statusColor: .orange)
        activeJobs.append(job)
    }
    func exportQASM() {}
    func toggleContinuousMode() { isContinuousModeActive.toggle() }
}

// MARK: - Factory API Key Sheet
struct FactoryApiKeySheet: View {
    @ObservedObject var viewModel: FactoryHubViewModel
    @Environment(\.dismiss) var dismiss
    @State private var apiKey = ""

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "key.radiowaves.forward.fill")
                        .font(.system(size: 56, weight: .light))
                        .foregroundStyle(QuantumHorizonColors.miamiSunset)

                    Text("Connect to IBM Quantum")
                        .font(QuantumHorizonTypography.sectionTitle(24))
                        .foregroundColor(.white)

                    Text("Enter your API key from quantum-computing.ibm.com")
                        .font(QuantumHorizonTypography.body(14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }

                // API Key Input
                SecureField("API Key", text: $apiKey)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )

                // Connect Button
                Button(action: {
                    viewModel.connect(apiKey: apiKey)
                    dismiss()
                }) {
                    Text("Connect")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(QuantumHorizonColors.miamiSunset)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(apiKey.isEmpty)
                .opacity(apiKey.isEmpty ? 0.5 : 1)

                Spacer()
            }
            .padding(24)
        }
    }
}

// MARK: - Factory Premium Sheet
struct FactoryPremiumSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            QuantumHorizonBackground()

            VStack(spacing: 24) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                // Crown icon
                Image(systemName: "crown.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(QuantumHorizonColors.goldCelebration)

                Text("Unlock Factory Premium")
                    .font(QuantumHorizonTypography.sectionTitle(24))
                    .foregroundColor(.white)

                Text("Access real quantum hardware and advanced deployment features")
                    .font(QuantumHorizonTypography.body(14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)

                // Features list
                VStack(alignment: .leading, spacing: 12) {
                    premiumFeatureRow("IBM Quantum hardware access")
                    premiumFeatureRow("127-qubit systems")
                    premiumFeatureRow("Priority queue placement")
                    premiumFeatureRow("Advanced error mitigation")
                    premiumFeatureRow("Continuous operation mode")
                }
                .padding()
                .glassmorphism(intensity: 0.08, cornerRadius: 16)

                // Upgrade button
                Button(action: { dismiss() }) {
                    Text("Upgrade - $9.99/month")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(QuantumHorizonColors.goldCelebration)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Text("7-day free trial included")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))

                Spacer()
            }
            .padding(24)
        }
    }

    private func premiumFeatureRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(QuantumHorizonColors.quantumGold)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        QuantumHorizonBackground()
        FactoryHubView()
    }
    .preferredColorScheme(.dark)
}
