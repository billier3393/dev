#!/usr/bin/env bash
# =============================================================================
# Claude Code Mac 원클릭 셋업 스크립트
# 가이드: Claude Code 완벽 마스터 가이드 (2026-03-08)
# 사용법: bash setup-mac.sh
# =============================================================================

set -e

# ── 색상 코드 ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── 유틸 함수 ─────────────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[✅]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[⚠️]${NC}   $*"; }
error()   { echo -e "${RED}[❌]${NC}   $*"; exit 1; }
step()    { echo -e "\n${BOLD}${CYAN}▶ $*${NC}"; }

# ── 배너 ──────────────────────────────────────────────────────────────────────
echo -e "${BOLD}"
cat << 'BANNER'
╔══════════════════════════════════════════════════════════════╗
║         Claude Code Mac 원클릭 셋업 (듀얼 계정 지원)          ║
║         Claude Code 완벽 마스터 가이드 v2026.03               ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

# ── 프로젝트 루트 감지 ────────────────────────────────────────────────────────
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
info "프로젝트 루트: ${PROJECT_ROOT}"

# ── shell 파일 감지 ───────────────────────────────────────────────────────────
if [[ -f "$HOME/.zshrc" ]]; then
  SHELL_RC="$HOME/.zshrc"
elif [[ -f "$HOME/.bash_profile" ]]; then
  SHELL_RC="$HOME/.bash_profile"
else
  SHELL_RC="$HOME/.zshrc"
  touch "$SHELL_RC"
fi
info "Shell 설정 파일: ${SHELL_RC}"

# =============================================================================
# 1단계: 환경 점검 및 필수 패키지 설치
# =============================================================================
step "1단계: 환경 점검"

# macOS 확인
if [[ "$(uname)" != "Darwin" ]]; then
  warn "macOS가 아닌 환경입니다. 일부 기능(알림, 음성)이 작동하지 않을 수 있습니다."
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  warn "Homebrew가 없습니다. 설치합니다..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  success "Homebrew 확인됨"
fi

# tmux (Agent Teams Split Panes 모드 지원)
if ! command -v tmux &>/dev/null; then
  info "tmux 설치 중... (Agent Teams Split Panes 모드에 필요)"
  brew install tmux
else
  success "tmux 확인됨 ($(tmux -V))"
fi

# Node.js
if ! command -v node &>/dev/null; then
  info "Node.js 설치 중..."
  brew install node
else
  success "Node.js 확인됨 ($(node -v))"
fi

# Claude Code
if ! command -v claude &>/dev/null; then
  info "Claude Code 설치 중..."
  npm install -g @anthropic-ai/claude-code
else
  success "Claude Code 확인됨 ($(claude --version 2>/dev/null || echo '버전 확인 불가'))"
fi

# =============================================================================
# 2단계: 계정 설정
# =============================================================================
step "2단계: Claude 계정 설정"

echo ""
echo -e "  ${BOLD}사용할 계정을 선택하세요:${NC}"
echo "  [1] 구독형 계정만 (Claude.ai Pro/Max)"
echo "  [2] API 계정만 (ANTHROPIC_API_KEY)"
echo "  [3] 둘 다 설정 ${GREEN}(권장)${NC}"
echo ""
read -rp "  선택 (1/2/3) [기본: 3]: " ACCOUNT_CHOICE
ACCOUNT_CHOICE="${ACCOUNT_CHOICE:-3}"

SETUP_SUB=false
SETUP_API=false

case "$ACCOUNT_CHOICE" in
  1) SETUP_SUB=true ;;
  2) SETUP_API=true ;;
  3) SETUP_SUB=true; SETUP_API=true ;;
  *) warn "잘못된 선택입니다. 기본값(3)으로 진행합니다."; SETUP_SUB=true; SETUP_API=true ;;
esac

# 구독형 계정 설정
if $SETUP_SUB; then
  info "구독형 계정 설정: 브라우저에서 Claude.ai 로그인이 필요합니다."
  echo -e "  ${YELLOW}지금 바로 로그인하시겠습니까? (나중에 'claude' 명령으로도 가능)${NC}"
  read -rp "  로그인 진행 (y/n) [기본: y]: " DO_LOGIN
  DO_LOGIN="${DO_LOGIN:-y}"
  if [[ "$DO_LOGIN" =~ ^[Yy]$ ]]; then
    claude auth login || warn "로그인을 건너뜁니다. 나중에 'claude auth login'으로 진행하세요."
  fi
  success "구독형 계정 설정 완료"
fi

# API 계정 설정
API_KEY_STORED=""
if $SETUP_API; then
  echo ""
  echo -e "  ${BOLD}Anthropic API 키를 입력하세요${NC}"
  echo "  (https://console.anthropic.com 에서 발급)"
  read -rsp "  API 키: " API_KEY_INPUT
  echo ""

  if [[ -n "$API_KEY_INPUT" ]]; then
    API_KEY_STORED="$API_KEY_INPUT"

    # 기존 설정 중복 방지
    if grep -q "ANTHROPIC_API_KEY_STORED" "$SHELL_RC" 2>/dev/null; then
      # 기존 줄 교체
      sed -i.bak "s|export ANTHROPIC_API_KEY_STORED=.*|export ANTHROPIC_API_KEY_STORED=\"${API_KEY_STORED}\"|" "$SHELL_RC"
    else
      echo "" >> "$SHELL_RC"
      echo "# Claude Code API 계정 키" >> "$SHELL_RC"
      echo "export ANTHROPIC_API_KEY_STORED=\"${API_KEY_STORED}\"" >> "$SHELL_RC"
    fi
    success "API 키 저장 완료 (${SHELL_RC})"
  else
    warn "API 키가 입력되지 않았습니다. 나중에 수동으로 설정하세요:"
    warn "  echo 'export ANTHROPIC_API_KEY_STORED=\"sk-ant-...\"' >> ${SHELL_RC}"
  fi
fi

# =============================================================================
# 3단계: 전역 ~/.claude/ 디렉터리 설정
# =============================================================================
step "3단계: 전역 Claude Code 설정 (~/.claude/)"

GLOBAL_CLAUDE="$HOME/.claude"
mkdir -p "$GLOBAL_CLAUDE/commands"
mkdir -p "$GLOBAL_CLAUDE/hooks"

# ── settings.json ─────────────────────────────────────────────────────────────
cat > "$GLOBAL_CLAUDE/settings.json" << 'SETTINGS_EOF'
{
  "model": "claude-sonnet-4-5",
  "toolSearch": "auto",
  "permissions": {
    "allow": [],
    "deny": []
  },
  "env": {
    "CLAUDE_TEAM_ENABLED": "0"
  },
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/notify-complete.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/task-gate.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS_EOF
success "settings.json 생성 완료"
info "  - 기본 모델: Sonnet (Opus 무단 사용 방지)"
info "  - MCP Tool Search: auto (컨텍스트 낭비 방지)"
info "  - 작업 완료 시 macOS 알림 훅 등록"

# ── 커스텀 커맨드: /changelog ──────────────────────────────────────────────────
cat > "$GLOBAL_CLAUDE/commands/changelog.md" << 'CMD_EOF'
---
name: changelog
description: git 커밋 내역 기반으로 변경 로그(CHANGELOG.md)를 자동 생성합니다
---

최근 git 커밋 내역을 분석해서 `CHANGELOG.md`를 생성 또는 업데이트해줘.

## 형식 규칙
- Keep A Changelog (https://keepachangelog.com) 형식 준수
- 한국어로 작성
- 섹션: Added(추가), Changed(변경), Fixed(수정), Removed(제거)
- 날짜 형식: YYYY-MM-DD

## 작업 순서
1. `git log --oneline -30` 실행해서 최근 커밋 확인
2. 커밋 메시지를 카테고리별로 분류
3. CHANGELOG.md 파일 생성 또는 상단에 새 버전 추가
4. 완료 후 생성된 내용을 요약해서 보고
CMD_EOF

# ── 커스텀 커맨드: /handoff ────────────────────────────────────────────────────
cat > "$GLOBAL_CLAUDE/commands/handoff.md" << 'CMD_EOF'
---
name: handoff
description: 현재 세션의 컨텍스트를 HANDOFF.md에 저장하거나 이전 세션을 복원합니다
---

$ARGUMENTS 값에 따라 동작:
- 인수 없음 또는 `save`: 현재 컨텍스트를 HANDOFF.md로 저장
- `load`: HANDOFF.md를 읽어서 이전 작업 컨텍스트 복원

## save 모드 (기본)
다음 내용을 `HANDOFF.md`로 저장해줘:

1. **현재 작업 요약**: 이번 세션에서 한 일
2. **진행 중인 작업**: 아직 완료되지 않은 태스크 목록
3. **주요 결정 사항**: 이번 세션에서 내린 중요한 기술적 결정
4. **다음 단계**: 다음 세션에서 해야 할 일 (우선순위 순)
5. **관련 파일**: 수정하거나 생성한 주요 파일 경로
6. **주의사항**: 다음 세션에서 알아야 할 이슈나 주의점

저장 후 "HANDOFF.md 저장 완료. 새 세션에서 '/handoff load'로 복원하세요." 라고 알려줘.

## load 모드
`HANDOFF.md` 파일을 읽어서 이전 세션의 컨텍스트를 파악하고,
"이전 세션에서 [요약]을 작업했습니다. [다음 단계]부터 계속 진행할까요?" 라고 물어봐줘.
CMD_EOF

# ── 커스텀 커맨드: /spec ───────────────────────────────────────────────────────
cat > "$GLOBAL_CLAUDE/commands/spec.md" << 'CMD_EOF'
---
name: spec
description: 프로젝트 스펙 인터뷰를 진행하고 SDD(소프트웨어 설계 문서)를 자동 생성합니다
---

코드 작성 전에 나한테 먼저 인터뷰를 진행해줘. 아래 항목을 하나씩 물어봐:

## 인터뷰 질문 목록

1. **프로젝트 개요**
   - 이 프로젝트/기능이 해결하려는 문제는?
   - 핵심 사용자는 누구인가?

2. **기술 스택**
   - 사용할 프레임워크/라이브러리
   - 데이터베이스 (있다면)
   - 배포 환경

3. **핵심 기능**
   - 반드시 포함될 기능 (MVP)
   - 나중에 추가할 기능 (Nice-to-have)

4. **UI/UX**
   - 디자인 참고 사이트나 스타일 있나?
   - 반응형 필요 여부
   - 컴포넌트 라이브러리 선호도

5. **비기능 요구사항**
   - 성능 목표 (응답 시간 등)
   - 보안 요구사항
   - 확장성 고려사항

## 인터뷰 완료 후

모든 답변을 바탕으로 `SPEC.md` 파일 생성:
- 프로젝트 개요
- 기술 스택 명세
- 기능 요구사항 (MVP / 확장)
- 아키텍처 다이어그램 (텍스트 형식)
- 파일 구조 제안
- 개발 순서 및 마일스톤

완료 후 "SPEC.md 생성 완료. Plan 모드(Shift+Tab)로 개발을 시작해보세요." 라고 안내해줘.
CMD_EOF

success "커스텀 커맨드 생성 완료: /changelog, /handoff, /spec"

# ── Hook: 작업 완료 알림 ──────────────────────────────────────────────────────
cat > "$GLOBAL_CLAUDE/hooks/notify-complete.sh" << 'HOOK_EOF'
#!/usr/bin/env bash
# Claude Code 작업 완료 시 macOS 알림 + 음성 알림
# 다중 세션 운영 시 어느 Claude가 완료됐는지 파악 가능

# 현재 작업 디렉터리 이름 추출
PROJECT_NAME=$(basename "$PWD")

if [[ "$(uname)" == "Darwin" ]]; then
  # macOS 알림
  osascript -e "display notification \"${PROJECT_NAME} 작업이 완료되었습니다!\" with title \"Claude Code\" sound name \"Glass\""
  # 음성 알림
  say -r 200 "클로드 작업 완료. ${PROJECT_NAME}"
fi

# Linux fallback (터미널 벨)
echo -e "\a"
HOOK_EOF
chmod +x "$GLOBAL_CLAUDE/hooks/notify-complete.sh"

# ── Hook: 테스트 게이트 ───────────────────────────────────────────────────────
cat > "$GLOBAL_CLAUDE/hooks/task-gate.sh" << 'HOOK_EOF'
#!/usr/bin/env bash
# Claude Code TaskCompleted 훅: 테스트 실패 시 작업 반려
# Claude가 "작업 완료"라고 선언할 때 실제 테스트를 돌려서 검증

# 테스트 파일이 없으면 통과
if [[ ! -f "package.json" ]] && [[ ! -f "pytest.ini" ]] && [[ ! -f "Makefile" ]]; then
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
HOOK_EOF
chmod +x "$GLOBAL_CLAUDE/hooks/task-gate.sh"

success "Hook 스크립트 생성 완료"
info "  - notify-complete.sh: 작업 완료 시 macOS 알림 + 음성"
info "  - task-gate.sh: 테스트 실패 시 task 자동 반려"

# =============================================================================
# 4단계: ~/.zshrc에 계정 전환 함수 추가
# =============================================================================
step "4단계: 계정 전환 함수 등록"

MARKER="# ── Claude Code 계정 전환 함수 (by setup-mac.sh) ──"

if ! grep -q "$MARKER" "$SHELL_RC" 2>/dev/null; then
  # SHELL_RC 경로를 함수 본문에 직접 삽입 (heredoc 변수 확장 제한 우회)
  SHELL_RC_HINT="$SHELL_RC"
  cat >> "$SHELL_RC" << ZSHRC_EOF

# ── Claude Code 계정 전환 함수 (by setup-mac.sh) ──
# 구독형 계정으로 Claude Code 실행 (Claude.ai Pro/Max)
function claude-sub() {
  unset ANTHROPIC_API_KEY
  echo "🔑 구독형 계정으로 실행 중..."
  claude "\$@"
}

# API 계정으로 Claude Code 실행
function claude-api() {
  if [[ -z "\$ANTHROPIC_API_KEY_STORED" ]]; then
    echo "❌ API 키가 설정되지 않았습니다."
    echo "   다음을 ${SHELL_RC_HINT}에 추가하세요:"
    echo "   export ANTHROPIC_API_KEY_STORED=\"sk-ant-...\""
    return 1
  fi
  export ANTHROPIC_API_KEY="\$ANTHROPIC_API_KEY_STORED"
  echo "🔑 API 계정으로 실행 중..."
  claude "\$@"
}

# Opus 모델로 Claude Code 실행 (복잡한 설계/디버깅용)
function claude-opus() {
  echo "🧠 Opus 모델로 실행 중... (비용 주의)"
  claude --model claude-opus-4-6 "\$@"
}

# 현재 Claude 계정 상태 확인
function claude-status() {
  echo "── Claude Code 계정 상태 ──"
  if [[ -n "\$ANTHROPIC_API_KEY" ]]; then
    echo "  현재 모드: API 계정 (키 앞 20자: \${ANTHROPIC_API_KEY:0:20}...)"
  else
    echo "  현재 모드: 구독형 계정 (claude-sub 기본값)"
  fi
  echo ""
  echo "  명령어:"
  echo "    claude-sub    → 구독형 계정 (Claude.ai Pro/Max)"
  echo "    claude-api    → API 계정"
  echo "    claude-opus   → Opus 모델 (복잡한 작업용)"
  echo "    claude-status → 이 화면"
}
ZSHRC_EOF
  success "계정 전환 함수 등록 완료"
else
  info "계정 전환 함수가 이미 등록되어 있습니다."
fi

# =============================================================================
# 5단계: 프로젝트 CLAUDE.md 생성
# =============================================================================
step "5단계: 프로젝트 CLAUDE.md 생성"

CLAUDE_MD_PATH="$PROJECT_ROOT/CLAUDE.md"

if [[ -f "$CLAUDE_MD_PATH" ]]; then
  warn "CLAUDE.md가 이미 존재합니다. 덮어쓸까요?"
  read -rp "  덮어쓰기 (y/n) [기본: n]: " OVERWRITE_CLAUDE
  OVERWRITE_CLAUDE="${OVERWRITE_CLAUDE:-n}"
  if [[ ! "$OVERWRITE_CLAUDE" =~ ^[Yy]$ ]]; then
    info "CLAUDE.md 생성을 건너뜁니다."
    SKIP_CLAUDE_MD=true
  fi
fi

if [[ "${SKIP_CLAUDE_MD:-false}" != "true" ]]; then
  cat > "$CLAUDE_MD_PATH" << 'CLAUDE_MD_EOF'
# 모든 응답은 반드시 한국어로 작성할 것

## 프로젝트: OpenClaw v11

멀티에이전트 AI 시스템 — 연구, 개발, 문서화, 데이터 분석, 보안, 테스트, 최적화를 통합 관리.

### 핵심 파일 구조

```
openclaw/openclaw.json          # 메인 설정 (모델, 에이전트, 예산)
openclaw/workspace/
  SOUL.md                       # 핵심 원칙 (필독)
  AGENTS.md                     # 28개 에이전트 정의
  chains/                       # 33개 ChatChain 파이프라인
  scripts/                      # 자동화 셸 스크립트
  config/
    project-setup.md            # 프로젝트 셋업 가이드
    copilot-setup.md            # 3-모델 API 연동 가이드
```

### 모델 선택 기준

| 용도 | 모델 | 이유 |
|------|------|------|
| 학습·단순 질문 | Haiku 4.5 | 가장 저렴 |
| 일반 코딩·균형 | Sonnet 4.5 | 기본값 |
| 복잡한 설계·디버깅 | Opus 4.6 | 최고 성능 |

### 개발 워크플로우

1. **새 기능 시작 전**: Plan 모드 (Shift+Tab) 진입 → 계획 수립 → 승인 후 실행
2. **컨텍스트 관리**: 30분마다 `/context` 확인 → 75% 이상 시 `/compact`
3. **세션 종료 전**: `/clear` 실행 필수 (컨텍스트 로트 방지)
4. **세션 인수인계**: `/handoff` 로 HANDOFF.md 저장

### 개발 규칙

- 특정 파일만 수정할 때는 `@filename` 으로 범위 명시
- `openclaw.json` 수정 시 반드시 백업 먼저 (`cp openclaw/openclaw.json openclaw/openclaw.json.bak`)
- Kimi K2.5 에이전트에는 PII(개인정보) 전달 금지
- 외부 데이터 전송 전 반드시 사용자 승인 요청

### 자주 하는 실수 방지

1. ❌ CLAUDE.md를 500줄 이상으로 늘리지 말 것 → 나머지는 스킬 파일로 분리
2. ❌ Plan 모드 없이 바로 코드 생성하지 말 것
3. ❌ `/clear` 없이 새 기능 개발 시작하지 말 것
4. ❌ MCP 도구 설치 후 Tool Search 활성화 잊지 말 것
5. ❌ openclaw.json 수정 전 백업 생략하지 말 것

### 커스텀 커맨드

- `/changelog` — git 커밋 기반 변경 로그 자동 생성
- `/handoff` — 세션 컨텍스트 HANDOFF.md 저장 (새 세션 인수인계)
- `/handoff load` — 이전 세션 컨텍스트 복원
- `/spec` — 프로젝트 스펙 인터뷰 → SDD 문서 자동 생성
CLAUDE_MD_EOF
  success "CLAUDE.md 생성 완료: ${CLAUDE_MD_PATH}"
fi

# =============================================================================
# 6단계: 프로젝트 수준 .claude/ 설정
# =============================================================================
step "6단계: 프로젝트 .claude/ 설정"

PROJECT_CLAUDE="$PROJECT_ROOT/.claude"
mkdir -p "$PROJECT_CLAUDE/commands"
mkdir -p "$PROJECT_CLAUDE/hooks"

# 프로젝트 수준 settings.json (전역 설정 상속 + 오버라이드)
cat > "$PROJECT_CLAUDE/settings.json" << 'PROJ_SETTINGS_EOF'
{
  "model": "claude-sonnet-4-5",
  "toolSearch": "auto",
  "env": {
    "CLAUDE_TEAM_ENABLED": "0"
  },
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/notify-complete.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/task-gate.sh"
          }
        ]
      }
    ]
  }
}
PROJ_SETTINGS_EOF

# 커맨드를 전역에서 복사
cp "$GLOBAL_CLAUDE/commands/changelog.md" "$PROJECT_CLAUDE/commands/"
cp "$GLOBAL_CLAUDE/commands/handoff.md" "$PROJECT_CLAUDE/commands/"
cp "$GLOBAL_CLAUDE/commands/spec.md" "$PROJECT_CLAUDE/commands/"

success "프로젝트 .claude/ 설정 완료"

# =============================================================================
# 완료 요약
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}"
cat << 'DONE_BANNER'
╔══════════════════════════════════════════════════════════════╗
║                  ✅ 설정 완료!                                ║
╚══════════════════════════════════════════════════════════════╝
DONE_BANNER
echo -e "${NC}"

echo -e "${BOLD}📁 생성된 파일:${NC}"
echo "  ~/.claude/settings.json           — 전역 설정 (Sonnet 고정, MCP Tool Search)"
echo "  ~/.claude/commands/changelog.md   — /changelog 커맨드"
echo "  ~/.claude/commands/handoff.md     — /handoff 커맨드"
echo "  ~/.claude/commands/spec.md        — /spec 커맨드"
echo "  ~/.claude/hooks/notify-complete.sh — 작업 완료 macOS 알림"
echo "  ~/.claude/hooks/task-gate.sh      — 테스트 실패 시 task 반려"
echo "  ${PROJECT_ROOT}/CLAUDE.md         — 프로젝트 지침"
echo "  ${PROJECT_ROOT}/.claude/          — 프로젝트 Claude 설정"
echo ""

echo -e "${BOLD}🔑 계정 전환 명령어:${NC}"
echo "  claude-sub    → 구독형 계정 (Claude.ai Pro/Max)"
echo "  claude-api    → API 계정 (ANTHROPIC_API_KEY)"
echo "  claude-opus   → Opus 모델 (복잡한 작업용)"
echo "  claude-status → 현재 계정 상태 확인"
echo ""

echo -e "${BOLD}💡 주요 커맨드 (Claude Code 내에서):${NC}"
echo "  /changelog    → git 커밋 기반 변경 로그 자동 생성"
echo "  /handoff      → 세션 컨텍스트 저장 (새 세션 인수인계)"
echo "  /spec         → 프로젝트 스펙 인터뷰 → SDD 문서 생성"
echo "  /context      → 컨텍스트 사용량 확인 (30분마다)"
echo "  /compact      → 대화 압축 (75% 이상 시)"
echo "  /clear        → 새 작업 전 컨텍스트 초기화"
echo ""

echo -e "${BOLD}⚡ 지금 바로 적용:${NC}"
echo "  source ${SHELL_RC}"
echo ""

echo -e "${YELLOW}팁: 'claude-status' 명령으로 현재 계정 상태를 확인하세요.${NC}"
echo ""
