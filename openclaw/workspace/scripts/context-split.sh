#!/usr/bin/env bash
# =============================================================
# context-split.sh — 200k 토큰 초과 컨텐츠 분할처리 및 요약
# OpenClaw v11
# 사용: bash context-split.sh --input <파일> --output <파일> [옵션]
# =============================================================
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# =============================================================
# 인자 파싱
# =============================================================
INPUT_FILE=""
OUTPUT_FILE="${WORKSPACE_DIR}/shared/handoffs/split_summary.md"
CHUNK_TOKENS=180000
OVERLAP_TOKENS=2000
SUMMARY_MODEL="google/gemini-2.5-flash"
CHARS_PER_TOKEN=3.5  # 한국어 평균 (영어는 4자/토큰, 한국어는 약 3자/토큰)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)         INPUT_FILE="$2";    shift 2 ;;
    --output)        OUTPUT_FILE="$2";   shift 2 ;;
    --chunk-size)    CHUNK_TOKENS="$2";  shift 2 ;;
    --overlap)       OVERLAP_TOKENS="$2"; shift 2 ;;
    --summary-model) SUMMARY_MODEL="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$INPUT_FILE" ]]; then
  echo "[CTX-SPLIT] ERROR: --input 필수"
  exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "[CTX-SPLIT] ERROR: 파일 없음: $INPUT_FILE"
  exit 1
fi

# =============================================================
# 토큰 수 추정 (문자 수 기반)
# =============================================================
CHAR_COUNT=$(wc -c < "$INPUT_FILE")
ESTIMATED_TOKENS=$(python3 -c "print(int(${CHAR_COUNT} / ${CHARS_PER_TOKEN}))")
GLOBAL_LIMIT=200000

echo "[CTX-SPLIT] 파일: $INPUT_FILE"
echo "[CTX-SPLIT] 추정 토큰: ${ESTIMATED_TOKENS} / 200,000 한도"

if [[ "$ESTIMATED_TOKENS" -le "$GLOBAL_LIMIT" ]]; then
  echo "[CTX-SPLIT] 200k 이하. 분할 불필요 → 원본 그대로 사용"
  cp "$INPUT_FILE" "$OUTPUT_FILE"
  exit 0
fi

echo "[CTX-SPLIT] 200k 초과 감지. 분할처리 시작..."

# =============================================================
# 분할 처리
# =============================================================
CHUNK_CHARS=$(python3 -c "print(int(${CHUNK_TOKENS} * ${CHARS_PER_TOKEN}))")
OVERLAP_CHARS=$(python3 -c "print(int(${OVERLAP_TOKENS} * ${CHARS_PER_TOKEN}))")
TMPDIR_CHUNKS=$(mktemp -d)
SUMMARY_PARTS=()

python3 - <<PYTHON
import sys, math

with open("${INPUT_FILE}", "r", encoding="utf-8") as f:
    content = f.read()

chunk_chars = ${CHUNK_CHARS}
overlap_chars = ${OVERLAP_CHARS}
tmpdir = "${TMPDIR_CHUNKS}"

chunks = []
start = 0
while start < len(content):
    end = min(start + chunk_chars, len(content))
    # 문장 경계에서 자르기 (줄 바꿈 기준)
    if end < len(content):
        last_newline = content.rfind("\n", start, end)
        if last_newline > start:
            end = last_newline
    chunk = content[start:end]
    chunks.append(chunk)
    start = max(start + chunk_chars - overlap_chars, end)

print(f"[CTX-SPLIT] 총 {len(chunks)}개 청크 생성")
for i, chunk in enumerate(chunks):
    path = f"{tmpdir}/chunk_{i:03d}.txt"
    with open(path, "w", encoding="utf-8") as f:
        f.write(chunk)
    print(f"  청크 {i+1}: {len(chunk.split())} words → {path}")
PYTHON

# =============================================================
# 각 청크 요약 (Gemini Flash API 또는 CLI)
# =============================================================
CHUNK_COUNT=$(ls "${TMPDIR_CHUNKS}"/chunk_*.txt 2>/dev/null | wc -l)
echo "[CTX-SPLIT] ${CHUNK_COUNT}개 청크 순차 요약 중..."

mkdir -p "$(dirname "$OUTPUT_FILE")"
SUMMARY_OUT="$OUTPUT_FILE"

{
  echo "# 분할처리 요약 보고서"
  echo "생성: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "원본: $INPUT_FILE"
  echo "청크: ${CHUNK_COUNT}개"
  echo "모델: ${SUMMARY_MODEL}"
  echo "---"
  echo ""
} > "$SUMMARY_OUT"

CHUNK_IDX=0
for chunk_file in "${TMPDIR_CHUNKS}"/chunk_*.txt; do
  CHUNK_IDX=$((CHUNK_IDX + 1))
  echo "[CTX-SPLIT] 청크 ${CHUNK_IDX}/${CHUNK_COUNT} 요약 중..."

  CHUNK_CONTENT=$(cat "$chunk_file")
  SUMMARY_PROMPT="다음 내용의 핵심을 3~5문장으로 요약하라. 수식·코드·수치·고유명사는 반드시 원문 그대로 보존할 것.\n\n---\n${CHUNK_CONTENT}\n---"

  # Claude Code CLI를 통한 요약 (Gemini Flash)
  # 실제 환경에서는 API 호출 또는 claude CLI 사용
  if command -v claude &>/dev/null; then
    SUMMARY=$(echo "${SUMMARY_PROMPT}" | claude --model "gemini-2.5-flash" --no-streaming 2>/dev/null || echo "[요약 실패 - 원문 청크 ${CHUNK_IDX} 참조]")
  else
    # fallback: 첫 500자 발췌
    SUMMARY=$(head -c 1500 "$chunk_file")
  fi

  {
    echo "## 청크 ${CHUNK_IDX}/${CHUNK_COUNT}"
    echo ""
    echo "${SUMMARY}"
    echo ""
    echo "---"
    echo ""
  } >> "$SUMMARY_OUT"
done

# =============================================================
# 최종 통합 요약
# =============================================================
{
  echo "## 최종 통합 요약"
  echo ""
  echo "위 ${CHUNK_COUNT}개 청크 요약을 종합한 전체 내용:"
  echo "(각 청크 요약 참조)"
} >> "$SUMMARY_OUT"

# 임시 파일 정리
rm -rf "${TMPDIR_CHUNKS}"

echo "[CTX-SPLIT] 분할처리 완료 → ${SUMMARY_OUT}"
echo "[CTX-SPLIT] 청크 ${CHUNK_COUNT}개 처리됨"
