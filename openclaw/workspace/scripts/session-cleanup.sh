#!/bin/bash
set -euo pipefail
TODAY=$(date +%Y-%m-%d)
mkdir -p memory
if [ -f "memory/SCRATCH.md" ]; then
  cat "memory/SCRATCH.md" >> "memory/$TODAY.md"
  rm "memory/SCRATCH.md"
fi
bash scripts/token-monitor.sh 2>/dev/null || true
echo "✅ 세션 정리 완료"
