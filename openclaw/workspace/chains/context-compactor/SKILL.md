---
name: "context-compactor"
description: "컨텍스트 80%+ 시 자동 압축 + 200k 글로벌 한도 관리. 보호 파일·동우님 원본 명령은 절대 압축하지 않음."
---
# Context Compactor (v11 + RAG)

## 200k 글로벌 한도 관리

모든 에이전트는 **200,000 토큰** 한도를 초과하면 안 된다.

```
[컨텍스트 사용량 체크]
  │
  ├─ < 160k (80%) → 정상 운영
  ├─ 160k~180k    → 압축 준비 시작
  ├─ 180k~195k    → context-split.sh 호출 고려
  └─ > 195k       → 즉시 압축 실행
```

## 컨텍스트 구성 우선순위

| 우선순위 | 콘텐츠 | 압축 가능? | 비고 |
|---------|--------|-----------|------|
| **P0** | 보호 파일 (SOUL.md, USER.md 등) | ❌ 절대 불가 | 항상 전문 로드 |
| **P0** | 동우님 원본 명령 | ❌ 절대 불가 | user_commands.jsonl 참조 |
| **P1** | RAG 검색 결과 | △ 재검색 가능 | 점수 낮은 것 제거 |
| **P2** | 현재 Phase 작업 컨텍스트 | △ 요약 가능 | Self-Review 완료분 |
| **P3** | 이전 Phase 전문 | ✅ 요약 압축 | 핵심만 보존 |
| **P4** | 과거 대화 이력 | ✅ 삭제/압축 | SCRATCH.md 저장 후 제거 |

## 압축 절차

1. 현재 작업 상태 → `memory/SCRATCH.md` 저장
2. **⚠️ 보호 파일 목록 확인** (`rag/protected-files.txt`)
   - 해당 파일 내용은 압축 대상에서 완전 제외
3. **⚠️ 동우님 원본 명령은 압축 대상에서 제외**
4. 실행 중 ChatChain 상태 → `chains/logs/` 저장
5. RAG 결과 중 점수 낮은 항목 제거 (threshold 이하)
6. 이전 Phase 내용 → 핵심 요약 (3~5문장)
7. `/compact` 실행
8. `memory/SCRATCH.md` 읽어서 복원
9. `memory/user_commands.jsonl`에서 원본 명령 다시 로드
10. 필요 시 보호 파일 재로드

## 200k 초과 컨텐츠 분할처리

컨텍스트에 로드할 외부 파일이 200k를 초과하는 경우:

```bash
bash scripts/context-split.sh \
  --input "$LARGE_FILE" \
  --chunk-size 180000 \
  --overlap 2000 \
  --summary-model "google/gemini-2.5-flash" \
  --output "shared/handoffs/split_summary_$(date +%s).md"
```

- 분할처리 후 요약본만 컨텍스트에 로드
- 원본 파일은 `shared/artifacts/`에 보관
- 수식·코드·수치는 요약에서 반드시 보존

## 토큰 예산 실시간 관리

```
[글로벌 한도] 200,000 tokens
  ├─ 보호 파일 예약: 8,000
  ├─ RAG 결과: 최대 12,000
  ├─ 현재 작업: 최대 175,000
  └─ 안전 버퍼: 5,000
```
