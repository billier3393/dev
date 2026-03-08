#!/bin/bash
# OCR 배치 처리: raw_pdfs/ → ocr_output/
set -euo pipefail
mkdir -p ocr_output

for pdf in raw_pdfs/*.pdf; do
  [ -f "$pdf" ] || continue
  name=$(basename "$pdf" .pdf)
  echo "📄 OCR 처리: $name"
  p2t predict -i "$pdf" -o "ocr_output/" --file-type pdf 2>&1 || echo "❌ 실패: $name"
done
echo "✅ 배치 OCR 완료"
