# CHAIN_REGISTRY.md — ChatChain 파이프라인 등록부

> 등록된 모든 ChatChain과 Phase 정의. CEO가 체인을 조합하여 실행한다.

---

## 체인 목록

### 1. research-chain (연구 체인)
```yaml
id: research-chain
trigger: "연구 [주제]"
phases:
  - name: "요구분석"
    chat: CEO ↔ CTO
    action: 연구 범위·방법론 결정
  - name: "리서치 플랜"
    chat: CTO ↔ research-lead
    action: 연구 계획 수립, 소스 선정
  - name: "웹 리서치"
    chat: research-lead ↔ research-web
    action: 웹·논문 검색, 자료 수집
  - name: "심층 분석"
    chat: research-lead ↔ research-analyst
    action: 수집 데이터 분석, 인사이트 도출
  - name: "보고서 작성"
    chat: research-lead ↔ docs-writer
    action: 연구 보고서 초안 작성
  - name: "Self-Review"
    chat: research-lead (자체검증)
    action: 품질·완성도 자기 점검
  - name: "최종보고"
    chat: CEO → 동우님
    action: 결과 종합 보고
output: research/
```

### 2. dev-chain (개발 체인)
```yaml
id: dev-chain
trigger: "개발 [작업]"
phases:
  - name: "요구분석"
    chat: CEO ↔ CTO
    action: 기술 요구사항 분석
  - name: "아키텍처 설계"
    chat: CTO ↔ dev-lead
    action: 설계·기술 스택 결정
  - name: "구현"
    chat: dev-lead ↔ dev-backend/dev-frontend/dev-automation
    action: 코드 작성 (병렬 가능)
  - name: "코드 리뷰"
    chat: CTO ↔ dev-lead
    action: 코드 품질·아키텍처 검증
  - name: "테스트"
    chat: testing-lead ↔ testing-functional
    action: 기능·통합 테스트
  - name: "보안 감사"
    chat: security-lead ↔ security-auditor
    action: 보안 취약점 점검
  - name: "Self-Review"
    chat: dev-lead (자체검증)
    action: 전체 품질 자기 점검
  - name: "최종보고"
    chat: CEO → 동우님
    action: 결과 종합 보고
output: code/
```

### 3. analysis-chain (분석 체인)
```yaml
id: analysis-chain
trigger: "분석 [데이터]"
phases:
  - name: "요구분석"
    chat: CEO ↔ COO
    action: 분석 목표·범위 정의
  - name: "데이터 준비"
    chat: data-lead ↔ data-engineer
    action: 데이터 수집·정제·구조화
  - name: "분석 실행"
    chat: data-lead ↔ data-engineer
    action: 통계 분석, 모델링
  - name: "시각화"
    chat: data-lead ↔ data-viz
    action: 차트·대시보드 생성
  - name: "보고서"
    chat: data-lead ↔ docs-writer
    action: 분석 보고서 작성
  - name: "Self-Review"
    chat: data-lead (자체검증)
    action: 수치·결론 자기 점검
  - name: "최종보고"
    chat: CEO → 동우님
    action: 인사이트 종합 보고
output: analysis/
```

### 4. report-chain (보고서 체인)
```yaml
id: report-chain
trigger: "보고서 [주제]"
phases:
  - name: "요구분석"
    chat: CEO ↔ COO
    action: 보고서 목적·독자·형식 결정
  - name: "자료 수집"
    chat: research-lead ↔ research-web
    action: 관련 자료 검색·수집
  - name: "데이터 분석"
    chat: data-lead ↔ data-engineer
    action: 정량 데이터 분석
  - name: "초안 작성"
    chat: docs-lead ↔ docs-writer
    action: 보고서 초안 작성
  - name: "포맷팅"
    chat: docs-lead ↔ docs-formatter
    action: 형식 정리, LaTeX/마크다운 변환
  - name: "검수"
    chat: docs-lead (자체검증)
    action: 최종 품질 검수
  - name: "최종보고"
    chat: CEO → 동우님
    action: 보고서 제출
output: reports/
```

### 5. creative-chain (기획 체인)
```yaml
id: creative-chain
trigger: "기획 [아이디어]"
phases:
  - name: "브리핑"
    chat: CEO ↔ COO
    action: 크리에이티브 목표 설정
  - name: "브레인스토밍"
    chat: creative-lead ↔ creative-content
    action: 아이디어 발산·수렴
  - name: "콘텐츠 제작"
    chat: creative-lead ↔ creative-content/creative-design
    action: 카피라이팅·디자인 (병렬)
  - name: "리뷰"
    chat: creative-lead (자체검증)
    action: 품질·방향성 자기 점검
  - name: "문서화"
    chat: creative-lead ↔ docs-formatter
    action: 산출물 정리·포맷팅
  - name: "최종보고"
    chat: CEO → 동우님
    action: 크리에이티브 결과 보고
output: creative/
```

### 6. security-chain (보안점검 체인)
```yaml
id: security-chain
trigger: "보안점검"
phases:
  - name: "범위 설정"
    chat: CTO ↔ security-lead
    action: 감사 범위·기준 설정
  - name: "코드 감사"
    chat: security-lead ↔ security-auditor
    action: 소스코드 보안 분석
  - name: "모니터링 점검"
    chat: security-lead ↔ security-monitor
    action: 로그·인젝션 탐지 현황
  - name: "취약점 테스트"
    chat: security-lead ↔ testing-functional
    action: 보안 테스트 케이스 실행
  - name: "보고서"
    chat: security-lead ↔ docs-writer
    action: 보안 감사 보고서 작성
  - name: "최종보고"
    chat: CTO → CEO → 동우님
    action: 보안 현황 보고 (중대 이슈 시 직접 보고)
output: security/
```

### 7. optimization-chain (최적화 체인)
```yaml
id: optimization-chain
trigger: "최적화 [대상]"
phases:
  - name: "현황 분석"
    chat: COO ↔ optim-lead
    action: 현재 성능·효율 측정
  - name: "성능 최적화"
    chat: optim-lead ↔ optim-perf
    action: 토큰·속도·비용 최적화
  - name: "프로세스 개선"
    chat: optim-lead ↔ optim-process
    action: 워크플로 병목 분석·개선
  - name: "테스트"
    chat: optim-lead ↔ testing-functional
    action: 최적화 결과 검증
  - name: "보고서"
    chat: optim-lead ↔ docs-writer
    action: 최적화 보고서 작성
  - name: "최종보고"
    chat: COO → CEO → 동우님
    action: 개선 결과 보고
output: optimization/
```

### 8. full-review-chain (전체리뷰 체인)
```yaml
id: full-review-chain
trigger: "전체리뷰"
phases:
  - name: "현황 수집"
    chat: CEO ↔ COO/CTO
    action: 전 팀 상태·산출물 수집
  - name: "기술 리뷰"
    chat: CTO ↔ dev-lead/testing-lead
    action: 기술 품질 점검
  - name: "보안 리뷰"
    chat: CTO ↔ security-lead
    action: 보안 상태 점검
  - name: "운영 리뷰"
    chat: COO ↔ optim-lead
    action: 운영 효율 점검
  - name: "종합 보고서"
    chat: docs-lead ↔ docs-writer
    action: 전체 리뷰 보고서 작성
  - name: "최종보고"
    chat: CEO → 동우님
    action: 종합 보고 및 개선안 제시
output: reports/
```

### 9. quick-chain (간편 체인)
```yaml
id: quick-chain
trigger: 자동 (간단 작업 시 CEO 판단)
phases:
  - name: "분석+배정"
    chat: CEO (단독)
    action: 즉시 판단, 적절한 워커에게 직접 배정
  - name: "실행"
    chat: [적절한 워커]
    action: 즉시 실행
  - name: "확인"
    chat: CEO (단독)
    action: 결과 확인 후 완료
output: (작업에 따라 다름)
```

### 10. ocr-chain (OCR 레거시 체인)
```yaml
id: ocr-chain
trigger: "OCR [파일명]"
phases:
  - name: "OCR 실행"
    chat: dev-lead ↔ dev-automation
    action: Pix2Text PDF → Markdown+LaTeX
  - name: "검증"
    chat: testing-lead ↔ testing-validator
    action: LaTeX·수식·표 정합성 검증
  - name: "수정"
    chat: dev-automation (오류 수정)
    action: 오류 수정 → validated 파일 생성
  - name: "완료"
    chat: dev-lead (확인)
    action: 완료 알림
output: ocr_output/
```

---

## 체인 실행 규칙

### Self-Reflection
- 모든 체인의 실행 Phase 후에는 Self-Review 수행
- 자기 점검 체크리스트: 완성도, 정확성, 일관성, 보안
- 불합격 시 해당 Phase 재실행 (최대 3회)
- 3회 실패 시 CEO에게 에스컬레이션

### 병렬 실행
- `(병렬 가능)` 표시된 Phase는 동시 실행 허용
- 병렬 결과는 리드가 통합

### 체인 로그
- 모든 체인 실행 → `chains/YYYY-MM-DD_[chain-id].md`에 기록
- 각 Phase의 시작·종료·결과·소요시간 기록

### 11. batch-chain (배치 처리 체인)
```yaml
id: batch-chain
trigger: "배치 [작업]"
phases:
  - name: "수집"
    chat: CEO (단독)
    action: 비긴급 태스크 식별, Batch 큐 적재
  - name: "제출"
    chat: optim-perf (자동)
    action: shared/batch_queue/ → Anthropic Batch API 제출
  - name: "폴링"
    chat: optim-perf (자동)
    action: 완료 대기, 결과 수집
  - name: "배포"
    chat: CEO (단독)
    action: 결과를 각 에이전트에 메시지로 전달
output: shared/batch_results/
```

### 12. skill-creation-chain (스킬 생성 체인)
```yaml
id: skill-creation-chain
trigger: "스킬생성 [이름]" 또는 자동 (새 태스크 유형 감지)
phases:
  - name: "분석"
    chat: CEO ↔ CTO
    action: 태스크 유형 분석, 기존 스킬 검색
  - name: "설계"
    chat: CTO ↔ dev-lead
    action: 스킬 구조 설계, SKILL.md 초안
  - name: "RWL 검증"
    chat: testing-lead (자체)
    action: Ralph Wiggum Loop 체크리스트 적용
  - name: "등록"
    chat: CEO (단독)
    action: skills/ 디렉토리에 등록
output: skills/
```
