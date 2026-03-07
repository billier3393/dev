#!/bin/bash
# 메모리 파일 AES-256-GCM 암호화
set -euo pipefail
KEY="${MEMORY_ENCRYPTION_KEY:?MEMORY_ENCRYPTION_KEY not set}"

for f in memory/*.json memory/*.jsonl agents/*/inbox/* agents/*/outbox/*; do
  [ -f "$f" ] || continue
  openssl enc -aes-256-gcm -salt -in "$f" -out "${f}.enc" -pass env:MEMORY_ENCRYPTION_KEY
  rm "$f"
  echo "🔐 암호화: $f → ${f}.enc"
done
