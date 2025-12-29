# SwiftQuantum 🌀⚛️

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2014%2B%20%7C%20macOS%2014%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**Apple 플랫폼을 위한 순수 Swift 양자 컴퓨팅 라이브러리** - 양자 역학의 힘을 iOS에 가져오세요!

> 🎓 양자 컴퓨팅 개념 학습에 완벽
> 
> 🚀 프로덕션 준비된 양자 시뮬레이션
> 
> 📱 인터랙티브 3D 블로흐 구면이 있는 아름다운 iOS Superposition Visualizer 앱

---

## ✨ 주요 특징

### 🎯 핵심 양자 연산
- **양자 상태**: 단일 큐비트 양자 상태 생성 및 조작
- **복소수**: 완전한 복소수 산술 및 위상 계산
- **양자 게이트**: 완전한 단일 큐비트 게이트 세트 (Pauli-X, Y, Z, Hadamard, Phase, T)
- **측정**: 통계적 및 확률적 측정 연산
- **양자 회로**: 여러 게이트를 사용한 회로 구축 및 실행

### 📊 고급 기능
- **블로흐 구면**: 양자 상태의 3D 기하학적 표현
- **상태 시각화**: ASCII 아트 및 텍스트 기반 양자 상태 표시
- **얽힘 준비**: 다중 큐비트 시스템을 위한 아키텍처
- **성능**: ~1µs 게이트 연산으로 최적화
- **인터랙티브 예제**: 5개의 동작하는 양자 컴퓨팅 시연

### 📱 iOS Superposition Visualizer 앱
- **인터랙티브 3D 블로흐 구면**: 실시간 업데이트가 있는 투명한 3D 시각화 ✨
- **6개의 인터랙티브 탭**: 포괄적인 양자 컴퓨팅 탐색
- **터치 기반 회전**: 양자 상태를 탐색하기 위한 직관적인 제스처
- **라이브 측정**: 애니메이션 히스토그램을 사용한 양자 측정 수행
- **프리셋 상태**: 표준 양자 상태에 빠른 접근 (|0⟩, |1⟩, |+⟩, |−⟩)
- **교육 예제**: 5개의 양자 컴퓨팅 시연
- **아름다운 UI**: 부드러운 애니메이션이 있는 다크 모드 양자 테마 인터페이스

---

## 📱 Superposition Visualizer 앱 (v1.1) ✨

6개의 인터랙티브 탭이 있는 포괄적인 양자 컴퓨팅 시각화 앱!

### 🎛️ 탭 1: 3D 보기 (블로흐 구면)
**인터랙티브 양자 상태 시각화**

```
특징:
├─ 실시간 3D 구면 렌더링
├─ 터치 기반 회전 (손가락으로 스와이프)
├─ 핀치로 줌
├─ 명확한 시각화를 위한 투명한 구면
├─ 와이어프레임 그리드 및 색상이 있는 축
├─ 상태 벡터 애니메이션
├─ 자동 리셋 버튼
└─ 부드러운 60fps 애니메이션
```

### 🎚️ 탭 2: 컨트롤
**실시간 양자 상태 조작**

```
확률 제어 (P(|0⟩)):
├─ 인터랙티브 슬라이더 (0.0 → 1.0)
├─ 표시: P(|0⟩) 및 P(|1⟩) 백분율
├─ 시각적 확률 막대 (파란색 및 빨간색)
├─ 실시간 블로흐 구면 업데이트
└─ 부드러운 애니메이션

위상 제어 (상대 위상):
├─ 인터랙티브 슬라이더 (0 → 2π)
├─ 라디안 및 도 표시
├─ 시각적 위상 원 표현
├─ 위상 화살표 시각화
└─ 실시간 상태 업데이트
```

### 📊 탭 3: 측정
**양자 측정 및 통계 분석**

```
측정 연산:
├─ 단일 측정
│  └─ 단일 양자 붕괴 관찰
├─ 1000회 측정
│  └─ 히스토그램을 사용한 통계적 측정
└─ 결과 지우기 버튼

결과 표시:
├─ 히스토그램 시각화
│  ├─ |0⟩ 개수 (파란색 막대)
│  └─ |1⟩ 개수 (빨간색 막대)
├─ 통계 분석
│  ├─ 총 측정 수
│  ├─ 측정된 P(|0⟩)
│  ├─ 예상 P(|0⟩)
│  └─ 오차 계산
└─ 색상으로 코딩된 품질 지표
```

### ⭐ 탭 4: 프리셋
**표준 양자 상태에 빠른 접근**

```
프리셋 버튼:
├─ |0⟩ 상태 (P = 1.0)
├─ |1⟩ 상태 (P = 0.0)
├─ 동일 중첩 (P = 0.5, phase = 0)
├─ +|⟩ 상태 (P = 0.5, phase = 0)
└─ −|⟩ 상태 (P = 0.5, phase = π)

한 번의 클릭으로 적용:
└─ 대상 상태로 부드러운 애니메이션
```

### 📖 탭 5: 정보
**포괄적인 양자 상태 정보**

```
양자 상태 카드:
├─ 현재 상태 공식 |ψ⟩
├─ α 및 β 진폭
└─ 위상 정보

블로흐 좌표 카드:
├─ X 좌표
├─ Y 좌표
└─ Z 좌표

양자 개념 정보:
└─ 중첩에 대한 교육 텍스트
```

### 🧪 탭 6: 예제 (개선됨!)
**최적화된 레이아웃이 있는 5가지 인터랙티브 양자 컴퓨팅 시연**

#### 레이아웃: 2행 그리드 시스템

```
행 1 (3개 버튼 - 전체 너비):
├─ 기본 연산      │ 양자 게이트   │ 랜덤 숫자
└─ [50% 너비]    │ [50% 너비]    │ [반응형]

행 2 (2개 버튼 + 스페이서):
├─ 알고리즘      │ 응용         │ 스페이서
└─ [~45% 너비]  │ [~45% 너비]  │ [유연함]
```

#### 예제 1️⃣: 기본 연산
```
시연: 기본 양자 역학

특징:
├─ 상태 선택기 (|0⟩, |1⟩, |+⟩, |−⟩)
├─ 실시간 확률 표시
├─ 시각적 확률 막대 (2×2 그리드 레이아웃)
├─ 1000회 샷에 대한 측정 버튼
└─ 통계 분석
  ├─ 측정 개수
  ├─ 총 샷
  └─ 백분율 계산

교육적 가치:
└─ 큐비트 상태 및 측정 이해
```

#### 예제 2️⃣: 양자 게이트
```
시연: 양자 게이트 연산

특징:
├─ 입력 상태 선택 (3개 버튼 그리드)
├─ 게이트 선택 (4개 스크롤 가능 옵션)
│  ├─ H (Hadamard) - 중첩 생성
│  ├─ X (Pauli-X) - 비트 플립
│  ├─ Z (Pauli-Z) - 위상 플립
│  └─ S (위상 게이트) - π/2 위상 시프트
├─ 출력 시각화
│  ├─ 결과 양자 상태
│  ├─ 확률 표시
│  └─ 게이트 설명
└─ 상태 변환 세부 정보

교육적 가치:
└─ 양자 게이트가 상태를 어떻게 변환하는지 학습
```

#### 예제 3️⃣: 랜덤 숫자 생성
```
시연: 양자 난수 생성기

특징:
├─ 랜덤 정수 생성 (1-100)
├─ 양자 UUID 생성
├─ 양자 엔트로피 소스
├─ 품질 메트릭
└─ 시각화

교육적 가치:
├─ 양자 무작위성 이해
└─ 실용적인 양자 컴퓨팅 응용
```

#### 예제 4️⃣: Deutsch-Jozsa 알고리즘
```
시연: 지수 속도 향상이 있는 양자 알고리즘

특징:
├─ 알고리즘 구현
│  ├─ 상수 함수 감지
│  └─ 균형 함수 감지
├─ 함수 타입 선택기
├─ 알고리즘 정보
│  ├─ 함수 타입 표시
│  ├─ 양자 쿼리: 1
│  └─ 고전적 쿼리: 2
├─ 알고리즘 실행 버튼
└─ 결과 분석

교육적 가치:
├─ 지수 속도 향상이 있는 첫 번째 양자 알고리즘
├─ 양자 병렬성 이해
└─ 양자 간섭 학습
```

#### 예제 5️⃣: 응용 및 최적화
```
시연: 실제 양자 컴퓨팅 응용

특징:
├─ 최적화 문제
│  ├─ 함수: f(x) = (x-2)² + 1
│  ├─ 목표: 최솟값 찾기
│  ├─ 시각적 표현
│  └─ 수학 공식 표시
├─ 최적화 실행 버튼
├─ 결과 표시
│  ├─ 찾은 최적 x 값
│  ├─ 계산된 최소 f(x)
│  ├─ 양자 vs 고전적 비교
│  └─ 속도 향상 요인
└─ 인터랙티브 조정

교육적 가치:
├─ 실용적인 양자 컴퓨팅 사용 사례
├─ 양자 속도 향상을 사용한 최적화
└─ 양자 이점 이해
```

### 🎛️ 탭 구조 업데이트 (v1.1.1)

**이전 레이아웃 문제:**
- 단일 수평 ScrollView with 5개 버튼
- 더 작은 화면에서 버튼이 압축되고 오버플로우
- iPhone SE에서 텍스트 절단 문제

**개선된 레이아웃:**
```swift
// SuperpositionView 탭 선택기
private var tabSelector: some View {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
            // 5개 TabButton with 최적화된 간격
            TabButton(...) // Controls
            TabButton(...) // Measure
            TabButton(...) // Presets
            TabButton(...) // Info
            TabButton(...) // Examples
            
            Spacer().frame(width: 8)  // 후행 스페이서
        }
        .padding(.horizontal)
    }
}

// TabButton 컴포넌트
struct TabButton: View {
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .frame(minWidth: 70)           // 최대가 아닌 최소 너비
            .padding(.vertical, 12)
            .padding(.horizontal, 8)       // 수평 패딩 추가
            .background(isSelected ? Color.cyan.opacity(0.2) : Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}
```

**이점:**
✅ 모든 버튼이 한 줄에 표시
✅ 화면 크기에 반응형
✅ 더 나은 터치 대상 (70pt 최소 너비)
✅ 탭 간 일관된 간격
✅ 텍스트 절단 없음
✅ 유연한 레이아웃 시스템

---

## 🚀 빠른 시작

### 설치

#### Swift Package Manager (권장)

`Package.swift`에 SwiftQuantum을 추가하세요:

```swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "1.0.0")
]
```

또는 Xcode에서:
1. File → Add Package Dependencies...
2. 입력: `https://github.com/Minapak/SwiftQuantum.git`
3. "Add Package" 클릭

### 기본 사용법

```swift
import SwiftQuantum
import SwiftUI

// 중첩 상태의 큐비트 생성
let qubit = Qubit.superposition
print("Probability of |0⟩: \(qubit.probability0)")  // 0.5

// 양자 게이트 적용
let circuit = QuantumCircuit(qubit: qubit)
circuit.addGate(.hadamard)
circuit.addGate(.pauliX)

// 실행 및 측정
let result = circuit.execute()
let measurement = result.measure()
print("Measured: |\(measurement)⟩")

// 3D 블로흐 구면에 시각화
struct ContentView: View {
    let qubit = Qubit.superposition
    
    var body: some View {
        VStack {
            BlochSphereView3D(qubit: qubit)
                .frame(height: 400)
            
            Text("P(|0⟩) = \(String(format: "%.2f", qubit.probability0))")
                .font(.title2)
        }
    }
}
```

### Superposition Visualizer 앱 실행

```bash
# 앱 디렉토리로 이동
cd ~/SwiftQuantum/Apps/SuperpositionVisualizer

# Xcode에서 열기
open SuperpositionVisualizer.xcodeproj

# 시뮬레이터 또는 기기에서 실행 (Cmd + R)
```

**최소 iOS 버전**: iOS 14.0
**지원 기기**: iPhone, iPad
**성능**: iPhone 13 이상에서 60fps

---

## 🏗️ 아키텍처

### 핵심 컴포넌트

```
SwiftQuantum/
├── 📄 README.md                          # 메인 문서
├── 📄 Package.swift                      # 패키지 정의
│
├── 📁 Sources/SwiftQuantum/              # 핵심 양자 컴퓨팅 라이브러리
│   ├── Complex.swift                     # 복소수 산술
│   ├── Qubit.swift                       # 단일 큐비트 양자 상태
│   ├── QuantumGates.swift                # 양자 게이트 연산
│   ├── QuantumCircuit.swift              # 회로 구축 및 실행
│   ├── QubitVisualizer.swift             # 상태 시각화 도구
│   └── SwiftQuantum.swift                # 공개 API
│
├── 📁 Apps/SuperpositionVisualizer/      # 인터랙티브 iOS 앱
│   ├── 📁 SuperpositionVisualizer/       # 메인 앱 타겟
│   │   ├── SuperpositionVisualizerApp.swift
│   │   ├── Preview Content/
│   │   ├── Assets/                       # 이미지, 색상 등
│   │   │
│   │   └── Views/
│   │       ├── SuperpositionView.swift       (6-탭 메인 보기)
│   │       │   ├─ 탭 1: 3D 블로흐 구면
│   │       │   ├─ 탭 2: 컨트롤 (확률 & 위상)
│   │       │   ├─ 탭 3: 측정 (단일 & 배치)
│   │       │   ├─ 탭 4: 프리셋 (5개 프리셋 상태)
│   │       │   ├─ 탭 5: 정보 (상태 세부 정보)
│   │       │   └─ 탭 6: 예제 (5개 시연)
│   │       │
│   │       ├── ExamplesView.swift            (5개 인터랙티브 예제)
│   │       │   ├─ ExampleButton 컴포넌트
│   │       │   ├─ BasicOperationsExample
│   │       │   ├─ QuantumGatesExample
│   │       │   ├─ RandomNumberExample
│   │       │   ├─ AlgorithmExample
│   │       │   └─ ApplicationsExample
│   │       │
│   │       ├── BlochSphereView.swift         (3D 시각화)
│   │       ├── BlochSphereView3D.swift       (향상된 3D)
│   │       ├── BlochSpher...D+Advanced.swift (구성)
│   │       ├── InfoView.swift
│   │       ├── MeasurementHistogram.swift
│   │       ├── QuickPresetaView.swift
│   │       ├── StateInfoCard.swift
│   │       └── (컴포넌트 파일)
│   │
│   └── 📁 SuperpositionVisualizerTests/  # 앱 단위 테스트
│
├── 📁 Examples/                          # 독립 실행형 예제
│   ├── AdvancedQuantumExamples.swift     # 고급 알고리즘
│   ├── BasicQuantumOperations.swift      # 시작하기
│   ├── DocumentationGenerator.swift      # 문서 생성
│   ├── QuantumAlgorithmTutorials.swift   # 튜토리얼 구현
│   ├── QuantumApplications.swift         # 실제 응용
│   ├── RunTutorials.swift                # 튜토리얼 실행기
│   └── SuperpositionPlayground.swift     # 인터랙티브 플레이그라운드
│
├── 📁 Tests/                             # 핵심 라이브러리 테스트
│
├── 📁 docs/                              # 문서
│   ├── QUICK_REFERENCE_EN.md
│   ├── COMPLETE_INTEGRATION_GUIDE_EN.md
│   ├── USAGE_EXAMPLES_EN.md
│   └── ... (기타 문서)
│
└── (설정 파일: CHANGELOG, LICENSE 등)
```

---

## 📊 성능

### iPhone 13 Pro의 벤치마크

| 연산 | 시간 | 참고 |
|------|------|------|
| 큐비트 생성 | ~100ns | 순수 상태 초기화 |
| 단일 게이트 | ~1µs | Hadamard, Pauli 게이트 |
| 회로 (10 게이트) | ~10µs | 순차 실행 |
| 측정 (1000x) | ~50µs | 통계 샘플링 |
| 블로흐 좌표 | ~200ns | 좌표 계산 |
| 3D 구면 렌더링 | 8-12ms | iPhone 13 이상에서 60fps |

### 기기 지원

| 기기 | iOS 지원 | 3D 성능 |
|------|---------|--------|
| iPhone 15+ | ✅ | 우수 ⭐⭐⭐⭐⭐ |
| iPhone 14 | ✅ | 우수 ⭐⭐⭐⭐ |
| iPhone 13 | ✅ | 우수 ⭐⭐⭐⭐ |
| iPhone 12 | ✅ | 좋음 ⭐⭐⭐ |
| iPhone 11 | ✅ | 좋음 ⭐⭐⭐ |
| iPad (6th+) | ✅ | 우수 ⭐⭐⭐⭐⭐ |

---

## 🗺️ 로드맵

### 버전 1.1 (릴리스됨 ✅)
- [x] 3D 블로흐 구면 시각화
- [x] 5개 시연이 있는 인터랙티브 예제 탭
- [x] SuperpositionView를 위한 최적화된 탭 레이아웃
- [x] 2행 그리드 시스템을 사용한 개선된 ExamplesView

### 버전 1.2 (Q1 2026)
- [ ] 다중 큐비트 지원 (2 큐비트 시스템)
- [ ] 양자 얽힘 시각화
- [ ] CNOT 및 제어 게이트
- [ ] 고급 양자 알고리즘
  - [ ] Grover의 검색 알고리즘
  - [ ] 양자 푸리에 변환
  - [ ] 위상 추정

### 버전 1.3 (Q2 2026)
- [ ] 노이즈 모델
- [ ] 디코히어런스 시뮬레이션
- [ ] 양자 오류 수정
- [ ] 3D 지원이 있는 macOS 앱

### 버전 2.0 (Q3 2026)
- [ ] 다중 큐비트 회로 (최대 10 큐비트)
- [ ] 클라우드 양자 컴퓨팅 통합
- [ ] 확장된 시각화 옵션
- [ ] 성능 최적화

---

## 📄 라이선스

SwiftQuantum은 MIT 라이선스 하에 릴리스됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참조하세요.

```
MIT 라이선스

저작권 (c) 2025 Eunmin Park

이 소프트웨어 및 관련 문서 파일("소프트웨어")을 사용, 
복사, 수정, 병합, 게시, 배포, 부분 라이선스 및/또는 판매할 수 있는 권한을 
어떤 제한 없이 모든 사람에게 무료로 부여합니다.
단, 다음 조건을 따라야 합니다:

위의 저작권 공지 및 이 허가 공지는 소프트웨어의 모든 사본 또는 상당한 부분에 
포함되어야 합니다.

소프트웨어는 "있는 그대로" 제공되며, 어떤 종류의 명시적 또는 묵시적 보증도 없습니다.
```

---

## 🙏 감사의 말

- Qiskit, Cirq 및 기타 양자 컴퓨팅 프레임워크에서 영감
- Swift 커뮤니티에 특별한 감사
- 양자 컴퓨팅 교육을 위한 사랑으로 구축
- 3D 블로흐 구면 시각화는 SceneKit으로 구현
- 교육 예제는 양자 컴퓨팅 선구자들에게 영감

---

## 📞 연락처 및 지원

- **저자**: 박은민 (Eunmin Park)
- **이메일**: dmsals2008@gmail.com
- **GitHub**: [@Minapak](https://github.com/Minapak)
- **기술 블로그**: [eunminpark.hashnode.dev](https://eunminpark.hashnode.dev/series/ios-quantum-engineer)

### 도움 받기

- 🐛 [버그 보고](https://github.com/Minapak/SwiftQuantum/issues/new?template=bug_report.md)
- ✨ [기능 요청](https://github.com/Minapak/SwiftQuantum/issues/new?template=feature_request.md)
- 💬 [토론 시작](https://github.com/Minapak/SwiftQuantum/discussions)
- 📖 [문서 읽기](https://swiftquantum.dev)

---

## 🌟 이번 릴리스의 새로운 기능 (v1.1.1)

### 레이아웃 개선 ✨

#### SuperpositionView 탭 선택기
**해결된 문제**: 탭 버튼이 더 작은 화면에서 압축되고 절단되었습니다.

**구현된 해결책**:
```swift
// maxWidth: .infinity에서 minWidth: 70으로 변경
TabButton:
  - minWidth: 70pt (반응형 최소값)
  - 수평 패딩: 8pt (내부 간격)
  - 수직 패딩: 12pt (터치 대상 크기)
  - 탭 간 간격: 12pt (더 나은 분리)
  - 글꼴 크기: .caption2 (공간 최적화)
```

**결과**:
✅ 모든 5개 탭이 한 줄에 표시됨
✅ iPhone SE부터 iPhone 15 Pro Max까지 작동
✅ 화면 방향에 반응형
✅ 더 나은 터치 대상 (최소 70×36pt)
✅ 텍스트 절단 없음

#### ExamplesView 버튼 그리드
**새로운 레이아웃 시스템**: 2행 반응형 그리드

```
행 1: [Basic] [Gates] [Random]  (3개 버튼, 100% 너비)
행 2: [Algorithm] [Apps] [Spacer]  (2개 버튼 + 유연한 공간)
```

**이점**:
✅ 스크롤 없이 모든 예제 표시
✅ 균형잡힌 버튼 배포
✅ 화면 크기에 반응형
✅ 터치 친화적인 버튼 크기
✅ 깨끗한 시각적 계층 구조

---

<div align="center">

**❤️ 와 ⚛️ 로 만들어진 박은민**

*한 번에 한 큐비트씩 iOS에 양자 컴퓨팅을 가져오기* 🚀

[GitHub](https://github.com/Minapak/SwiftQuantum) • [블로그](https://eunminpark.hashnode.dev) • [X/Twitter](https://twitter.com)

[⬆ 맨 위로](#swiftquantum-)

</div>
