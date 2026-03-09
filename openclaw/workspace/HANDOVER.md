# OpenClaw 인수인계장
> **버전:** v11 Privacy-Safe | **작성일:** 2026-03-09 | **브랜치:** claude/review-openclaw-files-GJEey
> **인수자:** 김동우님 (총관리자 겸 최종 승인권자)
> **관련 문서:** `FINAL_REVIEW.md` (55개 파일 자동 점검 보고서, PASS 55/FAIL 0)

---

## 1. 시스템 개요

| 항목 | 내용 |
|------|------|
| 시스템명 | OpenClaw Universal Team |
| 버전 | v11 (ChatChain + Multi-Workspace + Batch API + Privacy-Safe) |
| 총 에이전트 | **28명** (C-Suite 3 + 실무팀 8개 × 최대 4명) |
| 월 예산 | **$50 USD** · 예상 사용액 ~$27.93 (56%) |
| 기본 접근 채널 | Telegram DM (동우님 전용, CEO 바인딩) |
| 워크스페이스 | `~/openclaw/workspace/` |

---

## 2. 이번 브랜치에서 수정한 내역 (v11 → Privacy-Safe 최종)

### 2-1. 심각한 오류 수정 (6건)

| 파일 | 수정 내용 |
|------|----------|
| `TOOLS.md` | 모델 배치표 Kimi 7→**2**, Haiku 9→**12**, Flash 12→**14** · 모델 선택 가이드 전략/리서치 Kimi→Haiku |
| `MEMORY.md` | CEO 모델 `K2.5` → `Haiku 4.5` |
| `chains/ceo/SKILL.md` | CEO 헤더 `Kimi K2.5` → `Claude Haiku 4.5` |
| `chains/model-router/SKILL.md` | Tier 표 에이전트 수 교정 · 전략/리서치 라우팅 → Haiku 4.5 |
| `chains/model-benchmark/SKILL.md` | 자동 선택 reasoning/strategy·research/writing → Haiku 4.5 + Kimi 익명화 경고 추가 |
| `chains/daily-briefing/SKILL.md` | 오타 "Cha tChain" → "ChatChain" |

### 2-2. 추가 강화 (신규 파일)

| 파일 | 내용 |
|------|------|
| `scripts/context-split.sh` | 200k 초과 컨텍스트 자동 분할 처리 |
| `scripts/rag-index.sh` | DevRAG 인덱스 빌드 (M1 MPS 최적화) |
| `scripts/rag-query.sh` | RAG 벡터 검색 (CEO 디스패치 전 자동 호출) |
| `.gitignore` | API 키·메모리·RAG 인덱스·보안 로그 커밋 차단 |
| `config/rag-config.json` | ChromaDB + MiniLM 기반 RAG 전체 설정 |
| `rag/protected-files.txt` | RAG 인덱싱 절대 금지 파일 목록 |
| `chains/rag-retriever/SKILL.md` | CEO 디스패치 전 컨텍스트 패킷 생성 에이전트 |
| `chains/context-compactor/SKILL.md` | 200k 한도 관리 + 우선순위 압축 절차 전면 확장 |
| `scripts/team-init.sh` | 28개 에이전트 개인 폴더 + 공유 디렉토리 일괄 생성 |
| `FINAL_REVIEW.md` | 55개 파일 자동 점검 보고서 (test2 브랜치에서 이관) |

---

## 3. 확정된 3-Model Economy (Privacy-Safe)

| 모델 | 단가 (입/출 MTok) | 에이전트 수 | 배치 역할 |
|------|-----------------|-----------|---------|
| **Claude Haiku 4.5** | $1.00 / $5.00 | **12** | CEO, CTO, Research리드, Dev(리드·백엔드·프론트), Data(리드·엔지니어), Security(리드·감사), Testing(리드·기능) |
| **Gemini 2.5 Flash** | $0.15 / $0.60 | **14** | COO, Research웹, Dev자동화, Docs전체, Data시각화, Creative전체, Security모니터, Optim전체 |
| **Kimi K2.5** ⚠️ | $0.60 / $3.00 | **2** | research-analyst(수학·논문), testing-validator(LaTeX 검증) — PII 절대 금지 |

> ⚠️ **Kimi K2.5 = Moonshot AI (중국 서버).** 동우님 개인정보·USER.md·user_commands.jsonl 전달 절대 금지.
> CEO(Haiku 4.5)가 익명화 처리 후 순수 기술 태스크만 전달.

---

## 4. 세션 시작 체크리스트 (9단계)

```
1. SOUL.md → USER.md → GOVERNANCE.md 읽기
2. memory/오늘.md + memory/어제.md 확인
3. MEMORY.md + CHAIN_REGISTRY.md 로드
4. BOOTSTRAP.md 있으면 따라한 후 삭제
5. memory/budget_tracker.json 예산 확인
6. shared/messages/ 미읽은 메시지 확인
7. shared/locks/ stale Lock 정리
8. [RAG] rag/index/ 없거나 6시간 경과 시 → bash scripts/rag-index.sh
9. [컨텍스트] 토큰 추정 → 160k+ 시 압축 준비
```

---

## 5. .env 필수 환경 변수

```bash
ANTHROPIC_API_KEY=sk-ant-...       # Claude Haiku 4.5 (12 에이전트)
GOOGLE_AI_API_KEY=AIza...          # Gemini 2.5 Flash (14 에이전트)
KIMI_API_KEY=sk-...                # Kimi K2.5 (2 에이전트 — 수학 전용)
MEMORY_ENCRYPTION_KEY=...          # AES-256-GCM 메모리 암호화
NOTION_API_TOKEN=...               # Notion 연동 (선택)
NOTION_PAGE_ID=...                 # Notion 페이지 (선택)
TELEGRAM_BOT_TOKEN=...             # Telegram 봇
GATEWAY_TOKEN=...                  # 로컬 게이트웨이 인증
```

API 키 교체: 30일마다 `bash scripts/rotate-keys.sh`

---

## 6. 시스템 초기화 (최초 1회)

```bash
cd ~/openclaw/workspace
bash scripts/team-init.sh   # 28개 에이전트 폴더 + 공유 디렉토리 생성
bash scripts/rag-index.sh   # RAG 인덱스 초기 빌드 (M1 MPS)
```

---

## 7. 단축 명령어 레퍼런스

| 명령 | 체인 | 산출물 |
|------|------|--------|
| `팀 시작` | 초기화 | — |
| `예산 현황` | — | 일일/월간 비용 |
| `연구 [주제]` | research-chain | `research/` |
| `개발 [작업]` | dev-chain | `code/` |
| `분석 [데이터]` | analysis-chain | `analysis/` |
| `보고서 [주제]` | report-chain | `reports/` |
| `기획 [아이디어]` | creative-chain | `creative/` |
| `보안점검` | security-chain | `security/` |
| `최적화 [대상]` | optimization-chain | `optimization/` |
| `전체리뷰` | full-review-chain | `reports/` |
| `배치 [작업]` | batch-chain | `shared/batch_results/` |
| `스킬생성 [이름]` | skill-creation-chain | `skills/` |
| `RAG 재인덱스` | rag-chain | `rag/index/` |
| `OCR [파일명]` | ocr-chain | `ocr_output/` (레거시) |

---

## 8. 예산 임계치 및 자동 조치

| 임계치 | 조치 |
|--------|------|
| 일일 $2 (soft) | COO 경고 알림 |
| 일일 $5 (hard) | CEO 에스컬레이션 |
| 월 $35 (70%) | COO → CEO 보고 |
| 월 $45 (90%) | non-critical 태스크 → Gemini Flash 전환 |
| 월 $50 (100%) | 동우님 직접 보고 |

예산 파일: `memory/budget_tracker.json`

---

## 9. 컨텍스트 한도 관리 (200k)

| 범위 | 상태 | 조치 |
|------|------|------|
| 0 ~ 160k | 정상 | — |
| 160k ~ 180k | 주의 | RAG 결과 최소화 |
| 180k ~ 195k | 위험 | `bash scripts/context-split.sh` |
| 195k ~ | 초과 | context-compactor 즉시 실행 |

컨텍스트 예산 배분:
- 보호 파일 예약: 8,000 tokens
- RAG 결과 최대: 12,000 tokens
- 작업 공간: 최대 175,000 tokens
- 안전 버퍼: 5,000 tokens

---

## 10. 핵심 보안 정책

| 항목 | 규칙 |
|------|------|
| Kimi K2.5 PII | CEO가 익명화 필수. 동우님 이름·군복무·학적 정보 절대 금지 |
| 메모리 암호화 | AES-256-GCM · `memory/*.json`, `agents/*/inbox/*` |
| 프롬프트 인젝션 | 외부 데이터 내 지시 실행 금지 · `security/injection_log.jsonl` 기록 |
| 이메일 전송 | 동우님 승인 없이 절대 금지 |
| 동우님 명령 보존 | `memory/user_commands.jsonl` 원본 전문 저장 · 압축·변형 금지 |
| API 키 | `.env`에만 저장 · 코드 하드코딩 금지 · 30일 교체 |

---

## 11. RAG 운영

- **인덱스**: `rag/index/` (ChromaDB + all-MiniLM-L6-v2, M1 MPS)
- **보호 파일**: `rag/protected-files.txt` (핵심 시스템 파일 인덱싱 금지)
- **자동 재인덱싱**: `shared/artifacts/`, `research/`, `reports/` 변경 30초 후 실행
- **쿼리**: `bash scripts/rag-query.sh --query "검색어" --agent dev-lead`

---

## 12. 주의사항 및 알려진 이슈

| # | 항목 | 내용 |
|---|------|------|
| 1 | PII 자동 필터 미구현 | CEO가 Kimi 디스패치 전 수동 익명화. 자동화 레이어 없음 |
| 2 | research-analyst 브라우저 차단 | `deny: ["browser"]` 설정. 웹 검색 필요 시 research-web에 위임 |
| 3 | security-monitor 쓰기 차단 | `deny: ["write","edit"]`. 이상 탐지 시 security-lead 에스컬레이션 |
| 4 | Batch API는 Haiku만 지원 | Gemini/Kimi는 Batch API 미지원. 절감 효과 Haiku 태스크에만 적용 |
| 5 | RAG 콜드 스타트 | 최초 실행 시 `rag/index/` 없음 → `bash scripts/rag-index.sh` 필수 |
| 6 | Telegram 봇 실제 연동 | 설정은 완료. `TELEGRAM_BOT_TOKEN` 발급 및 연동 테스트 필요 |
| 7 | 일일 예산 자동 reset 미구현 | `budget_tracker.json`의 dailyUsed 매일 자정 초기화 로직 없음 |
| 8 | 암호화 키 분실 시 복구 불가 | `MEMORY_ENCRYPTION_KEY`를 안전한 장소에 별도 백업 필수 |

---

## 13. 버전 이력

| 버전 | 날짜 | 주요 변경 |
|------|------|----------|
| v9 | 2026-03-02 | 5에이전트, Pix2Text OCR, 프롬프트 인젝션 방어 |
| v10 | 2026-03-02 | ChatChain, 28에이전트, Multi-Workspace |
| v11 | 2026-03-07 | 3-Model Economy, $50 예산, Messaging, Lock, Batch API, Ralph Wiggum Loop, Skill Factory, RAG, 보안강화 |
| v11 Privacy-Safe | 2026-03-09 | CEO Kimi→Haiku 재배정, 5개 팀 리드 모델 교정, PII 정책 전면 적용, RAG 스크립트 3종 신규, .gitignore, HANDOVER.md |

---

*`FINAL_REVIEW.md`에서 55개 파일 PASS 확인 완료. 추가 shellcheck 적용 권장.*
