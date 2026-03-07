---
name: "context-compactor"
description: "컨텍스트 80%+ 시 자동 압축. 단, 동우님 원본 명령은 절대 압축하지 않음."
---
# Context Compactor (v11)
1. 현재 작업 상태 → `memory/SCRATCH.md`
2. **⚠️ 동우님 원본 명령은 압축 대상에서 제외**
3. 실행 중 ChatChain 상태 → `chains/` 로그에 저장
4. `/compact` 실행
5. SCRATCH.md 읽어서 복원
6. `memory/user_commands.jsonl`에서 원본 명령 다시 로드
