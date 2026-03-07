---
name: "keyboard-mouse"
description: "키보드 입력, 마우스 조작. macOS AppleScript/cliclick 사용."
user-invocable: true
metadata: {"openclaw": {"os": ["darwin"]}}
---
# Keyboard & Mouse
⚠️ **동우님 승인 없이 실행 금지**

## 키보드 (AppleScript)
```bash
osascript -e 'tell application "System Events" to keystroke "c" using command down'
```

## 마우스 (cliclick)
```bash
cliclick c:500,300
cliclick m:500,300
```
