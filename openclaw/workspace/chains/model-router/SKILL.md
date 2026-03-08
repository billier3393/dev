---
name: "model-router"
description: "태스크별 최적 모델 자동 선택. 3-Model Economy 기반."
metadata: {"openclaw": {"always": true}}
---
# Model Router (v11 — 3-Tier)

| Tier | 모델 | 가격 (입/출) | 용도 | 에이전트 수 |
|------|------|-------------|------|------------|
| 1 | Haiku 4.5 | $1.00/$5.00 | 코딩·오케스트레이션·보안·데이터·전략·리서치 | **12** |
| 2 | Gemini Flash | $0.15/$0.60 | 대량·OCR·문서·포맷·모니터링·운영 | **14** |
| 3 ⚠️ | Kimi K2.5 | $0.60/$3.00 | 수학·과학 형식 추론 **전용** (익명화 필수) | **2** |

> ⚠️ Kimi K2.5는 중국 서버 처리. CEO가 PII 제거 후 익명 기술 태스크만 전달.

## 자동 라우팅 규칙
- 코드 → Haiku 4.5 (SWE-bench 73.3%)
- 수학/물리 (익명화 후) → Kimi K2.5 (MATH 98%)
- 전략/분석/오케스트레이션 → Haiku 4.5 (Anthropic 미국 서버)
- 리서치·글쓰기 (PII 포함 가능) → Haiku 4.5 (안전)
- 대량/포맷 → Gemini Flash ($0.15)
- 예산 위험 시 → 전부 Gemini Flash

## 동적 전환
CEO 또는 Model Benchmark Router가 태스크 분석 후 자동으로 에이전트의 모델 오버라이드 가능.
`shared/messages/` 를 통해 모델 전환 지시 전달.
