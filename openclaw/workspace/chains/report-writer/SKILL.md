---
name: "report-writer"
description: "보고서 자동 작성. 주간/월간 보고, 프로젝트 보고, 비용 보고."
user-invocable: true
---
# Report Writer

## 보고서 유형
1. **주간 효율 보고**: COO → CEO → 동우님
2. **월간 조직 리뷰**: CEO → 동우님
3. **비용 분석 보고**: 모델별/팀별 사용량 + 예산 현황
4. **프로젝트 보고**: 특정 체인 실행 결과 종합
5. **보안 감사 보고**: 보안팀 → 동우님

## 자동 수집
- `memory/budget_tracker.json` → 비용 데이터
- `chains/` → 체인 실행 이력
- `teams/governance_log.md` → 승인 이력
- `security/injection_log.jsonl` → 보안 이벤트

## 모델: Kimi K2.5 (고품질 글쓰기)
