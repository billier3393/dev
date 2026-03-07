# API 모델 연동 가이드 (v11 — 3-Model Economy)

## 사전 준비
`.env` 파일에 3개 API 키를 설정:
```bash
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_AI_API_KEY=AIza...
KIMI_API_KEY=sk-...
```

## 모델 확인
```bash
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

# Kimi (K2.5) — OpenAI-compatible
curl -s https://api.moonshot.cn/v1/chat/completions \
  -H "Authorization: Bearer $KIMI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"kimi-k2.5","messages":[{"role":"user","content":"ping"}],"max_tokens":10}'
```

## 모델 ID 매핑
| OpenClaw ID | 실제 API model ID | Provider |
|---|---|---|
| `anthropic/claude-haiku-4.5` | `claude-haiku-4-5-20251001` | Anthropic |
| `google/gemini-2.5-flash` | `gemini-2.5-flash-preview-05-20` | Google AI |
| `kimi/kimi-k2.5` | `kimi-k2.5` | Moonshot (Kimi) |

## ⚠️ 주의
- API 키는 반드시 `.env`에만 저장 (코드에 하드코딩 금지)
- 30일마다 `scripts/rotate-keys.sh`로 키 교체
- 속도 제한: `openclaw.json`의 `rateLimiting` 참조

## openclaw onboard 적용 전 점검
`openclaw onboard` 실행 전에 아래를 먼저 확인:

```bash
# 1) 설정 파일 문법 확인
jq . ~/openclaw/openclaw.json

# 2) 필수 키 확인 (.env)
set -a && source ~/.env && set +a
test -n "$ANTHROPIC_API_KEY" && test -n "$GOOGLE_AI_API_KEY" && test -n "$KIMI_API_KEY"

# 3) 워크스페이스 초기화
cd ~/openclaw/workspace
bash scripts/team-init.sh
```

문제 없으면 onboard 적용:

```bash
openclaw onboard --config ~/openclaw/openclaw.json
```

적용 직후 검증:

```bash
openclaw doctor
openclaw agents list
```
