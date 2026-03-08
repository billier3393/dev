#!/bin/bash
# Batch API 결과 폴링
set -euo pipefail
BATCH_ID="${1:?Usage: batch-poll.sh <batch_id>}"
API_KEY="${ANTHROPIC_API_KEY}"

while true; do
  RESPONSE=$(curl -s "https://api.anthropic.com/v1/messages/batches/$BATCH_ID" \
    -H "x-api-key: $API_KEY" -H "anthropic-version: 2023-06-01")
  STATUS=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('processing_status','unknown'))")
  echo "⏳ 상태: $STATUS"
  if [ "$STATUS" = "ended" ]; then
    echo "✅ 배치 완료!"
    # 결과 다운로드
    curl -s "https://api.anthropic.com/v1/messages/batches/$BATCH_ID/results" \
      -H "x-api-key: $API_KEY" -H "anthropic-version: 2023-06-01" \
      > "shared/batch_results/${BATCH_ID}_results.jsonl"
    echo "📄 결과 저장: shared/batch_results/${BATCH_ID}_results.jsonl"
    break
  fi
  sleep 60
done
