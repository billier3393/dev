# TOOLS.md — 환경 설정 (v11 — 3-Model Economy · Privacy-Safe)

## 모델 구성 (3종)
| 모델 | 가격 (입/출 MTok) | 용도 | 할당 에이전트 수 |
|------|------------------|------|-----------------|
| Kimi K2.5 ⚠️ | $0.60 / $3.00 | 수학·과학 형식 추론 **전용** (PII 절대 금지) | **2** (research-analyst, testing-validator) |
| Claude Haiku 4.5 | $1.00 / $5.00 | 코딩·오케스트레이션·보안·데이터·안전 처리 | **12** |
| Gemini 2.5 Flash | $0.15 / $0.60 | 대량처리·OCR·문서·포맷·모니터링·운영 | **14** |

> ⚠️ **Kimi K2.5 = Moonshot AI (중국 서버)** — PII/개인정보 전달 절대 금지.
> CEO(Haiku 4.5)가 디스패치 전 반드시 익명화하여 순수 기술 태스크만 전달.

## 모델 선택 가이드 (Model Benchmark Router 참조)
| 태스크 유형 | 권장 모델 | 벤치마크 근거 |
|-------------|----------|---------------|
| 코드 작성·리뷰 | Haiku 4.5 | SWE-bench 73.3% |
| 수학·물리·수식 검증 (익명화된 데이터만) | Kimi K2.5 | MATH 98.0% |
| 전략·의사결정·오케스트레이션 | Haiku 4.5 | Anthropic (미국) — 안전, SWE 73.3% |
| 리서치·글쓰기 (PII 포함 가능) | Haiku 4.5 | Anthropic (미국) — 안전 |
| 대량 처리·자동화·OCR | Gemini Flash | 최저 비용 ($0.15) |
| 포맷팅·변환·문서 | Gemini Flash | 최저 비용 |
| 모니터링·로깅·운영 | Gemini Flash | 최저 비용 |

## Batch API (Anthropic)
- Haiku 4.5 Batch: $0.50 / $2.50 (50% 할인)
- 비긴급 작업(코드리뷰, 대량분석, 보고서) → Batch 큐에 적재
- 15분마다 또는 100건 도달 시 배치 제출
- 결과는 `shared/batch_results/`에 저장

## Pix2Text
- CLI: `p2t predict -i <input> -o <o> --file-type pdf`
- HTTP: `http://localhost:8503/pix2text`
- 출력: Markdown + LaTeX

## 채널
- Telegram: 동우님 전용 DM
- Gateway: localhost:18789 (loopback only)

## 파일 구조
```
workspace/
├── agents/         → 에이전트 개인 작업공간
├── shared/         → 팀 간 협업 공간
├── memory/         → 세션 기억 (암호화)
├── chains/         → ChatChain 실행 로그
├── teams/          → 팀 구성·확장 기록
├── skills/         → 에이전트 스킬 정의
├── scripts/        → 유틸리티 스크립트
└── config/         → 설정 파일
```
