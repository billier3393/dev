#!/bin/bash
# API 키 교체 스크립트 (30일마다)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${WORKSPACE_ROOT}/.env"
LOG_FILE="${WORKSPACE_ROOT}/memory/key_rotation_log.json"

mkdir -p "$(dirname "$LOG_FILE")"

echo "🔑 API 키 교체 프로세스 시작..."
echo "⚠️ 각 서비스의 대시보드에서 새 키를 발급받은 후 ${ENV_FILE}에 입력하세요."
echo ""
echo "1. Anthropic: https://console.anthropic.com/settings/keys"
echo "2. Google AI: https://aistudio.google.com/app/apikey"
echo "3. Kimi: https://platform.moonshot.cn/console/api-keys"
echo ""
echo "교체 후 이 스크립트를 다시 실행하여 기록하세요."
echo ""

# 로그 기록
DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
NEXT=$(date -u -d "+30 days" +%Y-%m-%d 2>/dev/null || date -u -v+30d +%Y-%m-%d)
printf '{"rotated_at":"%s","next_rotation":"%s"}\n' "$DATE" "$NEXT" >> "$LOG_FILE"

echo "✅ 키 교체 기록 완료. 다음 교체일: $NEXT"
echo "🗂️ 로그 파일: $LOG_FILE"
