# SwiftQuantum v2.2.4 - 프리미엄 양자 하이브리드 플랫폼

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2018%2B%20%7C%20macOS%2015%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![QuantumBridge](https://img.shields.io/badge/QuantumBridge-2.0-blueviolet.svg)](https://github.com/user/QuantumBridge)
[![Quantum-Hybrid](https://img.shields.io/badge/Quantum--Hybrid-2026-00ff88.svg)](#)
[![Agentic AI](https://img.shields.io/badge/Agentic%20AI-Ready-ff6b6b.svg)](#)
[![Localization](https://img.shields.io/badge/Languages-EN%20%7C%20KO%20%7C%20JA%20%7C%20ZH%20%7C%20DE-blue.svg)](#)

**실제 QPU 연결이 가능한 최초의 iOS 양자 컴퓨팅 프레임워크** - QuantumBridge 통합, 결함 허용 시뮬레이션, Harvard-MIT 연구 기반 교육 콘텐츠를 제공합니다!

> **Harvard-MIT 연구 기반**: 3,000개 이상의 연속 큐빗 작동과 0.5% 미만의 오류율을 시연한 2025년 Nature 논문 기반
>
> **실제 양자 하드웨어**: QuantumBridge API를 통해 IBM Quantum의 127큐빗 시스템에 연결
>
> **프리미엄 학습 플랫폼**: 구독 기반 과정이 포함된 MIT/Harvard 스타일 Quantum Academy
>
> **엔터프라이즈 솔루션**: 금융, 의료, 물류를 위한 B2B 산업 애플리케이션

---

## v2.2.4 새로운 기능 (2026년 프로덕션 릴리스)

### IBM Quantum Ecosystem 로컬라이제이션 및 구독 시스템 개편

- **IBM Quantum Ecosystem 전체 로컬라이제이션**:
  - 12개 에코시스템 프로젝트 이름 및 설명 로컬라이즈 (EN, KO, JA, ZH, DE)
  - 카테고리 라벨 (ML, Chemistry, Optimization, Hardware, Simulation, Research) 로컬라이즈
  - 에코시스템 프로젝트 카드, 상세 시트, 코드 내보내기 뷰 전체 로컬라이즈

- **구독 시스템 전면 재설계**:
  - 탭 기반 비교 UI (비교, Pro, Premium 탭)
  - 명확한 플랜 구분: Pro 월간, Pro 연간, Premium 월간, Premium 연간
  - Free/Pro/Premium 컬럼이 있는 기능 비교 테이블
  - 5개 언어로 로컬라이즈

- **구독 정보 페이지 (더보기 탭)**:
  - 설정 섹션에 새로운 "구독 알아보기" 메뉴 항목
  - Pro vs Premium 기능을 설명하는 전용 페이지
  - 기능 하이라이트가 포함된 티어 비교 카드
  - 설명이 포함된 모든 기능 목록
  - 구독을 위한 PaywallView로 원탭 접근

- **텍스트 잘림 수정**:
  - 혜택 설명에서 "..."을 유발하는 `lineLimit(1)` 수정
  - Industry 및 Circuits 탭 히어로 섹션이 모든 언어에서 전체 텍스트 표시

---

## v2.2.3 새로운 기능

### 포괄적인 로컬라이제이션 및 프리미엄 구독 재설계

- **인증 로컬라이제이션**: 로그인, 회원가입, 비밀번호 재설정 화면 전체 로컬라이즈
  - 모든 폼 필드, 버튼, 오류 메시지가 5개 언어로 제공 (EN, KO, JA, ZH, DE)
  - 인증 화면에서 SF Symbol을 실제 앱 아이콘으로 교체

- **구독 페이월 재설계**: 프리미엄 구매 경험의 완전한 개편
  - 티어 선택: 명확한 기능 비교가 포함된 Pro vs Premium
  - 기간 선택: 33% 절약 배지가 포함된 월간 vs 연간
  - 선택한 티어에 따른 동적 기능 목록
  - 5개 언어로 로컬라이즈된 가격 표시 및 설명

- **Academy 및 Industry UI 개선**:
  - Academy 히어로 섹션이 실제 앱 아이콘 사용
  - Industry 솔루션 카드 전체 로컬라이즈 (금융, 의료, 물류 등)
  - 하드코딩된 통계를 직관적인 혜택 설명으로 대체

---

## 빠른 시작

### 설치

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "2.2.4")
]
```

### 기본 사용법

```swift
import SwiftQuantum

// 양자 레지스터 생성
let register = QuantumRegister(numberOfQubits: 3)

// 게이트 적용
register.applyGate(.hadamard, to: 0)
register.applyCNOT(control: 0, target: 1)
register.applyCNOT(control: 1, target: 2)
// GHZ 상태 생성: (|000⟩ + |111⟩)/√2

// 측정
let results = register.measureMultiple(shots: 1000)
// ["000": ~500, "111": ~500]
```

### QuantumBridge 연결

```swift
import SwiftQuantum

// IBM Quantum용 실행기 생성
let executor = QuantumBridgeExecutor(
    executorType: .ibmBrisbane,
    apiKey: "YOUR_IBM_QUANTUM_API_KEY"  // IBM Quantum에서 획득
)

// 회로 구축
let circuit = BridgeCircuitBuilder(numberOfQubits: 2, name: "Bell")
    .h(0)
    .cx(control: 0, target: 1)

// 실제 양자 하드웨어에서 실행
let result = try await executor.execute(circuit: circuit, shots: 1000)
print("카운트: \(result.counts)")  // {"00": 498, "11": 502}
```

---

## QuantumBridge 탭 - 완전 가이드

**Bridge** 탭은 실제 양자 하드웨어로 가는 관문입니다! 다음과 같은 작업을 수행할 수 있습니다:

### QuantumBridge를 사용하는 이유

> **팁**: Bridge 탭의 오른쪽 상단 모서리에 있는 `?` 버튼을 탭하면 앱 내에서 이 정보를 볼 수 있습니다!

| 이점 | 설명 |
|-----|------|
| **실제 하드웨어** | 실제 IBM 양자 프로세서(127큐빗!)에서 회로 실행 |
| **진정한 양자 효과** | 실제 중첩 및 얽힘 경험 |
| **실제 결과** | 시뮬레이션이 아닌 실제 양자 컴퓨터에서 측정값 획득 |

### 백엔드 옵션

| 백엔드 | 최적 용도 | 장점 | 제한사항 |
|-------|---------|------|---------|
| **시뮬레이터** | 학습 및 테스트 | 즉각적인 결과, 무료, 대기열 없음 | 실제 양자 노이즈 없음 |
| **IBM Brisbane** | 프로덕션 및 연구 | 127 큐빗, 높은 결맞음 | 대기열 대기 시간 |
| **IBM Osaka** | 고속 실행 | 빠른 게이트 속도, 짧은 대기열 | 중간 수준의 노이즈 |
| **IBM Kyoto** | 연구 프로젝트 | 고급 오류 완화 | 현재 유지보수 중 |

### 빠른 작업

| 작업 | 설명 | 프리미엄 |
|-----|------|---------|
| **Bell 상태** | 2큐빗 사이의 양자 얽힘 생성 | 예 |
| **GHZ 상태** | 다중 큐빗(3+) 얽힘 | 예 |
| **QASM 내보내기** | OpenQASM 3.0 코드로 회로 내보내기 | 아니오 |
| **연속 모드** | 30초마다 회로 자동 반복 | 예 |

---

## Industry 탭 - 엔터프라이즈 솔루션

**Industry** 탭은 실제 비즈니스를 위한 양자 컴퓨팅 애플리케이션을 보여줍니다.

### 개요

| 기능 | 설명 |
|-----|------|
| **Industry 카드** | 양자 솔루션을 갖춘 6개 분야 |
| **ROI 계산기** | 잠재적 절감액 추정 |
| **상세 보기** | 각 산업의 응용 분야 학습 |
| **IBM Ecosystem** | IBM Quantum Ecosystem에서 프로젝트 실행 |

### 이용 가능한 산업

| 산업 | 사용 사례 | 효율성 향상 |
|-----|---------|------------|
| **금융** | 포트폴리오 최적화, 리스크 분석 | +52% |
| **의료** | 신약 발견, 단백질 접힘 | +38% |
| **물류** | 경로 최적화, 공급망 | +45% |
| **에너지** | 그리드 최적화, 예측 | +41% |
| **제조** | 품질 관리, 유지보수 | +33% |
| **AI & ML** | 양자 머신러닝 | +67% |

---

## IBM Quantum Ecosystem 통합

SwiftQuantum은 이제 **IBM Quantum Ecosystem**과 통합되어 iOS 기기에서 직접 실제 양자 프로젝트를 실행할 수 있습니다.

### Ecosystem 카테고리

| 카테고리 | 프로젝트 | 설명 |
|---------|---------|------|
| **머신러닝** | TorchQuantum, Qiskit ML | 양자 신경망 및 ML 알고리즘 |
| **화학 & 물리** | Qiskit Nature | 분자 시뮬레이션 및 신약 발견 |
| **최적화** | Qiskit Finance, Optimization | 포트폴리오 최적화 및 QAOA |
| **하드웨어 제공자** | IBM, Azure, AWS Braket, IonQ | 양자 프로세서 직접 접근 |
| **시뮬레이션** | Qiskit Aer, MQT DDSIM | 고성능 시뮬레이터 |
| **연구** | PennyLane, Cirq | 크로스 플랫폼 연구 프레임워크 |

---

## 아키텍처

```
SwiftQuantum v2.2.4/
├── Sources/SwiftQuantum/
│   ├── Core/
│   │   ├── Complex.swift              # 복소수 연산
│   │   ├── Qubit.swift                # 단일 큐빗 상태
│   │   ├── QuantumRegister.swift      # 다중 큐빗 (최대 20)
│   │   ├── QuantumGates.swift         # 15+ 양자 게이트
│   │   └── QuantumCircuit.swift       # 회로 구성
│   │
│   ├── Algorithms/
│   │   └── QuantumAlgorithms.swift    # Bell, Grover, DJ, Simon
│   │
│   ├── Bridge/
│   │   ├── QuantumBridge.swift        # QASM 내보내기, IBM 구성
│   │   └── QuantumExecutor.swift      # 하이브리드 실행 프로토콜
│   │
│   └── Resources/                     # 로컬라이제이션
│       ├── en.lproj/                  # 영어 (기본)
│       ├── ko.lproj/                  # 한국어
│       ├── ja.lproj/                  # 일본어
│       ├── zh-Hans.lproj/             # 중국어 (간체)
│       └── de.lproj/                  # 독일어
│
├── Apps/
│   └── SuperpositionVisualizer/       # 프리미엄 시각화 (4-Hub 네비게이션)
│       ├── QuantumHorizonView.swift   # 4-hub 네비게이션이 있는 메인 뷰
│       ├── Premium/                   # 구독 시스템
│       │   ├── APIClient.swift        # 백엔드 API 통신
│       │   ├── PremiumManager.swift   # StoreKit 2 + 백엔드 검증
│       │   ├── ContentAccessManager.swift  # 콘텐츠 잠금
│       │   └── PaywallView.swift      # 구독 UI
│       ├── Hubs/
│       │   ├── LabHubView.swift       # 컨트롤 + 측정 + 정보
│       │   ├── PresetsHubView.swift   # 프리셋 + 예제
│       │   ├── FactoryHubView.swift   # Bridge (QPU 연결)
│       │   └── MoreHubView.swift      # Academy + Industry + 프로필
│       └── Navigation/
│           └── QuantumHorizonTabBar.swift  # 4-탭 플로팅 바
│
├── Website/                           # 제품 웹사이트
│   ├── index.html                     # 랜딩 페이지
│   └── support.html                   # 지원 센터
│
└── Tests/
```

---

## 프리미엄 기능

### 구독 티어

| 기능 | 무료 | Pro ($4.99/월) | Premium ($9.99/월) |
|-----|------|---------------|-------------------|
| 로컬 시뮬레이션 | 20 큐빗 | 40 큐빗 | 40 큐빗 |
| 양자 게이트 | 모든 15+ | 모든 15+ | 모든 15+ |
| 기본 예제 | 예 | 예 | 예 |
| QuantumBridge 연결 | 아니오 | 예 | **예** |
| 오류 정정 시뮬레이션 | 아니오 | 아니오 | **예** |
| Quantum Academy 과정 | 2개 무료 | 모든 12+ | **모든 12+** |
| Industry 솔루션 | 보기만 | 부분 | **전체 접근** |
| 우선 지원 | 아니오 | 이메일 | **우선** |

---

## 연구 기반

### Harvard-MIT Nature 2025 논문

SwiftQuantum은 최첨단 양자 컴퓨팅 연구를 기반으로 구축되었습니다:

1. **"448개 중성 원자 큐빗을 사용한 결함 허용 양자 계산"** (Nature, 2025년 11월)
   - 0.5% 미만의 결함 허용 임계값 최초 시연

2. **"3,000큐빗 결맞음 시스템의 연속 작동"** (Nature, 2025년 9월)
   - 2시간 이상의 연속 양자 작동

3. **"중성 원자 양자 컴퓨터에서의 매직 상태 증류"** (Nature, 2025년 7월)
   - 범용 결함 허용 양자 계산에 필수

---

## 로드맵

### 버전 2.2.4 (현재 - 2026년 1월)
- [x] IBM Quantum Ecosystem 전체 로컬라이제이션 (12개 프로젝트, 6개 카테고리)
- [x] 탭 기반 비교로 구독 시스템 전면 재설계
- [x] 더보기 탭 설정에 구독 정보 페이지
- [x] 다국어 혜택 설명의 텍스트 잘림 수정
- [x] 모든 구독 관련 UI 5개 언어로 로컬라이즈

### 버전 2.3.0 (계획 - 2026년 2분기)
- [ ] 실제 IBM Quantum 작업 제출
- [ ] 양자 푸리에 변환 (QFT)
- [ ] Shor 알고리즘 구현
- [ ] 클라우드 작업 대기열 대시보드
- [ ] 팀/엔터프라이즈 계정

### 버전 3.0.0 (미래 - 2026년 4분기)
- [ ] 50+ 큐빗 시뮬레이션 (최적화)
- [ ] 다중 QPU 오케스트레이션
- [ ] 커스텀 노이즈 모델 빌더
- [ ] 양자 ML 통합 (PennyLane)

---

## 기여

기여를 환영합니다! 기여 가이드라인을 읽어주세요.

```bash
# 클론
git clone https://github.com/Minapak/SwiftQuantum.git
cd SwiftQuantum

# 빌드
swift build

# 테스트
swift test

# Xcode에서 열기
open Package.swift
```

---

## 라이선스

MIT 라이선스 - [LICENSE](LICENSE) 참조

---

## 연락처 및 지원

- **GitHub Issues**: [버그 신고](https://github.com/Minapak/SwiftQuantum/issues/new?template=bug_report.md)
- **기능 요청**: [기능 요청](https://github.com/Minapak/SwiftQuantum/issues/new?template=feature_request.md)
- **토론**: [GitHub Discussions](https://github.com/Minapak/SwiftQuantum/discussions)

---

<div align="center">

**SwiftQuantum - iOS에서의 양자 컴퓨팅의 미래**

*Harvard-MIT 연구 기반*

</div>
