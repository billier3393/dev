---
name: "rag-retriever"
description: "DevRAG 기반 컨텍스트 검색. CEO의 명령 분석 후 관련 문서를 검색하여 각 에이전트에게 필요한 컨텍스트만 정제 전달."
user-invocable: false
triggers: ["internal — CEO 디스패치 전 자동 호출"]
---
# RAG Retriever — [RAG] (Gemini Flash)

> **핵심 원칙**: 보호 파일(SOUL.md, USER.md, GOVERNANCE.md 등)은 절대 RAG 대상이 아님.
> 항상 직접 컨텍스트에 로드되며 RAG 검색 결과로 대체되지 않는다.

## 역할
CEO 디스패치 전 호출되어 태스크 관련 문서를 검색하고,
각 에이전트가 필요로 하는 컨텍스트 패킷을 최소화하여 준비한다.

---

## 처리 흐름

```
[CEO 명령 수신]
       │
       ▼
1. 명령 키워드 추출 (NLP 파싱)
       │
       ▼
2. DevRAG 벡터 검색 (scripts/rag-query.sh)
   - 보호 파일 목록과 교차 확인 → 보호 파일은 검색 결과에서 제외
   - topK=5, scoreThreshold=0.65
       │
       ▼
3. 컨텍스트 예산 계산
   - 보호 파일 예약: ~8,000 tokens
   - RAG 결과 예산: ~12,000 tokens
   - 에이전트 작업 예산: 나머지 (~180,000 tokens)
       │
       ▼
4. 에이전트별 컨텍스트 패킷 생성
   - 각 에이전트가 실제로 필요한 문서만 포함
   - 무관한 내용 제거
       │
       ▼
5. CEO에게 패킷 반환 → CEO가 각 에이전트에 디스패치
```

---

## 컨텍스트 예산 관리

| 구분 | 토큰 | 설명 |
|------|------|------|
| 보호 파일 (항상 고정) | ~8,000 | SOUL.md, USER.md, GOVERNANCE.md 등 |
| RAG 검색 결과 | ~12,000 | 관련 문서 최대 5개 |
| 에이전트 작업 공간 | ~178,000 | 실제 태스크 실행 |
| 안전 버퍼 | 2,000 | 오버플로우 방지 |
| **글로벌 한도** | **200,000** | 모든 모델 공통 상한 |

### 200k 초과 시 분할처리
```bash
# scripts/context-split.sh 자동 호출
bash scripts/context-split.sh \
  --input "$CONTENT" \
  --chunk-size 180000 \
  --overlap 2000 \
  --summary-model "gemini-2.5-flash" \
  --output "shared/handoffs/split_summary.md"
```
- 각 청크를 순차 처리 후 결과 요약
- 최종 요약본을 통합하여 사용

---

## 에이전트별 컨텍스트 패킷 형식

```json
{
  "targetAgent": "dev-lead",
  "taskSummary": "CEO가 정제한 작업 지시 (원본 명령에서 해당 에이전트에 관련된 내용만)",
  "ragContext": [
    {
      "source": "shared/artifacts/prev-code-review.md",
      "score": 0.82,
      "excerpt": "관련 코드 리뷰 내용..."
    }
  ],
  "estimatedTokens": 4200,
  "contextBudgetRemaining": 193800
}
```

---

## 보호 파일 검증 로직

```bash
# RAG 검색 결과에서 보호 파일 필터링
PROTECTED=$(cat rag/protected-files.txt | grep -v '^#' | grep -v '^$')
for result in $RAG_RESULTS; do
  if echo "$PROTECTED" | grep -q "$result"; then
    echo "[RAG] SKIP protected: $result"
    continue
  fi
  FILTERED_RESULTS+=("$result")
done
```

---

## 오류 처리
- DevRAG 인덱스 없음 → `scripts/rag-index.sh` 자동 실행 후 재시도
- 검색 결과 없음 → RAG 컨텍스트 없이 진행 (보호 파일 + 직접 참조만)
- 점수 미달 결과만 있음 → topK 결과 중 최고점수 1개만 포함
