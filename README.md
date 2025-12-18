# SwiftQuantum 🌀⚛️

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2017%2B%20%7C%20macOS%2014%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**A pure Swift quantum computing library for iOS and macOS** - bringing the power of quantum mechanics to Apple platforms!

> 🎓 Perfect for learning quantum computing concepts
> 
> 🚀 Production-ready quantum simulations
> 
> 📱 Beautiful iOS visualizer app with 3D Bloch sphere

---

## ✨ Features

### 🎯 Core Quantum Operations
- **Quantum States**: Create and manipulate single-qubit quantum states
- **Complex Numbers**: Full complex number arithmetic with phase calculations
- **Quantum Gates**: Complete set of single-qubit gates (Pauli-X, Y, Z, Hadamard, Phase, T)
- **Measurements**: Statistical and probabilistic measurement operations
- **Quantum Circuits**: Build and execute quantum circuits with multiple gates

### 📊 Advanced Capabilities
- **Bloch Sphere**: Geometric representation of quantum states
- **State Visualization**: ASCII art and text-based quantum state displays
- **Entanglement Ready**: Architecture prepared for multi-qubit systems
- **Performance**: Optimized with ~1µs gate operations

### 📱 iOS Superposition Visualizer App
- **Interactive 3D Bloch Sphere**: Transparent 3D visualization with real-time updates ✨ NEW!
- **Touch-Based Rotation**: Intuitive finger gestures to explore quantum states
- **Live Measurements**: Perform quantum measurements with animated histograms
- **Preset States**: Quick access to standard quantum states (|0⟩, |1⟩, |+⟩, |−⟩, |±i⟩)
- **Educational**: Built-in tutorials and explanations
- **Beautiful UI**: Dark mode quantum-themed interface

---

## 📸 Screenshots

### Superposition Visualizer App

<table>
  <tr>
    <td><img src="docs/screenshots/bloch-sphere-3d.png" alt="3D Bloch Sphere" width="250"/></td>
    <td><img src="docs/screenshots/measurements.png" alt="Measurements" width="250"/></td>
    <td><img src="docs/screenshots/presets.png" alt="Presets" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><b>3D Bloch Sphere Visualization</b></td>
    <td align="center"><b>Quantum Measurements</b></td>
    <td align="center"><b>Preset Quantum States</b></td>
  </tr>
</table>

---

## 🌐 3D Bloch Sphere Visualization (NEW!)

SwiftQuantum now features an **interactive 3D Bloch sphere** using SceneKit!

### What's New?

#### Before (2D)
```
Old: 2D flat circle
- Auto rotation only
- No user interaction
- Static coordinates
```

#### Now (3D) ✨
```
New: 3D transparent sphere
- Free touch-based rotation 🎮
- Real-time coordinate animation 🎯
- Wireframe grid, colored axes, equatorial plane
- Multiple color themes 🎨
```

### Quick Start (60 Seconds)

#### Step 1: Add File
Copy `BlochSphereView3D.swift` to your project:
```
Apps/SuperpositionVisualizer/SuperpositionVisualizer/
```

#### Step 2: One-Line Change
In **SuperpositionVisualizerApp.swift**:
```swift
// Change this:
BlochSphereView3D(qubit: currentQubit)  // ← Instead of BlochSphereView
```

#### Step 3: Build & Run
```bash
⌘ + B  # Build
⌘ + R  # Run
```

**Done!** 🎉 You now have a 3D quantum visualizer!

---

## 📚 3D Bloch Sphere Documentation

### Complete Integration Guide
Detailed step-by-step instructions: **[COMPLETE_INTEGRATION_GUIDE_EN.md](docs/COMPLETE_INTEGRATION_GUIDE_EN.md)**

### Usage Examples & Patterns
Practical code examples: **[USAGE_EXAMPLES_EN.md](docs/USAGE_EXAMPLES_EN.md)**

### Quick Reference
Fast lookup guide: **[QUICK_REFERENCE_EN.md](docs/QUICK_REFERENCE_EN.md)**

### Suggested Reading Order
1. **Start with:** QUICK_REFERENCE_EN.md (5 min) - Overview
2. **Then:** COMPLETE_INTEGRATION_GUIDE_EN.md (15 min) - Installation
3. **Explore:** USAGE_EXAMPLES_EN.md (20 min) - Real-world examples

---

## 🎨 3D Bloch Sphere Features

### Interactive Controls
- **Touch Rotation**: Rotate the sphere with your finger
- **Pause/Play**: Control animation playback
- **Reset Button**: Return to default camera orientation
- **Real-Time Coordinates**: Display X, Y, Z values in real-time

### Visual Components
- **Transparent 3D Sphere**: 92% transparency for clear interior view
- **Wireframe Grid**: Latitude/longitude reference lines
- **Colored Axes**: Red (X), Green (Y), Blue (Z)
- **Equatorial Plane**: Yellow reference at z=0 plane
- **State Vector**: Animated golden arrow pointing to quantum state

### Rendering Styles
```swift
// 5 built-in styles:
.minimal      // Lightweight, performance-optimized
.standard     // Balanced (recommended)
.detailed     // Rich visualization with dense grid
.cosmic       // Vibrant neon colors for presentations
.educational  // Clean, clear for teaching
```

### Color Themes
```swift
// 4 pre-configured themes:
.darkElectric    // Purple neon 💜
.science         // Cyan & green 🔬
.warmSunset      // Orange & red 🌅
.clean           // Minimal white ⚪
```

### Customization Example
```swift
var config = BlochSphereConfig.default
config.sphereTransparency = 0.88        // Adjust transparency
config.gridDensity = 12                 // More reference lines
config.arrowColor = UIColor(red: 1, green: 0, blue: 1, alpha: 0.9)  // Magenta arrow
config.animationDuration = 0.5          // Animation speed

let scene = BlochSphereSceneBuilder.buildScene(
    with: qubit,
    config: config
)
```

---

## 🚀 Quick Start

### Installation

#### Swift Package Manager (Recommended)

Add SwiftQuantum to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies...
2. Enter: `https://github.com/Minapak/SwiftQuantum.git`
3. Click "Add Package"

### Basic Usage

```swift
import SwiftQuantum

// Create a qubit in superposition
let qubit = Qubit.superposition
print("Probability of |0⟩: \(qubit.probability0)")  // 0.5

// Apply quantum gates
let circuit = QuantumCircuit(qubit: qubit)
circuit.addGate(.hadamard)
circuit.addGate(.pauliX)

// Execute and measure
let result = circuit.execute()
let measurement = result.measure()
print("Measured: |\(measurement)⟩")

// Visualize on 3D Bloch sphere
BlochSphereView3D(qubit: qubit)
```

---

## 📚 Examples & Tutorials

### 1️⃣ Creating Quantum States

```swift
// Pure states
let zero = Qubit.zero              // |0⟩
let one = Qubit.one                // |1⟩

// Superposition states
let plus = Qubit.superposition     // |+⟩ = (|0⟩ + |1⟩)/√2
let minus = Qubit.minusSuperposition // |−⟩ = (|0⟩ − |1⟩)/√2

// Custom superposition
let custom = Qubit(alpha: 0.6, beta: 0.8)  // 36% |0⟩, 64% |1⟩

// With phase
let iState = Qubit.iState          // (|0⟩ + i|1⟩)/√2
```

### 2️⃣ Quantum Gates

```swift
let qubit = Qubit.zero

// Pauli gates
qubit.applyGate(.pauliX)    // Bit flip: |0⟩ → |1⟩
qubit.applyGate(.pauliY)    // Y rotation
qubit.applyGate(.pauliZ)    // Phase flip

// Hadamard gate (creates superposition)
let superposed = Qubit.zero.applying(.hadamard)

// Phase gates
qubit.applyGate(.phase)     // S gate (π/2 phase)
qubit.applyGate(.tGate)     // T gate (π/4 phase)

// Custom rotation
qubit.applyGate(.rotationZ(angle: .pi / 4))
```

### 3️⃣ Quantum Circuits

```swift
// Build a quantum circuit
let circuit = QuantumCircuit(qubit: .zero)
circuit.addGate(.hadamard)
circuit.addGate(.phase)
circuit.addGate(.hadamard)

// Execute
let finalState = circuit.execute()

// Get circuit description
print(circuit.description)
// Output: H → S → H
```

### 4️⃣ Measurements & Statistics

```swift
let qubit = Qubit.superposition

// Single measurement (collapses state)
let result = qubit.measure()  // 0 or 1

// Multiple measurements (statistical)
let results = qubit.measureMultiple(count: 1000)
// results = [0: 503, 1: 497]

// With visualization
print(qubit.measureAndVisualize(shots: 1000))
```

### 5️⃣ Bloch Sphere

```swift
let qubit = Qubit.superposition

// Get Bloch coordinates
let (x, y, z) = qubit.blochCoordinates()
// x=1.0, y=0.0, z=0.0 for |+⟩

// Create from angles
let custom = Qubit.fromBlochAngles(theta: .pi/4, phi: .pi/2)

// Visualize in 3D
BlochSphereView3D(qubit: qubit)
    .frame(height: 400)
```

### 6️⃣ State Analysis

```swift
let qubit = Qubit.superposition

// Entropy (measure of uncertainty)
let entropy = qubit.entropy()  // 1.0 for max uncertainty

// Purity (1.0 for pure states)
let purity = qubit.purity()    // 1.0

// State fidelity (overlap with another state)
let other = Qubit.zero
let fidelity = qubit.fidelity(with: other)  // 0.5
```

### 7️⃣ 3D Bloch Sphere Customization

```swift
// Use different styles
struct ThemedBlochSphere: View {
    @State private var style: BlochSphereStyle = .cosmic
    let qubit: Qubit
    
    var body: some View {
        VStack {
            Picker("Style", selection: $style) {
                Text("Minimal").tag(BlochSphereStyle.minimal)
                Text("Standard").tag(BlochSphereStyle.standard)
                Text("Detailed").tag(BlochSphereStyle.detailed)
                Text("Cosmic").tag(BlochSphereStyle.cosmic)
                Text("Educational").tag(BlochSphereStyle.educational)
            }
            
            BlochSphereView3D(qubit: qubit)
        }
    }
}

// Or use advanced customization
let config = BlochSphereConfig.style(.detailed)
let scene = BlochSphereSceneBuilder.buildScene(
    with: qubit,
    config: config
)
```

---

## 📱 iOS Superposition Visualizer

### Running the App

```bash
cd ~/SwiftQuantum/Apps/SuperpositionVisualizer
open SuperpositionVisualizer.xcodeproj
```

Press **Cmd + R** to run in simulator or on device.

### Features

#### 🌐 3D Bloch Sphere Visualization (NEW!)
- Real-time 3D representation using SceneKit
- Touch-based rotation for full control
- Transparent sphere for interior visibility
- Color-coded axes and wireframe grid
- Real-time coordinate display (X, Y, Z)

#### 🎛️ Interactive Controls
- **Rotation**: Swipe to rotate the sphere freely
- **Pause/Play**: Control animation playback
- **Reset**: Return camera to default orientation
- **Coordinate Display**: Real-time X, Y, Z values

#### 📊 Quantum Measurements
- **Single Measurement**: Observe quantum collapse
- **Statistical Analysis**: 1000-shot measurements with histograms
- **Expected vs Measured**: Compare theoretical and experimental results

#### ⚡ Quick Presets
Six standard quantum states:
- |0⟩ - Ground state
- |1⟩ - Excited state  
- |+⟩ - Plus superposition
- |−⟩ - Minus superposition
- |+i⟩ - Plus-i state
- |−i⟩ - Minus-i state

#### 📖 Educational Content
- Built-in quantum computing tutorials
- Explanations of superposition and measurement
- Mathematics behind quantum states
- Interactive quantum state explorer

---

## 🎓 Playground Examples

Interactive playgrounds for learning:

### Superposition Playground

```bash
cd ~/SwiftQuantum
swift run
```

Then in Swift:
```swift
import SwiftQuantum

// Run all demonstrations
SuperpositionPlayground.runAll()

// Or run specific demos
SuperpositionPlayground.exploreSuperpositionStates()
SuperpositionPlayground.demonstrateQuantumCollapse()
SuperpositionPlayground.exploreBlochSphere()
SuperpositionPlayground.demonstrateQuantumParallelism()
```

### Basic Quantum Operations

```swift
// See Examples/BasicQuantumOperations.swift
BasicQuantumOperations.runAllExamples()
```

### Advanced Examples

```swift
// See Examples/AdvancedQuantumExamples.swift
AdvancedQuantumExamples.demonstrateAdvancedConcepts()
```

---

## 📚 Interactive Tutorials

SwiftQuantum includes comprehensive, step-by-step tutorials to help you master quantum computing!

### Running the Tutorial System

```bash
swift run TutorialRunner
```

Or directly in your Swift code:

```swift
import SwiftQuantum

// Run all tutorials
QuantumAlgorithmTutorials.runAllTutorials()

// Or run individual tutorials
QuantumAlgorithmTutorials.superpositionTutorial()
QuantumAlgorithmTutorials.deutschJozsaTutorial()
QuantumAlgorithmTutorials.quantumRNGTutorial()
```

### Available Tutorials

#### 1. 🌀 Understanding Quantum Superposition
Learn the fundamental concept of quantum superposition with visual demonstrations.

**What you'll learn:**
- Classical bits vs quantum qubits
- Creating superposition with Hadamard gates
- Visualizing Bloch sphere representations
- Measuring superposition states

#### 2. 🌊 Quantum Interference Patterns
Explore how quantum interference enables powerful algorithms.

**What you'll learn:**
- Constructive and destructive interference
- Phase control in quantum circuits
- How interference creates quantum advantage
- Testing different phase angles

#### 3. 🧮 Deutsch-Jozsa Algorithm
See quantum advantage in action with this landmark algorithm.

**What you'll learn:**
- The first quantum algorithm to show exponential speedup
- Quantum oracles and function evaluation
- Using superposition and interference together
- Performance comparison with classical approaches

#### 4. 🎲 Quantum Random Number Generation
Build cryptographically secure random number generators.

**What you'll learn:**
- True randomness vs pseudo-randomness
- Statistical analysis of quantum RNG
- Practical applications in cryptography
- Quality metrics (entropy, balance)

#### 5. 🔬 Quantum State Tomography
Reconstruct unknown quantum states through measurements.

**What you'll learn:**
- Measuring in different bases (X, Y, Z)
- State reconstruction algorithms
- Fidelity analysis
- The quantum measurement problem

### Tutorial Code Examples

#### Example 1: Building Your First Circuit

```swift
// Create a quantum circuit with superposition
let circuit = QuantumCircuit(qubit: .zero)
circuit.addGate(.hadamard)

// Visualize
print(circuit.asciiDiagram())
// Output: q₀ ─┤ H ├─

// Measure 1000 times
let results = circuit.measureMultiple(shots: 1000)
print("P(|0⟩) = \(Double(results[0] ?? 0) / 10.0)%")
print("P(|1⟩) = \(Double(results[1] ?? 0) / 10.0)%")
```

#### Example 2: Exploring Quantum Interference

```swift
// Create interference pattern
let circuit = QuantumCircuit(qubit: .zero)
circuit.addGate(.hadamard)          // Superposition
circuit.addGate(.rotationZ(.pi))    // Phase shift
circuit.addGate(.hadamard)          // Interference

// Should measure |1⟩ with ~100% probability
let state = circuit.execute()
print(state.stateDescription())
```

#### Example 3: Quantum Random Number Generator

```swift
let rng = QuantumApplications.QuantumRNG()

// Generate random bits
let bits = (0..<10).map { _ in rng.randomBit() }
print("Random bits: \(bits)")

// Generate random number
let number = rng.randomInt(in: 1...100)
print("Random number (1-100): \(number)")

// Test quality
let (entropy, balance) = rng.testRandomness(samples: 10000)
print("Entropy: \(entropy) (max: 1.0)")
print("Balance: \(balance) (optimal: 0.0)")
```

---

## 🏗️ Architecture

### Core Components

```
SwiftQuantum/
├── Sources/SwiftQuantum/
│   ├── Complex.swift           # Complex number arithmetic
│   ├── Qubit.swift              # Single-qubit quantum states
│   ├── QuantumGates.swift       # Quantum gate operations
│   ├── QuantumCircuit.swift     # Circuit building and execution
│   ├── QubitVisualizer.swift    # State visualization tools
│   └── SwiftQuantum.swift       # Public API
│
├── Examples/
│   ├── BasicQuantumOperations.swift
│   ├── AdvancedQuantumExamples.swift
│   ├── SuperpositionPlayground.swift
│   └── QuantumAlgorithmTutorials.swift
│
├── Apps/
│   └── SuperpositionVisualizer/  # iOS app
│       ├── Views/
│       │   ├── SuperpositionView.swift
│       │   ├── BlochSphereView.swift (Legacy 2D)
│       │   ├── BlochSphereView3D.swift (NEW 3D) ✨
│       │   ├── BlochSphereView3D+Advanced.swift (NEW Advanced) ✨
│       │   ├── MeasurementHistogram.swift
│       │   ├── StateInfoCard.swift
│       │   ├── QuickPresetsView.swift
│       │   └── InfoView.swift
│       └── SuperpositionVisualizerApp.swift
│
├── Tests/
│   └── SwiftQuantumTests/
│
├── Docs/
│   ├── QUICK_REFERENCE_EN.md
│   ├── COMPLETE_INTEGRATION_GUIDE_EN.md
│   ├── USAGE_EXAMPLES_EN.md
│   └── ... (other documentation)
│
└── README.md
```

### Design Philosophy

1. **Pure Swift**: No external dependencies
2. **Type Safety**: Leverage Swift's type system
3. **Performance**: Optimized for mobile devices
4. **Educational**: Clear, well-documented code
5. **Extensible**: Easy to add new features
6. **Interactive**: Beautiful 3D visualizations

---

## 📊 Performance

### Benchmarks on iPhone 13 Pro

| Operation | Time | Notes |
|-----------|------|-------|
| Qubit Creation | ~100ns | Pure state initialization |
| Single Gate | ~1µs | Hadamard, Pauli gates |
| Circuit (10 gates) | ~10µs | Sequential execution |
| Measurement (1000x) | ~50µs | Statistical sampling |
| Bloch Coordinates | ~200ns | Coordinate calculation |
| 3D Sphere Render | 8-12ms | 60fps on iPhone 13+ |

### Device Support for 3D Bloch Sphere

| Device | Support | Performance |
|--------|---------|-------------|
| iPhone 15+ | ✅ | Excellent ⭐⭐⭐⭐⭐ |
| iPhone 14 | ✅ | Excellent ⭐⭐⭐⭐ |
| iPhone 13 | ✅ | Excellent ⭐⭐⭐⭐ |
| iPhone 12 | ✅ | Good ⭐⭐⭐ |
| iPhone 11 | ✅ | Good ⭐⭐⭐ |
| iPad Pro | ✅ | Excellent ⭐⭐⭐⭐⭐ |

---

## 🧪 Testing

Run the test suite:

```bash
swift test
```

Run benchmarks:

```bash
swift run SwiftQuantumBenchmarks
```

Test coverage: **95%+**

---

## 🗺️ Roadmap

### Version 1.1 (Q4 2025)
- [x] 3D Bloch sphere visualization (RELEASED! ✨)
- [ ] Multi-qubit support (2-qubit systems)
- [ ] Quantum entanglement
- [ ] CNOT and controlled gates
- [ ] Bell states

### Version 1.2 (Q1 2026)
- [ ] Quantum algorithms
  - [ ] Deutsch-Jozsa
  - [ ] Grover's search
  - [ ] Quantum Fourier Transform
- [ ] Noise models
- [ ] Decoherence simulation

### Version 2.0 (Q2 2026)
- [ ] Multi-qubit circuits (up to 10 qubits)
- [ ] Quantum error correction
- [ ] Advanced visualizations
- [ ] macOS app with 3D support
- [ ] Cloud quantum computing integration

---

## 📖 Documentation

### 3D Bloch Sphere Documentation (NEW!)
- **[Quick Reference](docs/QUICK_REFERENCE_EN.md)** - Fast lookup guide (5 min read)
- **[Complete Integration Guide](docs/COMPLETE_INTEGRATION_GUIDE_EN.md)** - Step-by-step installation (15 min read)
- **[Usage Examples](docs/USAGE_EXAMPLES_EN.md)** - Practical code examples (20 min read)

### Quantum Computing API Reference
- [Complex Numbers](docs/Complex.md)
- [Quantum States](docs/Qubit.md)
- [Quantum Gates](docs/QuantumGates.md)
- [Quantum Circuits](docs/QuantumCircuit.md)
- [Visualization](docs/QubitVisualizer.md)

### Tutorials
- [Getting Started](docs/tutorials/01-getting-started.md)
- [Understanding Superposition](docs/tutorials/02-superposition.md)
- [Quantum Gates](docs/tutorials/03-quantum-gates.md)
- [Building Circuits](docs/tutorials/04-circuits.md)
- [The Bloch Sphere](docs/tutorials/05-bloch-sphere.md)

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/Minapak/SwiftQuantum.git
cd SwiftQuantum

# Build the package
swift build

# Run tests
swift test

# Open in Xcode
open Package.swift
```

### Areas for Contribution
- 🐛 Bug fixes
- ✨ New quantum gates
- 📚 Documentation improvements
- 🎨 UI/UX enhancements
- 🧪 Additional test cases
- 🌐 Internationalization
- 🎮 New visualization features

---

## 📄 License

SwiftQuantum is released under the MIT License. See [LICENSE](LICENSE) for details.

```
MIT License

Copyright (c) 2025 Eunmin Park

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- Inspired by Qiskit, Cirq, and other quantum computing frameworks
- Special thanks to the Swift community
- Built with love for quantum computing education
- 3D Bloch sphere visualization powered by SceneKit

---

## 📞 Contact & Support

- **Author**: Eunmin Park
- **Email**: dmsals2008@gmail.com
- **GitHub**: [@Minapak](https://github.com/Minapak)
- **Blog**: [eunminpark.hashnode.dev](https://eunminpark.hashnode.dev/series/ios-quantum-engineer)

### Support

- 🐛 [Report a Bug](https://github.com/Minapak/SwiftQuantum/issues/new?template=bug_report.md)
- ✨ [Request a Feature](https://github.com/Minapak/SwiftQuantum/issues/new?template=feature_request.md)
- 💬 [Discussions](https://github.com/Minapak/SwiftQuantum/discussions)
- 📖 [Documentation](https://swiftquantum.dev)

---

## 🌟 What's New in This Release

### 3D Bloch Sphere Visualization ✨

The latest version of SwiftQuantum introduces a **fully interactive 3D Bloch sphere** visualization:

**Key Features:**
- **Transparent 3D Sphere**: 92% transparent rendering using SceneKit
- **Touch-Based Rotation**: Free rotation with inertia-based scrolling
- **Real-Time Coordinates**: Live X, Y, Z value display
- **Wireframe Grid**: Latitude/longitude reference lines
- **Colored Axes**: RGB color coding for spatial orientation
- **State Vector Animation**: Smooth arrow animation to quantum state
- **Multiple Themes**: 5 rendering styles + 4 color themes
- **Full Customization**: 50+ configuration options

**Performance:**
- 60fps on iPhone 13+
- 5-8MB memory footprint
- Compatible with iOS 14+

**How to Upgrade:**
See the [Quick Integration Guide](docs/QUICK_REFERENCE_EN.md) - it's just one line change!

---

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Minapak/SwiftQuantum&type=Date)](https://star-history.com/#Minapak/SwiftQuantum&Date)

---

## 🔗 Related Projects

- [Qiskit](https://qiskit.org) - IBM's quantum computing framework (Python)
- [Cirq](https://quantumai.google/cirq) - Google's quantum programming framework (Python)
- [Q#](https://docs.microsoft.com/quantum/) - Microsoft's quantum programming language
- [ProjectQ](https://projectq.ch) - Open-source quantum computing framework

---

<div align="center">

**Made with ❤️ and ⚛️ by Eunmin Park**

*Bringing quantum computing to iOS, one qubit at a time* 🚀

[⬆ Back to Top](#swiftquantum-)

</div>
