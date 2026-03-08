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
