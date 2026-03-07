---
name: "batch-api"
description: "Anthropic Batch API 관리. 비긴급 Haiku 태스크를 모아 50% 할인으로 처리."
---
# Batch API Manager

## 개요
비긴급 Claude Haiku 4.5 태스크를 `shared/batch_queue/`에 적재하고,
15분마다 또는 100건 도달 시 Anthropic Batch API로 제출하여 50% 비용 절감.

## 적격 태스크
- 코드 리뷰 (비긴급)
- 대량 분석
- 보고서 생성
- 데이터 처리
- OCR 후처리 배치

## 큐 형식
`shared/batch_queue/{timestamp}_{agent}_{task}.json`:
```json
{
  "custom_id": "agent-{id}-task-{uuid}",
  "params": {
    "model": "claude-haiku-4-5-20251001",
    "max_tokens": 2048,
    "messages": [...]
  },
  "metadata": {
    "agent": "dev-lead",
    "chain": "dev-chain",
    "phase": "code-review",
    "priority": "low",
    "queued_at": "ISO-8601"
  }
}
```

## 배치 제출 스크립트
`scripts/batch-submit.sh` → 큐 수집 → API 제출 → 결과 폴링 → 배포

## 비용 절감 효과
- Haiku 표준: $1.00/$5.00
- Haiku Batch: $0.50/$2.50
- **월 Batch 사용 비율 30% 가정 시 → ~$4.50 절약**
