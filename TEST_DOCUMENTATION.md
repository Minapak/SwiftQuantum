# SwiftQuantum iOS 앱 테스트 가이드

**작성일:** 2026-01-16
**버전:** v2.2.1
**테스트 환경:** iPhone 17 Pro Max (Simulator, iOS 26.2)

---

## 1. 테스트 환경 설정

### 1.1 테스트 계정
```
Admin Credentials:
- Email: admin@swiftquantum.io
- Password: QuantumAdmin2026!
```

### 1.2 백엔드 서버 정보
| 서비스 | URL | 상태 |
|--------|-----|------|
| API Server | https://api.swiftquantum.tech | Running |
| QuantumBridge | https://bridge.swiftquantum.tech | Running |
| Web App | https://swiftquantum.tech | Running |

### 1.3 시뮬레이터 설정
- 디바이스: iPhone 17 Pro Max (iOS 26.2)
- 스크린샷 해상도: 1284x2778px (iPhone 6.5" Display)

---

## 2. 테스트 흐름 및 결과

### 2.1 앱 기본 기능 테스트

#### 2.1.1 앱 실행 및 온보딩
| 테스트 항목 | 결과 | 비고 |
|------------|------|------|
| 앱 런칭 | ✅ 성공 | 스플래시 화면 정상 표시 |
| 온보딩 플로우 | ✅ 성공 | 4단계 온보딩 완료 |
| 언어 선택 | ✅ 성공 | 5개국어 지원 확인 |

#### 2.1.2 4-Hub 네비게이션
| Hub | 기능 | 결과 |
|-----|------|------|
| Lab | 양자 시뮬레이션 | ✅ 정상 |
| Presets | 프리셋/예제 | ✅ 정상 |
| Bridge | QuantumBridge 연결 | ✅ 정상 (Premium 잠금) |
| More | 설정/프로필 | ✅ 정상 |

---

### 2.2 다국어 지원 (Localization) 테스트

#### 2.2.1 문제 발견 및 해결
**문제:** 탭바 및 일부 UI 요소가 언어 변경 시 영어로 고정됨

**원인:**
- `QuantumHub` enum에서 `LocalizationManager` 호출 시 MainActor isolation 에러
- 일부 View에서 hardcoded string 사용

**해결:**
1. `QuantumHorizonTabBar.swift`에 `@MainActor` 프로퍼티 추가
2. `LocalizationManager.swift`에 누락된 키 추가
3. `LabHubView.swift` 로컬라이제이션 적용

#### 2.2.2 지원 언어별 테스트
| 언어 | 코드 | Tab Bar | Lab Hub | Settings | 결과 |
|------|------|---------|---------|----------|------|
| English | en | Lab, Presets, Bridge, More | Control, Measure | Settings | ✅ |
| 한국어 | ko | 실험실, 프리셋, 브릿지, 더보기 | 제어, 측정 | 설정 | ✅ |
| 日本語 | ja | ラボ, プリセット, ブリッジ, その他 | 制御, 測定 | 設定 | ✅ |
| 简体中文 | zh-Hans | 实验室, 预设, 桥接, 更多 | 控制, 测量 | 设置 | ✅ |
| Deutsch | de | Labor, Vorlagen, Bridge, Mehr | Steuerung, Messung | Einstellungen | ✅ |

---

### 2.3 백엔드 연동 테스트

#### 2.3.1 API 연결
| Endpoint | 기능 | 결과 |
|----------|------|------|
| `/api/v1/users/profile` | 사용자 프로필 | ✅ 연결 성공 |
| `/api/v1/users/stats` | 사용자 통계 | ✅ 연결 성공 |
| `/api/v1/payment/subscription/status` | 구독 상태 | ✅ 연결 성공 |
| `/health` | 서버 헬스체크 | ✅ Running |

#### 2.3.2 오프라인 Fallback
| 시나리오 | 동작 | 결과 |
|----------|------|------|
| 네트워크 끊김 | UserDefaults 캐시 사용 | ✅ 정상 |
| API 에러 | 캐시된 데이터 표시 | ✅ 정상 |
| 첫 실행 (캐시 없음) | 기본값 표시 | ✅ 정상 |

---

### 2.4 Premium/결제 플로우 테스트

#### 2.4.1 StoreKit 2 통합
| 기능 | 구현 | 결과 |
|------|------|------|
| 상품 로드 | `Product.products(for:)` | ✅ 정상 |
| 구매 처리 | `product.purchase()` | ✅ 구현 완료 |
| 구매 복원 | `AppStore.sync()` | ✅ 구현 완료 |
| 트랜잭션 검증 | `checkVerified()` | ✅ 구현 완료 |

#### 2.4.2 구독 상품
| 상품 ID | 가격 | 기간 |
|---------|------|------|
| `com.swiftquantum.pro.monthly` | $4.99 | 월간 |
| `com.swiftquantum.pro.yearly` | $39.99 | 연간 |
| `com.swiftquantum.premium.monthly` | $9.99 | 월간 |
| `com.swiftquantum.premium.yearly` | $79.99 | 연간 |

#### 2.4.3 Premium 기능 게이팅
| 기능 | Free | Pro | Premium |
|------|------|-----|---------|
| Local Simulation (20 qubits) | ✅ | ✅ | ✅ |
| Local Simulation (40 qubits) | ❌ | ✅ | ✅ |
| Academy Courses (2개) | ✅ | ✅ | ✅ |
| Academy Courses (전체) | ❌ | ✅ | ✅ |
| QuantumBridge QPU | ❌ | ❌ | ✅ |
| Error Correction | ❌ | ❌ | ✅ |
| Industry Solutions | ❌ | ❌ | ✅ |

---

### 2.5 More Tab 설정 연동 테스트

#### 2.5.1 Safari WebView 연동
| 설정 항목 | 웹앱 경로 | 결과 |
|----------|----------|------|
| Notifications | /settings/notifications | ✅ 정상 |
| Appearance | /settings/appearance | ✅ 정상 |
| Privacy | /privacy | ✅ 정상 |
| Help & Support | /support | ✅ 정상 |

#### 2.5.2 네이티브 기능
| 설정 항목 | 동작 | 결과 |
|----------|------|------|
| Language | 언어 선택 Sheet | ✅ 정상 |
| Reset Tutorial | 온보딩 리셋 | ✅ 정상 |

#### 2.5.3 Academy → QuantumNative 딥링크
```swift
// URL Scheme: quantumnative://academy
if UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.open(url)
}
```
- **설치됨:** QuantumNative 앱의 Academy 화면으로 이동
- **미설치:** 앱 내 Academy 시트 표시 (Fallback)

---

### 2.6 하드코딩 제거 테스트

#### 2.6.1 제거된 하드코딩 값
| 파일 | 이전 | 이후 |
|------|------|------|
| `MoreHubView.swift` | `"5 Lessons"` | `"\(statsManager.lessonsCompleted) Done"` |
| `MoreHubView.swift` | `"Version 2.1.1"` | `"Version \(AppInfo.version)"` |
| `ProfileHubView.swift` | 하드코딩된 stats | 백엔드 API + UserDefaults fallback |

#### 2.6.2 동적 데이터 소스
| 데이터 | 소스 | Fallback |
|--------|------|----------|
| Lessons Completed | `/api/v1/users/stats` | UserDefaults |
| XP Points | `/api/v1/users/stats` | UserDefaults |
| Level | 계산식 (XP/500) | UserDefaults |
| App Version | `Bundle.main.infoDictionary` | "2.2.0" |

---

## 3. 스크린샷 캡처 결과

### 3.1 캡처된 스크린샷 위치
```
/Users/eunmin/Desktop/WORK/SwiftQuantum/AppStoreAssets/Screenshots/
├── iPhone_6.7/
│   ├── en/
│   │   ├── 01_lab.png
│   │   ├── 02_presets.png
│   │   ├── 03_bridge.png
│   │   └── 04_more.png
│   ├── ko/
│   ├── ja/
│   ├── zh-Hans/
│   └── de/
```

### 3.2 스크린샷 사양
- **해상도:** 1284 x 2778 px
- **포맷:** PNG
- **대상 디바이스:** iPhone 6.5" Display (App Store Connect)

---

## 4. 발견된 이슈 및 해결

### 4.1 해결된 이슈

| # | 이슈 | 원인 | 해결 |
|---|------|------|------|
| 1 | 다국어 UI 미반영 | MainActor isolation | `@MainActor` 프로퍼티 추가 |
| 2 | 탭바 영어 고정 | `LocalizationManager` 호출 방식 | `localizedTitle` 프로퍼티 분리 |
| 3 | 하드코딩된 통계 | API 미연결 | `UserStatsManager` 구현 |
| 4 | 버전 정보 고정 | 문자열 하드코딩 | `Bundle.main` 동적 조회 |

### 4.2 알려진 제한사항

| # | 항목 | 설명 |
|---|------|------|
| 1 | StoreKit Sandbox | 시뮬레이터에서 실제 결제 불가 (Sandbox 테스트 필요) |
| 2 | QuantumBridge | 실제 QPU 연결은 Production 환경에서만 가능 |
| 3 | Deep Link | QuantumNative 앱 미설치 시 Fallback으로 동작 |

---

## 5. 테스트 체크리스트

### 5.1 기능 테스트
- [x] 앱 실행 및 스플래시
- [x] 온보딩 플로우
- [x] 4-Hub 네비게이션
- [x] Lab Hub 양자 시뮬레이션
- [x] Presets Hub 예제 실행
- [x] Bridge Hub (Premium 잠금 확인)
- [x] More Hub 설정

### 5.2 다국어 테스트
- [x] English (en)
- [x] Korean (ko)
- [x] Japanese (ja)
- [x] Chinese Simplified (zh-Hans)
- [x] German (de)

### 5.3 백엔드 연동
- [x] API 연결
- [x] 오프라인 Fallback
- [x] 사용자 통계 동기화

### 5.4 Premium 기능
- [x] Paywall UI
- [x] StoreKit 2 통합
- [x] 기능 게이팅
- [x] 백엔드 검증 연동

---

## 6. 빌드 및 배포 정보

### 6.1 빌드 명령어
```bash
# 빌드
xcodebuild -project Apps/SuperpositionVisualizer/SuperpositionVisualizer.xcodeproj \
  -scheme SuperpositionVisualizer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.2' \
  build

# 시뮬레이터 설치
xcrun simctl install booted [APP_PATH]
```

### 6.2 빌드 결과
- **결과:** BUILD SUCCEEDED
- **경고:** 없음 (AppIntents metadata warning 제외)
- **에러:** 없음

---

## 7. 다음 단계

1. **TestFlight 배포:** 실제 디바이스에서 StoreKit Sandbox 테스트
2. **App Store 제출:** 스크린샷 및 메타데이터 업로드
3. **Production 백엔드:** API 서버 프로덕션 배포 확인
4. **QuantumNative 연동:** 딥링크 테스트 (실제 디바이스)

---

**작성자:** Claude Code (Automated Testing)
**최종 업데이트:** 2026-01-16 08:30 KST
