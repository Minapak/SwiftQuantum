//
//  ExploreView.swift
//  SwiftQuantum v2.0
//
//  Created by Eunmin Park on 2025-01-05.
//  Copyright © 2025 iOS Quantum Engineering. All rights reserved.
//
//  Interactive Bloch Sphere and Qubit Explorer
//

import SwiftUI
import SceneKit
import SwiftQuantum

struct ExploreView: View {
    @StateObject private var stateManager = QubitStateManager()
    @State private var selectedPreset: QubitPreset = .zero

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: QuantumSpacing.lg) {
                    // Header
                    headerSection

                    // Bloch Sphere
                    blochSphereSection

                    // State Info
                    stateInfoSection

                    // Controls
                    controlsSection

                    // Presets
                    presetsSection

                    // Measurement
                    measurementSection
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Qubit Explorer")
                    .font(QuantumTypography.displayMedium)
                    .foregroundColor(.white)

                Text("Interactive Bloch sphere visualization")
                    .font(QuantumTypography.body)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "atom")
                .font(.system(size: 36))
                .foregroundColor(QuantumColors.secondary)
        }
        .quantumCard()
    }

    // MARK: - Bloch Sphere

    private var blochSphereSection: some View {
        VStack(spacing: QuantumSpacing.md) {
            BlochSphereSceneView(qubit: stateManager.qubit)
                .frame(height: 300)
                .cornerRadius(QuantumSpacing.cornerRadius)

            // Bloch Coordinates
            HStack(spacing: QuantumSpacing.lg) {
                let coords = stateManager.qubit.blochCoordinates()

                CoordinateDisplay(label: "X", value: coords.x, color: .red)
                CoordinateDisplay(label: "Y", value: coords.y, color: .green)
                CoordinateDisplay(label: "Z", value: coords.z, color: .cyan)
            }
        }
        .quantumCard()
    }

    // MARK: - State Info

    private var stateInfoSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Quantum State", icon: "waveform")

            VStack(spacing: QuantumSpacing.sm) {
                // State equation
                HStack {
                    Text("|ψ⟩ =")
                        .font(QuantumTypography.monospace)
                        .foregroundColor(.white)

                    Text(stateManager.qubit.stateDescription())
                        .font(QuantumTypography.monospace)
                        .foregroundColor(QuantumColors.primary)
                }

                Divider().background(Color.white.opacity(0.1))

                // Properties
                HStack {
                    StatePropertyItem(
                        title: "Entropy",
                        value: String(format: "%.3f", stateManager.qubit.entropy()),
                        color: QuantumColors.secondary
                    )

                    StatePropertyItem(
                        title: "Purity",
                        value: String(format: "%.3f", stateManager.qubit.purity()),
                        color: QuantumColors.success
                    )

                    StatePropertyItem(
                        title: "Phase",
                        value: String(format: "%.2f°", stateManager.phase * 180 / .pi),
                        color: QuantumColors.accent
                    )
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Controls

    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Controls", icon: "slider.horizontal.3")

            VStack(spacing: QuantumSpacing.lg) {
                // Probability slider
                VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
                    HStack {
                        Text("P(|0⟩)")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)
                        Spacer()
                        Text(String(format: "%.1f%%", stateManager.probability0 * 100))
                            .font(QuantumTypography.monospace)
                            .foregroundColor(QuantumColors.zeroState)
                    }

                    Slider(value: $stateManager.probability0, in: 0...1)
                        .accentColor(QuantumColors.zeroState)

                    HStack {
                        Text("P(|1⟩)")
                            .font(QuantumTypography.caption)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                        Text(String(format: "%.1f%%", (1 - stateManager.probability0) * 100))
                            .font(QuantumTypography.caption)
                            .foregroundColor(QuantumColors.oneState)
                    }
                }

                // Phase slider
                VStack(alignment: .leading, spacing: QuantumSpacing.xs) {
                    HStack {
                        Text("Relative Phase")
                            .font(QuantumTypography.body)
                            .foregroundColor(.white)
                        Spacer()
                        Text(String(format: "%.2f rad", stateManager.phase))
                            .font(QuantumTypography.monospace)
                            .foregroundColor(QuantumColors.secondary)
                    }

                    Slider(value: $stateManager.phase, in: 0...(2 * .pi))
                        .accentColor(QuantumColors.secondary)

                    HStack {
                        Text("0")
                            .font(QuantumTypography.caption)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text("2π")
                            .font(QuantumTypography.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .quantumCard()
        }
    }

    // MARK: - Presets

    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Quick Presets", icon: "star.fill")

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: QuantumSpacing.sm) {
                ForEach(QubitPreset.allCases, id: \.self) { preset in
                    PresetButton(
                        preset: preset,
                        isSelected: selectedPreset == preset
                    ) {
                        selectedPreset = preset
                        stateManager.applyPreset(preset)
                    }
                }
            }
        }
    }

    // MARK: - Measurement

    private var measurementSection: some View {
        VStack(alignment: .leading, spacing: QuantumSpacing.md) {
            QuantumSectionHeader("Measurement", icon: "bolt.fill")

            VStack(spacing: QuantumSpacing.md) {
                // Measurement buttons
                HStack(spacing: QuantumSpacing.md) {
                    Button(action: stateManager.measureOnce) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Measure")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(QuantumPrimaryButtonStyle())

                    Button(action: { stateManager.measureMultiple(shots: 1000) }) {
                        HStack {
                            Image(systemName: "bolt.horizontal.fill")
                            Text("1000×")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(QuantumSecondaryButtonStyle())
                }

                // Results
                if !stateManager.measurementResults.isEmpty {
                    VStack(spacing: QuantumSpacing.sm) {
                        let total = stateManager.measurementResults.values.reduce(0, +)

                        QuantumMeasurementBar(
                            label: "|0⟩",
                            value: stateManager.measurementResults[0] ?? 0,
                            total: total,
                            color: QuantumColors.zeroState
                        )

                        QuantumMeasurementBar(
                            label: "|1⟩",
                            value: stateManager.measurementResults[1] ?? 0,
                            total: total,
                            color: QuantumColors.oneState
                        )
                    }
                }

                // Reset button
                Button(action: stateManager.reset) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(QuantumColors.warning)
                }
            }
            .quantumCard()
        }
    }
}

// MARK: - Qubit State Manager

class QubitStateManager: ObservableObject {
    @Published var probability0: Double = 1.0 {
        didSet { updateQubit() }
    }
    @Published var phase: Double = 0.0 {
        didSet { updateQubit() }
    }
    @Published var qubit: Qubit = .zero
    @Published var measurementResults: [Int: Int] = [:]

    private func updateQubit() {
        let alpha = Complex(sqrt(probability0), 0)
        let phaseComplex = Complex.exp(Complex(0, phase))
        let beta = phaseComplex * sqrt(1 - probability0)
        qubit = Qubit(amplitude0: alpha, amplitude1: beta)
    }

    func applyPreset(_ preset: QubitPreset) {
        switch preset {
        case .zero:
            probability0 = 1.0
            phase = 0.0
        case .one:
            probability0 = 0.0
            phase = 0.0
        case .plus:
            probability0 = 0.5
            phase = 0.0
        case .minus:
            probability0 = 0.5
            phase = .pi
        case .iState:
            probability0 = 0.5
            phase = .pi / 2
        case .minusI:
            probability0 = 0.5
            phase = 3 * .pi / 2
        }
        measurementResults = [:]
    }

    func measureOnce() {
        let result = qubit.measure()
        measurementResults = [result: 1]
    }

    func measureMultiple(shots: Int) {
        measurementResults = qubit.measureMultiple(count: shots)
    }

    func reset() {
        probability0 = 1.0
        phase = 0.0
        measurementResults = [:]
    }
}

// MARK: - Qubit Preset

enum QubitPreset: String, CaseIterable {
    case zero = "|0⟩"
    case one = "|1⟩"
    case plus = "|+⟩"
    case minus = "|−⟩"
    case iState = "|i⟩"
    case minusI = "|−i⟩"
}

// MARK: - Bloch Sphere Scene View

struct BlochSphereSceneView: UIViewRepresentable {
    let qubit: Qubit

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = createScene()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        if let stateVector = uiView.scene?.rootNode.childNode(withName: "stateVector", recursively: true) {
            let coords = qubit.blochCoordinates()
            updateStateVector(stateVector, x: coords.x, y: coords.y, z: coords.z)
        }
    }

    private func createScene() -> SCNScene {
        let scene = SCNScene()

        // Sphere
        let sphereGeometry = SCNSphere(radius: 1.0)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.1)
        sphereGeometry.firstMaterial?.isDoubleSided = true
        let sphereNode = SCNNode(geometry: sphereGeometry)
        scene.rootNode.addChildNode(sphereNode)

        // Axes
        addAxis(to: scene, direction: SCNVector3(1.5, 0, 0), color: .red, label: "X")
        addAxis(to: scene, direction: SCNVector3(0, 1.5, 0), color: .green, label: "Y")
        addAxis(to: scene, direction: SCNVector3(0, 0, 1.5), color: .cyan, label: "Z")

        // State vector
        let coords = qubit.blochCoordinates()
        let stateVector = createStateVector(x: coords.x, y: coords.y, z: coords.z)
        stateVector.name = "stateVector"
        scene.rootNode.addChildNode(stateVector)

        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(3, 2, 3)
        cameraNode.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }

    private func addAxis(to scene: SCNScene, direction: SCNVector3, color: UIColor, label: String) {
        let cylinder = SCNCylinder(radius: 0.02, height: CGFloat(sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z)))
        cylinder.firstMaterial?.diffuse.contents = color
        let cylinderNode = SCNNode(geometry: cylinder)

        // Position and rotate
        cylinderNode.position = SCNVector3(direction.x / 2, direction.y / 2, direction.z / 2)

        if direction.x != 0 {
            cylinderNode.eulerAngles.z = -.pi / 2
        } else if direction.z != 0 {
            cylinderNode.eulerAngles.x = .pi / 2
        }

        scene.rootNode.addChildNode(cylinderNode)
    }

    private func createStateVector(x: Double, y: Double, z: Double) -> SCNNode {
        let parentNode = SCNNode()

        // Arrow shaft
        let length = 1.0
        let cylinder = SCNCylinder(radius: 0.03, height: CGFloat(length))
        cylinder.firstMaterial?.diffuse.contents = UIColor.systemYellow
        cylinder.firstMaterial?.emission.contents = UIColor.systemYellow.withAlphaComponent(0.3)
        let shaftNode = SCNNode(geometry: cylinder)
        shaftNode.position = SCNVector3(0, Float(length / 2), 0)
        parentNode.addChildNode(shaftNode)

        // Arrow tip
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.08, height: 0.15)
        cone.firstMaterial?.diffuse.contents = UIColor.systemYellow
        let tipNode = SCNNode(geometry: cone)
        tipNode.position = SCNVector3(0, Float(length), 0)
        parentNode.addChildNode(tipNode)

        // Position the whole vector
        updateStateVector(parentNode, x: x, y: y, z: z)

        return parentNode
    }

    private func updateStateVector(_ node: SCNNode, x: Double, y: Double, z: Double) {
        // Calculate rotation to point in the direction (x, y, z)
        let targetPosition = SCNVector3(Float(x), Float(z), Float(y))  // Note: SCNKit uses different coordinate system

        // Calculate rotation angles
        let theta = acos(Float(z))  // Polar angle
        let phi = atan2(Float(y), Float(x))  // Azimuthal angle

        node.eulerAngles = SCNVector3(-theta, 0, 0)
        node.eulerAngles.y = phi
    }
}

// MARK: - Supporting Views

struct CoordinateDisplay: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(spacing: QuantumSpacing.xxs) {
            Text(label)
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.6))

            Text(String(format: "%.3f", value))
                .font(QuantumTypography.monospaceLarge)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatePropertyItem: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: QuantumSpacing.xxs) {
            Text(title)
                .font(QuantumTypography.caption)
                .foregroundColor(.white.opacity(0.6))

            Text(value)
                .font(QuantumTypography.monospace)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PresetButton: View {
    let preset: QubitPreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(preset.rawValue)
                .font(QuantumTypography.monospace)
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .frame(maxWidth: .infinity)
                .padding(.vertical, QuantumSpacing.sm)
                .background(isSelected ? QuantumColors.secondary : Color.white.opacity(0.1))
                .cornerRadius(QuantumSpacing.cornerRadiusSmall)
        }
    }
}

// MARK: - Preview

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .preferredColorScheme(.dark)
            .background(QuantumColors.backgroundGradient)
    }
}
