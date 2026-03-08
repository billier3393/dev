---
name: "messaging-system"
description: "에이전트 간 비동기 메시징. 개인 inbox/outbox + 공유 채널."
metadata: {"openclaw": {"always": true}}
---
# Agent Messaging System

## 메시지 전송
```bash
# 직접 메시지
echo '{"id":"msg-'$(uuidgen)'","from":"dev-lead","to":"testing-lead","type":"request","priority":"normal","subject":"코드 리뷰 요청","body":"shared/handoffs/code-v1.py 검토 부탁","timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","status":"sent"}' >> shared/messages/testing-lead_$(date +%s).jsonl

# 채널 메시지
echo '{"id":"msg-'$(uuidgen)'","from":"cto","to":"tech","type":"notification","priority":"high","subject":"긴급 보안 패치","body":"...","timestamp":"...","status":"sent"}' >> shared/messages/channel_tech_$(date +%s).jsonl
```

## 메시지 읽기
각 에이전트는 세션 시작 시 자기 이름이 포함된 메시지 파일을 스캔:
```bash
ls shared/messages/{my-id}_*.jsonl shared/messages/channel_{my-channels}_*.jsonl 2>/dev/null
```

## 핸드오프 프로토콜
Phase 간 산출물 전달:
1. 발신 에이전트 → `shared/handoffs/{chain}_{phase}_{file}` 저장
2. 메시지로 수신 에이전트에게 알림
3. 수신 에이전트 → 파일 읽기 + 메시지 `processed` 표시
