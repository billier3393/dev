---
name: "docs-team"
description: "보고서, 매뉴얼, 가이드 작성. '보고서' 명령 시 활성화."
user-invocable: true
---
# 문서 보고서 팀

## 에이전트
- **[Docs-Lead]** (`docs-lead`, Gemini Flash): 문서 전략, 템플릿, 품질 검수
- **[Docs-Writer]** (`docs-writer`, Gemini Flash): 보고서·매뉴얼·가이드 작성 (개인 문서 포함 가능 → 안전 모델)
- **[Docs-Formatter]** (`docs-formatter`, Gemini Flash): 포맷팅, LaTeX, 마크다운

## 템플릿
### 학업 리포트
```
# 제목
## 초록
## 1. 서론
## 2. 이론적 배경
## 3. 본론
## 4. 결론
## 참고문헌
```

### 기술 보고서
```
# 제목
## 개요
## 배경
## 분석
## 결과
## 권고사항
## 부록
```

## 출력 규칙
- 한국어 기본, 수식 LaTeX
- 출처 항상 명시
- 출력: `docs/`, `reports/`
- 보고라인: COO
