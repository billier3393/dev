#!/bin/bash
# 메모리 파일 복호화
set -euo pipefail
KEY="${MEMORY_ENCRYPTION_KEY:?MEMORY_ENCRYPTION_KEY not set}"

for f in memory/*.enc agents/*/inbox/*.enc agents/*/outbox/*.enc; do
  [ -f "$f" ] || continue
  OUT="${f%.enc}"
  openssl enc -aes-256-gcm -d -salt -in "$f" -out "$OUT" -pass env:MEMORY_ENCRYPTION_KEY
  rm "$f"
  echo "🔓 복호화: $f → $OUT"
done
