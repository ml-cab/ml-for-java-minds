(ch-27)=
# 27. Profiling LLM Workloads with JFR: Matmul, Forward Pass, and Tokens/sec
If your only performance signal for an LLM feature is "it feels slow," you're debugging blind. Java's **Java Flight Recorder (JFR)**, the same low-overhead, production-safe profiling facility you'd use to diagnose a slow REST endpoint or a GC pause, applies directly here, because inference, at the JVM level, is just a very hot, very regular execution path like any other: it can be instrumented with custom events the same way you'd instrument a payment pipeline.

A well-instrumented inference engine exposes custom JFR event types at each layer of the pipeline, rather than one opaque "request took N ms" number:

| JFR event (illustrative naming) | What it measures |
|---|---|
| `MatVec` | Individual matrix-vector multiplication duration: the innermost hot loop |
| `ForwardPass` | One full transformer forward pass (prefill or single decode step) |
| `TokenProduced` | One token delivered to the client, after sampling and stop-condition checks |
| `Tokenizer` | Tokenization/detokenization duration |
| `LoraTrainStep` | One optimizer update during LoRA training (forward/backward/optimizer split) |

This layered breakdown matters because it lets you answer *where* time is going, not just *that* time is going somewhere: precisely the difference between a flat total-request-latency metric and a proper distributed trace with spans. "Generation is slow" could mean the matmul itself is the bottleneck (suggesting a GPU/quantization/hardware question, [Chapter 26](#ch-26)), or that tokenization is unexpectedly expensive (a data/preprocessing question), or that something entirely outside the model, network or queueing, is eating the time.

A key metric worth understanding precisely: **tokens per second (TPS)**, the primary throughput number reported in any LLM performance comparison. It's derived, not separately tracked: computed from the span between the first and last "token produced" event and the total count in that window:

```
tps = count(TokenProduced events) / (timestamp(last event) - timestamp(first event))
```

This is a clean example of deriving an aggregate metric from a stream of discrete events rather than maintaining a separate running counter or timer in the hot path, the same pattern you'd use deriving request-rate metrics from a stream of access log entries rather than instrumenting a counter at every call site.

For distributed inference ([Chapter 30](#ch-30)), each JVM process, coordinator and every worker node, should write its own `.jfr` recording independently, since they're separate processes with separate event streams; a metrics extraction step then processes each file and, where cross-process percentile math is needed (p95/p99 latency across the whole cluster, not just one node), merges the event lists programmatically before computing percentiles, because you cannot correctly average or naively concatenate percentiles computed separately per file.

```bash
# Record a Flight Recording during a run
./juno local --model-path models/model.gguf --dtype FLOAT16 --max-tokens 50 --jfr 5m

# Extract to structured JSON for programmatic analysis or dashboards
java -cp metrics/target/metrics-*.jar cab.ml.juno.metrics.MetricsMain
cat target/metrics/metrics.json
```

Open the raw `.jfr` file in JDK Mission Control for interactive exploration, the same tool you'd already reach for diagnosing a GC or lock-contention issue in an ordinary Java service, and the event browser view works identically: filter to `ForwardPass`, sort by `durationMs` p95, and you have a concrete, reproducible target for optimization instead of a vague impression that "it feels slow."

---

[← Chapter 26: CPU vs GPU Inference: When CUDA/ROCm Matter and When Quantized CPU Wins](#ch-26) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 28: Memory, KV Cache, and Session Affinity: Why Chat Feels Faster the Second Time →](#ch-28)
