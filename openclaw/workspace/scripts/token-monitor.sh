#!/bin/bash
set -euo pipefail
mkdir -p memory
RAW=$(openclaw session status --json 2>/dev/null || echo '{"result":{"totalTokens":{"input":0,"output":0}}}')
INPUT=$(echo "$RAW" | python3 -c "import sys,json; print(json.load(sys.stdin).get('result',{}).get('totalTokens',{}).get('input',0))" 2>/dev/null || echo 0)
OUTPUT=$(echo "$RAW" | python3 -c "import sys,json; print(json.load(sys.stdin).get('result',{}).get('totalTokens',{}).get('output',0))" 2>/dev/null || echo 0)
TOTAL=$((INPUT + OUTPUT))
echo "📊 IN=$INPUT OUT=$OUTPUT TOTAL=$TOTAL"
cat > "memory/token_usage_state.json" << EOF2
{"lastCheck":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","input":$INPUT,"output":$OUTPUT,"total":$TOTAL}
EOF2
