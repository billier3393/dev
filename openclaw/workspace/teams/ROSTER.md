# ROSTER.md — 팀 명부 (v11 — Privacy-Safe 재배정)

> ⚠️ **Kimi K2.5 (Moonshot AI/중국)** — 개인정보 없는 순수 기술 태스크 2개 에이전트만 배정.

## C-Suite
| ID | 이름 | 모델 | 보고라인 | 비고 |
|----|------|------|---------|------|
| ceo | CEO | **Haiku 4.5** | 동우님 | PII 필터·오케스트레이터. v11 변경 |
| cto | CTO | Haiku 4.5 | CEO | SWE-bench 73.3% |
| coo | COO | Gemini Flash | CEO | 운영 저비용 |

## 리서치팀 (→CTO)
| ID | 이름 | 모델 | 보고라인 | 비고 |
|----|------|------|---------|------|
| research-lead | 리서치 리드 | **Haiku 4.5** | CTO | 사용자 컨텍스트 수신 가능. v11 변경 |
| research-web | 웹 리서처 | Gemini Flash | research-lead | 대량 검색 저비용 |
| research-analyst | 심층 분석가 | **Kimi K2.5** ⚠️ | research-lead | 수학·논문 분석 전용. PII 절대 금지 |

## 개발팀 (→CTO)
| ID | 이름 | 모델 | 보고라인 |
|----|------|------|---------|
| dev-lead | 개발 리드 | Haiku 4.5 | CTO |
| dev-backend | 백엔드 | Haiku 4.5 | dev-lead |
| dev-frontend | 프론트엔드 | Haiku 4.5 | dev-lead |
| dev-automation | 자동화/OCR | Gemini Flash | dev-lead |

## 문서팀 (→COO)
| ID | 이름 | 모델 | 보고라인 | 비고 |
|----|------|------|---------|------|
| docs-lead | 문서 리드 | Gemini Flash | COO | |
| docs-writer | 문서 작성자 | **Gemini Flash** | docs-lead | 개인 문서 처리 가능. v11 변경 |
| docs-formatter | 포맷터 | Gemini Flash | docs-lead | |

## 데이터팀 (→COO)
| ID | 이름 | 모델 | 보고라인 | 비고 |
|----|------|------|---------|------|
| data-lead | 데이터 리드 | **Haiku 4.5** | COO | 분석 지시 시 PII 노출 가능. v11 변경 |
| data-engineer | 데이터 엔지니어 | Haiku 4.5 | data-lead | |
| data-viz | 시각화 | Gemini Flash | data-lead | |

## 크리에이티브팀 (→COO)
| ID | 이름 | 모델 | 보고라인 | 비고 |
|----|------|------|---------|------|
| creative-lead | 리드 | **Gemini Flash** | COO | 창의 방향 설정. v11 변경 |
| creative-content | 콘텐츠 | Gemini Flash | creative-lead | |
| creative-design | 디자이너 | Gemini Flash | creative-lead | |

## 보안팀 (→CTO, 중대:동우님)
| ID | 이름 | 모델 | 보고라인 |
|----|------|------|---------|
| security-lead | 보안 리드 | Haiku 4.5 | CTO |
| security-auditor | 감사자 | Haiku 4.5 | security-lead |
| security-monitor | 모니터 | Gemini Flash | security-lead |

## 테스팅팀 (→CTO)
| ID | 이름 | 모델 | 보고라인 | 비고 |
|----|------|------|---------|------|
| testing-lead | 테스팅 리드 | Haiku 4.5 | CTO | |
| testing-functional | 기능 테스터 | Haiku 4.5 | testing-lead | |
| testing-validator | 검증자 | **Kimi K2.5** ⚠️ | testing-lead | LaTeX·수식 검증 전용. PII 절대 금지 |

## 최적화팀 (→COO)
| ID | 이름 | 모델 | 보고라인 |
|----|------|------|---------|
| optim-lead | 최적화 리드 | Gemini Flash | COO |
| optim-perf | 성능 최적화 | Gemini Flash | optim-lead |
| optim-process | 프로세스 | Gemini Flash | optim-lead |

---
**총 28 에이전트** | Kimi K2.5: **2** ⚠️ | Claude Haiku 4.5: **12** | Gemini 2.5 Flash: **14**
