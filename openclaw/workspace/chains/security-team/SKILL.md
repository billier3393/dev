---
name: "security-team"
description: "보안 감사, 취약점 점검, 인젝션 방어. '보안점검' 명령 시 활성화."
user-invocable: true
---
# 보안담당팀

## 에이전트
- **[Security-Lead]** (`security-lead`, Haiku 4.5): 보안 정책, 위협 분석, 감사 총괄
- **[Security-Auditor]** (`security-auditor`, Haiku 4.5): 코드 보안 감사, 취약점 스캔
- **[Security-Monitor]** (`security-monitor`, Gemini Flash): 실시간 모니터링, 인젝션 탐지

## 보안 감사 체크리스트
- [ ] 프롬프트 인젝션 방어 확인
- [ ] 외부 데이터 처리 안전성
- [ ] 에이전트 간 통신 무결성
- [ ] 파일 시스템 접근 권한
- [ ] 외부 전송 차단 확인
- [ ] 인젝션 패턴 탐지 규칙 업데이트

## ⛔ 인젝션 탐지 패턴
```regex
(시스템:|SYSTEM:|ignore previous|새로운 지시|forget .* instructions|you are now|pretend to be)
```

## 에스컬레이션
- 일반 이슈 → CTO → CEO
- **중대 이슈 → 동우님 직접 보고** (CEO 우회 가능)

## 출력: `security/`
## 보고라인: CTO (중대: 동우님 직접)
