---
name: "screen-reader"
description: "화면 캡처 및 OCR/Vision 분석. UI 요소 탐지."
user-invocable: true
metadata: {"openclaw": {"os": ["darwin"]}}
---
# Screen Reader
⚠️ 캡처 파일에 개인정보 포함 가능 → 외부 전송 금지, 사용 후 삭제

## 캡처
```bash
screencapture -x /tmp/screen.png
screencapture -x -R 0,0,800,600 /tmp/area.png
```

## OCR 분석
```bash
tesseract /tmp/screen.png stdout -l kor+eng
```
