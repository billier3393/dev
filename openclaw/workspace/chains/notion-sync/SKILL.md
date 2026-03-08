---
name: "notion-sync"
description: "Notion API 연동. 페이지/DB 조회."
metadata: {"openclaw": {"requires": {"env": ["NOTION_API_TOKEN", "NOTION_PAGE_ID"]}}}
---
# Notion Sync
```bash
curl -s -X POST 'https://api.notion.com/v1/search' \
  -H "Authorization: Bearer $NOTION_API_TOKEN" \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -d '{"query": "SEARCH_TERM"}'
```
