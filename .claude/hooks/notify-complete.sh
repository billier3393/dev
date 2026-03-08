#!/usr/bin/env bash
# Claude Code 작업 완료 시 macOS 알림 + 음성 알림
# 다중 세션 운영 시 어느 Claude가 완료됐는지 파악 가능

PROJECT_NAME=$(basename "$PWD")

if [[ "$(uname)" == "Darwin" ]]; then
  osascript -e "display notification \"${PROJECT_NAME} 작업이 완료되었습니다!\" with title \"Claude Code\" sound name \"Glass\""
  say -r 200 "클로드 작업 완료. ${PROJECT_NAME}"
fi

# Linux fallback (터미널 벨)
echo -e "\a"
