# 변경 로그

이 프로젝트의 모든 주목할 만한 변경 사항이 이 파일에 문서화됩니다.

형식은 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)를 기반으로 하며,
이 프로젝트는 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)을 준수합니다.

---

## [2.2.4] - 2026-01-18

### 추가됨
- **IBM Quantum Ecosystem 전체 로컬라이제이션**
  - 12개 에코시스템 프로젝트 이름 및 설명 로컬라이즈 (EN, KO, JA, ZH, DE)
  - 카테고리 라벨 (머신러닝, 화학, 최적화, 하드웨어, 시뮬레이션, 연구)
  - `QuantumEcosystemProject` 모델이 `nameKey`와 `descriptionKey` 사용하도록 리팩토링
  - `EcosystemCategory` enum에 `localizationKey` 속성 추가
  - `EcosystemProjectCard`, `EcosystemProjectDetailSheet`, `EcosystemCodeExportSheet` 로컬라이즈

- **구독 시스템 전면 재설계**
  - 탭 기반 비교 UI (비교, Pro, Premium 탭)
  - 4개의 별도 플랜을 가진 `SubscriptionPlan` enum (proMonthly, proYearly, premiumMonthly, premiumYearly)
  - Free/Pro/Premium 컬럼이 있는 기능 비교 테이블
  - 월간/연간 토글이 있는 플랜 선택 카드
  - 모든 구독 UI 5개 언어로 로컬라이즈

- **구독 정보 페이지 (더보기 탭)**
  - 티어 비교가 있는 새로운 `SubscriptionInfoView`
  - 프리미엄 잠금 해제 메시지가 있는 히어로 섹션
  - Pro vs Premium 티어 카드 나란히 배치
  - 아이콘과 설명이 있는 전체 기능 목록
  - PaywallView로 원탭 접근
  - 더보기 탭에 새로운 설정 행: "구독 알아보기"
  - 모든 문자열 로컬라이즈 (EN, KO, JA, ZH, DE)

- **새로운 로컬라이제이션 키 (5개 언어)**
  - `subscription.info.title`, `subscription.info.subtitle`, `subscription.info.choose_tier`
  - `subscription.info.best_value`, `subscription.info.pro.feature1-3`, `subscription.info.premium.feature1-3`
  - `subscription.info.all_features`, `subscription.info.feature.qpu/academy/industry/error/support`
  - `subscription.info.subscribe_now`, `subscription.info.cancel_anytime`
  - `ecosystem.category.*`, `ecosystem.project.*`, `ecosystem.project.*.desc`

### 수정됨
- **혜택 설명의 텍스트 잘림**
  - `IndustryHubView.heroBenefitRow`: `lineLimit(1)`을 `fixedSize(horizontal: false, vertical: true)`로 변경
  - `PresetsHubView.heroBenefitRow`: 동일한 수정 적용
  - 히어로 섹션이 "..." 잘림 없이 모든 언어에서 전체 텍스트 표시

### 변경됨
- **Ecosystem 프로젝트 모델**: 하드코딩된 영어 문자열 대신 로컬라이제이션 키 사용
- **PaywallView**: 탭 기반 구독 비교로 완전히 재작성
- **MoreHubView**: 설정 섹션에 구독 정보 항목 추가

---

## [2.2.3] - 2026-01-18

### 추가됨
- **인증 화면 로컬라이제이션**
  - 로그인, 회원가입, 비밀번호 재설정 화면 전체 로컬라이즈
  - 모든 폼 필드 (이메일, 사용자명, 비밀번호) 로컬라이즈
  - 오류 메시지 및 유효성 검사 텍스트 5개 언어로 제공
  - 인증 화면에서 SF Symbol 대신 실제 앱 아이콘 사용

- **프리미엄 구독 페이월 재설계**
  - 티어 및 기간 선택이 있는 완전한 UI 개편
  - 티어 선택: 시각적 표시가 있는 Pro vs Premium
  - 기간 선택: 33% 할인 배지가 있는 월간 vs 연간
  - 선택한 티어에 따른 동적 기능 목록
  - 로컬라이즈된 가격 및 설명

- **구독 로컬라이제이션 키 (5개 언어)**
  - `subscription.title`, `subscription.subtitle`, `subscription.choose_plan`
  - `subscription.pro/premium`, `subscription.monthly/yearly`
  - `subscription.pro.feature1-4`, `subscription.premium.feature1-5`
  - `subscription.pro/premium.desc_monthly/yearly`
  - `subscription.subscribe`, `subscription.restore`, `subscription.legal`

- **Industry 카드 로컬라이제이션**
  - 6개 산업 카드 전체 로컬라이즈 (금융, 의료, 물류, 에너지, 제조, AI)
  - 산업 혜택 설명 모든 언어로 로컬라이즈

- **QuantumNativeIcon 이미지 에셋**
  - 앱 내 사용을 위한 재사용 가능한 앱 아이콘 이미지 에셋 생성
  - Academy 히어로, 인증 화면, 페이월에서 사용

### 변경됨
- **Industry 히어로 섹션**: 하드코딩된 통계를 직관적인 혜택 설명으로 대체
- **Circuits 히어로 섹션**: 하드코딩된 통계를 혜택 설명으로 대체
- **Academy 히어로 섹션**: 그림자 효과가 있는 실제 앱 아이콘 사용
- **인증 로고 섹션**: SF Symbol "atom" 대신 앱 아이콘 사용

### 제거됨
- Academy 히어로 섹션에서 별점 표시 제거
- Industry 탭에서 하드코딩된 통계 (47%, 2.3x, 500+) 제거
- Circuits 탭에서 하드코딩된 통계 (Templates, Runs, Favorites) 제거

---

## [2.2.1] - 2026-01-16

### 추가됨
- **실시간 언어 전환**
  - 앱 재시작 없이 즉시 UI 업데이트
  - `@MainActor` 로컬라이즈 속성이 있는 `LocalizationManager`
  - `QuantumHub` enum의 MainActor 격리 문제 수정

- **더보기 탭 백엔드 통합**
  - 백엔드에서 사용자 통계를 가져오는 `UserStatsManager`
  - 앱 내 웹 설정 페이지를 위한 `SafariWebView`
  - 설정 항목 (알림, 외관, 개인정보, 도움말) → 웹 URL
  - UserDefaults 폴백이 있는 백엔드 연결 빠른 통계

- **동적 콘텐츠 (하드코딩된 값 제거)**
  - Academy 배지: `"5 Lessons"` → `"\(lessonsCompleted) Done"` (동적)
  - 버전 정보: `"2.1.1"` → `Bundle.main.infoDictionary` (동적)
  - 프로필 통계: 하드코딩 → 백엔드 API + 캐시 폴백

- **딥 링킹**
  - Academy 카드 → `quantumnative://academy`를 통해 QuantumNative 앱
  - 앱이 설치되지 않은 경우 앱 내 Academy 시트로 폴백

---

## [2.2.0] - 2026-01-13

### 추가됨
- **Apple App Store Server API v2를 사용한 백엔드 통합**
  - `APIClient.swift`: 완전한 백엔드 API 통신 레이어
  - Apple 서버와의 JWT 기반 인증
  - iOS에서 백엔드로의 트랜잭션 검증 흐름

- **StoreKit 2 프리미엄 시스템**
  - `PremiumManager.swift`: 백엔드 검증이 있는 완전한 StoreKit 2 통합
  - 구매 후 자동 트랜잭션 검증
  - 구독 상태 지속성 및 복원

- **콘텐츠 접근 관리**
  - `ContentAccessManager.swift`: 세분화된 콘텐츠 잠금 시스템
  - 아카데미 콘텐츠에 대한 레벨 기반 접근 제어
  - QuantumBridge 및 Industry 솔루션에 대한 기능 기반 접근
  - `.premiumContent()` SwiftUI 뷰 모디파이어

- **PaywallView**: 전문적인 구독 UI
  - Pro와 Premium 티어 간의 기능 비교
  - 연간 할인 배지가 있는 제품 선택
  - 구매 및 복원 기능
  - 법적 조건 및 개인정보 보호 정책 링크

- **독일어 로컬라이제이션 (de.lproj)**
  - 모든 UI 문자열의 전체 번역
  - 현재 5개 언어 지원: EN, KO, JA, ZH-Hans, DE

---

## [2.1.0] - 2026-01-06

### 추가됨
- **QuantumExecutor 프로토콜** - 하이브리드 실행 시스템
  - `LocalQuantumExecutor`: 선택적 오류 정정이 있는 로컬 시뮬레이션
  - `QuantumBridgeExecutor`: IBM Quantum API를 통한 실제 양자 하드웨어
  - 로컬과 클라우드 실행 간의 원활한 전환을 위한 통합 인터페이스
  - 결과에 충실도 메트릭 및 오류 정정 정보

- **결함 허용 시뮬레이션** (Harvard-MIT 2025 연구)
  - Nature 2025 논문을 기반으로 한 표면 코드 오류 정정
  - 448큐빗 결함 허용 아키텍처 시뮬레이션
  - 0.5% 미만의 논리적 오류율 모델링
  - 매직 상태 증류 지원

- **프리미엄 8탭 UI 구조**
  | 탭 | 이름 | 프리미엄 |
  |-----|------|---------|
  | 1 | 컨트롤 | 무료 |
  | 2 | 측정 | 무료 |
  | 3 | 프리셋 | 무료 |
  | 4 | 정보 | 무료 |
  | 5 | Bridge | 프리미엄 |
  | 6 | 예제 | 무료 |
  | 7 | Industry | 프리미엄 |
  | 8 | Academy | 프리미엄 |

- **4-Hub 네비게이션** (Apple HIG 통합)
  - `LabHubView.swift`: 컨트롤 + 측정 + 정보
  - `PresetsHubView.swift`: 프리셋 + 예제
  - `FactoryHubView.swift`: Bridge (QPU 연결)
  - `MoreHubView.swift`: Academy + Industry + 프로필
  - `QuantumHorizonTabBar.swift`: 플로팅 4탭 네비게이션

---

[2.2.4]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.3...v2.2.4
[2.2.3]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.1...v2.2.3
[2.2.1]: https://github.com/Minapak/SwiftQuantum/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.1.1...v2.2.0
[2.1.0]: https://github.com/Minapak/SwiftQuantum/compare/v2.0.0...v2.1.0
