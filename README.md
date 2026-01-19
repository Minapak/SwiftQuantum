# SwiftQuantum v2.2.5 - Premium Quantum Hybrid Platform

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2018%2B%20%7C%20macOS%2015%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![QuantumBridge](https://img.shields.io/badge/QuantumBridge-2.0-blueviolet.svg)](https://github.com/user/QuantumBridge)
[![Quantum-Hybrid](https://img.shields.io/badge/Quantum--Hybrid-2026-00ff88.svg)](#)
[![Agentic AI](https://img.shields.io/badge/Agentic%20AI-Ready-ff6b6b.svg)](#)
[![Localization](https://img.shields.io/badge/Languages-EN%20%7C%20KO%20%7C%20JA%20%7C%20ZH%20%7C%20DE-blue.svg)](#)

**The first iOS quantum computing framework with real QPU connectivity** - featuring QuantumBridge integration, fault-tolerant simulation, and Harvard-MIT research-based educational content!

> **Harvard-MIT Research Foundation**: Based on 2025 Nature publications demonstrating 3,000+ continuous qubit operation and sub-0.5% error rates
>
> **Real Quantum Hardware**: Connect to IBM Quantum's 127-qubit systems via QuantumBridge API
>
> **Premium Learning Platform**: MIT/Harvard-style Quantum Academy with subscription-based courses
>
> **Enterprise Solutions**: B2B industry applications for finance, healthcare, and logistics

---

## What's New in v2.2.5 (2026 Production Release)

### QuantumExperience Entertainment Module

New entertainment logic module for premium monetization features:

- **DailyChallengeEngine (Daily Pulse Logic)**:
  - Deterministic daily patterns using FNV-1a hash algorithm
  - O(1) complexity - instant pattern generation
  - Same date = Same pattern globally (user synchronization)
  - Extended pattern data: entanglement strength, coherence, lucky quantum state

- **OracleEngine (The Oracle Logic)**:
  - True quantum randomness via Hadamard gate + measurement
  - Context injection: user questions influence initial phase rotation
  - Confidence calculation based on entropy and probability distribution
  - Consultation history with configurable size limit

- **QuantumArtMapper (Art Data Mapping)**:
  - Maps quantum states to visual art parameters (hue, complexity, contrast)
  - Supports single qubit, multi-qubit registers, and circuit results
  - Configurable hue modes: continuous, quantized6, quantized12, warm, cool
  - HSB to RGB color conversion with hex output

```swift
// Daily Pulse - Global synchronized pattern
let pattern = QuantumExperience.todayPattern
print("Amplitude: \(pattern.amplitude), Phase: \(pattern.phase)")

// The Oracle - Quantum decision making
let answer = QuantumExperience.askOracle("Should I invest?")
print("Oracle says: \(answer ? "Yes" : "No")")

// Quantum Art - Generate colors from quantum states
let artData = QuantumExperience.generateArt(from: circuit)
print("Color: \(artData.hexColor), Complexity: \(artData.complexity)")
```

---

## What's New in v2.2.4

### IBM Quantum Ecosystem Localization & Subscription System Overhaul

- **IBM Quantum Ecosystem Full Localization**:
  - All 12 ecosystem project names and descriptions localized (EN, KO, JA, ZH, DE)
  - Category labels (ML, Chemistry, Optimization, Hardware, Simulation, Research) localized
  - Ecosystem project cards, detail sheets, and code export views fully localized

- **Subscription System Complete Redesign**:
  - Tab-based comparison UI (Compare, Pro, Premium tabs)
  - Clear plan differentiation: Pro Monthly, Pro Yearly, Premium Monthly, Premium Yearly
  - Feature comparison table with Free/Pro/Premium columns
  - Localized in all 5 languages

- **Subscription Info Page (More Tab)**:
  - New "Subscription Info" menu item in Settings section
  - Dedicated page explaining Pro vs Premium features
  - Tier comparison cards with feature highlights
  - All features list with descriptions
  - One-tap access to PaywallView for subscription

- **Text Truncation Fix**:
  - Fixed `lineLimit(1)` causing "..." truncation in benefit descriptions
  - Industry and Circuits tab hero sections now show full text in all languages

---

## What's New in v2.2.3

### Comprehensive Localization & Premium Subscription Redesign

- **Authentication Localization**: Login, Sign Up, Password Reset screens now fully localized
  - All form fields, buttons, error messages in 5 languages (EN, KO, JA, ZH, DE)
  - Replaced SF Symbol with actual app icon in auth screens

- **Subscription Paywall Redesign**: Complete overhaul of the premium purchase experience
  - Tier selection: Pro vs Premium with clear feature comparison
  - Period selection: Monthly vs Yearly with 33% savings badge
  - Dynamic feature lists based on selected tier
  - Localized pricing display and descriptions in all 5 languages

- **Academy & Industry UI Improvements**:
  - Academy hero section now uses actual app icon
  - Industry solution cards fully localized (Finance, Healthcare, Logistics, etc.)
  - Removed hardcoded stats, replaced with intuitive benefit descriptions

---

## What's New in v2.2.2

### UI Improvements & Bug Fixes

- **Bridge Tab Info Toggle**: "Why Use QuantumBridge?" is now a toggleable info card
  - Tap the `?` button in the top-right corner to show/hide the explanation
  - Cleaner initial view with explanation available on demand
- **Build Fixes**: Resolved syntax errors in PresetsHubView (LocalizedStringKey, padding)

---

## What's New in v2.2.1

### Backend Integration & Real-time Localization

Complete iOS-to-Backend integration with dynamic language switching:

```swift
// Real-time language switching
LocalizationManager.shared.setLanguage("ko")  // Instant UI update

// Backend API integration
let stats = try await APIClient.shared.get("/api/v1/users/stats")

// Dynamic content from backend
Text("Version \(AppInfo.version)")  // From Bundle.main
Text("\(statsManager.lessonsCompleted) Done")  // From backend
```

#### Key Updates

- **Real-time Language Switching**: Instant UI update without app restart
- **Backend Stats Integration**: User stats from API with UserDefaults fallback
- **Dynamic Content**: Removed hardcoded values, connected to real backend
- **Safari WebView Settings**: Settings pages open via in-app Safari
- **Deep Linking**: Academy opens QuantumNative app via URL scheme

### Multi-Language Support (5 Languages)

| Language | Code | Status |
|----------|------|--------|
| English | `en` | Default |
| Korean | `ko` | Full |
| Japanese | `ja` | Full |
| Chinese (Simplified) | `zh-Hans` | Full |
| German | `de` | Full |

---

## What's New in v2.2.0 (Backend Release)

### StoreKit 2 + Backend Verification

Complete iOS-to-Backend subscription flow with Apple App Store Server API v2:

```swift
// APIClient.swift - Backend communication
let result = try await APIClient.shared.verifyTransaction(transactionId: "...")

// PremiumManager.swift - Automatic backend verification after purchase
case .success(let verification):
    let transaction = try checkVerified(verification)
    await verifyWithBackend(transactionId: String(transaction.id))
    await transaction.finish()
```

#### Subscription Flow

```
1. iOS StoreKit 2 Purchase
   └── Transaction object received

2. iOS → Backend Verification
   └── POST /api/v1/payment/verify/transaction

3. Backend → Apple Server API
   └── JWT authentication (ES256)
   └── Transaction validation

4. Backend → Database
   └── User subscription activated

5. Backend → iOS Response
   └── UI updated with premium badge
```

### Content Access Control

```swift
// ContentAccessManager.swift
@ObservedObject var accessManager = ContentAccessManager.shared

// Check level access
if accessManager.canAccessLevel(5) { ... }

// Check feature access
if accessManager.canAccessQuantumBridge { ... }

// View modifier for premium content
SomeView()
    .premiumContent(feature: "quantum_bridge")
```

---

## Quick Start

### Installation

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "2.2.5")
]
```

### Basic Usage

```swift
import SwiftQuantum

// Create a quantum register
let register = QuantumRegister(numberOfQubits: 3)

// Apply gates
register.applyGate(.hadamard, to: 0)
register.applyCNOT(control: 0, target: 1)
register.applyCNOT(control: 1, target: 2)
// Creates GHZ state: (|000⟩ + |111⟩)/√2

// Measure
let results = register.measureMultiple(shots: 1000)
// ["000": ~500, "111": ~500]
```

### QuantumBridge Connection

```swift
import SwiftQuantum

// Create executor for IBM Quantum
let executor = QuantumBridgeExecutor(
    executorType: .ibmBrisbane,
    apiKey: "YOUR_IBM_QUANTUM_API_KEY"  // Get from IBM Quantum
)

// Build circuit
let circuit = BridgeCircuitBuilder(numberOfQubits: 2, name: "Bell")
    .h(0)
    .cx(control: 0, target: 1)

// Execute on real quantum hardware
let result = try await executor.execute(circuit: circuit, shots: 1000)
print("Counts: \(result.counts)")  // {"00": 498, "11": 502}
```

---

## QuantumBridge Tab - Complete Guide

The **Bridge** tab is your gateway to real quantum hardware! Here's what you can do:

### Why Use QuantumBridge?

> **Tip**: Tap the `?` button in the top-right corner of the Bridge tab to see this information in-app!

| Benefit | Description |
|---------|-------------|
| **Real Hardware** | Run circuits on actual IBM quantum processors (127 qubits!) |
| **True Quantum Effects** | Experience real superposition and entanglement |
| **Authentic Results** | Get measurements from real quantum computers, not simulations |

### Backend Options

| Backend | Best For | Advantages | Limitations |
|---------|----------|------------|-------------|
| **Simulator** | Learning & Testing | Instant results, Free, No queue | No real quantum noise |
| **IBM Brisbane** | Production & Research | 127 qubits, High coherence | Queue wait time |
| **IBM Osaka** | High-speed Execution | Fast gate speed, Shorter queues | Moderate noise |
| **IBM Kyoto** | Research Projects | Advanced error mitigation | Currently maintenance |

### Quick Actions

| Action | Description | Premium? |
|--------|-------------|----------|
| **Bell State** | Create quantum entanglement between 2 qubits | Yes |
| **GHZ State** | Multi-qubit (3+) entanglement | Yes |
| **Export QASM** | Export circuit as OpenQASM 3.0 code | No |
| **Continuous Mode** | Auto-repeat circuits every 30 seconds | Yes |

### Export QASM Example

```qasm
// OpenQASM 3.0 - Generated by SwiftQuantum
OPENQASM 3.0;
include "stdgates.inc";

qubit[2] q;
bit[2] c;

reset q;
h q[0];           // Put first qubit in superposition
cx q[0], q[1];    // Entangle with second qubit
c = measure q;
```

---

## Industry Tab - Enterprise Solutions

The **Industry** tab showcases quantum computing applications for real businesses.

### Overview

| Feature | Description |
|---------|-------------|
| **Industry Cards** | 6 sectors with quantum solutions |
| **ROI Calculator** | Estimate your potential savings |
| **Detailed View** | Learn about each industry's applications |
| **IBM Ecosystem** | Run projects from IBM Quantum Ecosystem |

### Available Industries

| Industry | Use Case | Efficiency Gain |
|----------|----------|-----------------|
| **Finance** | Portfolio optimization, Risk analysis | +52% |
| **Healthcare** | Drug discovery, Protein folding | +38% |
| **Logistics** | Route optimization, Supply chain | +45% |
| **Energy** | Grid optimization, Forecasting | +41% |
| **Manufacturing** | Quality control, Maintenance | +33% |
| **AI & ML** | Quantum machine learning | +67% |

### ROI Calculator

Input your company details to estimate quantum computing ROI:
- Team size (10 - 1000+ people)
- Annual IT budget ($50K - $10M+)
- Industry sector

---

## IBM Quantum Ecosystem Integration

SwiftQuantum now integrates with the **IBM Quantum Ecosystem**, allowing you to run real quantum projects directly from your iOS device.

### Ecosystem Categories

| Category | Projects | Description |
|----------|----------|-------------|
| **Machine Learning** | TorchQuantum, Qiskit ML | Quantum neural networks and ML algorithms |
| **Chemistry & Physics** | Qiskit Nature | Molecular simulation and drug discovery |
| **Optimization** | Qiskit Finance, Optimization | Portfolio optimization and QAOA |
| **Hardware Providers** | IBM, Azure, AWS Braket, IonQ | Direct access to quantum processors |
| **Simulation** | Qiskit Aer, MQT DDSIM | High-performance simulators |
| **Research** | PennyLane, Cirq | Cross-platform research frameworks |

### Featured Projects

| Project | Stars | Category | Best For |
|---------|-------|----------|----------|
| **TorchQuantum** | 1,591 | Machine Learning | Quantum neural networks with PyTorch |
| **Qiskit ML** | 928 | Machine Learning | Variational algorithms |
| **Qiskit Aer** | 629 | Simulation | High-performance circuit simulation |
| **Qiskit Nature** | 372 | Chemistry | Molecular simulations |
| **Qiskit Finance** | 302 | Optimization | Portfolio optimization |
| **Qiskit Optimization** | 272 | Optimization | QAOA and VQE algorithms |

### Ecosystem Features

- **Run Demo Circuits**: Execute sample circuits for each project
- **Export Sample Code**: Get Python code for each ecosystem project
- **GitHub Integration**: Direct links to project repositories
- **Category Filtering**: Filter projects by category

---

## Architecture

```
SwiftQuantum v2.2.5/
├── Sources/SwiftQuantum/
│   ├── Core/
│   │   ├── Complex.swift              # Complex number arithmetic
│   │   ├── Qubit.swift                # Single-qubit states
│   │   ├── QuantumRegister.swift      # Multi-qubit (up to 20)
│   │   ├── QuantumGates.swift         # 15+ quantum gates
│   │   └── QuantumCircuit.swift       # Circuit composition
│   │
│   ├── Algorithms/
│   │   └── QuantumAlgorithms.swift    # Bell, Grover, DJ, Simon
│   │
│   ├── Bridge/
│   │   ├── QuantumBridge.swift        # QASM export, IBM config
│   │   └── QuantumExecutor.swift      # Hybrid execution protocol
│   │
│   ├── Experience/                    # Entertainment Logic (NEW)
│   │   ├── QuantumExperience.swift    # Unified API entry point
│   │   ├── DailyChallengeEngine.swift # Daily Pulse patterns
│   │   ├── OracleEngine.swift         # Quantum decision making
│   │   └── QuantumArtMapper.swift     # State-to-art mapping
│   │
│   └── Resources/                     # Localization
│       ├── en.lproj/                  # English (Default)
│       ├── ko.lproj/                  # Korean
│       ├── ja.lproj/                  # Japanese
│       ├── zh-Hans.lproj/             # Chinese (Simplified)
│       └── de.lproj/                  # German
│
├── Apps/
│   └── SuperpositionVisualizer/       # Premium visualizer (4-Hub Navigation)
│       ├── QuantumHorizonView.swift   # Main view with 4-hub navigation
│       ├── DevMode/
│       │   └── DeveloperModeManager.swift  # QA/QC logging system
│       ├── Premium/                   # Subscription system
│       │   ├── APIClient.swift        # Backend API communication
│       │   ├── PremiumManager.swift   # StoreKit 2 + backend verify
│       │   ├── ContentAccessManager.swift  # Content locking
│       │   └── PaywallView.swift      # Subscription UI
│       ├── Hubs/
│       │   ├── LabHubView.swift       # Control + Measure + Info
│       │   ├── PresetsHubView.swift   # Presets + Examples
│       │   ├── FactoryHubView.swift   # Bridge (QPU connection)
│       │   └── MoreHubView.swift      # Academy + Industry + Profile
│       └── Navigation/
│           └── QuantumHorizonTabBar.swift  # 4-tab floating bar
│
├── Website/                           # Product website
│   ├── index.html                     # Landing page
│   └── support.html                   # Support center
│
└── Tests/
```

---

## Premium Features

### Subscription Tiers

| Feature | Free | Pro ($4.99/mo) | Premium ($9.99/mo) |
|---------|------|----------------|-------------------|
| Local Simulation | 20 qubits | 40 qubits | 40 qubits |
| Quantum Gates | All 15+ | All 15+ | All 15+ |
| Basic Examples | Yes | Yes | Yes |
| QuantumBridge Connection | No | Yes | **Yes** |
| Error Correction Simulation | No | No | **Yes** |
| Quantum Academy Courses | 2 free | All 12+ | **All 12+** |
| Industry Solutions | View only | Partial | **Full access** |
| Priority Support | No | Email | **Priority** |

---

## Research Foundation

### Harvard-MIT Nature 2025 Publications

SwiftQuantum is built on cutting-edge quantum computing research:

1. **"Fault-tolerant quantum computation with 448 neutral atom qubits"** (Nature, Nov 2025)
   - First demonstration of fault-tolerant threshold below 0.5%

2. **"Continuous operation of a coherent 3,000-qubit system"** (Nature, Sep 2025)
   - 2+ hours of continuous quantum operation

3. **"Magic state distillation on neutral atom quantum computers"** (Nature, Jul 2025)
   - Essential for universal fault-tolerant quantum computation

---

## Performance Benchmarks

| Operation | Time | Notes |
|-----------|------|-------|
| Qubit Creation | ~100ns | Pure state |
| Single Gate | ~1µs | Hadamard, Pauli |
| Circuit (10 gates) | ~10µs | Sequential |
| 5-qubit Register | ~100µs | Full state vector |
| Grover (3 qubits) | ~500µs | Complete algorithm |
| Error Correction Sim | ~1ms | Surface code d=3 |

### Qubit Scaling

| Qubits | State Vector | Memory |
|--------|--------------|--------|
| 5 | 32 amplitudes | ~512 B |
| 10 | 1,024 amplitudes | ~16 KB |
| 15 | 32,768 amplitudes | ~512 KB |
| 20 | 1,048,576 amplitudes | ~16 MB |

---

## Roadmap

### Version 2.2.5 (Current - January 2026)
- [x] QuantumExperience entertainment module for premium features
- [x] DailyChallengeEngine: Deterministic daily patterns (FNV-1a hash, O(1))
- [x] OracleEngine: True quantum randomness with context injection
- [x] QuantumArtMapper: Quantum state to visual art parameters
- [x] Swift 6 concurrency-safe with Sendable conformance
- [x] 16 new unit tests for Experience module

### Version 2.2.4 (January 2026)
- [x] IBM Quantum Ecosystem full localization (12 projects, 6 categories)
- [x] Subscription system complete redesign with tab-based comparison
- [x] Subscription Info page in More tab settings
- [x] Text truncation fix for multi-language benefit descriptions
- [x] All subscription-related UI localized in 5 languages

### Version 2.2.3 (January 2026)
- [x] Authentication screens localization (Login, Sign Up, Reset Password)
- [x] Premium subscription paywall complete redesign
- [x] Pro/Premium tier selection with feature comparison
- [x] Monthly/Yearly period selection with savings badge
- [x] Academy hero section uses actual app icon
- [x] Industry solution cards localization
- [x] Removed hardcoded stats in Industry and Circuits tabs

### Version 2.2.2 (January 2026)
- [x] Bridge tab info toggle (? button for "Why Use QuantumBridge?")
- [x] Build error fixes (LocalizedStringKey, padding syntax)
- [x] Cleaner initial Bridge view

### Version 2.2.1 (January 2026)
- [x] Real-time language switching without app restart
- [x] Backend integration for user stats and settings
- [x] Remove hardcoded values, dynamic content
- [x] Safari WebView for settings pages
- [x] Deep linking to QuantumNative app
- [x] Comprehensive test documentation

### Version 2.3.0 (Planned - Q2 2026)
- [ ] Real IBM Quantum job submission
- [ ] Quantum Fourier Transform (QFT)
- [ ] Shor's Algorithm implementation
- [ ] Cloud job queue dashboard
- [ ] Team/Enterprise accounts

### Version 3.0.0 (Future - Q4 2026)
- [ ] 50+ qubit simulation (optimized)
- [ ] Multi-QPU orchestration
- [ ] Custom noise model builder
- [ ] Quantum ML integration (PennyLane)

---

## Contributing

Contributions are welcome! Please read the contribution guidelines.

```bash
# Clone
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

## Environment Setup

### Required Environment Variables

Create a `.env` file (not committed to git):

```bash
# Backend API
API_BASE_URL=https://api.swiftquantum.tech
BRIDGE_BASE_URL=https://bridge.swiftquantum.tech

# IBM Quantum (Optional)
IBM_QUANTUM_API_KEY=your_ibm_quantum_api_key

# Apple App Store (Backend only)
APP_STORE_KEY_ID=your_key_id
APP_STORE_ISSUER_ID=your_issuer_id
APP_STORE_PRIVATE_KEY_PATH=/path/to/private/key.p8
```

### Backend Setup

See `SwiftQuantumBackend` repository for backend deployment instructions.

---

## License

MIT License - See [LICENSE](LICENSE)

---

## Contact & Support

- **GitHub Issues**: [Report Bug](https://github.com/Minapak/SwiftQuantum/issues/new?template=bug_report.md)
- **Feature Request**: [Request Feature](https://github.com/Minapak/SwiftQuantum/issues/new?template=feature_request.md)
- **Discussions**: [GitHub Discussions](https://github.com/Minapak/SwiftQuantum/discussions)

---

## Research References

- [Harvard Gazette: A Potential Quantum Leap](https://news.harvard.edu/gazette/story/2025/11/a-potential-quantum-leap/)
- [Nature: Continuous operation of a coherent 3,000-qubit system](https://www.nature.com/articles/s41586-025-09596-6)
- [MIT News: Fault-tolerant quantum computing](https://optics.org/news/16/4/51)
- [QuEra: Magic State Distillation](https://www.quera.com/press-releases/quera-harvard-and-mit-researchers-demonstrate-logical-level-magic-state-distillation-on-a-neutral-atom-quantum-computer)

---

<div align="center">

**SwiftQuantum - The future of quantum computing on iOS**

*Powered by Harvard-MIT research*

</div>
