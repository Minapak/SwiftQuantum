# SwiftQuantum v2.1.1 - 전체 아키텍처 문서

> **문서 버전:** 2.1.1
> **최종 업데이트:** 2026-01-08
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
9. [성능 벤치마크](#9-성능-벤치마크)

---

## 1. 프로젝트 개요

### 1.1 핵심 사양

| 항목 | 값 |
|------|-----|
| **프로젝트명** | SwiftQuantum |
| **버전** | 2.1.1 |
| **라이선스** | MIT |
| **플랫폼** | iOS 17+ / macOS 14+ |
| **Swift 버전** | 6.0 |
| **로컬 시뮬레이션** | 최대 20 큐빗 |
| **원격 실행** | IBM Quantum 127 큐빗 (QuantumBridge) |

### 1.2 기술 스택

```
┌─────────────────────────────────────────────────────────────┐
│                    SuperpositionVisualizer                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   SwiftUI   │  │  SceneKit   │  │  Quantum Horizon    │  │
│  │    Views    │  │  3D Bloch   │  │  Design System      │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      SwiftQuantum                            │
│  ┌──────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐  │
│  │   Core   │  │   Gates   │  │  Circuit  │  │ Algorithms│  │
│  │ Complex  │  │  Pauli,H  │  │  Builder  │  │ Bell,Grover│ │
│  │  Qubit   │  │  Rx,Ry,Rz │  │  Execute  │  │ DJ,Simon  │  │
│  └──────────┘  └───────────┘  └───────────┘  └───────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      Bridge Layer                            │
│  ┌───────────────────────┐  ┌───────────────────────────┐   │
│  │   QuantumExecutor     │  │     QuantumBridge         │   │
│  │   (Protocol)          │  │     (IBM Quantum)         │   │
│  └───────────────────────┘  └───────────────────────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    Apple Frameworks                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  Foundation  │  │  Accelerate  │  │     Combine      │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. 디렉토리 구조

```
SwiftQuantum/
├── Package.swift                          # SPM 패키지 정의
├── README.md                              # 프로젝트 소개
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
│       └── Localization/
│           └── QuantumLocalizedStrings.swift # 다국어 지원
│
├── Apps/
│   └── SuperpositionVisualizer/           # iOS 시각화 앱
│       └── SuperpositionVisualizer/
│           ├── SuperpositionVisualizerApp.swift  # 앱 진입점
│           ├── QuantumStateManager.swift         # 상태 관리 (MVVM)
│           ├── QuantumHorizonView.swift          # 메인 뷰 (2026 UI)
│           │
│           ├── DevMode/
│           │   └── DeveloperModeManager.swift    # QA/QC 로깅 시스템
│           │
│           ├── Premium/
│           │   └── PremiumManager.swift          # 프리미엄 상태 관리
│           │
│           ├── Navigation/
│           │   └── QuantumHorizonTabBar.swift    # 4-Hub 탭 바
│           │
│           ├── Hubs/
│           │   ├── LabHubView.swift              # 실험 허브
│           │   ├── PresetsHubView.swift          # 프리셋 허브
│           │   ├── FactoryHubView.swift          # 팩토리 허브 (Bridge)
│           │   ├── MoreHubView.swift             # 더보기 허브
│           │   ├── AcademyHubView.swift          # 학습 허브
│           │   ├── IndustryHubView.swift         # 산업 허브
│           │   └── ProfileHubView.swift          # 프로필 허브
│           │
│           ├── DesignSystem/
│           │   └── QuantumHorizonTheme.swift     # Glassmorphism 테마
│           │
│           ├── Components/
│           │   ├── EmptyStateView.swift          # 빈 상태 표시
│           │   └── QAgentView.swift              # AI 어시스턴트
│           │
│           ├── Onboarding/
│           │   └── OnboardingView.swift          # 첫 실행 온보딩
│           │
│           └── [기타 뷰 파일들...]
│
└── Tests/
    └── SwiftQuantumTests/                 # 단위 테스트
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
    func measure() -> Int                     // 확률적 측정
    func measureMultiple(count: Int) -> [Int: Int]
    func blochCoordinates() -> (x: Double, y: Double, z: Double)
    func entropy() -> Double                  // von Neumann 엔트로피
    func purity() -> Double                   // 순수성 (항상 1.0)

    static func random() -> Qubit             // Bloch 구 위 임의 점
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

#### QuantumCircuit.swift - 양자 회로

```swift
class QuantumCircuit {
    var initialState: Qubit
    var gates: [CircuitStep]

    // 회로 구성
    func addGate(_ gate: Gate) -> QuantumCircuit
    func insertGate(_ gate: Gate, at index: Int)
    func removeGate(at index: Int)

    // 실행
    func execute() -> Qubit
    func executeAndMeasure() -> Int
    func measureMultiple(shots: Int) -> [Int: Int]

    // 분석
    func theoreticalProbabilities() -> (prob0: Double, prob1: Double)
    func isUnitary() -> Bool
    func fidelity(with other: QuantumCircuit) -> Double

    // 최적화
    func optimized() -> QuantumCircuit        // 연속 게이트 축소
    func composed(with other: QuantumCircuit) -> QuantumCircuit
    func inverse() -> QuantumCircuit

    // 시각화
    func asciiDiagram() -> String
}
```

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

### 3.2 Bridge 계층

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
    // 회로 직렬화
    struct SerializedCircuit: Codable {
        var version: String
        var numberOfQubits: Int
        var gates: [SerializedGate]
        var metadata: CircuitMetadata
    }

    // QASM 변환
    static func toQASM(numberOfQubits: Int, gates: [...]) -> String
}
```

---

### 3.3 알고리즘

#### QuantumAlgorithms.swift

| 알고리즘 | 용도 | 복잡도 향상 |
|----------|------|-------------|
| **Bell State** | 얽힘 생성 | - |
| **Deutsch-Jozsa** | 함수 특성 판정 | 지수 → 상수 |
| **Grover's Search** | 무순서 탐색 | O(N) → O(√N) |
| **Simon's Algorithm** | 숨은 주기 | 지수 → 다항 |

---

### 3.4 DSL

#### QuantumCircuitBuilder.swift - 선언적 회로 구성

```swift
// 사용 예시
let circuit = DSLQuantumCircuit(numberOfQubits: 2) {
    Hadamard(0)
    CNOT(control: 0, target: 1)
    Measurement()
}
```

---

## 4. Apps/SuperpositionVisualizer 상세

### 4.1 앱 진입점

#### SuperpositionVisualizerApp.swift

```swift
@main
struct SuperpositionVisualizerApp: App {
    @AppStorage("useNewUI") private var useNewUI = true

    var body: some Scene {
        WindowGroup {
            if useNewUI {
                QuantumHorizonView()      // 2026 신규 UI
            } else {
                SuperpositionView()       // 구형 UI
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

    // 배경
    static let deepSpace: LinearGradient
    static let cosmicDark: LinearGradient

    // Glassmorphism
    static let glassWhite = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.15)
}
```

**타이포그래피:**

```swift
struct QuantumHorizonTypography {
    static func heroTitle(_ size: CGFloat = 48) -> Font
    static func sectionTitle(_ size: CGFloat = 28) -> Font
    static func cardTitle(_ size: CGFloat = 18) -> Font
    static func body(_ size: CGFloat = 16) -> Font
    static func caption(_ size: CGFloat = 12) -> Font
    static func largeNumber(_ size: CGFloat = 56) -> Font
    static func statNumber(_ size: CGFloat = 32) -> Font
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
    └── QuantumLocalizedStrings.swift ← Bundle, Locale

    QuantumExecutor.swift (Protocol - 독립)
    NoiseModel.swift (Protocol - 독립)
    QuantumCircuitBuilder.swift ← QuantumRegister, QuantumGates
```

### 5.2 SuperpositionVisualizer 의존성

```
SwiftUI + SwiftQuantum
    │
    ├── SuperpositionVisualizerApp.swift
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
    │       │               ├── IndustryHubView.swift
    │       │               └── ProfileHubView.swift
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
│                                                              │
│  func updateState(probability0:, phase:) {                   │
│      let alpha = sqrt(probability0)                          │
│      let beta = sqrt(1 - probability0) * exp(i * phase)      │
│      qubit = Qubit(alpha, beta).normalized()                 │
│  }                                                           │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ @Published 변경 알림
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    SwiftUI Views                             │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │BlochSphere3D │  │Probability   │  │ StateInfoCard    │   │
│  │  (SceneKit)  │  │   Display    │  │                  │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
│         │                 │                   │              │
│         ▼                 ▼                   ▼              │
│    3D 벡터 갱신      진폭 표시 갱신      상태 정보 갱신       │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 게이트 적용 흐름

```
사용자 게이트 선택 (H, X, Y, Z)
            │
            ▼
┌─────────────────────────────────────────┐
│  DeveloperModeManager.log(...)          │  ← DevMode 로깅
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  QuantumStateManager.applyHadamard()    │
│  {                                      │
│      let newQubit = QuantumGates        │
│          .hadamard(qubit)               │
│      setQubit(newQubit)                 │
│  }                                      │
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  QuantumGates.hadamard(_ qubit)         │
│  {                                      │
│      // H = 1/√2 * [[1,1],[1,-1]]       │
│      let a0 = (α + β) / √2             │
│      let a1 = (α - β) / √2             │
│      return Qubit(a0, a1)               │
│  }                                      │
└────────────────────┬────────────────────┘
                     │
                     ▼
           UI 자동 갱신 (SwiftUI)
```

### 6.3 측정 흐름

```
측정 버튼 탭
      │
      ▼
┌─────────────────────────────────────────┐
│  DeveloperModeManager.log(...)          │
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  let result = qubit.measure()           │
│  {                                      │
│      // Born 규칙: P(0) = |α|²          │
│      let p0 = amplitude0.magnitudeSquared│
│      let random = Double.random(in: 0...1)│
│      return random < p0 ? 0 : 1         │
│  }                                      │
└────────────────────┬────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────┐
│  상태 붕괴 (State Collapse)             │
│  if result == 0 {                       │
│      qubit = Qubit.zero                 │
│  } else {                               │
│      qubit = Qubit.one                  │
│  }                                      │
└────────────────────┬────────────────────┘
                     │
                     ▼
       UI 갱신 + 결과 히스토그램 업데이트
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
        case success = "✅"      // 정상 동작
        case failed = "❌"       // 실패
        case comingSoon = "⏳"   // 미구현
        case noAction = "⚠️"    // 액션 없음
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

### 7.3 Developer Mode Badge

```swift
struct DeveloperModeBadge: View {
    @ObservedObject var devMode = DeveloperModeManager.shared
    @State private var isPulsing = false

    // 위치: 오른쪽 상단
    // 기능:
    //   - 빨간 펄싱 인디케이터
    //   - 로그 카운트 표시 [N]
    //   - 탭하면 로그 오버레이 표시
}
```

---

## 8. Premium 시스템

### 8.1 PremiumManager.swift

**파일 위치:** `Apps/SuperpositionVisualizer/SuperpositionVisualizer/Premium/PremiumManager.swift`

프리미엄 구독 상태를 전역적으로 관리하는 싱글톤 클래스입니다.

```swift
@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    @Published var isPremium: Bool = false           // 프리미엄 활성화 상태
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var expiryDate: Date? = nil

    // 구독 티어
    enum SubscriptionTier: String, CaseIterable {
        case free = "Free"
        case premium = "Premium"        // $9.99/month
        case enterprise = "Enterprise"  // Contact Sales
    }

    // 기능 체크 속성
    var canUseQuantumBridge: Bool      // QPU 연결
    var canUseErrorCorrection: Bool    // 에러 정정 시뮬레이션
    var hasFullAcademyAccess: Bool     // 전체 Academy 코스
    var hasIndustryAccess: Bool        // Industry 솔루션

    // 액션
    func upgradeToPremium()            // 프리미엄 활성화
    func downgradeToFree()             // 무료로 다운그레이드
    func togglePremium()               // 토글 (테스트용)
}
```

### 8.2 Premium 기능 제어 흐름

```
┌────────────────────────────────────────────────────────────────┐
│                    PremiumManager.shared                        │
│                     (Singleton)                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  @Published var isPremium: Bool                          │  │
│  │  (UserDefaults 지속성 저장)                               │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────┬──────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┬─────────────────┐
          │               │               │                 │
          ▼               ▼               ▼                 ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ FactoryHubView  │ │AcademyHubView│ │IndustryHubView│ │ProfileHubView│
│                 │ │              │ │              │ │              │
│ • QPU 연결     │ │ • 잠긴 레벨  │ │ • 프리미엄   │ │ • 상태 표시  │
│ • 백엔드 선택  │ │   언락       │ │   솔루션     │ │ • 토글 기능  │
│ • Quick Actions│ │ • 모든 코스  │ │   접근       │ │              │
└────────┬────────┘ └──────┬───────┘ └──────┬───────┘ └──────┬───────┘
         │                 │                │                 │
         └─────────────────┴────────────────┴─────────────────┘
                                   │
                     ┌─────────────┴──────────────┐
                     │   Premium Sheets           │
                     │   (업그레이드 UI)           │
                     │   • FactoryPremiumSheet    │
                     │   • AcademyPremiumSheet    │
                     │   • IndustryPremiumSheet   │
                     │   • ProfilePremiumSheet    │
                     │                            │
                     │   Upgrade 버튼 →           │
                     │   PremiumManager.shared    │
                     │     .upgradeToPremium()    │
                     └────────────────────────────┘
```

### 8.3 Premium 상태별 UI 변화

| 화면 | Free 상태 | Premium 상태 |
|------|-----------|--------------|
| **Factory** | QPU 백엔드 잠금 (🔒) | 모든 백엔드 접근 가능 (👑) |
| **Academy** | Level 9+ 잠금 | 모든 12+ 레벨 언락 (UNLOCKED 배지) |
| **Industry** | 프리미엄 솔루션 흐림 처리 | 모든 솔루션 접근 (👑 배지) |
| **Profile** | "Free" 표시 | "PREMIUM" 배지 + 왕관 아이콘 |

### 8.4 Premium Sheet 구조

각 Hub에서 프리미엄 기능 접근 시 표시되는 업그레이드 시트:

```swift
struct [Hub]PremiumSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var showSuccessView = false

    var body: some View {
        // 1. 기능 설명 아이콘 및 텍스트
        // 2. 프리미엄 기능 목록 (체크마크)
        // 3. "Upgrade - $9.99/month" 버튼
        //    → premiumManager.upgradeToPremium()
        // 4. 성공 시 UpgradeSuccessView 표시
    }
}
```

### 8.5 UpgradeSuccessView

프리미엄 활성화 성공 시 표시되는 축하 화면:

```swift
struct UpgradeSuccessView: View {
    // 애니메이션:
    // 1. 황금 왕관 아이콘 확대
    // 2. "Welcome to Premium!" 텍스트
    // 3. 언락된 기능 목록 페이드인
    // 4. "Get Started" 버튼
}
```

### 8.6 DevMode 연동

모든 프리미엄 관련 인터랙션은 DeveloperModeManager로 로깅됩니다:

```swift
// 업그레이드 버튼
DeveloperModeManager.shared.log(
    screen: "Premium Sheet",
    element: "Upgrade Button - ACTIVATED",
    status: .success
)

// 프리미엄 기능 접근 시도 (Free 사용자)
DeveloperModeManager.shared.log(
    screen: "Bridge",
    element: "Backend: IBM Brisbane (Premium)",
    status: .comingSoon
)

// 프리미엄 토글 (Profile에서)
DeveloperModeManager.shared.log(
    screen: "Profile",
    element: "Settings: Premium Status - Toggle OFF",
    status: .success
)
```

---

## 9. 성능 벤치마크

### 9.1 연산 성능

| 연산 | 시간 | 비고 |
|------|------|------|
| 큐빗 생성 | ~100 ns | 순수 상태 |
| 단일 게이트 | ~0.5 µs | Hadamard, Pauli |
| 회로 실행 (10 게이트) | ~5 µs | 순차 적용 |
| 5-큐빗 레지스터 | ~100 µs | 전체 상태 벡터 |
| Grover (3 큐빗) | ~500 µs | 완전 알고리즘 |
| 에러 정정 시뮬레이션 | ~1 ms | Surface code d=3 |
| 1000-샷 측정 | ~25 µs | 병렬화 |

### 9.2 메모리 사용량

| 큐빗 수 | 상태 벡터 | 메모리 |
|---------|-----------|--------|
| 5 | 32 진폭 | ~512 B |
| 10 | 1,024 진폭 | ~16 KB |
| 15 | 32,768 진폭 | ~512 KB |
| 20 | 1,048,576 진폭 | ~16 MB |

### 9.3 NumPy 대비 성능

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
| 2.1.1 | 2026-01-08 | Developer Mode QA/QC 시스템, DEV 배지 우상단 이동, 전체 버튼 로깅 |
| 2.1.0 | 2026-01-06 | Quantum Horizon 2026 UI, 4-Hub 네비게이션, Harvard-MIT 연구 통합 |
| 2.0.0 | 2025-12-01 | QuantumBridge 연동, 다중 큐빗 지원 |
| 1.0.0 | 2025-06-01 | 초기 릴리스 |

---

<div align="center">

**SwiftQuantum v2.1.1**

*iOS 양자 컴퓨팅의 미래 - Harvard-MIT 연구 기반*

[GitHub](https://github.com/Minapak/SwiftQuantum) | [README](README.md)

</div>
