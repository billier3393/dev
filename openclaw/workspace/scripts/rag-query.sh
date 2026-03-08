#!/usr/bin/env bash
# =============================================================
# rag-query.sh — DevRAG 벡터 검색 (CEO 디스패치 전 호출)
# OpenClaw v11
# 사용: bash rag-query.sh --query "질문 텍스트" [--top-k 5] [--agent dev-lead]
# =============================================================
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INDEX_DIR="${WORKSPACE_DIR}/rag/index"
PROTECTED_LIST="${WORKSPACE_DIR}/rag/protected-files.txt"
OUTPUT_DIR="${WORKSPACE_DIR}/shared/handoffs"

# Apple Silicon MPS 백엔드
export PYTORCH_ENABLE_MPS_FALLBACK=1

# =============================================================
# 인자 파싱
# =============================================================
QUERY=""
TOP_K=5
SCORE_THRESHOLD=0.65
TARGET_AGENT="all"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --query)     QUERY="$2";          shift 2 ;;
    --top-k)     TOP_K="$2";          shift 2 ;;
    --threshold) SCORE_THRESHOLD="$2"; shift 2 ;;
    --agent)     TARGET_AGENT="$2";   shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$QUERY" ]]; then
  echo "[RAG-QUERY] ERROR: --query 필수"
  exit 1
fi

# =============================================================
# 인덱스 존재 확인 → 없으면 자동 인덱싱
# =============================================================
if [[ ! -d "${INDEX_DIR}" ]] || [[ -z "$(ls -A "${INDEX_DIR}" 2>/dev/null)" ]]; then
  echo "[RAG-QUERY] 인덱스 없음 → 자동 인덱싱 실행"
  bash "${WORKSPACE_DIR}/scripts/rag-index.sh"
fi

# =============================================================
# DevRAG 쿼리 실행
# =============================================================
RESULT_FILE="${OUTPUT_DIR}/rag_result_$(date +%s).json"
mkdir -p "${OUTPUT_DIR}"

if command -v devrag &>/dev/null; then
  devrag query \
    --index-dir "${INDEX_DIR}" \
    --query "$QUERY" \
    --top-k "${TOP_K}" \
    --threshold "${SCORE_THRESHOLD}" \
    --output "${RESULT_FILE}" \
    --protected "${PROTECTED_LIST}"
else
  # Python fallback
  python3 - <<PYTHON
import os, json, sys
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"

try:
    import chromadb
    from sentence_transformers import SentenceTransformer
except ImportError:
    print("[RAG-QUERY] ERROR: chromadb, sentence-transformers 설치 필요")
    sys.exit(1)

QUERY = """${QUERY}"""
TOP_K = ${TOP_K}
THRESHOLD = ${SCORE_THRESHOLD}
INDEX_DIR = "${INDEX_DIR}"
RESULT_FILE = "${RESULT_FILE}"

# 보호 파일 목록 로드
protected = set()
with open("${PROTECTED_LIST}") as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith("#"):
            protected.add(line)

client = chromadb.PersistentClient(path=INDEX_DIR)
try:
    collection = client.get_collection("openclaw_v11")
except Exception:
    print("[RAG-QUERY] 인덱스 없음. rag-index.sh 먼저 실행하세요.")
    sys.exit(1)

model = SentenceTransformer("all-MiniLM-L6-v2", device="mps")
embedding = model.encode([QUERY], normalize_embeddings=True).tolist()

results = collection.query(
    query_embeddings=embedding,
    n_results=TOP_K * 2,  # 보호 파일 필터링 여유분
    include=["documents", "metadatas", "distances"]
)

output = {"query": QUERY, "results": []}
count = 0
for doc, meta, dist in zip(
    results["documents"][0],
    results["metadatas"][0],
    results["distances"][0]
):
    score = 1.0 - dist  # cosine distance → similarity
    source = meta.get("source", "")

    # 보호 파일 필터링
    is_protected = any(p in source for p in protected)
    if is_protected:
        continue
    if score < THRESHOLD:
        continue

    output["results"].append({
        "source": source,
        "score": round(score, 4),
        "excerpt": doc[:400]  # 400자 발췌
    })
    count += 1
    if count >= TOP_K:
        break

with open(RESULT_FILE, "w", encoding="utf-8") as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

print(f"[RAG-QUERY] {count}개 결과 (보호 파일 제외) → {RESULT_FILE}")
PYTHON
fi

# =============================================================
# 결과를 stdout으로 출력 (CEO가 파싱)
# =============================================================
if [[ -f "${RESULT_FILE}" ]]; then
  echo "[RAG-QUERY] agent=${TARGET_AGENT} 결과:"
  cat "${RESULT_FILE}"
else
  echo "[RAG-QUERY] 결과 없음"
  echo '{"query":"'"${QUERY}"'","results":[]}'
fi
