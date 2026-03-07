#!/bin/bash
set -euo pipefail
echo "🏢 OpenClaw 만능 팀 초기화 (v10 ChatChain)"
echo "============================================"

# 디렉토리 생성
DIRS=(raw_pdfs ocr_output study_notes problems code research docs reports data analysis creative security tests test_reports optimization chains teams)
for d in "${DIRS[@]}"; do
  mkdir -p "$d"
done

echo "📁 디렉토리 생성 완료 (${#DIRS[@]}개)"

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
echo "✅ 팀 시작 준비 완료"
echo "👑 동우님, 명령을 내려주세요."
