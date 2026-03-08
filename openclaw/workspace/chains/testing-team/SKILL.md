---
name: "testing-team"
description: "기능·통합·수식 검증 테스트. 개발 체인 내 자동 활성화."
user-invocable: true
---
# 테스팅팀

## 에이전트
- **[Testing-Lead]** (`testing-lead`, Haiku 4.5): 테스트 전략, 케이스 설계, QA
- **[Testing-Functional]** (`testing-functional`, Haiku 4.5): 기능·통합 테스트
- **[Testing-Validator]** (`testing-validator`, Kimi K2.5): 수식·데이터 정합성·LaTeX 검증

## 테스트 유형
| 유형 | 담당 | 설명 |
|------|------|------|
| 기능 | Functional | 코드 기능 동작 확인 |
| 통합 | Functional | 컴포넌트 간 연동 확인 |
| 수식 검증 | Validator | LaTeX, 그리스 문자, 수식 균형 |
| 데이터 | Validator | 데이터 정합성, 타입 확인 |
| 보안 | → 보안팀 연계 | 보안 테스트 케이스 |

## LaTeX 검증 체크리스트 (v9 계승)
- [ ] `$...$` 짝 맞춤
- [ ] 그리스 문자 오인식 (α↔a, β↔B, θ↔0)
- [ ] 괄호 균형 (), {}, []
- [ ] 표 컬럼 수 일치
- [ ] SI 단위 일관성

## 출력: `tests/`, `test_reports/`
## 보고라인: CTO
