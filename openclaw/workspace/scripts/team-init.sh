#!/bin/bash
set -euo pipefail

echo "🏢 OpenClaw 만능 팀 초기화 (v11 ChatChain + Multi-Workspace)"
echo "========================================================="

# 실행 위치를 workspace 루트로 강제
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$WORKSPACE_ROOT"

# v11 공유 디렉토리
SHARED_DIRS=(
  shared/messages
  shared/locks
  shared/batch_queue
  shared/batch_results
  shared/handoffs
  shared/artifacts
)

# 보안/메모리 디렉토리
BASE_DIRS=(memory security teams chains)

# 에이전트 개인 작업공간 (personalDir + 표준 구조)
AGENT_IDS=(
  ceo cto coo
  research-lead research-web research-analyst
  dev-lead dev-backend dev-frontend dev-automation
  docs-lead docs-writer docs-formatter
  data-lead data-engineer data-viz
  creative-lead creative-content creative-design
  security-lead security-auditor security-monitor
  testing-lead testing-functional testing-validator
  optim-lead optim-perf optim-process
)
AGENT_SUBDIRS=(inbox outbox workspace scratch)

for d in "${BASE_DIRS[@]}"; do
  mkdir -p "$d"
done

for d in "${SHARED_DIRS[@]}"; do
  mkdir -p "$d"
done

for agent in "${AGENT_IDS[@]}"; do
  for sub in "${AGENT_SUBDIRS[@]}"; do
    mkdir -p "agents/${agent}/${sub}"
  done
done

# v11에서 참조하는 로그/상태 파일 기본 생성
touch memory/key_rotation_log.json
touch memory/user_commands.jsonl
touch security/injection_log.jsonl

if [ ! -f "memory/budget_tracker.json" ]; then
  cat > memory/budget_tracker.json <<'JSON'
{
  "monthly": {
    "limitUSD": 50,
    "usedUSD": 0,
    "resetDay": 1
  },
  "daily": {
    "softLimitUSD": 2,
    "hardLimitUSD": 5,
    "usedUSD": 0
  },
  "updatedAt": null
}
JSON
fi

echo "📁 v11 디렉토리/로그 생성 완료"
echo "   - 공유 디렉토리: ${#SHARED_DIRS[@]}개"
echo "   - 개인 에이전트: ${#AGENT_IDS[@]}명 × ${#AGENT_SUBDIRS[@]}개 서브폴더"
echo ""
echo "👥 팀 구성: 총 ${#AGENT_IDS[@]}명"
echo "✅ 팀 시작 준비 완료"
echo "👑 동우님, 명령을 내려주세요."
