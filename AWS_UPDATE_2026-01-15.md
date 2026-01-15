# SwiftQuantum AWS 업데이트 보고서

**작성일**: 2026년 1월 15일 15:00 KST
**작성자**: Claude Assistant
**상태**: ✅ 전체 완료

---

## 완료된 작업 요약

| 순서 | 작업 | 상태 |
|------|------|------|
| 1 | RDS PostgreSQL 인스턴스 생성 | ✅ |
| 2 | ECS Task Definition 업데이트 (PostgreSQL 연결) | ✅ |
| 3 | iOS 앱 API URL HTTPS 변경 | ✅ |
| 4 | QuantumBridge API Client 추가 | ✅ |
| 5 | App Store Webhook 설정 가이드 | ✅ |

---

## 1. RDS PostgreSQL 추가

### 1.1 생성된 RDS 인스턴스 정보

| 항목 | 값 |
|------|-----|
| **DB Instance ID** | swiftquantum-db |
| **Engine** | PostgreSQL 14.19 |
| **Instance Class** | db.t3.micro |
| **Endpoint** | `swiftquantum-db.c1myi84yslp3.ap-northeast-2.rds.amazonaws.com` |
| **Port** | 5432 |
| **Database Name** | swiftquantum |
| **Master Username** | quantum |
| **Storage** | 20 GB gp2 |
| **Backup Retention** | 1 day |
| **VPC** | vpc-0c7409f422251a72d |
| **Subnet Group** | swiftquantum-db-subnet |
| **Security Group** | sg-09df9e0482b71c229 |

### 1.2 실행된 명령어

```bash
# DB Subnet Group 생성
aws rds create-db-subnet-group \
    --db-subnet-group-name swiftquantum-db-subnet \
    --db-subnet-group-description "SwiftQuantum RDS Subnet Group" \
    --subnet-ids subnet-0efcdd786436e5080 subnet-0162e68429537c574 \
    --region ap-northeast-2

# RDS 인스턴스 생성
aws rds create-db-instance \
    --db-instance-identifier swiftquantum-db \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --engine-version "14" \
    --master-username quantum \
    --master-user-password 'SQuaParkbori1223' \
    --allocated-storage 20 \
    --db-name swiftquantum \
    --db-subnet-group-name swiftquantum-db-subnet \
    --vpc-security-group-ids sg-09df9e0482b71c229 \
    --no-publicly-accessible \
    --backup-retention-period 1 \
    --region ap-northeast-2
```

---

## 2. ECS Task Definition 업데이트

### 2.1 변경 사항

| 항목 | 이전 | 이후 |
|------|------|------|
| **DATABASE_URL** | `sqlite:///./app.db` | `postgresql://quantum:***@swiftquantum-db.c1myi84yslp3.ap-northeast-2.rds.amazonaws.com:5432/swiftquantum` |
| **Task Definition** | swiftquantum-task:5 | swiftquantum-task:6 |

### 2.2 실행된 명령어

```bash
# Task Definition 등록
aws ecs register-task-definition \
    --cli-input-json file:///tmp/task-definition-postgres.json \
    --region ap-northeast-2

# ECS 서비스 업데이트
aws ecs update-service \
    --cluster swiftquantum-cluster \
    --service swiftquantum-api \
    --task-definition swiftquantum-task:6 \
    --force-new-deployment \
    --region ap-northeast-2
```

### 2.3 Health Check 확인

```bash
curl https://api.swiftquantum.tech/health
```

**응답:**
```json
{
    "status": "healthy",
    "version": "1.0.0",
    "environment": "production",
    "database": "connected",
    "timestamp": "2026-01-15T05:59:40.912552"
}
```

✅ PostgreSQL 연결 성공

---

## 3. iOS 앱 API URL 업데이트

### 3.1 APIClient.swift 변경 사항

**파일 위치:** `Apps/SuperpositionVisualizer/SuperpositionVisualizer/Premium/APIClient.swift`

**변경 전:**
```swift
#if DEBUG
private let baseURL = "http://localhost:8000"
#else
private let baseURL = "http://swiftquantum-alb-2127499847.ap-northeast-2.elb.amazonaws.com"
#endif
```

**변경 후:**
```swift
#if DEBUG
private let baseURL = "http://localhost:8000"  // Local development
private let bridgeURL = "http://localhost:8001"  // Local QuantumBridge
#else
private let baseURL = "https://api.swiftquantum.tech"  // Production (HTTPS)
private let bridgeURL = "https://bridge.swiftquantum.tech"  // Production QuantumBridge
#endif
```

### 3.2 추가된 QuantumBridge API 메서드

| 메서드 | 설명 |
|--------|------|
| `bridgeHealthCheck()` | QuantumBridge 상태 확인 |
| `runBellState(stateType:shots:)` | Bell State 생성 |
| `runQuantumCircuit(qasm:shots:)` | 커스텀 회로 실행 |
| `runGrover(numQubits:markedStates:shots:)` | Grover 알고리즘 |
| `runDeutschJozsa(numQubits:oracleType:shots:)` | Deutsch-Jozsa 알고리즘 |

### 3.3 추가된 Response Models

```swift
// QuantumBridge 응답 모델
struct BridgeHealthResponse
struct BellStateResponse
struct BellStateResult
struct CircuitResponse
struct GroverResponse
struct GroverResult
struct DeutschJozsaResponse
struct DeutschJozsaResult
```

---

## 4. App Store Server Notifications (Webhook) 설정

### 4.1 Webhook 엔드포인트

| 환경 | URL |
|------|-----|
| **Production** | `https://api.swiftquantum.tech/api/v1/payment/webhook/appstore` |
| **Sandbox** | `https://api.swiftquantum.tech/api/v1/payment/webhook/appstore` |

### 4.2 App Store Connect 설정 방법

1. [App Store Connect](https://appstoreconnect.apple.com) 로그인
2. **My Apps** → **SwiftQuantum** 선택
3. **App Information** 탭 클릭
4. **App Store Server Notifications** 섹션 찾기
5. 다음 설정 입력:

| 필드 | 값 |
|------|-----|
| **Production Server URL** | `https://api.swiftquantum.tech/api/v1/payment/webhook/appstore` |
| **Sandbox Server URL** | `https://api.swiftquantum.tech/api/v1/payment/webhook/appstore` |
| **Version** | Version 2 Notifications |

6. **Save** 클릭

### 4.3 수신되는 알림 유형

| 알림 타입 | 설명 |
|----------|------|
| `SUBSCRIBED` | 새 구독 시작 |
| `DID_RENEW` | 구독 자동 갱신 |
| `DID_FAIL_TO_RENEW` | 갱신 실패 (결제 문제) |
| `DID_CHANGE_RENEWAL_STATUS` | 자동 갱신 on/off 변경 |
| `DID_CHANGE_RENEWAL_PREF` | 구독 플랜 변경 |
| `EXPIRED` | 구독 만료 |
| `GRACE_PERIOD_EXPIRED` | 유예 기간 만료 |
| `OFFER_REDEEMED` | 프로모션 코드 사용 |
| `REFUND` | 환불 처리 |
| `REVOKE` | 가족 공유 취소 |

### 4.4 Webhook 테스트

App Store Connect에서 설정 후, Sandbox 테스트 계정으로 구독 테스트 시 자동으로 알림이 전송됩니다.

```bash
# 서버 로그 확인
aws logs tail /ecs/swiftquantum --follow --region ap-northeast-2
```

---

## 5. 최종 아키텍처

```
┌─────────────────────────────────────────────────────────────────┐
│                      iOS App (SwiftQuantum)                      │
│                                                                  │
│   APIClient.swift                                                │
│   ├── baseURL: https://api.swiftquantum.tech                    │
│   └── bridgeURL: https://bridge.swiftquantum.tech               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Application Load Balancer                     │
│                        (HTTPS :443)                              │
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │ api.swiftquantum.tech → swiftquantum-tg (:8000)        │   │
│   │ bridge.swiftquantum.tech → quantumbridge-tg (:8001)    │   │
│   └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┴───────────────────┐
          ▼                                       ▼
┌──────────────────────────┐       ┌──────────────────────────┐
│   SwiftQuantumBackend    │       │      QuantumBridge       │
│   (ECS Fargate)          │       │     (ECS Fargate)        │
│                          │       │                          │
│   - Auth API             │       │   - /health              │
│   - Payment API          │       │   - /bell-state          │
│   - Learning API         │       │   - /run-circuit         │
│   - Webhook Handler      │       │   - /grover              │
└──────────────────────────┘       │   - /deutsch-jozsa       │
          │                        └──────────────────────────┘
          ▼
┌──────────────────────────┐
│     RDS PostgreSQL       │
│     (db.t3.micro)        │
│                          │
│  swiftquantum-db         │
│  Port: 5432              │
└──────────────────────────┘
```

---

## 6. 비용 업데이트

### 6.1 추가된 비용

| 서비스 | 사양 | 월 비용 (USD) |
|--------|------|---------------|
| **RDS PostgreSQL** | db.t3.micro, 20GB | ~$15-20 |

### 6.2 총 예상 비용

| 서비스 | 월 비용 (USD) |
|--------|---------------|
| ECS Fargate (Backend) | ~$10 |
| ECS Fargate (Bridge) | ~$18 |
| ALB | ~$20 |
| **RDS PostgreSQL** | ~$18 |
| Route 53 | ~$1 |
| CloudWatch Logs | ~$1 |
| ECR | ~$0.10 |
| Domain | ~$0.83 |
| **총합** | **~$70/월** |

---

## 7. 다음 단계 (선택사항)

| 우선순위 | 작업 | 예상 시간 |
|----------|------|----------|
| 1 | CloudWatch 알람 설정 | 20분 |
| 2 | Auto Scaling 설정 | 15분 |
| 3 | CI/CD 파이프라인 구축 | 1시간 |
| 4 | RDS 자동 백업 기간 연장 | 5분 |

---

## 8. 중요 자격 증명 정보

### 8.1 RDS 접속 정보

```
Host: swiftquantum-db.c1myi84yslp3.ap-northeast-2.rds.amazonaws.com
Port: 5432
Database: swiftquantum
Username: quantum
Password: SQuaParkbori1223
```

### 8.2 DATABASE_URL

```
postgresql://quantum:SQuaParkbori1223@swiftquantum-db.c1myi84yslp3.ap-northeast-2.rds.amazonaws.com:5432/swiftquantum
```

> ⚠️ 이 정보는 안전하게 보관하세요. 프로덕션에서는 AWS Secrets Manager 사용을 권장합니다.

---

**문서 작성 완료**: 2026-01-15 15:00 KST

**전체 상태**: ✅ 완료
