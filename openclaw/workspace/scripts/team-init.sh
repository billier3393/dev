#!/bin/bash
set -euo pipefail

echo "🏢 OpenClaw 만능 팀 초기화 (v11 ChatChain + Multi-Workspace)"
echo "=============================================================="

# 워크스페이스 디렉토리 생성 (openclaw.json과 동기화)
BASE_DIRS=(
  agents
  shared/messages
  shared/locks
  shared/batch_queue
  shared/batch_results
  shared/handoffs
  shared/artifacts
  memory
  chains
  teams
  security
)

for d in "${BASE_DIRS[@]}"; do
  mkdir -p "$d"
done

# 개인 작업공간 구조 생성
AGENTS=(
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

PERSONAL_SUBDIRS=(inbox outbox workspace scratch)

for agent in "${AGENTS[@]}"; do
  for sub in "${PERSONAL_SUBDIRS[@]}"; do
    mkdir -p "agents/${agent}/${sub}"
  done
done

# 운영 파일 초기화
touch memory/budget_tracker.json memory/user_commands.jsonl security/injection_log.jsonl

echo "📁 기본 디렉토리 생성 완료 (${#BASE_DIRS[@]}개)"
echo "👤 개인 워크스페이스 생성 완료 (${#AGENTS[@]}명 x ${#PERSONAL_SUBDIRS[@]}개)"

# 팀 현황 확인
echo ""
echo "👥 팀 구성:"
echo "  C-Suite: CEO, CTO, COO"
echo "  리서치팀: Lead + Web + Analyst (3명)"
echo "  개발팀: Lead + Backend + Frontend + Automation (4명)"
echo "  문서팀: Lead + Writer + Formatter (3명)"
echo "  데이터팀: Lead + Engineer + Viz (3명)"
echo "  크리에이티브팀: Lead + Content + Design (3명)"
echo "  보안팀: Lead + Auditor + Monitor (3명)"
echo "  테스팅팀: Lead + Functional + Validator (3명)"
echo "  최적화팀: Lead + Perf + Process (3명)"
echo ""
echo "  총 에이전트: 27명"
echo ""
echo "✅ 팀 시작 준비 완료 (openclaw onboard 적용 가능 상태)"
echo "👑 동우님, 명령을 내려주세요."
