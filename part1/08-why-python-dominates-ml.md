(ch-08)=
# 8. Why Python Dominates ML. And Why That Shouldn't Trap Your Java Stack
Python became ML's default language for reasons that are historical and pragmatic, not technical superiority for every task:

- **Research velocity.** Notebooks (Jupyter) let researchers iterate on ideas interactively, without a build step.
- **NumPy and friends came first.** A mature numerical computing ecosystem (NumPy, then PyTorch/TensorFlow) accumulated a decade-plus head start and network effects, because papers publish code in Python, so the next paper's code is also in Python.
- **The GIL doesn't matter as much as you'd think for training**, because the actual heavy lifting (matrix multiplication) happens inside C++/CUDA kernels that Python merely orchestrates. Python is the glue, not the engine.

None of this means your production Java service needs a Python subprocess bolted onto it. That's a common but avoidable architectural compromise: spinning up a Flask microservice just to call a model, adding a network hop, a second deployment pipeline, a second dependency-management story, and a second set of on-call runbooks for a team that otherwise lives entirely in the JVM.

Two escape hatches exist today:

1. **Talk to a model server over a standard wire protocol.** Tools like **llama.cpp**'s server mode and **Ollama** expose an OpenAI-compatible REST API (`POST /v1/chat/completions`). Your Java code just becomes an HTTP client, with no Python dependency in your own deployment at all, because the model server is a separate, independently-operated process (often not even written in Python: llama.cpp is C++).
2. **Run inference inside the JVM itself, with no subprocess at all.** This is the harder but more integrated option, and it's exactly what a project like **Juno** (`cab.ml`) is built for: it reads GGUF model files directly and runs the full transformer forward pass in pure Java, using `java.lang.foreign` (Panama FFI) to talk to CUDA/ROCm directly for GPU acceleration: no JNI wrapper library, no Python, no separate process to keep alive. A Java service can embed a chat model the same way it embeds any other library dependency:

```java
try (JunoPlayer player = JunoPlayer.builder(Path.of("/models/model.gguf"))
        .nodeCount(1).useGpu(true).build()) {
    var result = player.chat(List.of(ChatMessage.user("Summarize this ticket.")));
    System.out.println(result.text());
}
```

The takeaway isn't "Python bad, Java good": it's that **the language the model was trained in has nothing to do with the language that must serve it.** A GGUF file is a portable, language-agnostic weights format. Pick the serving path (subprocess-via-HTTP, or in-process-via-JVM) based on your operational constraints, not habit.

---

[← Chapter 7: What Is a Language Model? Tokens, Context Windows, and Why Chat Bots Feel Magical](#ch-07) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 9: Vectors and Similarity, Not Just Embeddings: Cosine, Dot Product, and Why "Closeness" Works →](#ch-09)
