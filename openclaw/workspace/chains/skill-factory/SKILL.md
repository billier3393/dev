---
name: "skill-factory"
description: "새 스킬을 자동 생성하는 메타 스킬. 태스크 분석 → 스킬 설계 → 검증 → 등록."
user-invocable: true
---
# Skill Factory

## 스킬 자동 생성 프로세스
```
[새 태스크 유형 감지] → [기존 스킬 검색] → 없음? → [스킬 설계]
                                                    ↓
                                              [SKILL.md 생성]
                                                    ↓
                                              [RWL 체크리스트 포함]
                                                    ↓
                                              [테스트 실행]
                                                    ↓
                                              [skills/ 등록]
```

## 스킬 템플릿
```yaml
---
name: "{skill-name}"
description: "{1줄 설명}"
user-invocable: {true/false}
metadata: {"openclaw": {"requires": {}, "os": []}}
---
# {Skill Name}

## 목적
{이 스킬이 해결하는 문제}

## 실행 조건
{언제 이 스킬이 활성화되는가}

## 단계
1. ...
2. ...
3. ...

## RWL 체크리스트
- [ ] {스킬별 자기 평가 항목}

## 모델 권장
{이 스킬에 최적인 모델과 이유}

## 비용 추정
{평균 토큰 사용량과 비용}
```

## 자동 모델 요청
스킬 설계 시 Model Benchmark Router를 참조하여:
1. 최적 모델 자동 선정
2. 보유하지 않은 모델이 필요하면 동우님에게 추가 요청 제안
3. 비용 추정 포함

## CEO 승인
새 스킬 생성 시 CEO가 검토 후 등록. 구조적 변경이 필요하면 동우님 승인.
