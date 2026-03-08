#!/usr/bin/env bash
# =============================================================
# rag-index.sh — DevRAG 인덱스 빌드 (MacBook Air M1 최적화)
# OpenClaw v11
# =============================================================
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAG_CONFIG="${WORKSPACE_DIR}/config/rag-config.json"
PROTECTED_LIST="${WORKSPACE_DIR}/rag/protected-files.txt"
INDEX_DIR="${WORKSPACE_DIR}/rag/index"
LOG_FILE="${WORKSPACE_DIR}/rag/index_log.jsonl"

# Apple Silicon MPS 백엔드 활성화
export PYTORCH_ENABLE_MPS_FALLBACK=1
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0  # M1 메모리 압박 방지

echo "[RAG-INDEX] OpenClaw v11 DevRAG 인덱싱 시작 (M1 MPS)"
echo "[RAG-INDEX] 인덱스 경로: ${INDEX_DIR}"

# 인덱스 디렉토리 생성
mkdir -p "${INDEX_DIR}"

# =============================================================
# 보호 파일 목록 로드 (이 파일들은 인덱싱 금지)
# =============================================================
PROTECTED_PATTERNS=()
while IFS= read -r line; do
  [[ "$line" =~ ^#.*$ ]] && continue  # 주석 제거
  [[ -z "$line" ]] && continue         # 빈 줄 제거
  PROTECTED_PATTERNS+=("$line")
done < "${PROTECTED_LIST}"

echo "[RAG-INDEX] 보호 파일 ${#PROTECTED_PATTERNS[@]}개 로드 완료 (인덱싱 제외)"

# =============================================================
# 인덱싱 대상 파일 수집 (보호 파일 제외)
# =============================================================
INDEXABLE_FILES=()
INDEX_PATTERNS=(
  "chains/*/SKILL.md"
  "shared/artifacts/**"
  "shared/handoffs/**"
  "chains/logs/**"
  "research/**/*.md"
  "code/**/*.md"
  "reports/**/*.md"
  "analysis/**/*.md"
  "creative/**/*.md"
  "security/**/*.md"
  "optimization/**/*.md"
  "teams/governance_log.md"
)

for pattern in "${INDEX_PATTERNS[@]}"; do
  while IFS= read -r -d '' file; do
    SKIP=false
    for protected in "${PROTECTED_PATTERNS[@]}"; do
      # 와일드카드 패턴 매칭
      if [[ "$file" == *"$protected"* ]]; then
        SKIP=true
        break
      fi
    done
    if [[ "$SKIP" == false ]]; then
      INDEXABLE_FILES+=("$file")
    fi
  done < <(find "${WORKSPACE_DIR}" -path "${WORKSPACE_DIR}/${pattern}" -type f -print0 2>/dev/null || true)
done

echo "[RAG-INDEX] 인덱싱 대상 파일: ${#INDEXABLE_FILES[@]}개"

# =============================================================
# DevRAG CLI를 통한 인덱싱
# (devrag index --config <config> --files <file1> <file2> ...)
# =============================================================
if command -v devrag &>/dev/null; then
  devrag index \
    --config "${RAG_CONFIG}" \
    --index-dir "${INDEX_DIR}" \
    --device mps \
    --batch-size 32 \
    --files "${INDEXABLE_FILES[@]}"
else
  # DevRAG가 없는 경우 Python fallback (chromadb + sentence-transformers)
  echo "[RAG-INDEX] devrag CLI 없음 → Python fallback 사용"
  python3 - <<PYTHON
import os, json, sys
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"

try:
    import chromadb
    from sentence_transformers import SentenceTransformer
except ImportError:
    print("[RAG-INDEX] ERROR: chromadb, sentence-transformers 설치 필요")
    print("  pip install chromadb sentence-transformers")
    sys.exit(1)

import glob, re

INDEX_DIR = "${INDEX_DIR}"
WORKSPACE = "${WORKSPACE_DIR}"
PROTECTED = """${PROTECTED_PATTERNS[@]:-}""".split()

client = chromadb.PersistentClient(path=INDEX_DIR)
collection = client.get_or_create_collection(
    name="openclaw_v11",
    metadata={"hnsw:space": "cosine"}
)

# M1 MPS 임베딩 모델 로드
model = SentenceTransformer("all-MiniLM-L6-v2", device="mps")
print(f"[RAG-INDEX] 임베딩 모델 로드 완료 (MPS)")

files = """${INDEXABLE_FILES[@]:-}""".split()
print(f"[RAG-INDEX] {len(files)}개 파일 인덱싱 시작")

CHUNK_SIZE = 512
OVERLAP = 64
docs, ids, metas = [], [], []

for filepath in files:
    if not os.path.exists(filepath):
        continue
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
    # 청킹
    words = content.split()
    for i in range(0, max(1, len(words) - OVERLAP), CHUNK_SIZE - OVERLAP):
        chunk = " ".join(words[i:i+CHUNK_SIZE])
        chunk_id = f"{filepath}::{i}"
        docs.append(chunk)
        ids.append(chunk_id)
        metas.append({"source": filepath, "chunk_start": i})

if docs:
    embeddings = model.encode(docs, batch_size=32, show_progress_bar=True, normalize_embeddings=True)
    collection.upsert(documents=docs, ids=ids, metadatas=metas, embeddings=embeddings.tolist())
    print(f"[RAG-INDEX] {len(docs)}개 청크 인덱싱 완료")
else:
    print("[RAG-INDEX] 인덱싱 대상 없음")
PYTHON
fi

# 인덱싱 완료 로그
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "{\"event\":\"index_complete\",\"timestamp\":\"${TIMESTAMP}\",\"files\":${#INDEXABLE_FILES[@]}}" >> "${LOG_FILE}"

echo "[RAG-INDEX] 완료 ✓"
