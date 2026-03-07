#!/bin/bash
# Anthropic Batch API 제출 스크립트
set -euo pipefail

QUEUE_DIR="shared/batch_queue"
RESULTS_DIR="shared/batch_results"
API_KEY="${ANTHROPIC_API_KEY}"

# 큐에 파일이 있는지 확인
COUNT=$(find "$QUEUE_DIR" -name "*.json" 2>/dev/null | wc -l)
if [ "$COUNT" -eq 0 ]; then
  echo "📭 배치 큐 비어있음"
  exit 0
fi

echo "📦 $COUNT건 배치 제출 준비..."

# 요청 배열 구성
REQUESTS="["
FIRST=true
for f in "$QUEUE_DIR"/*.json; do
  [ -f "$f" ] || continue
  if [ "$FIRST" = true ]; then FIRST=false; else REQUESTS+=","; fi
  REQUESTS+=$(cat "$f")
done
REQUESTS+="]"

# API 호출
RESPONSE=$(curl -s -X POST "https://api.anthropic.com/v1/messages/batches" \
  -H "x-api-key: $API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "{\"requests\": $REQUESTS}")

BATCH_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id','ERROR'))")
echo "✅ 배치 제출 완료: $BATCH_ID"

# 큐 정리
rm -f "$QUEUE_DIR"/*.json
echo "$RESPONSE" > "$RESULTS_DIR/${BATCH_ID}.json"
echo "📋 결과 폴링: scripts/batch-poll.sh $BATCH_ID"
