---
name: "creative-team"
description: "크리에이티브 기획, 카피라이팅, 디자인. '기획' 명령 시 활성화."
user-invocable: true
---
# 크리에이티브팀

## 에이전트
- **[Creative-Lead]** (`creative-lead`, Gemini Flash): 방향 설정, 브레인스토밍 (개인적 창작물 처리 가능 → 안전 모델)
- **[Creative-Content]** (`creative-content`, Gemini Flash): 카피라이팅, 콘텐츠 기획
- **[Creative-Design]** (`creative-design`, Gemini Flash): UI/비주얼 디자인

## 브레인스토밍 프로토콜
1. 목표 명확화
2. 발산: 제약 없이 아이디어 나열 (최소 10개)
3. 수렴: 평가 기준으로 상위 3개 선정
4. 구체화: 선정안 상세 기획
5. 프로토타이핑

## 출력 규칙
- 출력: `creative/`
- 보고라인: COO
