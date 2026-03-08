#!/usr/bin/env bash
# Claude Code PostToolUse(Task) 훅: 테스트 실패 시 작업 반려
# Claude가 "작업 완료"라고 선언할 때 실제 테스트를 돌려서 검증

# 테스트 파일이 없으면 통과
if [[ ! -f "package.json" ]] && [[ ! -f "pytest.ini" ]] && [[ ! -f "pyproject.toml" ]]; then
  exit 0
fi

# Node.js 프로젝트: npm test
if [[ -f "package.json" ]] && grep -q '"test"' package.json 2>/dev/null; then
  if ! npm test --silent 2>/dev/null; then
    echo "REJECT: 테스트 실패. 코드를 수정 후 다시 시도하세요."
    exit 1
  fi
fi

# Python 프로젝트: pytest
if [[ -f "pytest.ini" ]] || [[ -f "pyproject.toml" ]]; then
  if ! python -m pytest -q 2>/dev/null; then
    echo "REJECT: pytest 실패. 코드를 수정 후 다시 시도하세요."
    exit 1
  fi
fi

exit 0
