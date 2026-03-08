---
name: "lock-manager"
description: "공유 리소스 Lock 파일 관리. 동시 접근 충돌 방지."
metadata: {"openclaw": {"always": true}}
---
# Lock Manager

## Lock 획득
```bash
RESOURCE="shared/artifacts/report.md"
LOCK="shared/locks/$(echo $RESOURCE | tr '/' '_').lock"
if [ ! -f "$LOCK" ]; then
  echo '{"agent":"'$AGENT_ID'","acquired":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","ttl":300,"resource":"'$RESOURCE'"}' > "$LOCK"
  echo "LOCK_ACQUIRED"
else
  echo "LOCK_BUSY"
fi
```

## Lock 해제
```bash
rm -f "$LOCK"
```

## Stale Lock 정리
```bash
find shared/locks/ -name "*.lock" -mmin +10 -delete
```

## 규칙
- Lock 소유자만 해제 가능 (stale 제외)
- TTL 기본 300초 (5분)
- Lock 실패 시 최대 3회 재시도 (10초 간격)
- 절대 강제 해제 금지 (stale 자동 정리만)
