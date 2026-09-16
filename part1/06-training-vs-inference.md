(ch-06)=
# 6. Training vs Inference: Compile-Time Thinking vs Runtime Serving

Every Java application has two phases of its lifecycle compile-time and run-time. Machine learning has the identical split. **Training** produces model weights, an offline step you run whenever you have new data or a new behavior to teach. **Inference** runs that trained model on every user prompt, constantly.

| | Java | ML equivalent |
|---|---|---|
| **Build step** | `javac` source → compiler → `.class` file | model weights → training loop → checkpoint file |
| Input | Source code | Training data |
| Output | Bytecode file | Model weights |
| Cost | Seconds–minutes | Full pre-training: weeks on expensive hardware. LoRA fine-tuning: minutes to hours on GPU |
| **Run step** | JVM serving requests | Inference engine serving prompts |
| Input | Bytecode + runtime data | Weights file + user input |
| Cost | Milliseconds per request | Milliseconds–seconds per request |

Training is a **build step**. Inference is **serving traffic**.

One consequence worth noting: **a chat conversation does not train the model.** Everything the model appears to "remember" mid-conversation is just the transcript being re-sent as input on every turn. The same way a stateless HTTP handler only "remembers" a session because the client resends a cookie. Close the conversation and the weights are exactly as they were before you opened it.

## Weights, Context and Retrieval: A three steps to the right data management.

Lets think of what a model should "know" and how to achieve it efficiently.

- **Weights, via fine-tuning** 

The model's durable, compiled knowledge (introduced in [Chapter 1](#ch-01) and [Chapter 5](#ch-05)). Adjustable through [LoRA](https://arxiv.org/abs/2106.09685) (Hu et al., 2021): This Low-Rank Adaptation adds a small set of trainable parameters alongside the frozen base model, making iterative updates cheap enough in size and time to apply. We will certainly look at this with examples later. Use this step for behaviors that should hold across every future request: a tone, an output format, a domain reasoning style. Run it whenever you want a new capability baked in. 

- **Context window**

The "working memory" attached to each individual request: your system prompt, conversation history, and any text you include inline. It is re-read from scratch on every call and discarded when the request completes. Cheap to change between requests, but finite in size and cost. Covered in depth in [Chapter 7](#ch-07). Budget it like heap space, not disk.

- **Retrieval-Augmented Generation (RAG)**

Introduced by [Lewis et al. (2020)](https://arxiv.org/abs/2005.11401): at request time, relevant documents are fetched from a vector store or search index and injected into the context window before the model generates its response. Instead of baking facts into weights or manually pasting them into every prompt, the model reads them on demand, like a running service querying a database instead of loading the whole table into memory at startup. Essential for large, fast-changing corpora: documentation, product catalogs, legal filings.

For example a `price list` data belongs to the third step, not the first. It changes too often for building it's weights and is too large to paste into every prompt.

Notice what all three steps have in common: they all move data! `Fine-tuning` bakes your training data to a binary file through a training loop. Every `inference call` sends your system prompts, user inputs, and full conversation history through a context window on every single turn. `RAG` sends your retrieved documents, expertise from your internal knowledge base, your product catalog, your legal filings right into a context window before each request. 

Route any of that through a cloud API and you have accepted someone else's data retention policy, their model retraining terms, and their legal jurisdiction over everything you sent. 

Running all three steps locally keeps your data inside your own perimeter. It also keeps your processes under your control: you decide when to upgrade the model, what hardware it runs on, and whether a new version changed behavior in a way that would break your application. Rather than discovering that in production after a vendor silently pushed an update. And the cost structure changes fundamentally. A local inference server is a capital expense that amortizes across every request you ever make against it. A SaaS API is an operating expense billed per token, against a pricing page that can change without notice, for a model whose behavior can change without notice, under a data policy that can change without notice.

Which makes the choice of inference engine not a deployment detail to sort out after the architecture is set. It is one of the first decisions in any stack that runs models on its own hardware.

## Picking an On-Premise Inference Engine

A model checkpoint is your build artifact, the same role `.jar` plays after `mvn package`. An inference engine loads it once per model version; every request after that is a runtime call against an artifact that already exists.

| Engine | Runtime | What it is | Best fit |
|---|---|---|---|
| [**llama.cpp**](https://github.com/ggerganov/llama.cpp) | C/C++ | Open-source LLM inference in pure C/C++; the reference implementation for GGUF quantized models, with CPU and CUDA/Metal/Vulkan GPU backends | The portable baseline: runs on almost any hardware, from a laptop to an edge box |
| [**Ollama**](https://ollama.com) | Go (wraps llama.cpp) | A friendly CLI and REST wrapper around llama.cpp; downloads and runs models in a single command with automatic GGUF quantization selection | Fastest path from nothing to a running local model |
| [**LocalAI**](https://localai.io) | Go (pluggable backends) | Drop-in, self-hosted replacement for the OpenAI, Anthropic, and Open Responses APIs; backends installed on demand via gRPC, supporting LLMs, images, audio, and LoRA fine-tuning through its own REST API | Teams wanting a single OpenAI-compatible gateway in front of any backend, with fine-tuning included |
| [**vLLM**](https://github.com/vllm-project/vllm) | Python / PyTorch | High-throughput inference server built around [PagedAttention](https://arxiv.org/abs/2309.06180) for efficient GPU memory management; supports continuous batching and multi-GPU tensor parallelism | High-concurrency production serving on a GPU box or cluster |
| [**JLama**](https://github.com/tjake/Jlama) | Pure Java (JVM) | Mature Java-native inference engine using the Vector API for SIMD acceleration and Panama FFI for GPU access; supports LLaMA, Mistral, Gemma, and others | Established, production-ready Java-native inference, no native dependencies |
| [**Juno**](https://github.com/ml-cab/juno) | Pure Java (JVM) | End-to-end JVM inference and LoRA fine-tuning engine with pipeline and tensor parallelism, Panama-based CUDA/ROCm GPU backends, and support for embedded and mobile targets | On-prem distributed Java clusters, commodity GPU fine-tuning, local inference on a laptop, a Raspberry Pi, or an Android device. Pure JVM at every step with training included |

- **llama.cpp** is the fundamental software! The lightweight, C++-based inference engine that runs quantized LLMs directly on CPUs and GPUs, making it ideal for resource-constrained production servers. You definitely don't need to be a coding wizard to try it; you can just download it, type a single command to start a chat, or hook it into your own programming projects if you're building the next awesome application.

- The next two **Ollama** and **LocalAI** covers the portable and API-gateway shapes: “runs anywhere,” “runs in five minutes,” and “one OpenAI-compatible endpoint in front of any back-end.”

- **vLLM** covers maximum GPU throughput using PagedAttention. 

- **JLama** is the first Java native engine for self-contained LLM applications, it moves away from the traditional client-server model with an external services and embeds the model directly in your application, simplifying deployment and aligning the model's lifecycle with your application.

- **Juno** is the only full-stack option to embed LLM onto java runtime. Fine-tuning and inference on CPU and GPU, from Raspberry Pi to cluster, using entirely java processes.

## Conclusions

Local inference is the only architecture that gives you full control over your data: no packet leaves your network, no foreign jurisdiction applies, and no vendor's policy change can revoke access to your own models. Sending data to a SaaS API is not a security risk because of weak encryption, it is a risk because you are accepting someone else's corporate policies, retention rules, and legal jurisdiction the moment you send the first token.

Fine-tuning is no longer a cloud billing line item. With LoRA on a GPU with JVM-native engine that runs the same pipeline on-prem. Updating model behavior has the economics of a CI job and fits the same deployment pipeline your team already operates.

The three-steps of ML data management: weights, context, retrieval is not a framework someone invented. It falls directly out of the training/inference split: build steps are for durable behavior, runtime is for runtime data, and anything that changes faster than your release cadence belongs in a database, not in the weights.

**Further reading:**

- Hu, E. J. et al. (2021). [LoRA: Low-Rank Adaptation of Large Language Models](https://arxiv.org/abs/2106.09685). *ICLR 2022* — the paper behind the weights rung of the ladder. Core idea: freeze the base model entirely; learn two small low-rank matrices whose product approximates the full weight update. Because the adapter matrices are tiny relative to the base model, training is fast, cheap, and GPU-light — and multiple adapters can be hot-swapped over the same base checkpoint at inference time without reloading the model.
- Lewis, P. et al. (2020). [Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks](https://arxiv.org/abs/2005.11401). *NeurIPS 2020* — the paper that named and formalised the third rung. Core idea: instead of encoding all facts into model weights at training time, retrieve relevant documents at request time and condition the generator on them. Separates "what the model knows how to do" (weights) from "what facts it has access to" (retrieval index) — making the knowledge component updatable without ever touching the weights.
- Kwon, W. et al. (2023). [Efficient Memory Management for Large Language Model Serving with PagedAttention](https://arxiv.org/abs/2309.06180). *SOSP 2023* — the paper behind vLLM's throughput advantage in the engine table above. Core idea: manage the KV cache (the memory holding previously computed attention keys and values across a request) using OS-style virtual memory paging — allocating it in non-contiguous blocks rather than pre-reserving a fixed contiguous buffer per sequence. Eliminates most KV cache memory fragmentation and enables continuous batching across variable-length concurrent requests.

---


[← Chapter 5: Neural Networks as Layers of Math: Matrices You Already Met in Graphics and Games](#ch-05) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 7: What Is a Language Model? Tokens, Context Windows, and Why Chat Bots Feel Magical →](#ch-07)