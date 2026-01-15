//
//  BlochSphereView3D+Advanced.swift
//  SuperpositionVisualizer
//
//  Advanced customization options and rendering enhancements
//

import SceneKit
import SwiftUI

#if canImport(SwiftQuantum)
import SwiftQuantum
#endif

// MARK: - Bloch Sphere Rendering Styles

/// Predefined rendering styles for different use cases
enum BlochSphereStyle {
    /// Minimalist style: Transparent sphere with axes only
    /// Best for: Performance-critical applications
    /// Features: No grid, no equator, high transparency
    case minimal
    
    /// Standard style: Balanced visualization with grid
    /// Best for: General educational use
    /// Features: Wireframe grid, axes, equator, standard transparency
    case standard
    
    /// Detailed style: Rich visualization with dense grid
    /// Best for: In-depth educational content
    /// Features: Dense wireframe, all elements visible
    case detailed
    
    /// Cosmic style: Vibrant neon colors
    /// Best for: Presentations and visual impact
    /// Features: Bright colors, enhanced glowing effects
    case cosmic
    
    /// Educational style: Clean, clear visualization
    /// Best for: Teaching quantum mechanics
    /// Features: Clear grid, reduced visual clutter
    case educational
}

// MARK: - Bloch Sphere Configuration

/// Comprehensive configuration object for 3D Bloch sphere appearance and behavior
/// Allows fine-tuned customization of every visual aspect
struct BlochSphereConfig {
    // MARK: Sphere Properties
    
    /// Sphere transparency level (0.0 = fully transparent, 1.0 = fully opaque)
    /// Recommended: 0.92 for good balance between visibility and transparency
    var sphereTransparency: Float = 0.92
    
    // MARK: Wireframe Grid Properties
    
    /// Enable/disable wireframe grid display
    var showGrid: Bool = true
    
    /// Color of grid lines (latitude and longitude)
    var gridColor: UIColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 0.3)
    
    /// Grid density: number of lines in each direction (1-20)
    /// Higher = denser grid = more visual clutter but better reference
    var gridDensity: Int = 8
    
    // MARK: Axis Properties
    
    /// Enable/disable coordinate axes display
    var showAxes: Bool = true
    
    /// Length of coordinate axes extending from origin
    var axisLength: Float = 1.5
    
    // MARK: Equatorial Plane Properties
    
    /// Enable/disable equatorial plane display
    var showEquator: Bool = true
    
    /// Color of equatorial plane
    var equatorColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.15)
    
    // MARK: State Vector Properties
    
    /// Color of the state vector arrow and marker
    var arrowColor: UIColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.8)
    
    /// Glow/emission color for the state vector
    var arrowGlowColor: UIColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 0.4)
    
    /// Size of the state marker sphere
    var markerSize: Float = 0.12
    
    // MARK: Lighting Properties
    
    /// Ambient light brightness (0.0 = dark, 1.0 = fully bright)
    var ambientBrightness: Float = 0.4
    
    /// Enable/disable accent light for color emphasis
    var showAccentLight: Bool = true
    
    // MARK: Animation Properties
    
    /// Duration of state vector animation in seconds
    var animationDuration: TimeInterval = 0.5
    
    /// Enable automatic rotation of the sphere
    var enableAutoRotation: Bool = false
    
    /// Speed of automatic rotation (1.0 = normal, 2.0 = double speed)
    var autoRotationSpeed: Float = 1.0
    
    // MARK: Static Defaults
    
    /// Default configuration with standard settings
    static let `default` = BlochSphereConfig()
    
    /// Create configuration from predefined style
    static func style(_ style: BlochSphereStyle) -> BlochSphereConfig {
        switch style {
        case .minimal:
            return BlochSphereConfig(
                sphereTransparency: 0.95, showGrid: false,
                showAxes: true,
                showEquator: false
            )
            
        case .standard:
            return BlochSphereConfig()
            
        case .detailed:
            return BlochSphereConfig(
                sphereTransparency: 0.9, gridDensity: 12
            )
            
        case .cosmic:
            return BlochSphereConfig(
                gridColor: UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.4),
                equatorColor: UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.2), arrowColor: UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.9),
                arrowGlowColor: UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 0.6),
                ambientBrightness: 0.3
            )
            
        case .educational:
            return BlochSphereConfig(
                sphereTransparency: 0.85, gridColor: UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.4), gridDensity: 6
            )
        }
    }
}

// MARK: - Bloch Sphere Scene Builder

/// Advanced scene building utility for customized 3D scenes
class BlochSphereSceneBuilder {
    /// Build a complete Bloch sphere scene with custom configuration
    static func buildScene(
        with qubit: Qubit,
        config: BlochSphereConfig = .default
    ) -> SCNScene {
        let scene = SCNScene()
        
        /// Setup camera
        setupCamera(in: scene)
        
        /// Setup lighting system
        setupLighting(in: scene, config: config)
        
        /// Add Bloch sphere components
        addBlochSphere(to: scene, config: config)
        
        /// Add coordinate axes
        if config.showAxes {
            addAxes(to: scene, config: config)
        }
        
        /// Add state vector visualization
        addStateVector(for: qubit, to: scene, config: config)
        
        return scene
    }
    
    /// Setup camera node and position
    private static func setupCamera(in scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 3.5)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    /// Setup multi-layer lighting system
    private static func setupLighting(in scene: SCNScene, config: BlochSphereConfig) {
        /// Ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: CGFloat(config.ambientBrightness), alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        /// Main directional light
        let mainLight = SCNNode()
        mainLight.light = SCNLight()
        mainLight.light?.type = .directional
        mainLight.light?.color = UIColor(white: 0.8, alpha: 1.0)
        mainLight.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(mainLight)
        
        /// Accent light for color enhancement
        if config.showAccentLight {
            let accentLight = SCNNode()
            accentLight.light = SCNLight()
            accentLight.light?.type = .directional
            accentLight.light?.color = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.5)
            accentLight.position = SCNVector3(-5, -3, 3)
            scene.rootNode.addChildNode(accentLight)
        }
    }
    
    /// Add Bloch sphere with all components
    private static func addBlochSphere(to scene: SCNScene, config: BlochSphereConfig) {
        /// Transparent sphere geometry
        let sphereGeometry = SCNSphere(radius: 1.0)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.05)
        sphereGeometry.firstMaterial?.specular.contents = UIColor.white.withAlphaComponent(0.1)
        sphereGeometry.firstMaterial?.transparency = CGFloat(config.sphereTransparency)
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.name = "blochSphere"
        scene.rootNode.addChildNode(sphereNode)
        
        /// Add wireframe grid if enabled
        if config.showGrid {
            addWireframeGrid(to: scene, density: config.gridDensity, color: config.gridColor)
        }
        
        /// Add equatorial plane if enabled
        if config.showEquator {
            addEquatorialPlane(to: scene, color: config.equatorColor)
        }
    }
    
    /// Create wireframe grid with configurable density
    private static func addWireframeGrid(to scene: SCNScene, density: Int, color: UIColor) {
        let densityClamped = min(max(density, 1), 20)
        
        /// Latitude circles
        for i in 0..<(densityClamped - 1) {
            let angle = CGFloat(i + 1) * .pi / CGFloat(densityClamped)
            let circleRadius = sin(angle)
            let yPos = cos(angle)
            
            let torus = SCNTorus(ringRadius: CGFloat(circleRadius), pipeRadius: 0.008)
            torus.firstMaterial?.diffuse.contents = color
            
            let torusNode = SCNNode(geometry: torus)
            torusNode.position = SCNVector3(0, Float(yPos), 0)
            torusNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
            scene.rootNode.addChildNode(torusNode)
        }
        
        /// Longitude circles
        for i in 0..<densityClamped {
            let angle = CGFloat(i) * .pi / CGFloat(densityClamped)
            
            let torus = SCNTorus(ringRadius: 1.0, pipeRadius: 0.008)
            torus.firstMaterial?.diffuse.contents = color
            
            let torusNode = SCNNode(geometry: torus)
            torusNode.eulerAngles = SCNVector3(0, Float(angle), 0)
            scene.rootNode.addChildNode(torusNode)
        }
    }
    
    /// Add equatorial plane reference
    private static func addEquatorialPlane(to scene: SCNScene, color: UIColor) {
        let equator = SCNTorus(ringRadius: 1.0, pipeRadius: 0.006)
        equator.firstMaterial?.diffuse.contents = color
        
        let equatorNode = SCNNode(geometry: equator)
        equatorNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
        scene.rootNode.addChildNode(equatorNode)
    }
    
    /// Add coordinate axes
    private static func addAxes(to scene: SCNScene, config: BlochSphereConfig) {
        let length = config.axisLength
        
        addAxis(to: scene, from: SCNVector3(-length, 0, 0), 
                to: SCNVector3(length, 0, 0), 
                color: UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.6),
                label: "X")
        
        addAxis(to: scene, from: SCNVector3(0, -length, 0), 
                to: SCNVector3(0, length, 0), 
                color: UIColor(red: 0.3, green: 1.0, blue: 0.3, alpha: 0.6),
                label: "Y")
        
        addAxis(to: scene, from: SCNVector3(0, 0, -length), 
                to: SCNVector3(0, 0, length), 
                color: UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 0.6),
                label: "Z")
    }
    
    /// Create a single axis line
    private static func addAxis(to scene: SCNScene, from: SCNVector3, to: SCNVector3, 
                               color: UIColor, label: String) {
        let length = simd_distance(simd_float3(from), simd_float3(to))
        let cylinder = SCNCylinder(radius: 0.015, height: CGFloat(length))
        cylinder.firstMaterial?.diffuse.contents = color
        
        let axisNode = SCNNode(geometry: cylinder)
        axisNode.position = SCNVector3(
            (from.x + to.x) / 2,
            (from.y + to.y) / 2,
            (from.z + to.z) / 2
        )
        
        let direction = SCNVector3(to.x - from.x, to.y - from.y, to.z - from.z)
        axisNode.look(at: to, up: SCNVector3(0, 1, 0), localFront: direction)
        
        scene.rootNode.addChildNode(axisNode)
        
        /// Endpoint sphere
        let labelSphere = SCNSphere(radius: 0.08)
        labelSphere.firstMaterial?.diffuse.contents = color
        let labelNode = SCNNode(geometry: labelSphere)
        labelNode.position = to
        scene.rootNode.addChildNode(labelNode)
    }
    
    /// Add state vector visualization
    private static func addStateVector(for qubit: Qubit, to scene: SCNScene, 
                                      config: BlochSphereConfig) {
        let (x, y, z) = qubit.blochCoordinates()
        
        /// Arrow line
        let lineLength = sqrt(x*x + y*y + z*z)
        let cylinder = SCNCylinder(radius: 0.012, height: CGFloat(lineLength))
        cylinder.firstMaterial?.diffuse.contents = config.arrowColor
        cylinder.firstMaterial?.emission.contents = config.arrowGlowColor
        
        let arrowLineNode = SCNNode(geometry: cylinder)
        arrowLineNode.position = SCNVector3(x: Float(x/2), y: Float(z/2), z: Float(y/2))
        arrowLineNode.look(at: SCNVector3(x: Float(x), y: Float(z), z: Float(y)), 
                          up: SCNVector3(0, 1, 0), 
                          localFront: SCNVector3(0, 1, 0))
        
        /// State vector container
        let stateVectorNode = SCNNode()
        stateVectorNode.name = "stateVector"
        stateVectorNode.position = SCNVector3(x: Float(x), y: Float(z), z: Float(y))
        
        /// Arrowhead
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.08, height: 0.2)
        cone.firstMaterial?.diffuse.contents = config.arrowColor
        cone.firstMaterial?.emission.contents = config.arrowGlowColor
        
        let arrowheadNode = SCNNode(geometry: cone)
        arrowheadNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        arrowheadNode.position = SCNVector3(0, 0.1, 0)
        stateVectorNode.addChildNode(arrowheadNode)
        
        /// Marker sphere
        let markerSphere = SCNSphere(radius: CGFloat(config.markerSize))
        markerSphere.firstMaterial?.diffuse.contents = config.arrowColor
        markerSphere.firstMaterial?.emission.contents = config.arrowGlowColor
        
        let markerNode = SCNNode(geometry: markerSphere)
        markerNode.position = SCNVector3(0, 0, 0)
        stateVectorNode.addChildNode(markerNode)
        
        /// Assembly
        let parentContainer = SCNNode()
        parentContainer.addChildNode(arrowLineNode)
        parentContainer.addChildNode(stateVectorNode)
        
        scene.rootNode.addChildNode(parentContainer)
    }
}

// MARK: - Color Theme Presets

extension BlochSphereConfig {
    /// Dark electric theme: Purple and pink neon colors
    /// Best for: Modern, high-contrast presentations
    static let darkElectric = BlochSphereConfig(
        gridColor: UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.3),
        arrowColor: UIColor(red: 0.7, green: 0.0, blue: 1.0, alpha: 0.9),
        arrowGlowColor: UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.5),
        ambientBrightness: 0.2
    )
    
    /// Science theme: Cyan and green colors
    /// Best for: Scientific/research presentations
    static let science = BlochSphereConfig(
        gridColor: UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.4),
        equatorColor: UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.2), arrowColor: UIColor(red: 0.0, green: 1.0, blue: 0.8, alpha: 0.9),
        arrowGlowColor: UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.5)
    )
    
    /// Warm sunset theme: Orange and red colors
    /// Best for: Warm, inviting presentations
    static let warmSunset = BlochSphereConfig(
        gridColor: UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.3),
        equatorColor: UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 0.2), arrowColor: UIColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 0.9),
        arrowGlowColor: UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5)
    )
    
    /// Clean theme: Minimal, performance-optimized
    /// Best for: Fast performance on older devices
    static let clean = BlochSphereConfig(
        sphereTransparency: 0.95, showGrid: false,
        showAxes: true,
        showEquator: false,
        showAccentLight: false
    )
}
