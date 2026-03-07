---
name: "data-team"
description: "데이터 분석, 통계, 시각화. '분석' 명령 시 활성화."
user-invocable: true
---
# 데이터 분석팀

## 에이전트
- **[Data-Lead]** (`data-lead`, Kimi K2.5): 분석 설계, 통계 모델링, 인사이트
- **[Data-Engineer]** (`data-engineer`, Haiku 4.5): 데이터 파이프라인, ETL, 정제
- **[Data-Viz]** (`data-viz`, Gemini Flash): 시각화, 차트, 대시보드

## 분석 워크플로
1. 데이터 수집·정제 (Data-Engineer)
2. 탐색적 분석 (Data-Lead)
3. 통계 모델링 (Data-Lead)
4. 시각화 (Data-Viz)
5. 인사이트 도출 (Data-Lead)
6. 보고서 (→ 문서팀)

## 출력 규칙
- 코드: Python (pandas, numpy, matplotlib, seaborn)
- 차트: PNG + 코드 동시 산출
- 출력: `data/`, `analysis/`
- 보고라인: COO
