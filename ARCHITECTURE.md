# SwiftQuantum v2.2.1 - 전체 아키텍처 문서

> **문서 버전:** 2.2.1
> **최종 업데이트:** 2026-01-16
> **작성자:** Eunmin Park (iOS Quantum Engineering)

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [디렉토리 구조](#2-디렉토리-구조)
3. [Sources/SwiftQuantum 상세](#3-sourcesswiftquantum-상세)
4. [Apps/SuperpositionVisualizer 상세](#4-appssuperpositionvisualizer-상세)
5. [파일 간 의존성 맵](#5-파일-간-의존성-맵)
6. [데이터 흐름](#6-데이터-흐름)
7. [Developer Mode 시스템](#7-developer-mode-시스템)
8. [Premium 시스템](#8-premium-시스템)
9. [Backend 통합](#9-backend-통합)
10. [다국어 지원 시스템](#10-다국어-지원-시스템)
11. [Website 구조](#11-website-구조)
12. [성능 벤치마크](#12-성능-벤치마크)

---

## 1. 프로젝트 개요

### 1.1 핵심 사양

| 항목 | 값 |
|------|-----|
| **프로젝트명** | SwiftQuantum |
| **버전** | 2.2.1 |
| **라이선스** | MIT |
| **플랫폼** | iOS 15+ / macOS 14+ |
| **Swift 버전** | 6.0 |
| **로컬 시뮬레이션** | 최대 20 큐빗 |
| **원격 실행** | IBM Quantum 127 큐빗 (QuantumBridge) |
| **Bundle ID** | com.eunminpark.swiftquantum |
| **지원 언어** | EN, KO, JA, ZH-Hans, DE (5개 언어) |

### 1.2 기술 스택

```
┌─────────────────────────────────────────────────────────────────────┐
│                      Product Layer                                   │
│  ┌──────────────────┐  ┌─────────────────┐  ┌──────────────────┐   │
│  │  Website         │  │  iOS App        │  │  Backend API     │   │
│  │  (Landing/Support│  │  (Visualizer)   │  │  (SwiftQuantum   │   │
│  │   HTML/CSS)      │  │                 │  │   Backend)       │   │
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
│                        Bridge Layer                                  │
│  ┌────────────────────────┐  ┌────────────────────────────────────┐ │
│  │   QuantumExecutor      │  │     QuantumBridge                  │ │
│  │   (Protocol)           │  │     (IBM Quantum)                  │ │
│  └────────────────────────┘  └────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────┤
│                      Serialization Layer                             │
│  ┌────────────────────────┐  ┌────────────────────────────────────┐ │
│  │   GateDTO              │  │     QuantumCircuitDTO              │ │
│  │   (Qiskit-compatible)  │  │     (Network serialization)        │ │
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

## 2. 디렉토리 구조

```
SwiftQuantum/
├── Package.swift                          # SPM 패키지 정의
├── README.md                              # 프로젝트 소개
├── CHANGELOG.md                           # 변경 이력
├── ARCHITECTURE.md                        # 이 문서
│
├── Sources/
│   └── SwiftQuantum/                      # 양자 컴퓨팅 엔진
│       ├── SwiftQuantum.swift             # 모듈 진입점
│       ├── Complex.swift                  # 복소수 구현
│       ├── Qubit.swift                    # 단일 큐빗 상태
│       ├── QuantumGates.swift             # 양자 게이트 구현
│       ├── QuantumCircuit.swift           # 단일 큐빗 회로
│       ├── QuantumRegister.swift          # 다중 큐빗 레지스터
│       ├── QubitVisualizer.swift          # 시각화 유틸리티
│       │
│       ├── Core/
│       │   ├── LinearAlgebra.swift        # 고성능 선형대수 (Accelerate)
│       │   └── NoiseModel.swift           # Harvard-MIT 노이즈 모델
│       │
│       ├── Bridge/
│       │   ├── QuantumBridge.swift        # IBM Quantum 연동
│       │   └── QuantumExecutor.swift      # 실행 추상화 프로토콜
│       │
│       ├── Algorithms/
│       │   └── QuantumAlgorithms.swift    # Bell, Grover, DJ, Simon
│       │
│       ├── DSL/
│       │   └── QuantumCircuitBuilder.swift # SwiftUI 스타일 DSL
│       │
│       ├── Serialization/                 # NEW v2.2.0
│       │   ├── GateDTO.swift              # Qiskit 호환 게이트 DTO
│       │   └── QuantumCircuitDTO.swift    # 회로 직렬화 DTO
│       │
│       ├── Localization/
│       │   └── QuantumLocalizedStrings.swift
│       │
│       └── Resources/                     # 다국어 리소스
│           ├── en.lproj/Localizable.strings
│           ├── ko.lproj/Localizable.strings
│           ├── ja.lproj/Localizable.strings
│           ├── zh-Hans.lproj/Localizable.strings
│           └── de.lproj/Localizable.strings  # NEW v2.2.0
│
├── Apps/
│   └── SuperpositionVisualizer/           # iOS 시각화 앱
│       ├── SuperpositionVisualizer.xcodeproj
│       ├── Assets.xcassets/               # 앱 아이콘, 이미지
│       │   ├── AppIcon.appiconset/        # iOS/macOS 모든 사이즈
│       │   ├── AppLogo.imageset/          # 브랜드 로고
│       │   └── Splash.imageset/           # 스플래시 이미지
│       │
│       └── SuperpositionVisualizer/
│           ├── SuperpositionVisualizerApp.swift
│           ├── Info.plist
│           ├── LaunchScreen.storyboard    # NEW v2.2.1
│           │
│           ├── DevMode/
│           │   └── DeveloperModeManager.swift
│           │
│           ├── Premium/                   # NEW v2.2.0
│           │   ├── APIClient.swift        # Backend API 통신
│           │   ├── PremiumManager.swift   # StoreKit 2 통합
│           │   ├── ContentAccessManager.swift # 콘텐츠 접근 제어
│           │   └── PaywallView.swift      # 구독 UI
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
│           │   │   ├── BlochSphereView.swift
│           │   │   ├── BlochSphereView3D.swift
│           │   │   └── BlochSphereView3D+Advanced.swift
│           │   ├── Common/
│           │   │   ├── StateInfoCard.swift
│           │   │   ├── MeasurementHistogram.swift
│           │   │   ├── SuperpositionView.swift
│           │   │   ├── SplashScreenView.swift
│           │   │   ├── InfoView.swift
│           │   │   └── QuickPresetsView.swift
│           │   └── Quantum/
│           │       ├── QuantumHorizonView.swift
│           │       ├── QuantumStateManager.swift
│           │       ├── QuantumBridgeConnectionView.swift
│           │       ├── QuantumNativeView.swift
│           │       └── ErrorCorrectionView.swift
│           │
│           ├── DesignSystem/
│           │   └── QuantumHorizonTheme.swift
│           │
│           ├── Components/
│           │   ├── EmptyStateView.swift
│           │   └── QAgentView.swift
│           │
│           ├── Examples/
│           │   ├── ExamplesView.swift
│           │   ├── AdvancedExamplesView.swift
│           │   └── IndustrySolutionsView.swift
│           │
│           ├── Onboarding/
│           │   └── OnboardingView.swift
│           │
│           └── Localization/              # NEW v2.2.1
│               └── LocalizationManager.swift
│
├── Website/                               # NEW v2.2.1
│   ├── index.html                         # 제품 랜딩 페이지
│   └── support.html                       # 지원 센터
│
├── AppStoreAssets/                        # 앱스토어 자산
│   ├── AppIcon/
│   │   └── AppIcon_1024x1024.png
│   ├── README.md
│   └── capture_screenshots.sh
│
├── Tests/
│   └── SwiftQuantumTests/
│
└── docs/
```

---

## 3. Sources/SwiftQuantum 상세

### 3.1 Core 타입

#### Complex.swift - 복소수

```swift
struct Complex: Equatable, Hashable, Sendable {
    var real: Double
    var imaginary: Double

    // 계산 속성
    var magnitude: Double        // √(re² + im²)
    var magnitudeSquared: Double // re² + im²
    var phase: Double            // arctan(im/re)
    var conjugate: Complex       // a - bi

    // 연산자
    static func + (lhs: Complex, rhs: Complex) -> Complex
    static func - (lhs: Complex, rhs: Complex) -> Complex
    static func * (lhs: Complex, rhs: Complex) -> Complex
    static func / (lhs: Complex, rhs: Complex) -> Complex

    // 함수
    static func exp(_ z: Complex) -> Complex  // e^z
}
```

**수학적 배경:** 양자 상태의 확률 진폭은 복소수이며, Born 규칙에 의해 `|ψ|² = P(측정)`

---

#### Qubit.swift - 단일 큐빗

```swift
struct Qubit: Equatable, Hashable, Sendable {
    var amplitude0: Complex     // α (|0⟩ 계수)
    var amplitude1: Complex     // β (|1⟩ 계수)

    // 표준 상태
    static let zero             // |0⟩ = [1, 0]ᵀ
    static let one              // |1⟩ = [0, 1]ᵀ
    static let superposition    // |+⟩ = (|0⟩ + |1⟩)/√2
    static let minusSuperposition // |−⟩
    static let iState           // |i⟩ = (|0⟩ + i|1⟩)/√2
    static let minusIState      // |−i⟩

    // 주요 메서드
    func measure() -> Int
    func measureMultiple(count: Int) -> [Int: Int]
    func blochCoordinates() -> (x: Double, y: Double, z: Double)
    func entropy() -> Double
    func purity() -> Double

    static func random() -> Qubit
    static func fromBlochAngles(theta: Double, phi: Double) -> Qubit
}
```

**Bloch 구 좌표:**
```
x = sin(θ) * cos(φ)
y = sin(θ) * sin(φ)
z = cos(θ)
```

---

#### QuantumGates.swift - 양자 게이트

| 게이트 | 행렬 | 용도 |
|--------|------|------|
| **Pauli-X** | `[[0,1],[1,0]]` | 비트 플립 (NOT) |
| **Pauli-Y** | `[[0,-i],[i,0]]` | Y축 회전 |
| **Pauli-Z** | `[[1,0],[0,-1]]` | 위상 플립 |
| **Hadamard** | `1/√2 * [[1,1],[1,-1]]` | 중첩 생성 |
| **S** | `[[1,0],[0,i]]` | π/2 위상 |
| **T** | `[[1,0],[0,e^(iπ/4)]]` | π/4 위상 |
| **Rx(θ)** | 회전 행렬 | X축 회전 |
| **Ry(θ)** | 회전 행렬 | Y축 회전 |
| **Rz(θ)** | 회전 행렬 | Z축 회전 |
| **U3(θ,φ,λ)** | 일반화 행렬 | 임의 단일 큐빗 게이트 |

---

#### QuantumRegister.swift - 다중 큐빗

```swift
class QuantumRegister: @unchecked Sendable {
    let numberOfQubits: Int
    var amplitudes: [Complex]     // 2^n 개의 진폭

    // 게이트 적용
    func applyGate(_ gate: QuantumCircuit.Gate, to qubit: Int)
    func applyCNOT(control: Int, target: Int)
    func applyCZ(control: Int, target: Int)
    func applySWAP(qubit1: Int, qubit2: Int)
    func applyToffoli(control1: Int, control2: Int, target: Int)

    // 측정
    func measureAll() -> [Int]
    func measure(qubit: Int) -> Int
    func getAmplitude(state: Int) -> Complex
}
```

**메모리 사용:**

| 큐빗 수 | 상태 벡터 크기 | 메모리 |
|---------|---------------|--------|
| 5 | 32 | ~512 B |
| 10 | 1,024 | ~16 KB |
| 15 | 32,768 | ~512 KB |
| 20 | 1,048,576 | ~16 MB |

---

### 3.2 Serialization 계층 (NEW v2.2.0)

#### GateDTO.swift - Qiskit 호환 게이트

```swift
/// Qiskit 호환 게이트 DTO
/// 네트워크 직렬화 및 Python 백엔드와 호환성을 위한 구조체
public struct GateDTO: Codable, Equatable, Sendable {
    /// Qiskit 게이트명 ("h", "x", "cx", "rx" 등)
    public let name: String

    /// 대상 큐빗 인덱스 (0-indexed)
    /// - 단일 큐빗: [target]
    /// - 2-큐빗: [control, target] 또는 [qubit1, qubit2]
    /// - 3-큐빗: [control1, control2, target]
    public let qubits: [Int]

    /// 선택적 파라미터 (회전 각도 등)
    public let params: [Double]?
}
```

**지원 게이트 매핑:**

| Swift Gate | GateDTO name | qubits | params |
|------------|--------------|--------|--------|
| Hadamard | "h" | [target] | nil |
| Pauli-X | "x" | [target] | nil |
| Rx(θ) | "rx" | [target] | [θ] |
| CNOT | "cx" | [control, target] | nil |
| Toffoli | "ccx" | [c1, c2, target] | nil |

#### QuantumCircuitDTO.swift - 회로 직렬화

```swift
/// 네트워크 전송용 양자 회로 DTO
public struct QuantumCircuitDTO: Codable, Equatable, Sendable {
    public let version: String          // "1.0"
    public let name: String?
    public let numberOfQubits: Int
    public let numberOfClassicalBits: Int
    public let gates: [GateDTO]
    public let metadata: CircuitMetadata?
}

public struct CircuitMetadata: Codable, Equatable, Sendable {
    public let createdAt: Date?
    public let description: String?
    public let tags: [String]?
}
```

---

### 3.3 Bridge 계층

#### QuantumExecutor.swift - 실행 추상화

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
    case localSimulator      // 로컬 시뮬레이션
    case ibmQuantumBridge    // IBM Quantum 원격
    case cloud               // 클라우드 서비스
}
```

#### QuantumBridge.swift - IBM Quantum 연동

```swift
struct QuantumBridge {
    // QASM 2.0 변환
    static func toQASM(numberOfQubits: Int, gates: [...]) -> String

    // 회로 직렬화
    struct SerializedCircuit: Codable {
        var version: String
        var numberOfQubits: Int
        var gates: [SerializedGate]
        var metadata: CircuitMetadata
    }
}
```

---

### 3.4 알고리즘

| 알고리즘 | 용도 | 복잡도 향상 |
|----------|------|-------------|
| **Bell State** | 얽힘 생성 | - |
| **Deutsch-Jozsa** | 함수 특성 판정 | 지수 → 상수 |
| **Grover's Search** | 무순서 탐색 | O(N) → O(√N) |
| **Simon's Algorithm** | 숨은 주기 | 지수 → 다항 |

---

## 4. Apps/SuperpositionVisualizer 상세

### 4.1 앱 진입점

#### SuperpositionVisualizerApp.swift

```swift
@main
struct SuperpositionVisualizerApp: App {
    @AppStorage("useNewUI") private var useNewUI = true
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some Scene {
        WindowGroup {
            if useNewUI {
                QuantumHorizonView()
                    .environmentObject(localizationManager)
            } else {
                SuperpositionView()
            }
        }
    }
}
```

---

### 4.2 상태 관리

#### QuantumStateManager.swift (MVVM ViewModel)

```swift
@MainActor
class QuantumStateManager: ObservableObject {
    @Published var qubit: Qubit = .zero
    @Published var probability0: Double = 1.0
    @Published var phase: Double = 0.0
    @Published var displayText: String = ""
    @Published var showDisplay: Bool = false

    // 상태 업데이트
    func setQubit(_ newQubit: Qubit)
    func updateState(probability0: Double, phase: Double)
    func setState(_ state: BasicQuantumState)

    // 게이트 적용
    func applyHadamard()
    func applyPauliX()
    func applyPauliY()
    func applyPauliZ()

    // 측정
    func measureQubit()
    func reset()
}
```

---

### 4.3 4-Hub 네비게이션

#### QuantumHub 열거형

```swift
enum QuantumHub: Int, CaseIterable {
    case lab = 0       // 실험 제어 + 측정 + 정보
    case presets = 1   // 프리셋 + 예제
    case bridge = 2    // IBM Quantum 연결
    case more = 3      // 학습 + 산업 + 프로필

    var title: String { ... }
    var icon: String { ... }
    var accentColor: Color { ... }
    var description: String { ... }
}
```

#### Hub 뷰 구조

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

### 4.4 디자인 시스템

#### QuantumHorizonTheme.swift

**색상 팔레트:**

```swift
struct QuantumHorizonColors {
    // Miami Sunset 그래디언트
    static let miamiSunrise: LinearGradient
    static let miamiSunset: LinearGradient
    static let goldCelebration: LinearGradient

    // 주요 색상
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

**컴포넌트:**

```swift
// Glassmorphism 카드
struct BentoCard<Content: View>: View {
    enum BentoSize { case small, medium, large, wide, tall }
}

// 유리 버튼
struct GlassButton: View { ... }

// 통계 표시
struct StatDisplay: View { ... }

// 탭 아이템
struct HubTabItem: View { ... }

// 배경
struct QuantumHorizonBackground: View { ... }

// 애니메이션
struct MiamiWaveAnimation: View { ... }
struct PulsingGlow: ViewModifier { ... }
struct GoldParticleView: View { ... }
```

---

## 5. 파일 간 의존성 맵

### 5.1 Sources/SwiftQuantum 의존성

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
    ├── Serialization/               NEW v2.2.0
    │   ├── GateDTO.swift ← QuantumGates
    │   └── QuantumCircuitDTO.swift ← GateDTO
    │
    └── QuantumLocalizedStrings.swift ← Bundle, Locale

    QuantumExecutor.swift (Protocol - 독립)
    NoiseModel.swift (Protocol - 독립)
    QuantumCircuitBuilder.swift ← QuantumRegister, QuantumGates
```

### 5.2 SuperpositionVisualizer 의존성

```
SwiftUI + SwiftQuantum + StoreKit
    │
    ├── SuperpositionVisualizerApp.swift
    │       │
    │       ├── LocalizationManager.swift (NEW v2.2.1)
    │       │
    │       ├── QuantumHorizonView.swift
    │       │       │
    │       │       ├── QuantumStateManager.swift
    │       │       │
    │       │       ├── DeveloperModeManager.swift
    │       │       │
    │       │       ├── QuantumHorizonTabBar.swift
    │       │       │
    │       │       └── Hub Views
    │       │           ├── LabHubView.swift
    │       │           │   └── BlochSphereView3D.swift ← SceneKit
    │       │           │
    │       │           ├── PresetsHubView.swift
    │       │           │
    │       │           ├── FactoryHubView.swift
    │       │           │   └── QuantumBridgeConnectionView.swift
    │       │           │
    │       │           └── MoreHubView.swift
    │       │               ├── AcademyHubView.swift
    │       │               │   └── ContentAccessManager.swift
    │       │               ├── IndustryHubView.swift
    │       │               └── ProfileHubView.swift
    │       │
    │       ├── Premium/ (NEW v2.2.0)
    │       │   ├── APIClient.swift
    │       │   ├── PremiumManager.swift ← StoreKit 2
    │       │   ├── ContentAccessManager.swift ← PremiumManager
    │       │   └── PaywallView.swift ← PremiumManager
    │       │
    │       └── QuantumHorizonTheme.swift
    │
    └── (구형) SuperpositionView.swift
```

---

## 6. 데이터 흐름

### 6.1 양자 상태 조작 흐름

```
┌─────────────────────────────────────────────────────────────┐
│                        User Input                            │
│  (슬라이더 조작, 게이트 버튼 탭, 측정 버튼)                   │
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
                            │ @Published 변경 알림
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    SwiftUI Views                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │BlochSphere3D │  │Probability   │  │ StateInfoCard    │   │
│  │  (SceneKit)  │  │   Display    │  │                  │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Premium 구독 흐름 (NEW v2.2.0)

```
┌─────────────────────────────────────────────────────────────┐
│  1️⃣ User taps "Upgrade" in PaywallView                      │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  2️⃣ PremiumManager.purchase(product:)                       │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  StoreKit 2 Product.purchase()                      │    │
│  │  → Transaction received                             │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  3️⃣ Backend Verification                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  APIClient.shared.verifyTransaction(transactionId)  │    │
│  │  POST /api/v1/payment/verify/transaction            │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  4️⃣ Backend → Apple App Store Server API v2                 │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  JWT authentication (ES256)                         │    │
│  │  Transaction validation                             │    │
│  │  → User subscription activated in DB                │    │
│  └─────────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  5️⃣ iOS App receives success response                       │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  PremiumManager.isPremium = true                    │    │
│  │  ContentAccessManager updates access levels         │    │
│  │  UI shows premium badge                             │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Developer Mode 시스템

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

    var successCount: Int
    var failedCount: Int
    var comingSoonCount: Int
    var noActionCount: Int
}
```

### 7.2 로깅된 인터랙션

| 화면 | 로깅 요소 | 상태 타입 |
|------|-----------|-----------|
| **Lab** | Mode Selector, Probability Slider, Gate Buttons (H/X/Y/Z), Measure Buttons, Reset | ✅ Success |
| **Presets** | Category Filter, Preset Cards, Search Clear | ✅ Success |
| **Bridge** | Connect/Disconnect, Backend Selection, Deploy, Quick Actions, Job Cancel | ✅/⏳ Premium |
| **Academy** | Level Selection, Start/Review Buttons, Close Detail | ✅/⏳ Locked |
| **Industry** | Solution Cards, ROI Calculate, Pricing Plans | ✅/⏳ Coming Soon |
| **Profile** | Settings Button, Achievements, All Settings Toggles | ✅/⏳ Coming Soon |
| **More** | Academy/Industry/Profile Cards, Language, Reset Tutorial | ✅/⏳ Coming Soon |
| **TabBar** | All 4 Tab Navigations (Lab, Presets, Bridge, More) | ✅ Success |

---

## 8. Premium 시스템

### 8.1 PremiumManager.swift

```swift
@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    @Published var isPremium: Bool = false
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var products: [Product] = []
    @Published var purchaseInProgress: Bool = false

    enum SubscriptionTier: String, CaseIterable {
        case free = "Free"
        case pro = "Pro"           // $4.99/month
        case premium = "Premium"   // $9.99/month
    }

    // StoreKit 2
    func loadProducts() async
    func purchase(_ product: Product) async throws -> Transaction?
    func restorePurchases() async
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T

    // Backend verification
    func verifyWithBackend(transactionId: String) async
}
```

### 8.2 ContentAccessManager.swift (NEW v2.2.0)

```swift
@MainActor
class ContentAccessManager: ObservableObject {
    static let shared = ContentAccessManager()

    @Published var currentTier: PremiumManager.SubscriptionTier = .free

    // Level access (Academy)
    func canAccessLevel(_ level: Int) -> Bool {
        switch currentTier {
        case .free: return level <= 2
        case .pro: return level <= 12
        case .premium: return true
        }
    }

    // Feature access
    var canAccessQuantumBridge: Bool { currentTier != .free }
    var canAccessIndustry: Bool { currentTier == .premium }
    var canAccessAdvancedAlgorithms: Bool { currentTier != .free }
}
```

### 8.3 PaywallView.swift (NEW v2.2.0)

```swift
struct PaywallView: View {
    @ObservedObject var premiumManager = PremiumManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        // 1. Feature comparison (Pro vs Premium)
        // 2. Product selection with yearly savings badge
        // 3. Purchase button with loading state
        // 4. Restore purchases button
        // 5. Legal terms and privacy links
    }
}
```

### 8.4 Premium 상태별 UI 변화

| 화면 | Free 상태 | Pro 상태 | Premium 상태 |
|------|-----------|----------|--------------|
| **Factory** | QPU 백엔드 잠금 🔒 | 일부 접근 가능 | 모든 백엔드 접근 👑 |
| **Academy** | Level 1-2 | Level 1-12 | 모든 레벨 언락 |
| **Industry** | 미리보기만 | 일부 솔루션 | 전체 접근 👑 |
| **Profile** | "Free" 표시 | "PRO" 배지 | "PREMIUM" 배지 |

---

## 9. Backend 통합

### 9.1 APIClient.swift (NEW v2.2.0)

```swift
actor APIClient {
    static let shared = APIClient()

    // Configuration
    #if DEBUG
    private let baseURL = "http://localhost:8000"
    private let bridgeURL = "http://localhost:8001"
    #else
    private let baseURL = "https://api.swiftquantum.tech"
    private let bridgeURL = "https://bridge.swiftquantum.tech"
    #endif

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

### 9.2 Backend 엔드포인트

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/payment/verify/transaction` | POST | Apple 트랜잭션 검증 |
| `/api/v1/users/me` | GET | 현재 사용자 정보 |
| `/api/v1/users/subscription` | GET | 구독 상태 확인 |
| `/api/v1/quantum/execute` | POST | 양자 회로 실행 |
| `/api/v1/quantum/jobs/{id}` | GET | 작업 상태 확인 |

### 9.3 인증 흐름

```
┌─────────────────────────────────────────────────────────────┐
│  iOS App                                                     │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  StoreKit 2 Transaction                               │  │
│  │  → Transaction ID extracted                           │  │
│  └───────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  APIClient.verifyTransaction(transactionId)                  │
│  POST /api/v1/payment/verify/transaction                     │
│  Body: { "transaction_id": "...", "bundle_id": "..." }       │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Backend (SwiftQuantumBackend)                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  1. Generate JWT (ES256) with Apple Key                │  │
│  │  2. Call Apple App Store Server API v2                │  │
│  │  3. Validate transaction status                       │  │
│  │  4. Update user subscription in database              │  │
│  │  5. Return success response                           │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. 다국어 지원 시스템

### 10.1 지원 언어

| 언어 | 코드 | 상태 |
|------|------|------|
| 🇺🇸 English | `en` | ✅ Default |
| 🇰🇷 Korean | `ko` | ✅ |
| 🇯🇵 Japanese | `ja` | ✅ |
| 🇨🇳 Chinese (Simplified) | `zh-Hans` | ✅ |
| 🇩🇪 German | `de` | ✅ NEW v2.2.0 |

### 10.2 LocalizationManager.swift (NEW v2.2.1)

```swift
@MainActor
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: String = "en"
    @Published var refreshTrigger: UUID = UUID()

    var supportedLanguages: [String] {
        ["en", "ko", "ja", "zh-Hans", "de"]
    }

    func setLanguage(_ languageCode: String) {
        currentLanguage = languageCode
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        refreshTrigger = UUID()  // Trigger UI refresh
    }

    func localizedString(_ key: String) -> String {
        // Dynamic localization lookup
    }
}
```

### 10.3 실시간 언어 전환

```swift
// OnboardingView.swift
struct OnboardingView: View {
    @ObservedObject var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack {
            // Language selector
            ForEach(localizationManager.supportedLanguages, id: \.self) { lang in
                Button(action: {
                    localizationManager.setLanguage(lang)
                }) {
                    Text(languageDisplayName(lang))
                }
            }

            // Content that updates immediately
            Text(localizationManager.localizedString("welcome_title"))
        }
        .id(localizationManager.refreshTrigger)  // Force view refresh
    }
}
```

---

## 11. Website 구조

### 11.1 파일 구조 (NEW v2.2.1)

```
Website/
├── index.html      # 제품 랜딩 페이지
└── support.html    # 지원 센터
```

### 11.2 index.html - 랜딩 페이지

**섹션 구성:**
1. **Hero Section**: 앱 프리뷰, 주요 특징 하이라이트
2. **Features Section**: 핵심 기능 소개
3. **Pricing Section**: 구독 티어 비교 (Free / Pro / Premium)
4. **Research Section**: Harvard-MIT 연구 기반 강조
5. **Download Section**: App Store 다운로드 링크
6. **Footer**: 연락처, 소셜 링크

### 11.3 support.html - 지원 센터

**섹션 구성:**
1. **FAQ Section**: 자주 묻는 질문
2. **Contact Form**: 문의 양식
3. **Documentation Links**: 문서 링크
4. **Resources**: 추가 리소스

---

## 12. 성능 벤치마크

### 12.1 연산 성능

| 연산 | 시간 | 비고 |
|------|------|------|
| 큐빗 생성 | ~100 ns | 순수 상태 |
| 단일 게이트 | ~0.5 µs | Hadamard, Pauli |
| 회로 실행 (10 게이트) | ~5 µs | 순차 적용 |
| 5-큐빗 레지스터 | ~100 µs | 전체 상태 벡터 |
| Grover (3 큐빗) | ~500 µs | 완전 알고리즘 |
| 에러 정정 시뮬레이션 | ~1 ms | Surface code d=3 |
| 1000-샷 측정 | ~25 µs | 병렬화 |

### 12.2 메모리 사용량

| 큐빗 수 | 상태 벡터 | 메모리 |
|---------|-----------|--------|
| 5 | 32 진폭 | ~512 B |
| 10 | 1,024 진폭 | ~16 KB |
| 15 | 32,768 진폭 | ~512 KB |
| 20 | 1,048,576 진폭 | ~16 MB |

### 12.3 NumPy 대비 성능

```
Apple Silicon M-series 기준:
- vDSP 벡터 연산: 400% 더 빠름
- 행렬-벡터 곱: 350% 더 빠름
- 복소수 연산: 300% 더 빠름
```

---

## 변경 이력

| 버전 | 날짜 | 변경 내용 |
|------|------|-----------|
| 2.2.1 | 2026-01-16 | Website 추가 (Landing, Support), 앱 아이콘/런치스크린, 실시간 언어 전환, LocalizationManager |
| 2.2.0 | 2026-01-13 | Backend 통합 (APIClient), StoreKit 2 + 백엔드 검증, ContentAccessManager, PaywallView, 독일어 지원, DTO 레이어 |
| 2.1.1 | 2026-01-08 | Developer Mode QA/QC 시스템, DEV 배지 우상단 이동, 전체 버튼 로깅 |
| 2.1.0 | 2026-01-06 | Quantum Horizon 2026 UI, 4-Hub 네비게이션, Harvard-MIT 연구 통합 |
| 2.0.0 | 2026-01-05 | QuantumBridge 연동, 다중 큐빗 지원 |
| 1.2.0 | 2025-12-29 | Quantum Explorer UI 리디자인 |
| 1.1.0 | 2025-09-30 | SuperpositionVisualizer 앱 |
| 1.0.0 | 2025-09-28 | 초기 릴리스 |

---

<div align="center">

**SwiftQuantum v2.2.1**

*iOS 양자 컴퓨팅의 미래 - Harvard-MIT 연구 기반*

[GitHub](https://github.com/Minapak/SwiftQuantum) | [README](README.md) | [CHANGELOG](CHANGELOG.md)

</div>
