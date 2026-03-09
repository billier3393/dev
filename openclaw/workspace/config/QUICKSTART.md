# OpenClaw v11 — 빠른 설치 가이드

> 처음부터 `팀 시작`까지 약 **15분** 소요

---

## 시스템 요구사항

| 항목 | 요건 |
|------|------|
| OS | macOS 12+ (Apple Silicon 권장) / Ubuntu 20.04+ |
| Python | 3.10 이상 |
| 도구 | `bash`, `curl`, `openssl` |
| API 키 | Anthropic · Google AI · Kimi (Moonshot) |

---

## Step 0 — 저장소 클론 (30초)

```bash
git clone https://github.com/billier3393/dev.git ~/openclaw-project
cd ~/openclaw-project
```

---

## Step 1 — Python 의존성 설치 (3–5분)

```bash
pip install chromadb sentence-transformers torch
```

> Apple Silicon(M1/M2/M3): MPS 가속이 자동으로 적용됩니다.
> Linux / Intel Mac: CPU 모드로 동작합니다.

---

## Step 2 — API 키 설정 (5분)

### 2-1. .env 파일 생성

```bash
cat > openclaw/.env << 'EOF'
# 필수 (3개)
ANTHROPIC_API_KEY=sk-ant-여기에_입력
GOOGLE_AI_API_KEY=AIza여기에_입력
KIMI_API_KEY=sk-여기에_입력

# 선택
NOTION_API_TOKEN=secret_여기에_입력
NOTION_PAGE_ID=여기에_입력
TELEGRAM_BOT_TOKEN=여기에_입력
GATEWAY_TOKEN=여기에_입력

# 메모리 암호화 키 (아래 명령어로 생성)
MEMORY_ENCRYPTION_KEY=
EOF
```

암호화 키 생성 후 위 파일에 붙여넣기:

```bash
openssl rand -base64 32
```

### 2-2. API 연결 확인

```bash
source openclaw/.env

# Anthropic (Claude Haiku 4.5)
curl -s https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-haiku-4-5-20251001","max_tokens":10,"messages":[{"role":"user","content":"ping"}]}'

# Google (Gemini 2.5 Flash)
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$GOOGLE_AI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"ping"}]}]}'

# Kimi K2.5 (OpenAI-compatible)
curl -s https://api.moonshot.cn/v1/chat/completions \
  -H "Authorization: Bearer $KIMI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"kimi-k2.5","messages":[{"role":"user","content":"ping"}],"max_tokens":10}'
```

각 명령어에서 JSON 응답이 오면 정상입니다.

---

## Step 3 — 팀 초기화 (1분)

```bash
cd openclaw/workspace
bash scripts/team-init.sh
```

완료 시 17개 디렉토리 생성 + 28개 에이전트 준비 완료 메시지가 출력됩니다.

---

## Step 4 — RAG 인덱싱 (3–10분)

```bash
bash scripts/rag-index.sh
```

완료 후 `rag/index/` 디렉토리가 생성됩니다.

---

## Step 5 — 메모리 암호화 (선택)

```bash
bash scripts/encrypt-memory.sh
```

> `MEMORY_ENCRYPTION_KEY` 가 `.env`에 설정되어 있어야 합니다.

---

## Step 6 — 작동 확인 (1분)

Claude Code 세션에서 순서대로 입력:

```
팀 시작
```
```
팀 현황
```
```
연구 AI 최신 동향
```

CEO(Haiku 4.5)가 응답하면 설치 완료입니다.

---

## 주요 명령어 요약

| 명령어 | 동작 |
|--------|------|
| `팀 시작` | 전체 초기화 |
| `연구 [주제]` | 리서치 체인 |
| `개발 [작업]` | 개발 체인 |
| `분석 [데이터]` | 분석 체인 |
| `보고서 [주제]` | 보고서 체인 |
| `기획 [아이디어]` | 크리에이티브 체인 |
| `보안점검` | 보안 체인 |
| `최적화 [대상]` | 최적화 체인 |
| `배치 [작업]` | Batch API 체인 |
| `스킬생성 [이름]` | Skill Factory |
| `예산 현황` | 일/월 비용 확인 |

---

## 주의사항

- ⚠️ `.env` 파일은 `.gitignore`에 포함됨 — **절대 커밋하지 말 것**
- ⚠️ Kimi K2.5(`research-analyst`, `testing-validator`)에 개인정보 전달 금지
- ⚠️ `openclaw.json` 수정 전 백업 필수: `cp openclaw/openclaw.json openclaw/openclaw.json.bak`
- ⚠️ 월 예산 $50 한도 — `bash scripts/token-monitor.sh`로 수시 확인

---

## 문제 해결

| 증상 | 조치 |
|------|------|
| RAG 인덱싱 실패 | `pip install chromadb sentence-transformers` 재설치 |
| API 연결 오류 | `.env` 키 값 공백/줄바꿈 여부 확인 |
| MPS 오류 | `export PYTORCH_ENABLE_MPS_FALLBACK=1` 후 재실행 |
| Lock 잠김 | `bash scripts/session-cleanup.sh` 실행 |

---

*전체 설정 세부 사항 → [`copilot-setup.md`](./copilot-setup.md) | [`project-setup.md`](./project-setup.md)*
