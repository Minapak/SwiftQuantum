# AWS Production Setup Guide for SwiftQuantum

## 현재 상태
- ✅ ALB: `http://swiftquantum-alb-2127499847.ap-northeast-2.elb.amazonaws.com`
- ✅ ECS Fargate 실행 중
- ✅ Health Check 정상
- ⏳ HTTPS 미설정
- ⏳ RDS 미설정
- ⏳ 도메인 미연결

---

## 1. HTTPS 설정 (Route 53 + ACM)

### Step 1-1: 도메인 구매/이전

**옵션 A: Route 53에서 도메인 구매**
```bash
# AWS 콘솔에서 진행
# Route 53 → Registered domains → Register Domain
# swiftquantum.com 검색 후 구매 (~$12/년)
```

**옵션 B: 외부 도메인 사용 (가비아, Namecheap 등)**
1. 외부에서 도메인 구매
2. Route 53에서 Hosted Zone 생성
3. 외부 도메인 레지스트라에서 NS 레코드를 Route 53 NS로 변경

### Step 1-2: Route 53 Hosted Zone 생성
```bash
# 도메인을 구매했다면 실행
aws route53 create-hosted-zone \
  --name swiftquantum.com \
  --caller-reference "swiftquantum-$(date +%s)" \
  --query 'HostedZone.Id' \
  --output text
```

### Step 1-3: ACM 인증서 요청 (us-east-1 리전)
```bash
# ACM 인증서 요청 (CloudFront용은 us-east-1 필수, ALB는 ap-northeast-2)
aws acm request-certificate \
  --region ap-northeast-2 \
  --domain-name "api.swiftquantum.com" \
  --validation-method DNS \
  --query 'CertificateArn' \
  --output text
```

### Step 1-4: DNS 검증
1. ACM 콘솔에서 CNAME 레코드 확인
2. Route 53에 CNAME 레코드 추가
3. 검증 완료 대기 (5-30분)

### Step 1-5: ALB에 HTTPS 리스너 추가
```bash
# 인증서 ARN 확인
CERT_ARN=$(aws acm list-certificates --region ap-northeast-2 --query "CertificateSummaryList[?DomainName=='api.swiftquantum.com'].CertificateArn" --output text)

# ALB ARN 확인
ALB_ARN=$(aws elbv2 describe-load-balancers --names swiftquantum-alb --query 'LoadBalancers[0].LoadBalancerArn' --output text)

# Target Group ARN 확인
TG_ARN=$(aws elbv2 describe-target-groups --names swiftquantum-tg --query 'TargetGroups[0].TargetGroupArn' --output text)

# HTTPS 리스너 추가
aws elbv2 create-listener \
  --load-balancer-arn $ALB_ARN \
  --protocol HTTPS \
  --port 443 \
  --certificates CertificateArn=$CERT_ARN \
  --default-actions Type=forward,TargetGroupArn=$TG_ARN
```

### Step 1-6: Route 53에 A 레코드 추가
```bash
# Hosted Zone ID 확인
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='swiftquantum.com.'].Id" --output text | cut -d'/' -f3)

# ALB DNS 확인
ALB_DNS="swiftquantum-alb-2127499847.ap-northeast-2.elb.amazonaws.com"
ALB_ZONE_ID=$(aws elbv2 describe-load-balancers --names swiftquantum-alb --query 'LoadBalancers[0].CanonicalHostedZoneId' --output text)

# A 레코드 (Alias) 생성
aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTED_ZONE_ID \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "api.swiftquantum.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "'$ALB_ZONE_ID'",
          "DNSName": "'$ALB_DNS'",
          "EvaluateTargetHealth": true
        }
      }
    }]
  }'
```

---

## 2. RDS PostgreSQL 추가

### Step 2-1: RDS 서브넷 그룹 생성
```bash
# VPC 서브넷 확인
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-XXXXX" --query 'Subnets[*].[SubnetId,AvailabilityZone]' --output table

# 서브넷 그룹 생성
aws rds create-db-subnet-group \
  --db-subnet-group-name swiftquantum-db-subnet \
  --db-subnet-group-description "SwiftQuantum RDS Subnet Group" \
  --subnet-ids subnet-XXXXX subnet-YYYYY
```

### Step 2-2: RDS 보안 그룹 생성
```bash
# 보안 그룹 생성
aws ec2 create-security-group \
  --group-name swiftquantum-rds-sg \
  --description "SwiftQuantum RDS Security Group" \
  --vpc-id vpc-XXXXX

# ECS에서 PostgreSQL 접근 허용 (포트 5432)
aws ec2 authorize-security-group-ingress \
  --group-id sg-XXXXX \
  --protocol tcp \
  --port 5432 \
  --source-group sg-ECS_SECURITY_GROUP_ID
```

### Step 2-3: RDS 인스턴스 생성
```bash
aws rds create-db-instance \
  --db-instance-identifier swiftquantum-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version 15.4 \
  --master-username swiftquantum_admin \
  --master-user-password "YOUR_SECURE_PASSWORD" \
  --allocated-storage 20 \
  --storage-type gp3 \
  --db-subnet-group-name swiftquantum-db-subnet \
  --vpc-security-group-ids sg-XXXXX \
  --no-publicly-accessible \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00" \
  --preferred-maintenance-window "Mon:04:00-Mon:05:00" \
  --db-name swiftquantum
```

### Step 2-4: 환경 변수 업데이트
RDS 엔드포인트를 ECS Task Definition에 추가:
```json
{
  "name": "DATABASE_URL",
  "value": "postgresql://swiftquantum_admin:PASSWORD@swiftquantum-db.XXXXX.ap-northeast-2.rds.amazonaws.com:5432/swiftquantum"
}
```

---

## 3. iOS 앱 API URL 업데이트

HTTPS 설정 완료 후 `APIClient.swift` 수정:
```swift
#if DEBUG
private let baseURL = "http://localhost:8000"
#else
private let baseURL = "https://api.swiftquantum.com"  // HTTPS로 변경
#endif
```

---

## 4. App Store Server Notifications (Webhook) 설정

### Step 4-1: Webhook 엔드포인트 확인
현재 백엔드에 이미 구현되어 있음:
- `POST /api/v1/payment/webhook/appstore`

### Step 4-2: App Store Connect에서 설정
1. App Store Connect 로그인
2. 앱 선택 → App Information
3. App Store Server Notifications
4. Production Server URL 입력:
   ```
   https://api.swiftquantum.com/api/v1/payment/webhook/appstore
   ```
5. Sandbox Server URL (테스트용):
   ```
   https://api.swiftquantum.com/api/v1/payment/webhook/appstore
   ```
6. Version: **Version 2** 선택

### Step 4-3: Webhook 알림 유형
자동으로 수신되는 알림:
- `SUBSCRIBED` - 구독 시작
- `DID_RENEW` - 구독 갱신
- `DID_FAIL_TO_RENEW` - 갱신 실패
- `EXPIRED` - 구독 만료
- `REFUND` - 환불
- `REVOKE` - 취소

---

## 5. 비용 예상 (월별)

| 서비스 | 예상 비용 |
|--------|----------|
| ECS Fargate (0.25 vCPU, 0.5GB) | ~$10-15 |
| ALB | ~$20 |
| RDS db.t3.micro | ~$15-20 |
| Route 53 Hosted Zone | ~$0.50 |
| ACM 인증서 | 무료 |
| 데이터 전송 | ~$5-10 |
| **총계** | **~$50-70/월** |

---

## 6. 빠른 시작 체크리스트

- [ ] 도메인 구매 (swiftquantum.com)
- [ ] Route 53 Hosted Zone 생성
- [ ] ACM 인증서 요청 및 검증
- [ ] ALB HTTPS 리스너 추가
- [ ] Route 53 A 레코드 추가
- [ ] RDS 인스턴스 생성
- [ ] ECS Task Definition 환경변수 업데이트
- [ ] iOS 앱 URL 변경 (`https://api.swiftquantum.com`)
- [ ] App Store Connect Webhook 설정
- [ ] 테스트 결제 확인

---

## 문의 및 지원
AWS 설정 관련 도움이 필요하면 요청해주세요.
