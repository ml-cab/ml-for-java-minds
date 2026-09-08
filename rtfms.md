(rtfms)=
# rtfms.md — Read The F\*\*\*ing ManualS

Sources for the specific inference-tool material in this book: CLI flags, REST endpoints, LoRA training/inference internals, and observability surfaces for the tools that keep coming up as comparison points — **Juno** (`cab.ml`, the JVM-native engine this book uses for most hands-on examples), **llama.cpp** (the C/C++ engine most of the local-LLM ecosystem is quietly built on top of), **LocalAI** (a Go-based, backend-agnostic server aimed at drop-in OpenAI API compatibility), **vLLM** (the Python/PyTorch high-throughput GPU engine), and **JLama** (the established pure-Java inference engine). General machine learning, LLM, and distributed-systems research sources are listed separately in [references.md](references.md).

Entries below are grouped by topic, not by tool, specifically so the three projects' different choices are easy to compare side by side. Every entry was verified by fetching the live documentation page (or, where a project documents a feature only in its GitHub repository rather than a rendered docs site, the specific repository file) rather than reconstructed from memory or general familiarity with the tool. All three projects are under active development; if a flag, default, or endpoint looks different when you check it yourself, the live source is authoritative, not this list.

## Quickstart / running a model locally

(ref-juno-quickstart-local)=
### Juno Documentation §1.2 — Quickstart: Local Player

*Juno Documentation*. §1.2, Quickstart: Local Player. https://ml.cab/juno-documentation/quickstart-local

*The `./juno local --model-path ...` invocation and the `--api-port` flag for running the REST API alongside the REPL — cited in [Chapter 6](part1/06-training-vs-inference.md) and [Chapter 8](part1/08-why-python-dominates-ml.md).*

(ref-juno-jvm-embedding)=
### Juno Documentation §1.3 — Quickstart: JVM Embedding

*Juno Documentation*. §1.3, Quickstart: JVM Embedding. https://ml.cab/juno-documentation/quickstart-jvm-embedding

*The `JunoPlayer` in-process facade (`.chat()`, `.streamPublisher()`, `.embed()`) and the `JunoHttpClient` blocking/streaming methods — cited in [Chapter 7](part1/07-what-is-a-language-model.md), [Chapter 8](part1/08-why-python-dominates-ml.md), and [Chapter 10](part2/10-embeddings-101.md).*

(ref-jlama-readme)=
### JLama — README and Getting Started

tjake. *JLama*. https://github.com/tjake/Jlama

*Pure Java LLM inference engine using Java's Vector API for SIMD-width matrix acceleration and Panama FFI for GPU backends — the established Java-native inference option in the on-premise engine table in [Chapter 6](part1/06-training-vs-inference.md). JLama supports LLaMA 3, Mistral, Gemma, Mixtral, and other architectures in GGUF format. Unlike Juno, it focuses on inference only and does not include a LoRA training pipeline; for the training-vs-inference-only distinction between the two JVM engines, see the table comparison in [Chapter 6](part1/06-training-vs-inference.md) and the fuller discussion in [Chapter 8](part1/08-why-python-dominates-ml.md).*

(ref-llamacpp-server)=
### llama.cpp — Server (`tools/server/README.md`)

ggml-org. *llama.cpp*. `tools/server/README.md`. https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*The canonical `llama-server` documentation: build/run instructions, the full endpoint list, and every server-side CLI flag — the llama.cpp-side comparison point in [Chapter 6](part1/06-training-vs-inference.md) and [Chapter 8](part1/08-why-python-dominates-ml.md). Unlike Juno, there's no JVM embedding story here: llama.cpp is consumed either as a standalone server process or through language-specific bindings (`llama-cpp-python` for Python, for instance) built on top of the underlying C library.*

(ref-localai-quickstart)=
### LocalAI — Quickstart

Di Giacinto, E. et al. *LocalAI Documentation*. Quickstart. https://localai.io/docs/basics/getting_started/

*LocalAI's own framing: a free, open-source, drop-in REST API replacement for OpenAI (and, more recently, Anthropic), aimed squarely at running LLMs, images, and audio on consumer-grade hardware — cited in [Chapter 6](part1/06-training-vs-inference.md) and [Chapter 8](part1/08-why-python-dominates-ml.md) as a comparison point: a Go binary with pluggable backends, rather than a JVM library or a C++ server you embed directly.*

## OpenAI-compatible REST API

(ref-juno-openai-api)=
### Juno Documentation §5.2 — OpenAI-Compatible API

*Juno Documentation*. §5.2, OpenAI-Compatible API. https://ml.cab/juno-documentation/openai-compatible-api

*The `/v1/chat/completions` endpoint, default sampling values (`temperature=0.7`, `top_p=0.9`, `x_juno_top_k=50`), and the `x_juno_session_id` / `x_juno_priority` request extensions — cited in [Chapter 14](part2/14-temperature-top-p-top-k.md), [Chapter 16](part2/16-gguf-and-quantization.md), [Chapter 17](part2/17-openai-compatible-apis.md), [Chapter 28](part3/28-memory-kv-cache-session-affinity.md), and [Chapter 31](part4/31-production-serving-patterns.md).*

(ref-llamacpp-openai-api)=
### llama.cpp — OpenAI-Compatible Chat Completions

ggml-org. *llama.cpp*. `tools/server/README.md`, §"POST /v1/chat/completions". https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*llama.cpp's server explicitly disclaims "strong claims of compatibility with OpenAI API spec," while still implementing the core `/v1/chat/completions` and `/v1/embeddings` surface well enough that unmodified OpenAI SDK clients work against it by changing only the base URL — the point of comparison for [Chapter 17](part2/17-openai-compatible-apis.md)'s "same JSON contract, different vendor" framing. Its own generation-specific extensions (`mirostat`, `repeat_penalty`, and similar) are plain top-level JSON fields rather than a namespaced `x_*` prefix, unlike Juno's `x_juno_*` fields — worth noting as a real API-design difference, not just a naming quirk, since an unprefixed extension field risks silently colliding with a future official OpenAI field.*

(ref-localai-openai-api)=
### LocalAI — Overview: OpenAI-Compatible API

Di Giacinto, E. et al. *LocalAI Documentation*. Overview. https://localai.io/docs/overview/index.html

*LocalAI markets itself explicitly as a "drop-in replacement for OpenAI, Anthropic, and Open Responses APIs," implemented as a small core binary with model backends installed on demand via a gRPC interface — a third architectural answer, alongside Juno's in-process JVM library and llama.cpp's embeddable C++ server, to the same "OpenAI-compatible wire format, different runtime" problem discussed in [Chapter 17](part2/17-openai-compatible-apis.md).*

(ref-vllm-openai-api)=
### vLLM — OpenAI-Compatible Server

vLLM Project. *vLLM Documentation*. OpenAI-Compatible Server. https://docs.vllm.ai/en/latest/serving/online_serving/openai_compatible_server/

*A Python, GPU-first serving engine (`vllm serve MODEL`) implementing the OpenAI Completions, Chat, and Embeddings APIs, plus its own Prometheus `/metrics` endpoint and dynamic LoRA adapter loading/unloading through the same API server — cited in [Chapter 8](part1/08-why-python-dominates-ml.md). vLLM is also the origin of the PagedAttention technique cited in [Chapter 28](part3/28-memory-kv-cache-session-affinity.md) ([Kwon et al., 2023](references.md#ref-pagedattention)): unlike llama.cpp, Juno, or LocalAI, it's built specifically around maximizing GPU throughput at scale rather than running comfortably on a laptop.*

(ref-tgi-openai-api)=
### Hugging Face — Text Generation Inference (TGI)

Hugging Face. *Text Generation Inference Documentation*. Messages API. https://huggingface.co/docs/text-generation-inference/en/messages_api

*A production-grade serving toolkit with an unusual split architecture: a Rust HTTP router handling batching and request scheduling, talking over gRPC to a separate Python model server that actually runs inference — OpenAI-compatible since v1.4.0's "Messages API," with continuous batching, Flash/PagedAttention, and Prometheus metrics built in. Cited in [Chapter 8](part1/08-why-python-dominates-ml.md) as a third "talk to it over HTTP" option, architecturally distinct from both llama.cpp's single C++ binary and vLLM's single Python process: TGI deliberately splits routing from model execution across a language boundary.*

## LoRA: training vs. inference-only application

(ref-juno-lora-concepts)=
### Juno Documentation §4.1 — LoRA Concepts

*Juno Documentation*. §4.1, Concepts. https://ml.cab/juno-documentation/concepts

*The `W_effective = W + scale * B * A` formulation and the TinyLlama parameter-count table (1,100,048,000 frozen vs. 720,896 trainable at rank 8) — cited in [Chapter 22](part3/22-fine-tuning-vs-prompting-vs-rag.md), [Chapter 24](part3/24-lora-explained.md), and [Chapter 36](part5/36-loss-functions-gradient-descent-bias-variance.md).*

(ref-juno-training-guide)=
### Juno Documentation §4.3 — Training Guide

*Juno Documentation*. §4.3, Training Guide. https://ml.cab/juno-documentation/training-guide

*The `/train-qa` REPL command, A-only decoupled AdamW weight decay, and global gradient-norm clipping — cited in [Chapter 22](part3/22-fine-tuning-vs-prompting-vs-rag.md), [Chapter 24](part3/24-lora-explained.md), and [Chapter 36](part5/36-loss-functions-gradient-descent-bias-variance.md).*

(ref-juno-inference-adapter)=
### Juno Documentation §4.4 — Inference with a Trained Adapter

*Juno Documentation*. §4.4, Inference with a Trained Adapter. https://ml.cab/juno-documentation/inference-with-adapter

*The `--lora-play PATH` flag, its default to greedy (temperature-0) decoding for deterministic fact recall, and the read-only `LoraTrainableHandler` wrapper — cited in [Chapter 24](part3/24-lora-explained.md).*

(ref-llamacpp-lora)=
### llama.cpp — LoRA Adapters (server `--lora` / `POST /lora-adapters`)

ggml-org. *llama.cpp*. `tools/server/README.md`, §"LoRA adapters". https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*The important structural difference from both Juno and LocalAI, worth being explicit about in [Chapter 24](part3/24-lora-explained.md): llama.cpp does not train LoRA adapters at all. It only **applies** pre-trained adapters at inference time (`--lora FILE`, with `--lora-init-without-apply` plus `POST /lora-adapters` for runtime hot-swapping), and separately **converts** adapters already trained elsewhere (typically via Hugging Face PEFT) into its own GGUF adapter format with the `convert_lora_to_gguf.py` script. If your workflow needs to actually *train* a LoRA adapter rather than just load or convert one, llama.cpp on its own is the wrong tool; Juno and LocalAI (below) both close that gap, each with a different training backend.*

(ref-llamacpp-convert-lora)=
### llama.cpp — `convert_lora_to_gguf.py`

ggml-org. *llama.cpp*. `convert_lora_to_gguf.py`. https://github.com/ggml-org/llama.cpp/blob/master/convert_lora_to_gguf.py

*The script that converts a Hugging Face PEFT LoRA adapter (`adapter_config.json` + `adapter_model.safetensors`) into llama.cpp's own GGUF adapter format — the conversion step referenced alongside [Chapter 25](part3/25-merge-adapters-into-gguf.md)'s discussion of merging.*

(ref-localai-finetuning)=
### LocalAI — Fine-Tuning

Di Giacinto, E. et al. *LocalAI Documentation*. Fine-Tuning. https://localai.io/docs/features/fine-tuning/index.html

*LocalAI, unlike llama.cpp, does train LoRA adapters directly through its own REST API (`POST /api/fine-tuning/jobs`, backed by a pluggable `trl` backend supporting SFT, DPO, GRPO, and other training methods, with `training_type: "lora"` as one of two options alongside full fine-tuning). This makes LocalAI the closer structural match to Juno's `/train-qa` REPL loop discussed in [Chapter 22](part3/22-fine-tuning-vs-prompting-vs-rag.md) and [Chapter 24](part3/24-lora-explained.md), a tool that both trains and serves, rather than llama.cpp's serve-and-convert-only model. The API also documents export straight to GGUF (`POST /.../export` with `"export_format": "gguf"`), the same end state Juno's `juno merge` command and llama.cpp's conversion scripts both arrive at by different routes — see [Chapter 25](part3/25-merge-adapters-into-gguf.md).*

## Merging adapters into a base model

(ref-juno-merging-adapters)=
### Juno Documentation §4.5 — Merging Adapters

*Juno Documentation*. §4.5, Merging Adapters. https://ml.cab/juno-documentation/merging-adapters

*The `juno merge` command, the `f32-preserve` default merge policy, and the measured LoRA-delta-versus-quantization-noise figures (~6×10⁻⁴ delta vs. ~3×10⁻³ Q4_K noise per element) — cited in [Chapter 25](part3/25-merge-adapters-into-gguf.md).*

## Observability and metrics

(ref-juno-jfr-metrics)=
### Juno Documentation §7.1 — JFR and Metrics

*Juno Documentation*. §7.1, JFR and Metrics. https://ml.cab/juno-documentation/jfr-and-metrics

*The `--jfr DURATION` flag, the `juno.*` custom JFR event catalog, and the `MetricsMain` extraction step producing `target/metrics/metrics.json` — cited in [Chapter 27](part3/27-profiling-llm-workloads-with-jfr.md).*

(ref-llamacpp-metrics)=
### llama.cpp — Server Metrics (`--metrics` / `GET /metrics`)

ggml-org. *llama.cpp*. `tools/server/README.md`, §"GET /metrics". https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*A Prometheus-format `/metrics` endpoint, opt-in via the `--metrics` flag (disabled by default), exposing counters like prompt- and generation-token totals — a lighter-weight, ops-facing alternative to Juno's JVM Flight Recorder approach discussed in [Chapter 27](part3/27-profiling-llm-workloads-with-jfr.md): llama.cpp hands you a scrape target for Prometheus/Grafana rather than a recording file you extract and inspect after the fact.*

(ref-localai-tracing)=
### LocalAI — Tracing

Di Giacinto, E. et al. *LocalAI Documentation*. Tracing. https://localai.io/docs/features/tracing/index.html

*LocalAI's approach is different again: rather than a Prometheus scrape endpoint or a JFR-style recording, it retains a bounded, persistent history of recent API exchanges and backend operations, inspectable live on a "Traces" page in its own management UI — a third distinct answer, alongside Juno's JFR and llama.cpp's Prometheus endpoint, to "how do I see what my inference server is actually doing," referenced in [Chapter 27](part3/27-profiling-llm-workloads-with-jfr.md).*

---

## A note on how this list was built

Every entry above was verified by fetching the live documentation page or, for llama.cpp's features that are documented only in-repository rather than on a rendered docs site, the specific GitHub source file, rather than pulled from memory. All three tools are under active development, and llama.cpp in particular ships CLI flags and endpoints that have moved or been renamed across releases (the server example directory itself has been relocated at least once, from `examples/server/` to `tools/server/`), so a URL or flag name here that no longer matches what you find live is a sign the project moved, not that this list is being careless.

---

[Table of Contents](index.md) &nbsp;|&nbsp; [General References](references.md)