# SwiftQuantum v2.0 🌀⚛️

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2014%2B%20%7C%20macOS%2014%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![QuantumBridge](https://img.shields.io/badge/QuantumBridge-1.0-blueviolet.svg)](https://github.com/Minapak/QuantumBridge)

**A comprehensive quantum computing framework for iOS and macOS** - featuring QuantumBridge integration for IBM Quantum connectivity!

> 🎓 Perfect for learning quantum computing concepts
>
> 🚀 Production-ready quantum simulations with up to 20 qubits
>
> 🔗 IBM Quantum hardware integration via QuantumBridge API
>
> 📱 Beautiful SwiftQuantumV2 app with interactive circuit builder

---

## ✨ What's New in v2.0

### 🔗 QuantumBridge Integration
- **IBM Quantum Connectivity**: Connect to real quantum hardware
- **QASM Export**: Export circuits to OpenQASM format
- **Error Mitigation**: ZNE, M3, and Dynamical Decoupling configurations
- **Backend Presets**: Simulator, Brisbane, Osaka, Kyoto

### 🧮 Multi-Qubit Support (NEW!)
- **QuantumRegister**: Up to 20 qubits with tensor product states
- **Two-Qubit Gates**: CNOT, CZ, SWAP
- **Three-Qubit Gates**: Toffoli (CCNOT)
- **Entanglement**: Bell states, GHZ states

### 🎯 4 Major Quantum Algorithms
| Algorithm | Description | Speedup |
|-----------|-------------|---------|
| **Bell State** | Create maximally entangled qubit pairs | Foundation of QC |
| **Deutsch-Jozsa** | Determine if function is constant or balanced | Exponential |
| **Grover's Search** | Search unstructured databases | Quadratic O(√N) |
| **Simon's Algorithm** | Find hidden periods | Exponential |

### 📱 SwiftQuantumV2 App
- **Complete UI Redesign**: Quantum-themed dark mode interface
- **5-Tab Navigation**: Home, Algorithms, Circuit Builder, Explore, Settings
- **Interactive Algorithm Runner**: Run quantum algorithms with visual results
- **Visual Circuit Builder**: Drag-and-drop gate palette
- **QASM Export**: Export circuits for IBM Quantum

---

## 🚀 Quick Start

### Installation

#### Swift Package Manager (Recommended)

Add SwiftQuantum to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "2.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies...
2. Enter: `https://github.com/Minapak/SwiftQuantum`
3. Click "Add Package"

### Basic Usage

```swift
import SwiftQuantum

// Single qubit operations
let qubit = Qubit.superposition
print("P(|0⟩): \(qubit.probability0)")  // 0.5

// Multi-qubit register (NEW in v2.0!)
let register = QuantumRegister(numberOfQubits: 3)
register.applyGate(.hadamard, to: 0)
register.applyCNOT(control: 0, target: 1)
register.applyCNOT(control: 1, target: 2)
// Creates GHZ state: (|000⟩ + |111⟩)/√2

let results = register.measureAll(shots: 1000)
// Results: ["000": ~500, "111": ~500]
```

### Running Quantum Algorithms

```swift
import SwiftQuantum

// Bell State - Create entanglement
let bell = BellState()
let bellResult = bell.run()
print("State: \(bellResult.stateName)")  // |Φ+⟩
print("Correlation: \(bellResult.correlation)")  // 1.0

// Grover's Search - Find marked item
let grover = GroverSearch(numberOfQubits: 3, markedState: 5)
let groverResult = grover.run()
print("Found: \(groverResult.foundState)")  // 5
print("Success: \(groverResult.successProbability)%")  // ~95%

// Run all algorithms at once
let allResults = QuantumAlgorithmRunner.runAll()
```

### IBM Quantum Integration

```swift
import SwiftQuantum

// Export circuit to QASM
let qasm = QuantumBridge.toQASM(
    numberOfQubits: 2,
    gates: [
        .init(name: "h", qubit: 0),
        .init(name: "cx", qubit: 0, target: 1)
    ]
)
// Output: OPENQASM 2.0; include "qelib1.inc"; ...

// Configure for IBM Quantum backend
let config = IBMQuantumConfig.brisbane
config.apiKey = "YOUR_IBM_QUANTUM_API_KEY"

// Error mitigation
let mitigation = ErrorMitigationConfig.standard
// Includes: ZNE, M3 readout correction
```

---

## 📸 Screenshots

### SwiftQuantumV2 App

<table>
  <tr>
    <td><img src="docs/screenshots/v2-home.png" alt="Home" width="250"/></td>
    <td><img src="docs/screenshots/v2-algorithms.png" alt="Algorithms" width="250"/></td>
    <td><img src="docs/screenshots/v2-circuit.png" alt="Circuit Builder" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><b>Home Dashboard</b></td>
    <td align="center"><b>Algorithm Runner</b></td>
    <td align="center"><b>Circuit Builder</b></td>
  </tr>
</table>

---

## 🎯 Features

### Core Quantum Operations
- **Quantum States**: Single-qubit and multi-qubit (up to 20 qubits)
- **Complex Numbers**: Full complex number arithmetic with phase calculations
- **15+ Quantum Gates**: H, X, Y, Z, S, T, CNOT, CZ, SWAP, Toffoli, and more
- **Measurements**: Statistical and probabilistic measurement operations
- **Quantum Circuits**: Build and execute circuits with multiple gates

### QuantumBridge Features
- **QASM Export**: Convert circuits to OpenQASM 2.0 format
- **IBM Quantum Backends**: Simulator, Brisbane, Osaka, Kyoto presets
- **Error Mitigation**: Zero-Noise Extrapolation, M3 Readout, Dynamical Decoupling
- **Circuit Builder API**: Fluent interface for building circuits

### Visualization
- **3D Bloch Sphere**: Interactive SceneKit visualization
- **Measurement Histograms**: Visual result analysis
- **State Visualization**: ASCII art and text-based displays

---

## 🏗️ Architecture

```
SwiftQuantum/
├── 📄 Package.swift                      # Package definition
│
├── 📁 Sources/SwiftQuantum/              # Core library
│   ├── Complex.swift                     # Complex numbers
│   ├── Qubit.swift                       # Single-qubit states
│   ├── QuantumRegister.swift             # Multi-qubit states (NEW!)
│   ├── QuantumGates.swift                # Gate operations
│   ├── QuantumCircuit.swift              # Circuit execution
│   ├── QubitVisualizer.swift             # Visualization
│   ├── SwiftQuantum.swift                # Public API
│   │
│   ├── 📁 Algorithms/                    # Quantum algorithms (NEW!)
│   │   └── QuantumAlgorithms.swift       # Bell, DJ, Grover, Simon
│   │
│   └── 📁 Bridge/                        # QuantumBridge API (NEW!)
│       └── QuantumBridge.swift           # IBM Quantum integration
│
├── 📁 Apps/
│   ├── 📁 SwiftQuantumV2/                # New v2.0 app (NEW!)
│   │   └── SwiftQuantumV2/
│   │       ├── SwiftQuantumV2App.swift
│   │       ├── Design/
│   │       │   └── QuantumDesignSystem.swift
│   │       └── Views/
│   │           ├── MainTabView.swift
│   │           ├── HomeView.swift
│   │           ├── AlgorithmsView.swift
│   │           ├── CircuitBuilderView.swift
│   │           ├── ExploreView.swift
│   │           └── SettingsView.swift
│   │
│   └── 📁 SuperpositionVisualizer/       # Original visualizer app
│
└── 📁 Tests/SwiftQuantumTests/           # Unit tests
```

---

## 📊 Performance

### Benchmarks

| Operation | Time | Notes |
|-----------|------|-------|
| Qubit Creation | ~100ns | Pure state initialization |
| Single Gate | ~1µs | Hadamard, Pauli gates |
| Circuit (10 gates) | ~10µs | Sequential execution |
| Measurement (1000x) | ~50µs | Statistical sampling |
| 5-qubit Register | ~100µs | Full state vector |
| Grover (3 qubits) | ~500µs | Complete algorithm |

### Qubit Scaling

| Qubits | State Vector Size | Memory |
|--------|-------------------|--------|
| 5 | 32 amplitudes | ~512 bytes |
| 10 | 1,024 amplitudes | ~16 KB |
| 15 | 32,768 amplitudes | ~512 KB |
| 20 | 1,048,576 amplitudes | ~16 MB |

---

## 🧪 Testing

```bash
# Build the package
swift build

# Run tests
swift test

# Run specific tests
swift test --filter SwiftQuantumTests
```

---

## 📚 Documentation

### API Reference
- [QuantumRegister](docs/QuantumRegister.md) - Multi-qubit operations
- [QuantumAlgorithms](docs/QuantumAlgorithms.md) - Algorithm implementations
- [QuantumBridge](docs/QuantumBridge.md) - IBM Quantum integration

### Tutorials
- [Getting Started with v2.0](docs/tutorials/v2-getting-started.md)
- [Multi-Qubit Systems](docs/tutorials/multi-qubit.md)
- [Running Quantum Algorithms](docs/tutorials/algorithms.md)
- [IBM Quantum Integration](docs/tutorials/ibm-quantum.md)

---

## 🗺️ Roadmap

### Version 2.0 (Current) ✅
- [x] Multi-qubit support (up to 20 qubits)
- [x] QuantumBridge integration
- [x] 4 major quantum algorithms
- [x] QASM export
- [x] SwiftQuantumV2 app with new UI

### Version 2.1 (Planned)
- [ ] Quantum Fourier Transform (QFT)
- [ ] Shor's Algorithm (factoring)
- [ ] VQE (Variational Quantum Eigensolver)
- [ ] Real IBM Quantum job submission

### Version 2.2 (Future)
- [ ] Noise models and decoherence simulation
- [ ] Quantum error correction codes
- [ ] Hardware-aware transpilation
- [ ] Cloud quantum computing dashboard

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/Minapak/SwiftQuantum.git
cd SwiftQuantum

# Build
swift build

# Test
swift test

# Open in Xcode
open Package.swift
```

---

## 📄 License

SwiftQuantum is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [QuantumBridge](https://github.com/Minapak/QuantumBridge) - IBM Quantum integration inspiration
- [Qiskit](https://qiskit.org) - IBM's quantum computing framework
- [Cirq](https://quantumai.google/cirq) - Google's quantum programming framework
- Swift community for excellent tooling

---

## 📞 Contact & Support

- **Author**: Eunmin Park (박은민)
- **Email**: dmsals2008@gmail.com
- **GitHub**: [@Minapak](https://github.com/Minapak)
- **Blog**: [eunminpark.hashnode.dev](https://eunminpark.hashnode.dev/series/ios-quantum-engineer)

### Getting Help

- 🐛 [Report a Bug](https://github.com/Minapak/SwiftQuantum/issues/new?template=bug_report.md)
- ✨ [Request a Feature](https://github.com/Minapak/SwiftQuantum/issues/new?template=feature_request.md)
- 💬 [Start a Discussion](https://github.com/Minapak/SwiftQuantum/discussions)

---

<div align="center">

**Made with ❤️ and ⚛️ by Eunmin Park**

*Quantum computing on iOS, now with IBM Quantum integration* 🚀

[GitHub](https://github.com/Minapak/SwiftQuantum) • [QuantumBridge](https://github.com/Minapak/QuantumBridge) • [Blog](https://eunminpark.hashnode.dev)

[⬆ Back to Top](#swiftquantum-v20-)

</div>
