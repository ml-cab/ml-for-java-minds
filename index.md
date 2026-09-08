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

- **1.** [Machine Learning Without the Mystery: A Developer's Mental Model](part1/01-machine-learning-without-mystery.md)
- **2.** [From if/else Rules to Learned Behaviour: When Models Replace Hard-Coded Logic](part1/02-if-else-to-learned-behaviour.md)
- **3.** [Data, Features, Labels: How a Dataset Looks If You Think in POJOs](part1/03-data-features-labels.md)
- **4.** [Supervised, Unsupervised, and Generative AI. Explained Like Design Patterns](part1/04-supervised-unsupervised-generative.md)
- **5.** [Neural Networks as Layers of Math: Matrices You Already Met in Graphics and Games](part1/05-neural-networks-as-layers-of-math.md)
- **6.** [Training vs Inference: Compile-Time Thinking vs Runtime Serving](part1/06-training-vs-inference.md)
- **7.** [What Is a Language Model? Tokens, Context Windows, and Why Chat Bots Feel Magical](part1/07-what-is-a-language-model.md)
- **8.** [Why Python Dominates ML. And Why That Shouldn't Trap Your Java Stack](part1/08-why-python-dominates-ml.md)
- **9.** [Vectors and Similarity, Not Just Embeddings: Cosine, Dot Product, and Why "Closeness" Works](part1/09-vectors-and-similarity.md)

**Part II. Intermediate: LLMs and Practical Paths**

- **10.** [Embeddings 101: Turning Text into Vectors Your Services Can Search](part2/10-embeddings-101.md)
- **11.** [Vector Databases and ANN Indexes: HNSW for People Who Think in B-Trees](part2/11-vector-databases-ann-indexes.md)
- **12.** [Prompt Engineering for Engineers: Specs, Contracts, and Failure Modes](part2/12-prompt-engineering-for-engineers.md)
- **13.** [Structured Output: JSON Schema, Constrained Decoding, and Why "Just Ask Nicely" Fails](part2/13-structured-output.md)
- **14.** [Temperature, Top-P, Top-K: Sampling Knobs That Change Model Personality](part2/14-temperature-top-p-top-k.md)
- **15.** [Function Calling and Tool Use: Letting the Model Call Your Java Methods](part2/15-function-calling-tool-use.md)
- **16.** [GGUF and Quantization: How Big Models Fit on Ordinary Hardware](part2/16-gguf-and-quantization.md)
- **17.** [OpenAI-Compatible APIs: One Client Interface, Many Backends](part2/17-openai-compatible-apis.md)
- **18.** [RAG for Java Teams: Retrieve Documents, Then Ask the Model](part2/18-rag-for-java-teams.md)
- **19.** [Prompt Injection: The SQL Injection of the LLM Era](part2/19-prompt-injection.md)
- **20.** [Safety and Guardrails: Hallucinations, PII, and What Your App Must Own](part2/20-safety-and-guardrails.md)
- **21.** [Evaluating LLM Output: Why Unit Tests Don't Work and What Replaces Them](part2/21-evaluating-llm-output.md)

**Part III. Advanced: Fine-Tuning, Performance, Ops**

- **22.** [Fine-Tuning vs Prompting vs RAG: Choosing the Right Lever](part3/22-fine-tuning-vs-prompting-vs-rag.md)
- **23.** [Preparing a Fine-Tuning Dataset: From Logs and Tickets to Training Pairs](part3/23-preparing-a-fine-tuning-dataset.md)
- **24.** [LoRA Explained: Small Adapters That Specialize a Big Model](part3/24-lora-explained.md)
- **25.** [Merge Adapters into GGUF: Shipping One Artifact, No Sidecar Weights](part3/25-merge-adapters-into-gguf.md)
- **26.** [CPU vs GPU Inference: When CUDA/ROCm Matter and When Quantized CPU Wins](part3/26-cpu-vs-gpu-inference.md)
- **27.** [Profiling LLM Workloads with JFR: Matmul, Forward Pass, and Tokens/sec](part3/27-profiling-llm-workloads-with-jfr.md)
- **28.** [Memory, KV Cache, and Session Affinity: Why Chat Feels Faster the Second Time](part3/28-memory-kv-cache-session-affinity.md)
- **29.** [Continuous Batching: Serving Many Users Without Serving Them One at a Time](part3/29-continuous-batching.md)

**Part IV. Professional: Distributed Systems & Production ML on the JVM**

- **30.** [Pipeline vs Tensor Parallelism: Splitting Transformers Across Machines](part4/30-pipeline-vs-tensor-parallelism.md)
- **31.** [Production Serving Patterns: Health Dashboards, Priorities, and Multi-Tenant Chat APIs](part4/31-production-serving-patterns.md)
- **32.** [Observability for LLM Apps: Tracing Tokens, Costs, and Latency Like Any Other Distributed Call](part4/32-observability-for-llm-apps.md)
- **33.** [Model and Prompt Versioning: Rollout, Rollback, and A/B Testing for Non-Deterministic Systems](part4/33-model-and-prompt-versioning.md)
- **34.** [Compliance for Generative Apps: Licenses, Merged Weights, and EU AI Act Reality Checks](part4/34-compliance-for-generative-apps.md)

**Part V. Beyond LLMs: Classical ML, Vision, and the Rest of the Field**

- **35.** [Classical ML: Regression, Trees, and Ensembles Before You Ever Touch a Transformer](part5/35-classical-ml-regression-trees-ensembles.md)
- **36.** [Loss Functions, Gradient Descent, and the Bias-Variance Trade-off](part5/36-loss-functions-gradient-descent-bias-variance.md)
- **37.** [Evaluating Classical Models: Precision, Recall, ROC-AUC, and Confusion Matrices](part5/37-evaluating-classical-models.md)
- **38.** [Feature Engineering: Encoding, Scaling, and Missing Data](part5/38-feature-engineering.md)
- **39.** [Computer Vision: CNNs, Detection, Segmentation, and Diffusion Models](part5/39-computer-vision-cnns-diffusion.md)
- **40.** [From RNNs to Transformers: Why Attention Won](part5/40-rnns-to-transformers.md)
- **41.** [Reinforcement Learning and RLHF: How Chat Models Learn to Be Helpful](part5/41-reinforcement-learning-and-rlhf.md)
- **42.** [MLOps for Classical ML: Feature Stores, Experiment Tracking, and Data Versioning](part5/42-mlops-for-classical-ml.md)
- **43.** [Agents and Multimodality: Planning, Memory, and Vision-Language Models](part5/43-agents-and-multimodality.md)
- **44.** [Pretraining at Scale: Data, Tokenizers, and Scaling Laws](part5/44-pretraining-at-scale.md)

**Back matter**

- [References](references.md) - the peer-reviewed and official sources behind the book's general ML/LLM/distributed-systems claims
- [rtfms.md](rtfms.md) - documentation for the specific inference tools mentioned throughout the book (Juno, llama.cpp, LocalAI), compared side by side on the same topics: quickstart, OpenAI-compatible APIs, LoRA training vs. inference-only adapter loading, merging, and observability
