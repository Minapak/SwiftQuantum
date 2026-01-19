# SwiftQuantum v2.2.5 - Architecture Document

> **Document Version:** 2.2.5
> **Last Updated:** 2026-01-19

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Directory Structure](#2-directory-structure)
3. [Sources/SwiftQuantum Details](#3-sourcesswiftquantum-details)
4. [Apps/SuperpositionVisualizer Details](#4-appssuperpositionvisualizer-details)
5. [File Dependencies Map](#5-file-dependencies-map)
6. [Data Flow](#6-data-flow)
7. [Developer Mode System](#7-developer-mode-system)
8. [Premium System](#8-premium-system)
9. [Backend Integration](#9-backend-integration)
10. [Multi-Language Support](#10-multi-language-support)
11. [Performance Benchmarks](#11-performance-benchmarks)

---

## 1. Project Overview

### 1.1 Core Specifications

| Item | Value |
|------|-------|
| **Project Name** | SwiftQuantum |
| **Version** | 2.2.5 |
| **License** | MIT |
| **Platform** | iOS 15+ / macOS 14+ |
| **Swift Version** | 6.0 |
| **Local Simulation** | Up to 20 qubits |
| **Remote Execution** | IBM Quantum 127 qubits (QuantumBridge) |
| **Supported Languages** | EN, KO, JA, ZH-Hans, DE (5 languages) |

### 1.2 Technology Stack

```
┌─────────────────────────────────────────────────────────────────────┐
│                      Product Layer                                   │
│  ┌──────────────────┐  ┌─────────────────┐  ┌──────────────────┐   │
│  │  Website         │  │  iOS App        │  │  Backend API     │   │
│  │  (Landing/Support│  │  (Visualizer)   │  │  (Python/FastAPI)│   │
│  │   HTML/CSS)      │  │                 │  │                  │   │
│  └──────────────────┘  └─────────────────┘  └──────────────────┘   │
├─────────────────────────────────────────────────────────────────────┤
│                    SuperpositionVisualizer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────────┐  │
│  │   SwiftUI   │  │  SceneKit   │  │  Quantum Horizon            │  │
│  │    Views    │  │  3D Bloch   │  │  Design System              │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────────┤
│                         SwiftQuantum                                 │
│  ┌──────────┐  ┌───────────┐  ┌───────────┐  ┌───────────────────┐ │
│  │   Core   │  │   Gates   │  │  Circuit  │  │   Algorithms      │ │
│  │ Complex  │  │  Pauli,H  │  │  Builder  │  │  Bell,Grover      │ │
│  │  Qubit   │  │  Rx,Ry,Rz │  │  Execute  │  │  DJ,Simon         │ │
│  └──────────┘  └───────────┘  └───────────┘  └───────────────────┘ │
├─────────────────────────────────────────────────────────────────────┤
│                      Experience Layer (NEW)                         │
│  ┌────────────────┐  ┌──────────────────┐  ┌────────────────────┐  │
│  │ DailyChallenge │  │   OracleEngine   │  │ QuantumArtMapper   │  │
│  │    Engine      │  │  (True Random)   │  │ (State→Art)        │  │
│  └────────────────┘  └──────────────────┘  └────────────────────┘  │
├─────────────────────────────────────────────────────────────────────┤
│                        Bridge Layer                                  │
│  ┌────────────────────────┐  ┌────────────────────────────────────┐ │
│  │   QuantumExecutor      │  │     QuantumBridge                  │ │
│  │   (Protocol)           │  │     (IBM Quantum)                  │ │
│  └────────────────────────┘  └────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────┤
│                      Premium Layer                                   │
│  ┌──────────────┐  ┌───────────────────┐  ┌──────────────────────┐ │
│  │ APIClient    │  │ ContentAccess     │  │ PremiumManager       │ │
│  │ (Backend)    │  │ Manager           │  │ (StoreKit 2)         │ │
│  └──────────────┘  └───────────────────┘  └──────────────────────┘ │
├─────────────────────────────────────────────────────────────────────┤
│                      Apple Frameworks                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌─────────┐ │
│  │  Foundation  │  │  Accelerate  │  │   StoreKit   │  │ Combine │ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Directory Structure

```
SwiftQuantum/
├── Package.swift                          # SPM package definition
├── README.md                              # Project introduction
├── CHANGELOG.md                           # Change history
├── ARCHITECTURE.md                        # This document
├── SECURITY.md                            # Security guidelines
├── .gitignore                             # Git ignore rules
│
├── Sources/
│   └── SwiftQuantum/                      # Quantum computing engine
│       ├── SwiftQuantum.swift             # Module entry point
│       ├── Complex.swift                  # Complex number implementation
│       ├── Qubit.swift                    # Single qubit state
│       ├── QuantumGates.swift             # Quantum gate implementation
│       ├── QuantumCircuit.swift           # Single qubit circuit
│       ├── QuantumRegister.swift          # Multi-qubit register
│       ├── QubitVisualizer.swift          # Visualization utilities
│       │
│       ├── Core/
│       │   ├── LinearAlgebra.swift        # High-performance linear algebra
│       │   └── NoiseModel.swift           # Harvard-MIT noise model
│       │
│       ├── Bridge/
│       │   ├── QuantumBridge.swift        # IBM Quantum integration
│       │   └── QuantumExecutor.swift      # Execution abstraction protocol
│       │
│       ├── Algorithms/
│       │   └── QuantumAlgorithms.swift    # Bell, Grover, DJ, Simon
│       │
│       ├── DSL/
│       │   └── QuantumCircuitBuilder.swift # SwiftUI-style DSL
│       │
│       ├── Serialization/
│       │   ├── GateDTO.swift              # Qiskit-compatible gate DTO
│       │   └── QuantumCircuitDTO.swift    # Circuit serialization DTO
│       │
│       ├── Experience/                    # Entertainment Logic (NEW)
│       │   ├── QuantumExperience.swift    # Unified API entry point
│       │   ├── DailyChallengeEngine.swift # Daily Pulse patterns
│       │   ├── OracleEngine.swift         # Quantum decision making
│       │   └── QuantumArtMapper.swift     # State-to-art mapping
│       │
│       └── Resources/                     # Multi-language resources
│           ├── en.lproj/
│           ├── ko.lproj/
│           ├── ja.lproj/
│           ├── zh-Hans.lproj/
│           └── de.lproj/
│
├── Apps/
│   └── SuperpositionVisualizer/           # iOS visualization app
│       ├── SuperpositionVisualizer.xcodeproj
│       ├── Assets.xcassets/               # App icons, images
│       │
│       └── SuperpositionVisualizer/
│           ├── SuperpositionVisualizerApp.swift
│           ├── Info.plist
│           ├── LaunchScreen.storyboard
│           │
│           ├── DevMode/
│           │   └── DeveloperModeManager.swift
│           │
│           ├── Premium/
│           │   ├── APIClient.swift        # Backend API communication
│           │   ├── PremiumManager.swift   # StoreKit 2 integration
│           │   ├── ContentAccessManager.swift
│           │   └── PaywallView.swift
│           │
│           ├── Navigation/
│           │   └── QuantumHorizonTabBar.swift
│           │
│           ├── Hubs/
│           │   ├── LabHubView.swift
│           │   ├── PresetsHubView.swift
│           │   ├── FactoryHubView.swift
│           │   ├── MoreHubView.swift
│           │   ├── AcademyHubView.swift
│           │   ├── IndustryHubView.swift
│           │   └── ProfileHubView.swift
│           │
│           ├── Views/
│           │   ├── BlochSphere/
│           │   ├── Common/
│           │   └── Quantum/
│           │
│           ├── DesignSystem/
│           │   └── QuantumHorizonTheme.swift
│           │
│           ├── Onboarding/
│           │   └── OnboardingView.swift
│           │
│           ├── Auth/
│           │   └── AuthenticationView.swift    # Login/SignUp/Reset
│           │
│           └── Localization/
│               └── LocalizationManager.swift
│
├── Website/
│   ├── index.html                         # Product landing page
│   └── support.html                       # Support center
│
├── AppStoreAssets/
│   └── Screenshots/
│
└── Tests/
    └── SwiftQuantumTests/
```

---

## 3. Sources/SwiftQuantum Details

### 3.1 Core Types

#### Complex.swift - Complex Numbers

```swift
struct Complex: Equatable, Hashable, Sendable {
    var real: Double
    var imaginary: Double

    // Computed properties
    var magnitude: Double        // √(re² + im²)
    var magnitudeSquared: Double // re² + im²
    var phase: Double            // arctan(im/re)
    var conjugate: Complex       // a - bi

    // Operators
    static func + (lhs: Complex, rhs: Complex) -> Complex
    static func - (lhs: Complex, rhs: Complex) -> Complex
    static func * (lhs: Complex, rhs: Complex) -> Complex
    static func / (lhs: Complex, rhs: Complex) -> Complex

    // Functions
    static func exp(_ z: Complex) -> Complex  // e^z
}
```

#### Qubit.swift - Single Qubit

```swift
struct Qubit: Equatable, Hashable, Sendable {
    var amplitude0: Complex     // α (|0⟩ coefficient)
    var amplitude1: Complex     // β (|1⟩ coefficient)

    // Standard states
    static let zero             // |0⟩ = [1, 0]ᵀ
    static let one              // |1⟩ = [0, 1]ᵀ
    static let superposition    // |+⟩ = (|0⟩ + |1⟩)/√2

    // Key methods
    func measure() -> Int
    func measureMultiple(count: Int) -> [Int: Int]
    func blochCoordinates() -> (x: Double, y: Double, z: Double)
}
```

#### QuantumGates.swift - Quantum Gates

| Gate | Matrix | Purpose |
|------|--------|---------|
| **Pauli-X** | `[[0,1],[1,0]]` | Bit flip (NOT) |
| **Pauli-Y** | `[[0,-i],[i,0]]` | Y-axis rotation |
| **Pauli-Z** | `[[1,0],[0,-1]]` | Phase flip |
| **Hadamard** | `1/√2 * [[1,1],[1,-1]]` | Superposition |
| **S** | `[[1,0],[0,i]]` | π/2 phase |
| **T** | `[[1,0],[0,e^(iπ/4)]]` | π/4 phase |
| **Rx(θ)** | Rotation matrix | X-axis rotation |
| **Ry(θ)** | Rotation matrix | Y-axis rotation |
| **Rz(θ)** | Rotation matrix | Z-axis rotation |

#### QuantumRegister.swift - Multi-Qubit

```swift
class QuantumRegister: @unchecked Sendable {
    let numberOfQubits: Int
    var amplitudes: [Complex]     // 2^n amplitudes

    // Gate application
    func applyGate(_ gate: QuantumCircuit.Gate, to qubit: Int)
    func applyCNOT(control: Int, target: Int)
    func applyCZ(control: Int, target: Int)
    func applySWAP(qubit1: Int, qubit2: Int)
    func applyToffoli(control1: Int, control2: Int, target: Int)

    // Measurement
    func measureAll() -> [Int]
    func measure(qubit: Int) -> Int
}
```

**Memory Usage:**

| Qubits | State Vector Size | Memory |
|--------|-------------------|--------|
| 5 | 32 | ~512 B |
| 10 | 1,024 | ~16 KB |
| 15 | 32,768 | ~512 KB |
| 20 | 1,048,576 | ~16 MB |

---

### 3.2 Serialization Layer

#### GateDTO.swift - Qiskit-Compatible Gate

```swift
/// Qiskit-compatible gate DTO for network serialization
public struct GateDTO: Codable, Equatable, Sendable {
    /// Qiskit gate name ("h", "x", "cx", "rx", etc.)
    public let name: String

    /// Target qubit indices (0-indexed)
    public let qubits: [Int]

    /// Optional parameters (rotation angles, etc.)
    public let params: [Double]?
}
```

#### QuantumCircuitDTO.swift - Circuit Serialization

```swift
/// Network-transferable quantum circuit DTO
public struct QuantumCircuitDTO: Codable, Equatable, Sendable {
    public let version: String          // "1.0"
    public let name: String?
    public let numberOfQubits: Int
    public let numberOfClassicalBits: Int
    public let gates: [GateDTO]
    public let metadata: CircuitMetadata?
}
```

---

### 3.3 Bridge Layer

#### QuantumExecutor.swift - Execution Abstraction

```swift
protocol QuantumExecutor: Sendable {
    var executorType: ExecutorType { get }
    var name: String { get }
    var isAvailable: Bool { get }
    var maxQubits: Int { get }

    func execute(circuit: BridgeCircuitBuilder, shots: Int) async throws -> ExecutionResult
    func submitJob(circuit: BridgeCircuitBuilder, shots: Int) async throws -> QuantumJob
    func getJobStatus(jobId: String) async throws -> QuantumJob
    func cancelJob(jobId: String) async throws
}

enum ExecutorType {
    case localSimulator      // Local simulation
    case ibmQuantumBridge    // IBM Quantum remote
    case cloud               // Cloud service
}
```

---

### 3.4 Algorithms

| Algorithm | Purpose | Complexity Improvement |
|-----------|---------|------------------------|
| **Bell State** | Entanglement creation | - |
| **Deutsch-Jozsa** | Function characterization | Exponential → Constant |
| **Grover's Search** | Unordered search | O(N) → O(√N) |
| **Simon's Algorithm** | Hidden period | Exponential → Polynomial |

---

### 3.5 Experience Layer (NEW in v2.2.5)

#### DailyChallengeEngine.swift - Daily Pulse Logic

```swift
/// Generates deterministic daily patterns for global user synchronization
public struct DailyChallengeEngine {
    /// O(1) deterministic pattern generation
    public static func generateDailyPattern(userSeed: String) -> (amplitude: Double, phase: Double)

    /// Extended pattern with additional quantum-inspired parameters
    public static func generateExtendedDailyPattern(userSeed: String) -> DailyPatternData

    /// Today's pattern using current UTC date
    public static func generateTodayPattern() -> (amplitude: Double, phase: Double)
}

/// Extended daily pattern data
public struct DailyPatternData: Codable, Equatable, Sendable {
    let amplitude: Double              // 0.0-1.0
    let phase: Double                  // 0.0-2π
    let entanglementStrength: Double   // 0.0-1.0
    let coherenceTime: Double          // 0.0-1.0
    let interferencePattern: Int       // For visual generation
    let luckyQuantumState: Int         // 1-8 (quantum octets)
    let dateSeed: String
}
```

#### OracleEngine.swift - The Oracle Logic

```swift
/// True quantum randomness for entertainment-grade decision making
public final class OracleEngine: @unchecked Sendable {
    /// Consults the oracle with a question (Hadamard + Measure)
    public func consultOracle(question: String) -> OracleResult

    /// Statistical analysis over multiple consultations
    public func consultOracleStatistics(question: String, shots: Int) -> OracleStatistics

    /// Quick boolean decision
    public func quickDecision(question: String) -> Bool
}

/// Oracle consultation result
public struct OracleResult: Codable, Equatable, Sendable {
    let answer: Bool                   // true = Yes, false = No
    let confidence: Double             // 0.0-1.0
    let collapsedCoordinate: CGPoint   // For visualization
    let question: String
    let timestamp: Date
    let quantumState: String           // State at measurement
}
```

#### QuantumArtMapper.swift - Art Data Mapping

```swift
/// Transforms quantum states to visual art parameters
public final class QuantumArtMapper: @unchecked Sendable {
    /// Map single qubit to art parameters
    public func mapToArtParameters(qubit: Qubit) -> ArtData

    /// Map multi-qubit register to art parameters
    public func mapToArtParameters(register: QuantumRegister) -> ArtData

    /// Map circuit execution result
    public func mapToArtParameters(circuit: QuantumCircuit) -> ArtData
}

/// Art parameters derived from quantum states
public struct ArtData: Codable, Equatable, Sendable {
    let primaryHue: Double     // 0.0-1.0 (maps to 0-360°)
    let complexity: Int        // 1-10 (fractal depth)
    let contrast: Double       // 0.0-1.0 (phase variance based)
    let saturation: Double     // 0.0-1.0
    let brightness: Double     // 0.0-1.0
    let quantumSignature: String

    var hexColor: String       // e.g., "#FF6B6B"
    var rgbColor: (red: Double, green: Double, blue: Double)
}
```

**Mapping Logic:**

| Parameter | Source | Algorithm |
|-----------|--------|-----------|
| **Hue** | Most probable basis state | Index normalized to [0, 1] |
| **Complexity** | Entropy | Higher entropy = higher complexity |
| **Contrast** | Phase variance | Larger variance = higher contrast |
| **Saturation** | Probability concentration | Max prob → saturation |
| **Brightness** | Superposition count | More states = brighter |

---

## 4. Apps/SuperpositionVisualizer Details

### 4.1 4-Hub Navigation

#### QuantumHub Enum

```swift
enum QuantumHub: Int, CaseIterable {
    case lab = 0       // Experiment control + measurement + info
    case presets = 1   // Presets + examples
    case bridge = 2    // IBM Quantum connection
    case more = 3      // Learning + industry + profile

    var title: String { ... }
    var localizedTitle: String { ... }  // @MainActor
    var icon: String { ... }
    var accentColor: Color { ... }
}
```

#### Hub View Structure

```
QuantumHorizonView
    │
    ├── LabHubView
    │   ├── BlochSphereView3D (SceneKit)
    │   ├── Mode Selector (Control / Measure)
    │   ├── Probability Controls
    │   ├── Gate Buttons (H, X, Y, Z)
    │   └── Measurement Results
    │
    ├── PresetsHubView
    │   ├── Search Bar
    │   ├── Category Filter
    │   └── Preset Cards Grid
    │
    ├── FactoryHubView (Bridge)
    │   ├── Connection Status
    │   ├── Backend Selection
    │   ├── Quick Actions
    │   └── Job Queue
    │
    └── MoreHubView
        ├── Academy Card → AcademyHubView
        ├── Industry Card → IndustryHubView
        └── Profile Card → ProfileHubView
```

---

### 4.2 Design System

#### QuantumHorizonTheme.swift

**Color Palette:**

```swift
struct QuantumHorizonColors {
    // Miami Sunset Gradient
    static let miamiSunrise: LinearGradient
    static let miamiSunset: LinearGradient
    static let goldCelebration: LinearGradient

    // Primary Colors
    static let quantumCyan = Color(red: 0.0, green: 0.9, blue: 1.0)
    static let quantumPurple = Color(red: 0.6, green: 0.3, blue: 1.0)
    static let quantumPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let quantumGold = Color(red: 1.0, green: 0.75, blue: 0.3)
    static let quantumGreen = Color(red: 0.3, green: 1.0, blue: 0.6)

    // Glassmorphism
    static let glassWhite = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.15)
}
```

---

## 5. File Dependencies Map

### 5.1 Sources/SwiftQuantum Dependencies

```
Foundation
    │
    ├── Complex.swift
    │       │
    │       ├── Qubit.swift
    │       │       │
    │       │       ├── QuantumGates.swift
    │       │       │       │
    │       │       │       ├── QuantumCircuit.swift
    │       │       │       │
    │       │       │       └── QuantumRegister.swift
    │       │       │               │
    │       │       │               ├── QuantumAlgorithms.swift
    │       │       │               │
    │       │       │               └── QuantumBridge.swift
    │       │       │
    │       │       └── QubitVisualizer.swift
    │       │
    │       └── LinearAlgebra.swift ← Accelerate
    │
    ├── Serialization/
    │   ├── GateDTO.swift ← QuantumGates
    │   └── QuantumCircuitDTO.swift ← GateDTO
    │
    └── QuantumLocalizedStrings.swift ← Bundle, Locale

    QuantumExecutor.swift (Protocol - Independent)
    NoiseModel.swift (Protocol - Independent)
    QuantumCircuitBuilder.swift ← QuantumRegister, QuantumGates
```

---

## 6. Data Flow

### 6.1 Quantum State Manipulation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        User Input                            │
│  (Slider manipulation, gate button tap, measure button)      │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  QuantumStateManager                         │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  @Published var qubit: Qubit                        │    │
│  │  @Published var probability0: Double                │    │
│  │  @Published var phase: Double                       │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │ @Published change notification
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    SwiftUI Views                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │BlochSphere3D │  │Probability   │  │ StateInfoCard    │   │
│  │  (SceneKit)  │  │   Display    │  │                  │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Premium Subscription Flow

```
┌─────────────────────────────────────────────────────────────┐
│  1. User taps "Upgrade" in PaywallView                       │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  2. PremiumManager.purchase(product:)                        │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  StoreKit 2 Product.purchase()                      │    │
│  │  → Transaction received                             │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  3. Backend Verification                                     │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  APIClient.shared.verifyTransaction(transactionId)  │    │
│  │  POST /api/v1/payment/verify/transaction            │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  4. Backend → Apple App Store Server API v2                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  JWT authentication (ES256)                         │    │
│  │  Transaction validation                             │    │
│  │  → User subscription activated in DB                │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  5. iOS App receives success response                        │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  PremiumManager.isPremium = true                    │    │
│  │  ContentAccessManager updates access levels         │    │
│  │  UI shows premium badge                             │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Developer Mode System

### 7.1 DeveloperModeManager

```swift
@MainActor
class DeveloperModeManager: ObservableObject {
    static let shared = DeveloperModeManager()

    @Published var isEnabled: Bool = true
    @Published var tapLogs: [TapLogEntry] = []
    @Published var showLogOverlay: Bool = false

    struct TapLogEntry: Identifiable {
        let id = UUID()
        let timestamp: Date
        let screen: String
        let element: String
        let status: TapStatus
    }

    enum TapStatus: String {
        case success = "✅"
        case failed = "❌"
        case comingSoon = "⏳"
        case noAction = "⚠️"
    }

    func log(screen: String, element: String, status: TapStatus)
    func clearLogs()
    func exportLogs() -> String
}
```

---

## 8. Premium System

### 8.1 PremiumManager.swift

```swift
@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    @Published var isPremium: Bool = false
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var products: [Product] = []

    enum SubscriptionTier: String, CaseIterable {
        case free = "Free"
        case pro = "Pro"           // $4.99/month
        case premium = "Premium"   // $9.99/month
    }

    // StoreKit 2
    func loadProducts() async
    func purchase(_ product: Product) async throws -> Transaction?
    func restorePurchases() async

    // Backend verification
    func verifyWithBackend(transactionId: String) async
}
```

### 8.2 Premium Status by Tier

| Screen | Free | Pro | Premium |
|--------|------|-----|---------|
| **Factory** | QPU backends locked | Partial access | Full access |
| **Academy** | Level 1-2 | Level 1-12 | All levels |
| **Industry** | Preview only | Some solutions | Full access |
| **Profile** | "Free" label | "PRO" badge | "PREMIUM" badge |

---

## 9. Backend Integration

### 9.1 APIClient.swift

```swift
actor APIClient {
    static let shared = APIClient()

    // Configuration (set via environment)
    private var baseURL: String
    private var bridgeURL: String

    // Token management
    func setAuthToken(_ token: String?)
    func getAuthToken() -> String?
    func clearAuthToken()

    // Generic request
    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T

    // Payment verification
    func verifyTransaction(transactionId: String) async throws -> VerifyResponse
}
```

### 9.2 Backend Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/payment/verify/transaction` | POST | Apple transaction verification |
| `/api/v1/users/me` | GET | Current user info |
| `/api/v1/users/stats` | GET | User statistics |
| `/api/v1/users/subscription` | GET | Subscription status |
| `/api/v1/quantum/execute` | POST | Quantum circuit execution |
| `/api/v1/quantum/jobs/{id}` | GET | Job status check |

---

## 10. Multi-Language Support

### 10.1 Supported Languages

| Language | Code | Status |
|----------|------|--------|
| English | `en` | Default |
| Korean | `ko` | Full |
| Japanese | `ja` | Full |
| Chinese (Simplified) | `zh-Hans` | Full |
| German | `de` | Full |

### 10.2 LocalizationManager.swift

```swift
@MainActor
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: String = "en"

    var supportedLanguages: [String] {
        ["en", "ko", "ja", "zh-Hans", "de"]
    }

    func setLanguage(_ languageCode: String) {
        currentLanguage = languageCode
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        // Triggers UI refresh
    }

    func string(for key: LocalizedStringKey) -> String {
        // Dynamic localization lookup
    }
}
```

---

## 11. Performance Benchmarks

### 11.1 Computation Performance

| Operation | Time | Notes |
|-----------|------|-------|
| Qubit creation | ~100 ns | Pure state |
| Single gate | ~0.5 µs | Hadamard, Pauli |
| Circuit execution (10 gates) | ~5 µs | Sequential |
| 5-qubit register | ~100 µs | Full state vector |
| Grover (3 qubits) | ~500 µs | Complete algorithm |
| Error correction simulation | ~1 ms | Surface code d=3 |
| 1000-shot measurement | ~25 µs | Parallelized |

### 11.2 Memory Usage

| Qubits | State Vector | Memory |
|--------|--------------|--------|
| 5 | 32 amplitudes | ~512 B |
| 10 | 1,024 amplitudes | ~16 KB |
| 15 | 32,768 amplitudes | ~512 KB |
| 20 | 1,048,576 amplitudes | ~16 MB |

### 11.3 Performance vs NumPy

```
Apple Silicon M-series:
- vDSP vector operations: 400% faster
- Matrix-vector multiply: 350% faster
- Complex number operations: 300% faster
```

---

## 12. Authentication System

### 12.1 AuthenticationView.swift

```swift
struct AuthenticationView: View {
    @ObservedObject var authService = AuthService.shared
    @ObservedObject var localization = LocalizationManager.shared

    enum AuthMode {
        case login
        case signUp
        case forgotPassword
    }

    // Localization helper
    private func L(_ key: String) -> String {
        return localization.string(forKey: key)
    }
}
```

### 12.2 Authentication Localization Keys

| Key | EN | KO |
|-----|----|----|
| `auth.welcome_back` | Welcome Back | 다시 오신 것을 환영합니다 |
| `auth.create_account` | Create Account | 계정 만들기 |
| `auth.email` | Email | 이메일 |
| `auth.password` | Password | 비밀번호 |
| `auth.login` | Login | 로그인 |
| `auth.signup` | Sign Up | 회원가입 |
| `auth.forgot_password` | Forgot Password? | 비밀번호를 잊으셨나요? |

---

## 13. Subscription Paywall System

### 13.1 PaywallView.swift

```swift
struct PaywallView: View {
    enum SubscriptionTier {
        case pro      // $4.99/month, $39.99/year
        case premium  // $9.99/month, $79.99/year
    }

    enum SubscriptionPeriod {
        case monthly
        case yearly   // 33% savings
    }

    @State private var selectedTier: SubscriptionTier = .premium
    @State private var selectedPeriod: SubscriptionPeriod = .yearly
}
```

### 13.2 Subscription Localization Keys

| Key | EN | KO |
|-----|----|----|
| `subscription.title` | Unlock SwiftQuantum | SwiftQuantum 잠금 해제 |
| `subscription.pro` | Pro | Pro |
| `subscription.premium` | Premium | Premium |
| `subscription.monthly` | Monthly | 월간 |
| `subscription.yearly` | Yearly | 연간 |
| `subscription.save_percent` | SAVE 33% | 33% 할인 |
| `subscription.subscribe` | Subscribe | 구독하기 |

---

## Change History

| Version | Date | Changes |
|---------|------|---------|
| 2.2.5 | 2026-01-19 | QuantumExperience entertainment module (DailyChallengeEngine, OracleEngine, QuantumArtMapper) |
| 2.2.4 | 2026-01-18 | IBM Quantum Ecosystem localization, subscription system redesign |
| 2.2.3 | 2026-01-18 | Auth localization, PaywallView redesign, Industry/Circuits UI improvements |
| 2.2.1 | 2026-01-16 | Real-time localization, backend integration, hardcoded values removal |
| 2.2.0 | 2026-01-13 | Backend integration (APIClient), StoreKit 2, ContentAccessManager, PaywallView, German support |
| 2.1.1 | 2026-01-08 | Developer Mode QA/QC system |
| 2.1.0 | 2026-01-06 | Quantum Horizon 2026 UI, 4-Hub navigation, Harvard-MIT research integration |
| 2.0.0 | 2026-01-05 | QuantumBridge integration, multi-qubit support |
| 1.0.0 | 2025-09-28 | Initial release |

---

<div align="center">

**SwiftQuantum v2.2.5**

*The future of quantum computing on iOS - Powered by Harvard-MIT research*

</div>
