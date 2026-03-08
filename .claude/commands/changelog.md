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
