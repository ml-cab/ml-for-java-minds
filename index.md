# ML for Java Minds

*A practical field guide to machine learning and LLMs, written for people who think in classes, interfaces, and compile errors.*

```{image} ml-4-java-minds.jpg
:alt: ML for Java Minds cover
:width: 800px
:align: center
```

---

**How to read this book**

You don't need a PhD, and you don't need to learn Python first. Every chapter builds on the last one, but each is also short enough to read on a coffee break. Code and command examples lean on tools you can run today: **llama.cpp**, **Ollama**, and **Juno**. Where a Java analogy helps, we use it. Where a diagram helps more than a paragraph, we draw one as a Mermaid diagram so it renders visually in any editor or viewer that supports it.

Five parts, forty-four chapters:

- **Beginner**: ML literacy for Java minds (1-9)
- **Intermediate**: LLMs and practical paths (10-21)
- **Advanced**: Fine-tuning, performance, ops (22-29)
- **Professional**: Distributed systems & production ML on the JVM (30-34)
- **Beyond LLMs**: Classical ML, vision, and the rest of the field (35-44)

A scoping note on that last part, and on the book as a whole: Parts I-IV are deliberately focused on **LLM engineering for Java developers**, not general machine learning. Part V exists to fill in the classical-ML, computer-vision, and training-theory material that a text-focused book like this one would otherwise skip entirely, so readers get an honest map of what "machine learning" covers beyond language models.

---

## Table of Contents

**Part I. Beginner: ML Literacy for Java Minds**

- **1.** [Machine Learning Without the Mystery: A Developer's Mental Model](#ch-01)
- **2.** [From if/else Rules to Learned Behavior: When Models Replace Hard-Coded Logic](#ch-02)
- **3.** [Data, Features, Labels: How a Dataset Looks If You Think in POJOs](#ch-03)
- **4.** [Supervised, Unsupervised, and Generative AI. Explained Like Design Patterns](#ch-04)
- **5.** [Neural Networks as Layers of Math: Matrices You Already Met in Graphics and Games](#ch-05)
- **6.** [Training vs Inference: Compile-Time Thinking vs Runtime Serving](#ch-06)
- **7.** [What Is a Language Model? Tokens, Context Windows, and Why Chat Bots Feel Magical](#ch-07)
- **8.** [Same Matrix Multiply, Different Hardware: A Tour of JVM Inference Engines](#ch-08)
- **9.** [Vectors and Similarity, Not Just Embeddings: Cosine, Dot Product, and Why "Closeness" Works](#ch-09)

**Part II. Intermediate: LLMs and Practical Paths**

- **10.** [Embeddings 101: Turning Text into Vectors Your Services Can Search](#ch-10)
- **11.** [Vector Databases and ANN Indexes: HNSW for People Who Think in B-Trees](#ch-11)
- **12.** [Prompt Engineering for Engineers: Specs, Contracts, and Failure Modes](#ch-12)
- **13.** [Structured Output: JSON Schema, Constrained Decoding, and Why "Just Ask Nicely" Fails](#ch-13)
- **14.** [Temperature, Top-P, Top-K: Sampling Knobs That Change Model Personality](#ch-14)
- **15.** [Function Calling and Tool Use: Letting the Model Call Your Java Methods](#ch-15)
- **16.** [GGUF and Quantization: How Big Models Fit on Ordinary Hardware](#ch-16)
- **17.** [OpenAI-Compatible APIs: One Client Interface, Many Backends](#ch-17)
- **18.** [RAG for Java Teams: Retrieve Documents, Then Ask the Model](#ch-18)
- **19.** [Prompt Injection: The SQL Injection of the LLM Era](#ch-19)
- **20.** [Safety and Guardrails: Hallucinations, PII, and What Your App Must Own](#ch-20)
- **21.** [Evaluating LLM Output: Why Unit Tests Don't Work and What Replaces Them](#ch-21)

**Part III. Advanced: Fine-Tuning, Performance, Ops**

- **22.** [Fine-Tuning vs Prompting vs RAG: Choosing the Right Lever](#ch-22)
- **23.** [Preparing a Fine-Tuning Dataset: From Logs and Tickets to Training Pairs](#ch-23)
- **24.** [LoRA Explained: Small Adapters That Specialize a Big Model](#ch-24)
- **25.** [Merge Adapters into GGUF: Shipping One Artifact, No Sidecar Weights](#ch-25)
- **26.** [CPU vs GPU Inference: When CUDA/ROCm Matter and When Quantized CPU Wins](#ch-26)
- **27.** [Profiling LLM Workloads with JFR: Matmul, Forward Pass, and Tokens/sec](#ch-27)
- **28.** [Memory, KV Cache, and Session Affinity: Why Chat Feels Faster the Second Time](#ch-28)
- **29.** [Continuous Batching: Serving Many Users Without Serving Them One at a Time](#ch-29)

**Part IV. Professional: Distributed Systems & Production ML on the JVM**

- **30.** [Pipeline vs Tensor Parallelism: Splitting Transformers Across Machines](#ch-30)
- **31.** [Production Serving Patterns: Health Dashboards, Priorities, and Multi-Tenant Chat APIs](#ch-31)
- **32.** [Observability for LLM Apps: Tracing Tokens, Costs, and Latency Like Any Other Distributed Call](#ch-32)
- **33.** [Model and Prompt Versioning: Rollout, Rollback, and A/B Testing for Non-Deterministic Systems](#ch-33)
- **34.** [Compliance for Generative Apps: Licenses, Merged Weights, and EU AI Act Reality Checks](#ch-34)

**Part V. Beyond LLMs: Classical ML, Vision, and the Rest of the Field**

- **35.** [Classical ML: Regression, Trees, and Ensembles Before You Ever Touch a Transformer](#ch-35)
- **36.** [Loss Functions, Gradient Descent, and the Bias-Variance Trade-off](#ch-36)
- **37.** [Evaluating Classical Models: Precision, Recall, ROC-AUC, and Confusion Matrices](#ch-37)
- **38.** [Feature Engineering: Encoding, Scaling, and Missing Data](#ch-38)
- **39.** [Computer Vision: CNNs, Detection, Segmentation, and Diffusion Models](#ch-39)
- **40.** [From RNNs to Transformers: Why Attention Won](#ch-40)
- **41.** [Reinforcement Learning and RLHF: How Chat Models Learn to Be Helpful](#ch-41)
- **42.** [MLOps for Classical ML: Feature Stores, Experiment Tracking, and Data Versioning](#ch-42)
- **43.** [Agents and Multimodality: Planning, Memory, and Vision-Language Models](#ch-43)
- **44.** [Pretraining at Scale: Data, Tokenizers, and Scaling Laws](#ch-44)

**Back matter**

- [References](references.md) - the peer-reviewed and official sources behind the book's general ML/LLM/distributed-systems claims
- [rtfms.md](rtfms.md) - documentation for the specific inference tools mentioned throughout the book (Juno, llama.cpp, LocalAI), compared side by side on the same topics: quickstart, OpenAI-compatible APIs, LoRA training vs. inference-only adapter loading, merging, and observability
