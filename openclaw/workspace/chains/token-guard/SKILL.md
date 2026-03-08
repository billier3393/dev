---
name: "token-guard"
description: "토큰/비용 모니터링. $50/월 예산 관리. 모델 다운그레이드 트리거."
metadata: {"openclaw": {"always": true}}
---
# Token Guard (v11)

## 비용 절약 규칙
1. 응답 길이 = 질문 복잡도에 비례
2. 코드: diff 형식 우선
3. 스킬: 온디맨드 로딩
4. 하트비트: `HEARTBEAT_OK` (1토큰)
5. 컨텍스트 80%+ → context-compactor 실행
6. Quick Chain 적극 활용
7. 비긴급 Haiku 태스크 → Batch API (50% 할인)
8. 동일 품질 가능 시 → Gemini Flash 우선

## 예산 모니터링
- 일일: soft $2 / hard $5
- 월간: $50 (70% 경고 / 90% 위험)
- 위험 시 자동 조치:
  - 70%: COO에게 경고 알림
  - 90%: 모든 non-critical → Gemini Flash 전환
  - 100%: CEO에게 에스컬레이션, 동우님 보고

## 캐싱 없음
- memorySearch.cache.enabled = false
- 모든 조회는 실시간 수행
- 비용은 순수 API 호출 기반으로 추적
