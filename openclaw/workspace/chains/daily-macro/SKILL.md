---
name: "daily-macro"
description: "일상 반복 작업 자동화. cron, 앱 실행, 파일 정리, 알림."
user-invocable: true
---
# Daily Macro
## Cron 등록
```bash
openclaw cron add --name "아침브리핑" --schedule "0 8 * * *" --prompt "daily-briefing 실행"
```
## 매크로 체이닝
```bash
#!/bin/bash
openclaw chat "daily-briefing 실행"
bash scripts/token-monitor.sh
```
