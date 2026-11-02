(rtfms)=
# rtfms.md — Read The Folking Manuals

Sources for the specific inference-tool material in this book: CLI flags, REST endpoints, LoRA training/inference internals, and observability surfaces for the tools that keep coming up as comparison points — **Juno** (`cab.ml`, the JVM-native engine this book uses for most hands-on examples), **llama.cpp** (the C/C++ engine most of the local-LLM ecosystem is quietly built on top of), **LocalAI** (a Go-based, backend-agnostic server aimed at drop-in OpenAI API compatibility), **vLLM** (the Python/PyTorch high-throughput GPU engine), **JLama**, **Llama3.java** and **jitLLM** (pure-Java inference engines with different compute strategies), and **java-llama.cpp** (JNI bindings to llama.cpp). A short section on the JDK platform features and CPU/GPU matrix-multiplication work these engines rely on follows the tool entries. General machine learning, LLM, and distributed-systems research sources are listed separately in [references.md](references.md).

Entries below are grouped by topic, not by tool, specifically so the three projects' different choices are easy to compare side by side. Every entry was verified by fetching the live documentation page (or, where a project documents a feature only in its GitHub repository rather than a rendered docs site, the specific repository file) rather than reconstructed from memory or general familiarity with the tool. All three projects are under active development; if a flag, default, or endpoint looks different when you check it yourself, the live source is authoritative, not this list.

## Quickstart / running a model locally

(ref-juno-quickstart-local)=
### Juno Documentation §1.2 — Quickstart: Local Player

*Juno Documentation*. §1.2, Quickstart: Local Player. https://ml.cab/juno-documentation/quickstart-local

*The `./juno local --model-path ...` invocation and the `--api-port` flag for running the REST API alongside the REPL.*

(ref-juno-jvm-embedding)=
### Juno Documentation §1.3 — Quickstart: JVM Embedding

*Juno Documentation*. §1.3, Quickstart: JVM Embedding. https://ml.cab/juno-documentation/quickstart-jvm-embedding

*The `JunoPlayer` in-process facade (`.chat()`, `.streamPublisher()`, `.embed()`) and the `JunoHttpClient` blocking/streaming methods.*

(ref-jlama-readme)=
### JLama — README and Getting Started

tjake. *JLama*. https://github.com/tjake/Jlama

*Pure Java LLM inference engine using Java's Vector API for SIMD-width matrix acceleration — the established Java-native inference option among the on-premise engines. Its README describes support for Gemma, Llama, Mistral, Mixtral, Qwen2, Granite and GPT-2 family models, F32/F16/BF16 weights with Q8/Q4 quantization, an OpenAI-compatible `restapi` command, distributed-inference commands, and a `jlama-native` module alongside `jlama-core`. Its primary model format is Hugging Face SafeTensors, with pre-quantized variants published by its author on Hugging Face (for example `tjake/Llama-3.2-1B-Instruct-JQ4`); check the live README for current GGUF support. It requires Java 20+ (in practice `--add-modules jdk.incubator.vector --enable-preview`). For background, see InfoQ, [JLama: The First Pure Java Model Inference Engine Implemented With Vector API and Project Panama](https://www.infoq.com/news/2024/05/jlama-llm-inference-java). Unlike Juno, it focuses on inference only and does not include a LoRA training pipeline.*

(ref-llama3-java)=
### Llama3.java — single-file Java inference

Peterssen, A. *Llama3.java*. https://github.com/mukel/llama3.java

*Llama 3, 3.1 and 3.2 inference in a single Java file with no dependencies: a GGUF parser, a Llama 3 tokenizer based on minbpe, grouped-query attention, and Q4_0/Q8_0 quantization. It uses the Vector API (`--add-modules jdk.incubator.vector`) and requires Java 21+ for `MemorySegment` memory-mapping of the weights file; it runs via `jbang` and supports GraalVM Native Image with ahead-of-time model preloading. The README describes it as the successor of llama2.java (itself based on Karpathy's llama2.c) and as a vehicle for testing JVM compiler optimizations; it was presented at Devoxx Belgium 2024.*

(ref-llama2c)=
### llama2.c — the minimal C ancestor

Karpathy, A. *llama2.c*. https://github.com/karpathy/llama2.c

*A minimal C implementation of Llama 2 inference, named in the Llama3.java README as the origin of the line of single-file implementations. Useful reading material for anyone who wants to see a complete forward pass in a few hundred lines.*

(ref-jitllm)=
### jitLLM — GPU inference from Java via TornadoVM

TornadoVM project. *jitLLM*. https://www.tornadovm.org/jitllm · Source: https://github.com/beehive-lab/jitllm · LangChain4j integration: https://docs.langchain4j.dev/integrations/language-models/jitllm/

*Described on its site as the "Java Inference Tornado toolkit": GGUF-format inference, automatically compiled to run on GPUs through TornadoVM, with documented support for Llama 3, Mistral, Qwen 2.5/3, Phi-3, IBM Granite, Gemma and DeepSeek-R1-Distill models, official LangChain4j and Quarkus integrations, and Maven artifacts for JDK 21 and for JDK 22+. The `onGPU` builder flag selects GPU execution; the related GPULlama3.java README documents that `false` runs on the CPU through a lightweight Llama3.java-based implementation. Artifact versions and the supported-model list change quickly, so check the site rather than this entry.*

(ref-tornadovm)=
### TornadoVM documentation

TornadoVM project. *TornadoVM Documentation*. https://tornadovm.readthedocs.io/en/latest/

*TornadoVM is a plug-in for OpenJDK and GraalVM that runs Java programs on heterogeneous hardware such as GPUs and multi-core CPUs. It is the compilation layer beneath jitLLM above.*

(ref-java-llama-cpp)=
### java-llama.cpp — JNI bindings for llama.cpp

Kherud. *java-llama.cpp*. https://github.com/kherud/java-llama.cpp

*Java bindings that call the real llama.cpp through JNI, published as a Maven artifact. The default build is CPU-only; GPU acceleration requires compiling llama.cpp yourself with the desired backend. Because llama.cpp's memory is not managed by the JVM, the README notes the model object should be closed (`AutoCloseable`) to avoid leaks. Not pure Java, unlike the pure-Java engines above.*

(ref-ollama)=
### Ollama

Ollama. *Ollama*. https://github.com/ollama/ollama

*The model-management wrapper around llama.cpp (`ollama run MODEL`, serving by default on port 11434). Consult the repository for current installation and API documentation.*

(ref-llamacpp-server)=
### llama.cpp — Server (`tools/server/README.md`)

ggml-org. *llama.cpp*. `tools/server/README.md`. https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*The canonical `llama-server` documentation: build/run instructions, the full endpoint list, and every server-side CLI flag — the llama.cpp-side comparison point. Unlike Juno, there's no JVM embedding story here: llama.cpp is consumed either as a standalone server process or through language-specific bindings (`llama-cpp-python` for Python, for instance) built on top of the underlying C library.*

(ref-localai-quickstart)=
### LocalAI — Quickstart

Di Giacinto, E. et al. *LocalAI Documentation*. Quickstart. https://localai.io/docs/basics/getting_started/

*LocalAI's own framing: a free, open-source, drop-in REST API replacement for OpenAI (and, more recently, Anthropic), aimed squarely at running LLMs, images, and audio on consumer-grade hardware — a useful comparison point: a Go binary with pluggable backends, rather than a JVM library or a C++ server you embed directly.*

## OpenAI-compatible REST API

(ref-juno-openai-api)=
### Juno Documentation §5.2 — OpenAI-Compatible API

*Juno Documentation*. §5.2, OpenAI-Compatible API. https://ml.cab/juno-documentation/openai-compatible-api

*The `/v1/chat/completions` endpoint, default sampling values (`temperature=0.7`, `top_p=0.9`, `x_juno_top_k=50`), and the `x_juno_session_id` / `x_juno_priority` request extensions.*

(ref-llamacpp-openai-api)=
### llama.cpp — OpenAI-Compatible Chat Completions

ggml-org. *llama.cpp*. `tools/server/README.md`, §"POST /v1/chat/completions". https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*llama.cpp's server explicitly disclaims "strong claims of compatibility with OpenAI API spec," while still implementing the core `/v1/chat/completions` and `/v1/embeddings` surface well enough that unmodified OpenAI SDK clients work against it by changing only the base URL — the reference point for any "same JSON contract, different vendor" comparison. Its own generation-specific extensions (`mirostat`, `repeat_penalty`, and similar) are plain top-level JSON fields rather than a namespaced `x_*` prefix, unlike Juno's `x_juno_*` fields — worth noting as a real API-design difference, not just a naming quirk, since an unprefixed extension field risks silently colliding with a future official OpenAI field.*

(ref-localai-openai-api)=
### LocalAI — Overview: OpenAI-Compatible API

Di Giacinto, E. et al. *LocalAI Documentation*. Overview. https://localai.io/docs/overview/index.html

*LocalAI markets itself explicitly as a "drop-in replacement for OpenAI, Anthropic, and Open Responses APIs," implemented as a small core binary with model backends installed on demand via a gRPC interface — a third architectural answer, alongside Juno's in-process JVM library and llama.cpp's embeddable C++ server, to the same "OpenAI-compatible wire format, different runtime" problem.*

(ref-vllm-openai-api)=
### vLLM — OpenAI-Compatible Server

vLLM Project. *vLLM Documentation*. OpenAI-Compatible Server. https://docs.vllm.ai/en/latest/serving/online_serving/openai_compatible_server/

*A Python, GPU-first serving engine (`vllm serve MODEL`) implementing the OpenAI Completions, Chat, and Embeddings APIs, plus its own Prometheus `/metrics` endpoint and dynamic LoRA adapter loading/unloading through the same API server. vLLM is also the origin of the PagedAttention technique ([Kwon et al., 2023](references.md#ref-pagedattention)): unlike llama.cpp, Juno, or LocalAI, it's built specifically around maximizing GPU throughput at scale rather than running comfortably on a laptop.*

(ref-tgi-openai-api)=
### Hugging Face — Text Generation Inference (TGI)

Hugging Face. *Text Generation Inference Documentation*. Messages API. https://huggingface.co/docs/text-generation-inference/en/messages_api

*A production-grade serving toolkit with an unusual split architecture: a Rust HTTP router handling batching and request scheduling, talking over gRPC to a separate Python model server that actually runs inference — OpenAI-compatible since v1.4.0's "Messages API," with continuous batching, Flash/PagedAttention, and Prometheus metrics built in. It is a third "talk to it over HTTP" option, architecturally distinct from both llama.cpp's single C++ binary and vLLM's single Python process: TGI deliberately splits routing from model execution across a language boundary.*

## LoRA: training vs. inference-only application

(ref-juno-lora-concepts)=
### Juno Documentation §4.1 — LoRA Concepts

*Juno Documentation*. §4.1, Concepts. https://ml.cab/juno-documentation/concepts

*The `W_effective = W + scale * B * A` formulation and the TinyLlama parameter-count table (1,100,048,000 frozen vs. 720,896 trainable at rank 8).*

(ref-juno-training-guide)=
### Juno Documentation §4.3 — Training Guide

*Juno Documentation*. §4.3, Training Guide. https://ml.cab/juno-documentation/training-guide

*The `/train-qa` REPL command, A-only decoupled AdamW weight decay, and global gradient-norm clipping.*

(ref-juno-inference-adapter)=
### Juno Documentation §4.4 — Inference with a Trained Adapter

*Juno Documentation*. §4.4, Inference with a Trained Adapter. https://ml.cab/juno-documentation/inference-with-adapter

*The `--lora-play PATH` flag, its default to greedy (temperature-0) decoding for deterministic fact recall, and the read-only `LoraTrainableHandler` wrapper.*

(ref-llamacpp-lora)=
### llama.cpp — LoRA Adapters (server `--lora` / `POST /lora-adapters`)

ggml-org. *llama.cpp*. `tools/server/README.md`, §"LoRA adapters". https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*The important structural difference from both Juno and LocalAI, worth being explicit about: llama.cpp does not train LoRA adapters at all. It only **applies** pre-trained adapters at inference time (`--lora FILE`, with `--lora-init-without-apply` plus `POST /lora-adapters` for runtime hot-swapping), and separately **converts** adapters already trained elsewhere (typically via Hugging Face PEFT) into its own GGUF adapter format with the `convert_lora_to_gguf.py` script. If your workflow needs to actually *train* a LoRA adapter rather than just load or convert one, llama.cpp on its own is the wrong tool; Juno and LocalAI (below) both close that gap, each with a different training backend.*

(ref-llamacpp-convert-lora)=
### llama.cpp — `convert_lora_to_gguf.py`

ggml-org. *llama.cpp*. `convert_lora_to_gguf.py`. https://github.com/ggml-org/llama.cpp/blob/master/convert_lora_to_gguf.py

*The script that converts a Hugging Face PEFT LoRA adapter (`adapter_config.json` + `adapter_model.safetensors`) into llama.cpp's own GGUF adapter format — the conversion step for the load-and-apply-at-runtime adapter path, as an alternative to merging.*

(ref-localai-finetuning)=
### LocalAI — Fine-Tuning

Di Giacinto, E. et al. *LocalAI Documentation*. Fine-Tuning. https://localai.io/docs/features/fine-tuning/index.html

*LocalAI, unlike llama.cpp, does train LoRA adapters directly through its own REST API (`POST /api/fine-tuning/jobs`, backed by a pluggable `trl` backend supporting SFT, DPO, GRPO, and other training methods, with `training_type: "lora"` as one of two options alongside full fine-tuning). This makes LocalAI the closer structural match to Juno's `/train-qa` REPL loop, a tool that both trains and serves, rather than llama.cpp's serve-and-convert-only model. The API also documents export straight to GGUF (`POST /.../export` with `"export_format": "gguf"`), the same end state Juno's `juno merge` command and llama.cpp's conversion scripts both arrive at by different routes.*

## Merging adapters into a base model

(ref-juno-merging-adapters)=
### Juno Documentation §4.5 — Merging Adapters

*Juno Documentation*. §4.5, Merging Adapters. https://ml.cab/juno-documentation/merging-adapters

*The `juno merge` command, the `f32-preserve` default merge policy, and the measured LoRA-delta-versus-quantization-noise figures (~6×10⁻⁴ delta vs. ~3×10⁻³ Q4_K noise per element).*

## Deployment

(ref-juno-aws-deployment)=
### Juno Documentation §6.2 — AWS Deployment

*Juno Documentation*. §6.2, AWS Deployment. https://ml.cab/juno-documentation/aws-deployment/

*The `juno-deploy.sh` cluster lifecycle script (`setup`, `start`, `stop`, `teardown`, `status`, `scan-regions`) run through `launcher.sh`: setup options for instance type, node count, coordinator placement, model URL, pipeline or tensor parallelism, activation wire format, JFR recording, and `--lora-play` to copy a trained adapter to every node; the AWS vCPU quota increases a GPU instance family needs before the first `setup`; GPU driver handling in the prebuilt AMI (CUDA on NVIDIA, ROCm on AMD Radeon, backend auto-selected at node bootstrap); and the train-locally, deploy-with-adapter flow.*

## Observability and metrics

(ref-juno-jfr-metrics)=
### Juno Documentation §7.1 — JFR and Metrics

*Juno Documentation*. §7.1, JFR and Metrics. https://ml.cab/juno-documentation/jfr-and-metrics

*The `--jfr DURATION` flag, the `juno.*` custom JFR event catalog, and the `MetricsMain` extraction step producing `target/metrics/metrics.json`.*

(ref-llamacpp-metrics)=
### llama.cpp — Server Metrics (`--metrics` / `GET /metrics`)

ggml-org. *llama.cpp*. `tools/server/README.md`, §"GET /metrics". https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md

*A Prometheus-format `/metrics` endpoint, opt-in via the `--metrics` flag (disabled by default), exposing counters like prompt- and generation-token totals — a lighter-weight, ops-facing alternative to Juno's JVM Flight Recorder approach: llama.cpp hands you a scrape target for Prometheus/Grafana rather than a recording file you extract and inspect after the fact.*

(ref-localai-tracing)=
### LocalAI — Tracing

Di Giacinto, E. et al. *LocalAI Documentation*. Tracing. https://localai.io/docs/features/tracing/index.html

*LocalAI's approach is different again: rather than a Prometheus scrape endpoint or a JFR-style recording, it retains a bounded, persistent history of recent API exchanges and backend operations, inspectable live on a "Traces" page in its own management UI — a third distinct answer, alongside Juno's JFR and llama.cpp's Prometheus endpoint, to "how do I see what my inference server is actually doing."*

## JDK platform features and matrix-multiplication engineering

(ref-jep-vector-api)=
### OpenJDK — Vector API (JEPs)

OpenJDK. JEP 448: Vector API (Sixth Incubator). https://openjdk.org/jeps/448 · JEP 460: Vector API (Seventh Incubator). https://openjdk.org/jeps/460 · JEP 508: Vector API (Tenth Incubator). https://openjdk.org/jeps/508

*The `jdk.incubator.vector` module expresses vector computations that compile at runtime to SIMD instructions (AVX on x64, NEON on AArch64). It has been re-incubated in successive JDK releases — JEP 448 shipped in JDK 21, JEP 460 in JDK 22, and JEP 508 was targeted to JDK 25 — so check the JEP for your JDK version before relying on it.*

(ref-project-panama)=
### OpenJDK — Project Panama

OpenJDK. Project Panama. https://openjdk.org/projects/panama/

*The OpenJDK project that connects Java with native code. Its Foreign Function & Memory API ([JEP 454](#ref-jep-ffm)) is what lets a Java engine call vendor GPU libraries such as cuBLAS and rocBLAS directly, without JNI wrapper code.*

(ref-jep-ffm)=
### OpenJDK — Foreign Function & Memory API (JEP 454)

OpenJDK. JEP 454: Foreign Function & Memory API. https://openjdk.org/jeps/454

*The finalized (JDK 22) API in `java.lang.foreign` for calling native libraries and managing off-heap memory without JNI — the mechanism behind the Panama-based CUDA/ROCm and BLAS calls, and behind memory-mapped weight files in Java inference engines.*

(ref-hat-matmul)=
### Project Babylon / HAT — GPU matrix multiplication from Java

Fumero, J. (2026, January). Optimizing GPU Programs from Java using Babylon and HAT. *OpenJDK Project Babylon articles*. https://openjdk.org/projects/babylon/articles/hat-matmul/hat-matmul

*A hands-on walkthrough of matrix multiplication on the Heterogeneous Accelerator Toolkit, which uses Babylon's code reflection to generate CUDA/OpenCL kernels from Java, showing step-by-step optimization (tiling, memory layout, vectorization). Babylon's code-reflection API lives in the incubating `jdk.incubator.code` module; consult the project page for current status.*

(ref-java-llms-perf)=
### Papadimitriou (2023) — Java and LLMs: are we there yet?

Papadimitriou, M. (2023, December 19). Java and LLMs: are we there yet? Performance analysis of LLM inference on the Java platform with Panama, Vector API, and TornadoVM. *Medium*. https://medium.com/@mpapadimitriou92/java-and-llms-are-we-there-yet-300cf9418ed7

*An engineering blog post (not peer-reviewed) by a TornadoVM engineer. It profiles a llama2.java implementation using the Vector API and off-heap memory, offloads its dominant matrix-vector operation to a GPU with TornadoVM, and compares the results with native llama2.c on small (15M–110M parameter) models. Also states that LLM computations are dominated by vector and matrix multiplications that are often bound by memory bandwidth.*

(ref-henry-vector-api)=
### Henry (2021) — Learnings with the Vector API

Henry, L. (2021, January 28). Learnings with the Vector API. *panama-dev mailing list*. https://mail.openjdk.org/pipermail/panama-dev/2021-January/011930.html

*A practitioner's report on writing BLAS matrix-matrix multiplication with the Vector API: roughly 15 GFLOP/s on the author's machine versus roughly 25 GFLOP/s for OpenBLAS, with the gap attributed to the inner-loop tile size and unrolling and to HotSpot's register allocation at the time. Dated (JDK 16-era), so useful for the diagnosis rather than the numbers.*

(ref-llamafile-sgemm)=
### llama.cpp — llamafile `sgemm` CPU kernels

Tunney, J. et al. ggml : add llamafile sgemm (#6414). *llama.cpp*. https://github.com/ggml-org/llama.cpp/pull/6414 · Background: Tunney, J. LLaMA Now Goes Faster on CPUs. https://justine.lol/matmul/

*The change that upstreamed llamafile's CPU matrix-multiplication kernels ("tinyBLAS") into llama.cpp. Its commit message reports roughly 40% faster Q4_0/Q8_0 processing and about 2x faster f16/f32 prompt processing on the author's hardware, plus proper AVX512 support. Treat the figures as the author's measurements on one machine.*

(ref-kleidiai)=
### Arm KleidiAI and i8mm kernels

Arm. *KleidiAI*. https://github.com/ARM-software/kleidiai · Arm Community blog: Optimizing Llama.cpp with Arm I8MM instruction. https://community.arm.com/arm-community-blogs/b/ai-blog/posts/optimize-llama-cpp-with-arm-i8mm-instruction

*KleidiAI is a set of micro-kernels hand-optimized in Arm assembly for AI inference on Arm CPUs, using instructions such as SMMLA (signed 8-bit integer matrix multiply-accumulate, part of the `i8mm` feature) and SME's FMOPA (floating-point outer-product accumulate). llama.cpp's `ggml-cpu` backend integrates KleidiAI as an optional trait, and the Arm blog describes llama.cpp Q4_K/Q6_K kernels optimized with `smmla`. Vendor material; performance claims there are Arm's own. The x86 counterparts (such as AVX512-VNNI and AMX) are not covered by any entry here.*

---

## A note on how this list was built

Every entry above was verified by fetching the live documentation page or, for llama.cpp's features that are documented only in-repository rather than on a rendered docs site, the specific GitHub source file, rather than pulled from memory. Entries added later (Llama3.java, jitLLM, TornadoVM, java-llama.cpp, the JEP, HAT, llamafile and Arm entries) were checked against the project's README or documentation page, or an indexed copy of it, at the time of writing; the Ollama and llama2.c entries are pointers to the repositories. All of these tools are under active development, and llama.cpp in particular ships CLI flags and endpoints that have moved or been renamed across releases (the server example directory itself has been relocated at least once, from `examples/server/` to `tools/server/`), so a URL or flag name here that no longer matches what you find live is a sign the project moved, not that this list is being careless.

---

[Table of Contents](index.md) &nbsp;|&nbsp; [General References](references.md)