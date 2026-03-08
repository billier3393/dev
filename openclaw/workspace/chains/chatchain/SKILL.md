---
name: "chatchain"
description: "ChatChain 실행 엔진. 체인 선택, Phase 실행, Self-Reflection, 비용 추적."
metadata: {"openclaw": {"always": true}}
---
# ChatChain Engine (v11)

## 체인 실행 프로토콜
1. **체인 선택**: CEO가 CHAIN_REGISTRY.md에서 적절한 체인 선택
2. **모델 배정**: Model Benchmark Router로 Phase별 최적 모델 결정
3. **비용 추정**: 예상 토큰/비용 산출 후 예산 확인
4. **Phase 실행**: 참여자 Chat → 산출물 → Self-Check
5. **Ralph Wiggum Loop**: 모든 Phase에 자동 적용
6. **핸드오프**: `shared/handoffs/`를 통해 Phase 간 산출물 전달
7. **Lock 관리**: 공유 리소스 접근 시 Lock 획득/해제
8. **비용 기록**: 각 Phase의 실제 토큰/비용을 체인 로그에 기록

## 체인 로그 형식
```markdown
# [chain-id] 실행 로그
- 시작: YYYY-MM-DD HH:MM
- 요청: [원본 요청 전문 — 절대 압축 금지]
- 총 비용: $X.XX

## Phase 1: [Phase명]
- 참여: [에이전트] (모델: [모델명])
- 시작: HH:MM → 종료: HH:MM
- 비용: ~$X.XX (입력: X tok, 출력: X tok)
- 결과: [요약]
- Self-Check: PASS/FAIL (재시도: N회)
- RWL: PASS/FAIL
```
