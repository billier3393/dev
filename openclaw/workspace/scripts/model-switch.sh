#!/bin/bash
# 모델 전환 스크립트 (v11 — 3-Model Economy)
# 사용법: model-switch.sh <agent-id> <model-tier>
# Tier: kimi | haiku | flash
set -euo pipefail

AGENT="${1:?Usage: model-switch.sh <agent-id> <tier: kimi|haiku|flash>}"
TIER="${2:?Usage: model-switch.sh <agent-id> <tier: kimi|haiku|flash>}"

case "$TIER" in
  kimi)   MODEL="kimi/kimi-k2.5"              ; LABEL="Kimi K2.5 ($0.60/$3.00)" ;;
  haiku)  MODEL="anthropic/claude-haiku-4.5"   ; LABEL="Claude Haiku 4.5 ($1.00/$5.00)" ;;
  flash)  MODEL="google/gemini-2.5-flash"      ; LABEL="Gemini 2.5 Flash ($0.15/$0.60)" ;;
  *)      echo "❌ 알 수 없는 tier: $TIER (kimi|haiku|flash)"; exit 1 ;;
esac

echo "🔄 모델 전환: $AGENT → $LABEL"
echo "   shared/messages/ 에 전환 알림 기록"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
echo "{\"from\":\"system\",\"to\":\"$AGENT\",\"type\":\"notification\",\"subject\":\"모델 전환\",\"body\":\"$MODEL 으로 전환됨\",\"timestamp\":\"$TIMESTAMP\"}" >> "shared/messages/${AGENT}_model_switch.jsonl"
echo "✅ 전환 완료"
