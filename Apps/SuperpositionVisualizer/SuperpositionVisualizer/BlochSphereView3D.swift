//
//  BlochSphereView3D.swift
//  SuperpositionVisualizer
//
//  Created by Eunmin Park on 2025-01-18.
//  3D transparent Bloch sphere with ENHANCED state vector visualization
//

import SwiftUI
import SceneKit

#if canImport(SwiftQuantum)
import SwiftQuantum
#else
/// Mock Qubit for SwiftUI Preview support
extension Qubit {
    static var superposition: Qubit {
        return Qubit(alpha: 0.7071, beta: 0.7071)
    }
    
    func blochCoordinates() -> (Double, Double, Double) {
        (0.7, 0.0, 0.7)
    }
}
#endif

/// 3D Bloch Sphere Visualization (ENHANCED VERSION)
///
/// A fully interactive 3D representation of quantum states using SceneKit.
/// Features:
/// - Transparent 3D sphere (70% transparent, white color)
/// - ENHANCED state vector visualization (BOLD and CLEAR!)
/// - Interactive touch-based rotation
/// - Smooth state vector animation
/// - Wireframe grid (latitude/longitude lines)
/// - Colored axes (Red/Green/Blue for X/Y/Z)
/// - Origin marker for reference
/// - Multi-layer lighting system
///
/// Usage:
/// ```swift
/// BlochSphereView3D(qubit: currentQubit)
/// ```
struct BlochSphereView3D: View {
    /// The quantum state to visualize
    let qubit: Qubit
    
    /// Reference to the SceneKit view for camera control
    @State private var sceneView: SCNView?
    
    var body: some View {
        ZStack {
            /// 3D SceneKit visualization layer - ENHANCED!
            SceneKitViewRepresentable(
                qubit: qubit,
                sceneView: $sceneView
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - SceneKit View Representable

/// SwiftUI wrapper for SceneKit 3D rendering
/// Bridges the gap between SwiftUI's declarative UI and SceneKit's imperative 3D API
struct SceneKitViewRepresentable: UIViewRepresentable {
    /// The quantum state to visualize
    let qubit: Qubit
    
    /// Binding to the underlying SceneKit view for external camera control
    @Binding var sceneView: SCNView?
    
    func makeUIView(context: Context) -> SCNView {
        /// Initialize 3D scene
        let scene = SCNScene()
        let sceneView = SCNView()
        sceneView.scene = scene
        
        /// Set black background for quantum aesthetic
        sceneView.backgroundColor = .black
        
        /// Enable user interaction with camera
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
        /// Enable smooth inertia-based scrolling for better user experience
        sceneView.defaultCameraController.inertiaEnabled = true
        
        // MARK: Setup Camera
        
        /// Create and position camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        /// Position camera at (0, 0, 3.5) to view the sphere from front
        cameraNode.position = SCNVector3(0, 0, 3.5)
        scene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        
        // MARK: Setup Lighting
        
        /// Add multi-layer lighting system for professional appearance
        addLighting(to: scene)
        
        // MARK: Add Bloch Sphere Components
        
        /// Add the main Bloch sphere with all visual elements
        /// Includes: transparent sphere, wireframe grid, axes, equatorial plane
        addBlochSphere(to: scene)
        
        // MARK: Add Origin Marker (NEW!)
        
        /// 원점을 명확하게 표시
        addOriginMarker(to: scene)
        
        // MARK: Add State Vector Visualization (ENHANCED!)
        
        /// Create animated arrow pointing from origin to current quantum state
        /// NOW WITH MUCH BETTER VISIBILITY!
        let stateVectorNode = createEnhancedStateVector(qubit: qubit)
        scene.rootNode.addChildNode(stateVectorNode)
        
        /// Save reference to SceneKit view for camera control
        self.sceneView = sceneView
        
        /// IMPORTANT: Setup a timer to continuously update state vector
        /// This ensures the state vector is always in sync with the qubit state
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateStateVector(sceneView: sceneView, qubit: qubit)
        }
        
        /// Store timer reference in a way that keeps it alive
        sceneView.accessibilityHint = UUID().uuidString
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        /// Update state vector position based on qubit state changes
        /// This is called whenever the parent SwiftUI view updates
        updateStateVector(sceneView: uiView, qubit: qubit)
    }
    
    // MARK: - Update Methods
    
    /// Update state vector position (FASTER ANIMATION!)
    private func updateStateVector(sceneView: SCNView, qubit: Qubit) {
        guard let scene = sceneView.scene else { return }
        
        /// Get current Bloch coordinates (x, y, z all in range [-1, 1])
        let (x, y, z) = qubit.blochCoordinates()
        
        /// Update the 3D state vector position
        if let stateVector = scene.rootNode.childNode(withName: "stateVector", recursively: true) {
            /// Convert Bloch coordinates to 3D position
            /// Note: Y and Z are swapped for proper 3D orientation
            let targetPosition = SCNVector3(x: Float(x), y: Float(z), z: Float(y))
            
            /// Smoothly animate the state vector to the new position (FASTER!)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.15  // 더 빠른 애니메이션 (0.3 → 0.15)
            stateVector.position = targetPosition
            SCNTransaction.commit()
        }
    }
    
    // MARK: - Scene Setup Methods
    
    /// Configure multi-layer lighting system for realistic appearance
    /// Combines ambient, directional, and accent lights
    private func addLighting(to scene: SCNScene) {
        /// Layer 1: Ambient Light
        /// Provides overall illumination without creating strong shadows
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.5, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        /// Layer 2: Main Directional Light
        /// Creates primary illumination and shadows
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.color = UIColor(white: 1.0, alpha: 1.0)
        /// Position light from upper right front
        directionalLight.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(directionalLight)
        
        /// Layer 3: Accent Light
        /// Adds subtle blue color for quantum aesthetic
        let accentLight = SCNNode()
        accentLight.light = SCNLight()
        accentLight.light?.type = .directional
        accentLight.light?.color = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 0.6)
        /// Position light from lower left back
        accentLight.position = SCNVector3(-5, -3, 3)
        scene.rootNode.addChildNode(accentLight)
    }
    
    /// Add all Bloch sphere visual components to the scene
    private func addBlochSphere(to scene: SCNScene) {
        /// Create the main white semi-transparent sphere
        let sphereGeometry = SCNSphere(radius: 1.0)
        
        /// Configure sphere material for visibility
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.35)
        sphereGeometry.firstMaterial?.specular.contents = UIColor.white.withAlphaComponent(0.3)
        /// Set transparency to 70% (0.70 = 70% transparent, 30% opaque)
        sphereGeometry.firstMaterial?.transparency = 0.70
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.name = "blochSphere"
        scene.rootNode.addChildNode(sphereNode)
        
        /// Add wireframe grid to show surface clearly
        addWireframeSphere(to: scene)
        
        /// Add coordinate axes (X, Y, Z)
        addAxes(to: scene)
        
        /// Add equatorial plane reference
        addEquatorialPlane(to: scene)
    }
    
    /// Add origin marker (원점 표시) - NEW!
    private func addOriginMarker(to scene: SCNScene) {
        /// 작은 하얀색 구로 원점 표시
        let originSphere = SCNSphere(radius: 0.08)
        originSphere.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        originSphere.firstMaterial?.emission.contents = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        
        let originNode = SCNNode(geometry: originSphere)
        originNode.position = SCNVector3(0, 0, 0)
        originNode.name = "originMarker"
        scene.rootNode.addChildNode(originNode)
    }
    
    /// Create wireframe sphere using torus shapes
    /// Represents latitude and longitude lines
    private func addWireframeSphere(to scene: SCNScene) {
        let radius = 1.0
        
        // MARK: Latitude Circles
        
        /// Create 9 horizontal rings (latitude circles)
        /// Ranging from north pole to south pole
        for i in 0..<9 {
            /// Calculate angle for this latitude ring
            let angle = CGFloat(i + 1) * .pi / 10.0
            
            /// Calculate radius of the circle at this latitude
            let circleRadius = sin(angle)
            
            /// Calculate Y position (height) at this latitude
            let yPos = cos(angle)
            
            /// Create torus for this latitude circle
            let torus = SCNTorus(ringRadius: CGFloat(circleRadius), pipeRadius: 0.008)
            torus.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.5)
            
            let torusNode = SCNNode(geometry: torus)
            torusNode.position = SCNVector3(0, Float(yPos), 0)
            /// Rotate torus to be horizontal
            torusNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
            scene.rootNode.addChildNode(torusNode)
        }
        
        // MARK: Longitude Circles
        
        /// Create 8 vertical meridian circles (longitude lines)
        for i in 0..<8 {
            /// Calculate angle for this meridian
            let angle = CGFloat(i) * .pi / 4.0
            
            /// Create full-radius torus for meridian
            let torus = SCNTorus(ringRadius: 1.0, pipeRadius: 0.008)
            torus.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.4)
            
            let torusNode = SCNNode(geometry: torus)
            /// Rotate torus to be vertical
            torusNode.eulerAngles = SCNVector3(0, Float(angle), 0)
            scene.rootNode.addChildNode(torusNode)
        }
    }
    
    /// Add X, Y, Z coordinate axes with color coding
    private func addAxes(to scene: SCNScene) {
        let axisLength = 1.5
        
        /// X-axis: Red (left-right)
        addAxis(to: scene, from: SCNVector3(-axisLength, 0, 0),
                to: SCNVector3(axisLength, 0, 0),
                color: UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 0.8))
        
        /// Y-axis: Green (up-down)
        addAxis(to: scene, from: SCNVector3(0, -axisLength, 0),
                to: SCNVector3(0, axisLength, 0),
                color: UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 0.8))
        
        /// Z-axis: Blue (front-back)
        addAxis(to: scene, from: SCNVector3(0, 0, -axisLength),
                to: SCNVector3(0, 0, axisLength),
                color: UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.8))
    }
    
    /// Create a single coordinate axis line with endpoint sphere
    private func addAxis(to scene: SCNScene, from: SCNVector3, to: SCNVector3,
                        color: UIColor) {
        /// Calculate axis length using 3D distance formula
        let length = simd_distance(simd_float3(from), simd_float3(to))
        
        /// Create cylinder for the axis line
        let cylinder = SCNCylinder(radius: 0.015, height: CGFloat(length))
        cylinder.firstMaterial?.diffuse.contents = color
        
        let axisNode = SCNNode(geometry: cylinder)
        /// Position cylinder at midpoint between from and to
        axisNode.position = SCNVector3(
            (from.x + to.x) / 2,
            (from.y + to.y) / 2,
            (from.z + to.z) / 2
        )
        
        /// Orient cylinder to point along the axis direction
        let direction = SCNVector3(to.x - from.x, to.y - from.y, to.z - from.z)
        axisNode.look(at: to, up: SCNVector3(0, 1, 0), localFront: direction)
        
        scene.rootNode.addChildNode(axisNode)
        
        /// Add colored sphere at the positive end of the axis
        let labelSphere = SCNSphere(radius: 0.08)
        labelSphere.firstMaterial?.diffuse.contents = color
        let labelNode = SCNNode(geometry: labelSphere)
        labelNode.position = to
        scene.rootNode.addChildNode(labelNode)
    }
    
    /// Add equatorial plane reference visualization
    /// Yellow torus at z=0 to help with orientation
    private func addEquatorialPlane(to scene: SCNScene) {
        let equator = SCNTorus(ringRadius: 1.0, pipeRadius: 0.006)
        equator.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
        
        let equatorNode = SCNNode(geometry: equator)
        /// Rotate torus to be horizontal at z=0
        equatorNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
        scene.rootNode.addChildNode(equatorNode)
    }
    
    /// Create ENHANCED state vector visualization
    /// Much more visible and intuitive!
    private func createEnhancedStateVector(qubit: Qubit) -> SCNNode {
        let (x, y, z) = qubit.blochCoordinates()
        
        // MARK: Arrow Line (MUCH THICKER!)
        
        /// Calculate length of arrow from origin to state position
        let lineLength = sqrt(x*x + y*y + z*z)
        
        /// Create cylinder for arrow line (THICKER: 0.012 → 0.03)
        let cylinder = SCNCylinder(radius: 0.03, height: CGFloat(lineLength))
        
        /// Configure arrow line appearance (BRIGHTER and more GLOWING!)
        let gradient = UIColor(red: 1.0, green: 0.95, blue: 0.0, alpha: 1.0)
        cylinder.firstMaterial?.diffuse.contents = gradient
        cylinder.firstMaterial?.emission.contents = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.8)  // 더 밝은 발광
        
        let arrowLineNode = SCNNode(geometry: cylinder)
        /// Position arrow at midpoint
        arrowLineNode.position = SCNVector3(x: Float(x/2), y: Float(z/2), z: Float(y/2))
        /// Orient arrow to point toward the state
        arrowLineNode.look(at: SCNVector3(x: Float(x), y: Float(z), z: Float(y)),
                          up: SCNVector3(0, 1, 0),
                          localFront: SCNVector3(0, 1, 0))
        
        // MARK: State Vector Container
        
        /// Create container node that will hold arrowhead and marker
        let stateVectorNode = SCNNode()
        stateVectorNode.name = "stateVector"
        /// Position at the quantum state location
        stateVectorNode.position = SCNVector3(x: Float(x), y: Float(z), z: Float(y))
        
        // MARK: Arrowhead (MUCH BIGGER!)
        
        /// Create cone for arrowhead (BIGGER: 0.08 → 0.15)
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.15, height: 0.3)
        cone.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 0.95, blue: 0.0, alpha: 1.0)
        cone.firstMaterial?.emission.contents = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.9)  // 매우 밝은 발광
        
        let arrowheadNode = SCNNode(geometry: cone)
        /// Rotate cone to point upward (default is pointing up in Z)
        arrowheadNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        /// Position arrowhead slightly above the state marker
        arrowheadNode.position = SCNVector3(0, 0.15, 0)
        stateVectorNode.addChildNode(arrowheadNode)
        
        // MARK: State Marker (MUCH BIGGER!)
        
        /// Create glowing sphere at the state position (BIGGER: 0.12 → 0.25)
        let markerSphere = SCNSphere(radius: 0.25)
        markerSphere.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 0.95, blue: 0.0, alpha: 1.0)
        markerSphere.firstMaterial?.emission.contents = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.9)  // 매우 밝은 발광
        
        let markerNode = SCNNode(geometry: markerSphere)
        markerNode.position = SCNVector3(0, 0, 0)
        stateVectorNode.addChildNode(markerNode)
        
        // MARK: Assembly
        
        /// Combine arrow line and state vector into a container
        let parentContainer = SCNNode()
        parentContainer.addChildNode(arrowLineNode)
        parentContainer.addChildNode(stateVectorNode)
        
        return parentContainer
    }
}

// MARK: - Preview

struct BlochSphereView3D_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            BlochSphereView3D(qubit: .superposition)
        }
    }
}
