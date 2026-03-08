---
name: "close-loop"
description: "세션 종료 시 메모리 정리, 체인 로그 마감, 예산 갱신, 암호화."
---
# Close Loop (v11)
1. `memory/YYYY-MM-DD.md` 업데이트
2. 실행 중 ChatChain → 상태 저장
3. 중요 사항 → `MEMORY.md`
4. 토큰/비용 사용량 → `memory/budget_tracker.json` 갱신
5. `teams/governance_log.md` 업데이트
6. `shared/locks/` stale 정리
7. `shared/messages/` 7일 초과 정리
8. 메모리 파일 암호화 확인
