# HANDOFF.md — OpenClaw 에이전트 인수인계장
> 작성일: 2026-03-09 | 버전: v11 | 브랜치: `claude/claude-code-mac-guide-PqRs1`
> 최신 커밋: `12782f5`

---

## 📌 이 파일 읽는 법

세션 시작 루틴(AGENTS.md §1) 완료 후 **즉시 이 파일을 읽을 것.**
CEO → 관련 팀장에게 브리핑, 팀장 → 해당 워커에게 전달.

---

## 1. 시스템 변경 사항 (2026-03-09)

### 1-A. 모델 ID 버그 수정 — **전 에이전트 필독**

| 항목 | 수정 전 (잘못된 값) | 수정 후 (올바른 값) |
|------|------------------|--------------------|
| Haiku 모델 ID | `claude-haiku-4-6` | `claude-haiku-4-5-20251001` |
| Excel 레이블 | `"Haiku 4.6"` | `"Haiku 4.5"` |
| CLAUDE.md 모델표 | `Sonnet 4.5` | `Sonnet 4.6` |

> ⚠️ `claude-haiku-4-6`는 **존재하지 않는 모델 ID**. API 호출 시 오류 발생.
> 현재 최신 Haiku: `claude-haiku-4-5-20251001`

### 1-B. openclaw.json — 변경 없음

`openclaw.json`의 에이전트 모델 설정은 원래부터 정확했음:
- `anthropic/claude-haiku-4.5` → 내부적으로 `claude-haiku-4-5-20251001` 매핑
- `google/gemini-2.5-flash` → `gemini-2.5-flash-preview-05-20`
- `kimi/kimi-k2.5` → `kimi-k2.5`

### 1-C. Excel 연동 기능 추가 (setup-mac.sh v11 업데이트)

이제 `team-config.xlsx` 수정 후 `bash setup-mac.sh` 재실행 시 **세 곳이 자동 반영**됨:

```
① ~/.zshrc      — 팀별 Shell 함수 (기존)
② openclaw.json — 에이전트 모델 업데이트 (신규)
③ .env          — API 키 upsert (신규)
```

**Excel 새 시트 — `🤖 OpenClaw 에이전트`:**
- 28개 에이전트 pre-fill
- E열 `변경 모델` 드롭다운 → 저장 후 재실행하면 `openclaw.json` 자동 업데이트
- 변경 전 `openclaw.json.bak` 자동 생성

**Excel `팀별 설정` 열 변경:**
- F열 → `Kimi API Key` 추가 (구 F열 메모 → G열로 이동)

### 1-D. .gitignore 보안 강화

```
*.bak               # sed/자동 백업 파일 — API 키 노출 방지
team-config.xlsx    # 팀별 API 키 포함 파일 — 로컬 전용
```

---

## 2. 확정된 모델 ID (전 에이전트 기준표)

| OpenClaw 내부 ID | 실제 API 호출 ID | 제공사 | 용도 | PII |
|-----------------|----------------|--------|------|-----|
| `anthropic/claude-haiku-4.5` | `claude-haiku-4-5-20251001` | Anthropic | 코딩·오케스트레이션 | ✅ 안전 |
| `google/gemini-2.5-flash` | `gemini-2.5-flash-preview-05-20` | Google | 대량처리·문서·OCR | ✅ 안전 |
| `kimi/kimi-k2.5` | `kimi-k2.5` | Moonshot (중국 서버) | 수학·과학 추론 | ⛔ 절대 금지 |

> **Gemini 주의**: `gemini-2.5-flash-preview-05-20`는 날짜 고정 preview ID.
> Google이 deprecated 시 오류 발생 → 주기적으로 최신 ID 확인 필요.

---

## 3. 현재 에이전트 모델 배치

| 팀 | 에이전트 ID | 모델 | PII |
|----|-----------|------|-----|
| C-Suite | ceo, cto | `anthropic/claude-haiku-4.5` | ✅ |
| C-Suite | coo | `google/gemini-2.5-flash` | ✅ |
| Research | research-lead | `anthropic/claude-haiku-4.5` | ✅ |
| Research | research-web | `google/gemini-2.5-flash` | ✅ |
| Research | **research-analyst** | `kimi/kimi-k2.5` | ⛔ **PII 금지** |
| Dev | dev-lead, dev-backend, dev-frontend | `anthropic/claude-haiku-4.5` | ✅ |
| Dev | dev-automation | `google/gemini-2.5-flash` | ✅ |
| Docs | docs-lead, docs-writer, docs-formatter | `google/gemini-2.5-flash` | ✅ |
| Data | data-lead, data-engineer | `anthropic/claude-haiku-4.5` | ✅ |
| Data | data-viz | `google/gemini-2.5-flash` | ✅ |
| Creative | creative-lead, creative-content, creative-design | `google/gemini-2.5-flash` | ✅ |
| Security | security-lead, security-auditor | `anthropic/claude-haiku-4.5` | ✅ |
| Security | security-monitor | `google/gemini-2.5-flash` | ✅ |
| Testing | testing-lead, testing-functional | `anthropic/claude-haiku-4.5` | ✅ |
| Testing | **testing-validator** | `kimi/kimi-k2.5` | ⛔ **PII 금지** |
| Optim | optim-lead, optim-perf, optim-process | `google/gemini-2.5-flash` | ✅ |

---

## 4. 다음 세션 할 일 (우선순위 순)

### [HIGH] Gemini preview ID 유효성 확인
```
현재 ID: gemini-2.5-flash-preview-05-20
확인 위치: openclaw/openclaw.json → models.providers.google.models.gemini-2.5-flash.id
           openclaw/workspace/config/copilot-setup.md → curl 예제 URL
담당: CTO 또는 research-web
```

### [MEDIUM] openclaw.json 토큰 30% 경고 추가 검토
```
현재: budget.warningThresholdPercent: 70 (예산 기준만 있음)
필요: contextManagement 섹션에 토큰 기준 early-warning 추가
담당: CTO
```

### [LOW] chains/ 파일 수 정합성
```
CLAUDE.md: "33개 ChatChain"
CHAIN_REGISTRY.md: 14개 등록
실제 chains/ 디렉터리: 확인 필요
담당: COO
```

---

## 5. 주의사항 — 에이전트별 행동 지침

### ⛔ 절대 금지
1. `kimi/kimi-k2.5` 에이전트(research-analyst, testing-validator)에 **PII 전달 금지**
   - PII 포함 데이터는 Haiku 또는 Gemini 에이전트에만 전달
2. `openclaw.json` 수정 전 **백업 필수**:
   ```bash
   cp openclaw/openclaw.json openclaw/openclaw.json.bak
   ```
   `.bak` 파일은 `.gitignore`에 등록됨 — git 노출 없음
3. API 키 절대 로그·메시지·아티팩트에 평문 기록 금지

### ✅ 권장 사항
- `team-config.xlsx`로 에이전트 모델 변경 시 → `bash setup-mac.sh` 재실행 (자동 반영)
- Gemini preview ID 의심 시 → `copilot-setup.md`의 curl로 먼저 테스트
- 새 기능 개발 전 → CEO에게 예산 여유 확인 (`budget_tracker.json`)

---

## 6. 관련 파일

```
수정된 파일 (이번 세션):
  claude-code-mac-guide/setup-mac.sh   # Excel→OpenClaw 연동 구현
  CLAUDE.md                             # 모델 선택 기준 표 개정
  .gitignore                            # *.bak, team-config.xlsx 추가

변경 없음 (정상):
  openclaw/openclaw.json                # 에이전트 모델 설정 원본 정확
  openclaw/workspace/SOUL.md
  openclaw/workspace/AGENTS.md
  openclaw/workspace/config/copilot-setup.md

이 파일:
  openclaw/workspace/HANDOFF.md        # ← 지금 읽는 파일
```

---

> 다음 세션 시작 시 CEO가 이 파일을 읽고 관련 팀장에게 브리핑할 것.
> 작업 완료 후 이 파일의 §4 할 일 목록에서 완료 항목 제거.
