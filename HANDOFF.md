# HANDOFF.md — 세션 인수인계장
> 저장일시: 2026-03-09 | 브랜치: `claude/claude-code-mac-guide-PqRs1`

---

## 1. 현재 작업 요약

**이번 세션에서 완료한 작업 2가지:**

### A. OpenClaw + setup-mac.sh 전체 교차 검토
- `setup-mac.sh`, `CLAUDE.md`, `.gitignore`, `openclaw/openclaw.json`, `copilot-setup.md` 전체 검토
- 총 **5개 버그/누락** 발견 및 수정 완료

### B. 수정 내용 (커밋: `f209ec3`)
| # | 파일 | 수정 내용 |
|---|------|----------|
| 1 | `setup-mac.sh` | `MODEL_HAIKU="claude-haiku-4-6"` → `"claude-haiku-4-5-20251001"` (존재하지 않는 모델 ID 수정) |
| 2 | `setup-mac.sh` | Excel Python `MODEL_MAP["haiku 4.6"]` → `"haiku 4.5"`, 실제 API ID 수정 |
| 3 | `setup-mac.sh` | `MODEL_LABELS["Haiku 4.6"]` → `"Haiku 4.5"`, 완료 배너 텍스트 동일 수정 |
| 4 | `CLAUDE.md` | `Sonnet 4.5`(미존재) → `Sonnet 4.6`, 모델 표를 CLI용·에이전트용 2개로 분리, 실제 모델 ID 병기 |
| 5 | `.gitignore` | `*.bak`(sed 백업 파일), `team-config.xlsx`(API 키 포함) 누락 항목 추가 |

---

## 2. 진행 중인 작업

없음 — 이번 세션 작업 모두 완료 및 push됨.

---

## 3. 주요 결정 사항

### 모델 ID 확정
- **Haiku**: `claude-haiku-4-5-20251001` (4.6은 미출시, 시스템 확인)
- **Sonnet**: `claude-sonnet-4-6`
- **Opus**: `claude-opus-4-6`
- **Gemini**: `gemini-2.5-flash-preview-05-20` (날짜 고정 preview ID, 주기 확인 필요)
- **Kimi**: `kimi-k2.5`

### OpenClaw는 setup-mac.sh와 별개 시스템
- `toolSearch: "auto"` → Claude Code CLI 전용, OpenClaw 에이전트에 불필요
- `team-config.xlsx` → 터미널 단축키 함수용, OpenClaw 에이전트 모델은 `openclaw.json`에서 관리
- OpenClaw 보안(AES-256-GCM, 인젝션 방어, 예산 관리)은 이미 구현됨

### CLAUDE.md 구조 결정
- Claude Code CLI용 모델 표와 OpenClaw 에이전트용 3-Model Economy 표를 **분리 병기**
- 각 항목에 실제 API 모델 ID 명시

---

## 4. 다음 세션 할 일 (우선순위 순)

1. **[HIGH] Gemini preview ID 확인**
   - `gemini-2.5-flash-preview-05-20` — 날짜 고정 preview ID
   - Google AI API에서 현재 유효한지, 더 최신 ID로 교체 필요한지 확인
   - 변경 시: `openclaw.json` → `models.providers.google.models.gemini-2.5-flash.id`
   - 변경 시: `copilot-setup.md` → curl 예제 URL

2. **[MEDIUM] openclaw.json 컨텍스트 30% 경고 추가 검토**
   - 현재 `budget.warningThresholdPercent: 70` (예산 기준)은 있지만 **토큰 기준 30% 경고**는 없음
   - `contextManagement.chunkingPolicy`에 token warning threshold 추가 고려

3. **[LOW] setup-mac.sh Excel: 사용 전 실행 테스트**
   - Python MODEL_MAP 키 변경(`haiku 4.6` → `haiku 4.5`)으로 기존 저장된 `team-config.xlsx` 있을 경우 호환성 체크 필요
   - `generate_excel()` 함수 재실행으로 새 xlsx 생성 권장

4. **[LOW] chains/ 디렉터리 수 불일치 확인**
   - `CLAUDE.md`는 "33개 ChatChain", `CHAIN_REGISTRY.md`는 14개 등록
   - chains/ 실제 파일 수와 문서 간 수치 정합성 맞추기

---

## 5. 관련 파일

```
수정된 파일:
  /home/user/dev/claude-code-mac-guide/setup-mac.sh   # 모델 상수, Excel Python, CLAUDE.md 템플릿
  /home/user/dev/CLAUDE.md                             # 모델 선택 기준 표 전면 개정
  /home/user/dev/.gitignore                            # *.bak, team-config.xlsx 추가

확인한 파일 (수정 없음):
  /home/user/dev/openclaw/openclaw.json                # 3-Model Economy 설정 (정상)
  /home/user/dev/openclaw/workspace/config/copilot-setup.md  # API 연동 가이드
  /home/user/dev/openclaw/workspace/SOUL.md
  /home/user/dev/openclaw/workspace/AGENTS.md
```

---

## 6. 주의사항

### ⚠️ 반드시 알아야 할 사항

1. **Haiku 4.6은 존재하지 않음**
   - `claude-haiku-4-6` API 호출 시 404/오류 발생
   - 현재 최신 Haiku: `claude-haiku-4-5-20251001`
   - 다른 스크립트/설정 파일에 `haiku-4-6` 남아있는지 전체 검색 권장: `grep -r "haiku-4-6" .`

2. **Kimi K2.5 — PII 절대 금지**
   - API 엔드포인트: `https://api.moonshot.cn` (중국 서버)
   - 어떤 개인정보도 Kimi 에이전트(research-analyst, testing-validator)에 전달 금지

3. **openclaw.json 수정 전 백업 필수**
   ```bash
   cp openclaw/openclaw.json openclaw/openclaw.json.bak
   ```
   `.bak` 파일은 `.gitignore`에 추가됨 — git에 올라가지 않음

4. **team-config.xlsx 생성 위치**
   - setup-mac.sh 실행 시 생성 위치: `~/team-config.xlsx` (홈 디렉터리)
   - 이 파일은 `.gitignore`에 추가됨 — git에 올라가지 않음

5. **브랜치**
   - 현재 작업 브랜치: `claude/claude-code-mac-guide-PqRs1`
   - 원격 push 완료 (`f209ec3`)

---

> `/handoff load` 로 이 파일을 다음 세션에서 복원하세요.
