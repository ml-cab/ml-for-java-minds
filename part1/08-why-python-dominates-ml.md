(ch-08)=
# 8. Why Python Dominates ML. And Why That Shouldn't Trap Your Java Stack
Python became ML's default language for reasons that are historical and pragmatic, not technical superiority for every task:

- **Research velocity.** Notebooks (Jupyter) let researchers iterate on ideas interactively, without a build step.
- **NumPy and friends came first.** A mature numerical computing ecosystem (NumPy, then PyTorch/TensorFlow) accumulated a decade-plus head start and network effects, because papers publish code in Python, so the next paper's code is also in Python.
- **The GIL doesn't matter as much as you'd think for training**, because the actual heavy lifting (matrix multiplication) happens inside C++/CUDA kernels that Python merely orchestrates. Python is the glue, not the engine.

None of this means your production Java service needs a Python subprocess bolted onto it. That's a common but avoidable architectural compromise: spinning up a Flask microservice just to call a model, adding a network hop, a second deployment pipeline, a second dependency-management story, and a second set of on-call runbooks for a team that otherwise lives entirely in the JVM.

Two escape hatches exist today:

1. **Talk to a model server over a standard wire protocol.** Your Java code just becomes an HTTP client, with no Python dependency in your own deployment at all, because the model server is a separate, independently-operated process. Several genuinely different engines all converge on the same OpenAI-compatible `POST /v1/chat/completions` contract, which is worth knowing since they make very different trade-offs underneath it:
   - **llama.cpp**'s server mode (`llama-server`) and **Ollama** (which wraps llama.cpp with model management ergonomics): a single C++ process, no Python at all in the serving path.
   - **vLLM**: a Python, GPU-first engine (`vllm serve MODEL`) built specifically to maximize throughput at scale rather than run comfortably on a laptop; it's also where PagedAttention, cited in [Chapter 28](#ch-28), originated ([vLLM OpenAI-Compatible Server](../rtfms.md#ref-vllm-openai-api)).
   - **Hugging Face's Text Generation Inference (TGI)**: an unusual split architecture, a Rust HTTP router handling batching and scheduling, talking over gRPC to a separate Python process that actually runs the model, OpenAI-compatible since its "Messages API" ([TGI Messages API](../rtfms.md#ref-tgi-openai-api)).
   - **LocalAI**: a Go binary explicitly built around drop-in OpenAI (and Anthropic) API compatibility, with model backends installed on demand as separate processes over gRPC rather than compiled into one binary ([LocalAI Overview](../rtfms.md#ref-localai-openai-api)).

   Every one of these is a different language, a different process architecture, and a different set of trade-offs, yet from your Java client's perspective they're indistinguishable: same JSON contract, same `base_url` swap, [Chapter 17](#ch-17) covers this in depth.
2. **Run inference inside the JVM itself, with no subprocess at all.** It's exactly what a project like **Juno** (`cab.ml`) is built for: it reads GGUF model files directly and runs the full transformer forward pass in pure Java, using `java.lang.foreign` (Panama FFI) to talk to CUDA/ROCm directly for GPU acceleration: no JNI wrapper library, no Python, no separate process to keep alive.

```java
try (JunoPlayer player = JunoPlayer.builder(Path.of("/models/model.gguf"))
        .nodeCount(1).useGpu(true).build()) {
    var result = player.chat(List.of(ChatMessage.user("Summarize this ticket.")));
    System.out.println(result.text());
}
```

*(the `JunoPlayer` builder and `.chat()` facade shown above, [Juno Documentation §1.3](../rtfms.md#ref-juno-jvm-embedding))*

The takeaway isn't "Python bad, Java good": it's that **the language the model was trained in has nothing to do with the language that must serve it.** A GGUF file is a portable, language-agnostic weights format. Pick the serving path (subprocess-via-HTTP, or in-process-via-JVM) based on your operational constraints, not habit.

---

[← Chapter 7: What Is a Language Model? Tokens, Context Windows, and Why Chat Bots Feel Magical](#ch-07) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 9: Vectors and Similarity, Not Just Embeddings: Cosine, Dot Product, and Why "Closeness" Works →](#ch-09)
