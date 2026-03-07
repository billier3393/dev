---
name: "model-benchmark"
description: "AI 모델 벤치마크 DB. 태스크별 최적 모델 자동 선택. 비용-성능 균형점 계산."
metadata: {"openclaw": {"always": true}}
---
# Model Benchmark Router (v11)

## 보유 모델 벤치마크 DB
```yaml
kimi-k2.5:
  provider: kimi
  price: { input: 0.60, output: 3.00 }
  benchmarks:
    MMLU: 92.0
    GPQA_Diamond: 87.6
    MATH_500: 98.0
    HumanEval: 99.0
    SWE_bench: 76.8
    LiveCodeBench_v6: 85.0
    AIME_2025: 96.1
  strengths: [reasoning, math, coding, research, analysis]
  weaknesses: [cost-per-output, no-batch-api]

claude-haiku-4.5:
  provider: anthropic
  price: { input: 1.00, output: 5.00, batch_input: 0.50, batch_output: 2.50 }
  benchmarks:
    MMLU: 88.0
    SWE_bench: 73.3
    speed_tps: 95.5
  strengths: [coding, security-audit, testing, tool-use, batch-api]
  weaknesses: [cost-per-token-higher, reasoning-gap-vs-frontier]

gemini-2.5-flash:
  provider: google
  price: { input: 0.15, output: 0.60, thinking_output: 1.25 }
  benchmarks:
    GPQA_Diamond: 80.8  # thinking mode
    SWE_bench: 41.3
    AIME_2025: 75.6
    context_window: 1048576
  strengths: [ultra-low-cost, massive-context, ocr, bulk-processing, monitoring]
  weaknesses: [coding-quality, complex-reasoning-without-thinking]
```

## 참조용 외부 모델 DB (⚠️ 보유하지 않음 — 벤치마크 비교용 참조 데이터)
```yaml
claude-opus-4.6: { GPQA: 91.3, SWE: 80.8, price_in: 5.00 }
claude-sonnet-4.5: { SWE: 77.2, price_in: 3.00 }
gpt-4.1: { MMLU: 90.2, GPQA: 66.3, SWE: 54.6, price_in: 2.00 }
deepseek-v3: { MMLU: 88.5, MATH: 90.2, price_in: 0.27 }
deepseek-r1: { MMLU: 90.8, MATH: 97.3, price_in: 0.55 }
gemini-2.5-pro: { GPQA: 84.0, SWE: 63.8, price_in: 1.25 }
qwen3-235b: { MATH: 98.0, Codeforces: 2056, price_in: 0.18 }
llama4-maverick: { MMLU: 85.2, price_in: 0.20 }
```

## 자동 모델 선택 알고리즘

### 1. 태스크 분류
```
입력 → 태스크 유형 분류:
  - coding → Haiku 4.5 (SWE 73.3%)
  - math/physics → Kimi K2.5 (MATH 98%)
  - reasoning/strategy → Kimi K2.5 (GPQA 87.6%)
  - research/writing → Kimi K2.5 (MMLU 92%)
  - bulk/format/ocr → Gemini Flash (최저가)
  - monitoring/logging → Gemini Flash (최저가)
  - security-audit → Haiku 4.5 (코드 분석)
  - testing → Haiku 4.5 (코드 실행)
```

### 2. 비용-성능 균형 계산
```
score = (benchmark_score / 100) * task_weight
cost = (estimated_input_tokens * input_price + estimated_output_tokens * output_price) / 1_000_000
efficiency = score / cost
→ efficiency가 가장 높은 모델 선택
```

### 3. 예산 잔여량 반영
```
if 월_잔여_예산 < 30%:
  → 모든 non-critical 태스크를 Gemini Flash로 다운그레이드
if 월_잔여_예산 < 10%:
  → critical 태스크만 허용, 나머지 큐에 대기
```

### 4. Batch API 적격 여부
```
if 긴급도 == "low" and provider == "anthropic":
  → Batch API 큐에 적재 (50% 할인)
```
