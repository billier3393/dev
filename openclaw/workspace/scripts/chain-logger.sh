#!/bin/bash
set -euo pipefail
CHAIN_ID=${1:-"unknown"}
TODAY=$(date +%Y-%m-%d)
LOG_FILE="chains/${TODAY}_${CHAIN_ID}.md"
mkdir -p chains

if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" << TEMPLATE
# ${CHAIN_ID} 실행 로그
- 시작: $(date +"%Y-%m-%d %H:%M")
- 요청: [요청 내용]

TEMPLATE
fi

echo "$LOG_FILE"
