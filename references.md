# References

Sources for the general machine learning, LLM, and distributed-systems material in *ML for Java Minds* — everything in Parts I–IV that is *not* specific to the Juno project (those sources are listed separately in `ref.md`). Entries are grouped by the chapter they support, with the original publication venue and, where one exists, the arXiv identifier so you can pull the full text directly.

## Part I — Beginner

**Chapter 5 — Neural Networks as Layers of Math**
- Rumelhart, D. E., Hinton, G. E., & Williams, R. J. (1986). Learning representations by back-propagating errors. *Nature*, 323(6088), 533–536. https://doi.org/10.1038/323533a0
  *The original backpropagation paper — the algorithm behind "how does the network learn" in this chapter.*

**Chapter 7 — What Is a Language Model?**
- Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention Is All You Need. *NeurIPS 2017*. arXiv:1706.03762. https://arxiv.org/abs/1706.03762
  *The Transformer architecture underlying every modern LLM discussed in the book.*
- Sennrich, R., Haddow, B., & Birch, A. (2016). Neural Machine Translation of Rare Words with Subword Units. *ACL 2016*, 1715–1725. arXiv:1508.07909. https://arxiv.org/abs/1508.07909
  *The Byte-Pair Encoding (BPE) tokenization scheme referenced when explaining tokens.*

**Chapter 9 — Vectors and Similarity**
- Mikolov, T., Chen, K., Corrado, G., & Dean, J. (2013). Efficient Estimation of Word Representations in Vector Space. arXiv:1301.3781. https://arxiv.org/abs/1301.3781
  *word2vec — the paper that established that training on context produces geometrically meaningful embeddings, the core idea behind Chapters 9–10.*

## Part II — Intermediate

**Chapter 11 — Vector Databases and ANN Indexes**
- Malkov, Y. A., & Yashunin, D. A. (2018). Efficient and Robust Approximate Nearest Neighbor Search Using Hierarchical Navigable Small World Graphs. *IEEE Transactions on Pattern Analysis and Machine Intelligence*, 42(4), 824–836. arXiv:1603.09320. https://arxiv.org/abs/1603.09320
  *The HNSW algorithm covered as the "B-tree of vector search."*

**Chapter 14 — Temperature, Top-P, Top-K**
- Holtzman, A., Buys, J., Du, L., Forbes, M., & Choi, Y. (2020). The Curious Case of Neural Text Degeneration. *ICLR 2020*. arXiv:1904.09751. https://arxiv.org/abs/1904.09751
  *Introduces nucleus (top-p) sampling and explains why greedy/beam decoding degenerates — the basis for the sampling-knobs discussion.*

**Chapter 15 — Function Calling and Tool Use**
- Schick, T., Dwivedi-Yu, J., Dessì, R., Raileanu, R., Lomeli, M., Zettlemoyer, L., Cancedda, N., & Scialom, T. (2023). Toolformer: Language Models Can Teach Themselves to Use Tools. *NeurIPS 2023*. arXiv:2302.04761. https://arxiv.org/abs/2302.04761
- Yao, S., Zhao, J., Yu, D., Du, N., Shafran, I., Narasimhan, K., & Cao, Y. (2023). ReAct: Synergizing Reasoning and Acting in Language Models. *ICLR 2023*. arXiv:2210.03629. https://arxiv.org/abs/2210.03629
  *Two foundational papers on how LLMs decide to invoke external tools/APIs, the research background behind function calling.*

**Chapter 16 — GGUF and Quantization**
- Frantar, E., Ashkboos, S., Hoefler, T., & Alistarh, D. (2022). GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers. arXiv:2210.17323. https://arxiv.org/abs/2210.17323
  *A widely-used post-training quantization method; grounds the general discussion of trading precision for memory footprint (GGUF's own k-quant schemes are a distinct, related approach, documented in the llama.cpp/GGUF project rather than a single paper).*

**Chapter 18 — RAG for Java Teams**
- Lewis, P., Perez, E., Piktus, A., Petroni, F., Karpukhin, V., Goyal, N., Küttler, H., Lewis, M., Yih, W., Rocktäschel, T., Riedel, S., & Kiela, D. (2020). Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. *NeurIPS 2020*. arXiv:2005.11401. https://arxiv.org/abs/2005.11401
  *The paper that coined "RAG" and established the retrieve-then-generate pattern this chapter is built around.*

**Chapter 19 — Prompt Injection**
- Greshake, K., Abdelnabi, S., Mishra, S., Endres, C., Holz, T., & Fritz, M. (2023). Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection. *Proceedings of the 16th ACM Workshop on Artificial Intelligence and Security (AISec '23)*, 79–90. arXiv:2302.12173. https://arxiv.org/abs/2302.12173
  *The paper that named and formalized indirect prompt injection as a distinct vulnerability class, the "SQL injection of the LLM era" framing used in this chapter.*

**Chapter 20 — Safety and Guardrails: Hallucinations**
- Ji, Z., Lee, N., Frieske, R., Yu, T., Su, D., Xu, Y., Ishii, E., Bang, Y. J., Madotto, A., & Fung, P. (2023). Survey of Hallucination in Natural Language Generation. *ACM Computing Surveys*, 55(12), Article 248. https://doi.org/10.1145/3571730 · arXiv:2202.03629. https://arxiv.org/abs/2202.03629
  *A comprehensive survey of what hallucination is, how it's measured, and why it's a structural property rather than a bug — the basis for the chapter's framing.*

**Chapter 21 — Evaluating LLM Output**
- Zheng, L., Chiang, W.-L., Sheng, Y., Zhuang, S., Wu, Z., Zhuang, Y., Lin, Z., Li, Z., Li, D., Xing, E. P., Zhang, H., Gonzalez, J. E., & Stoica, I. (2023). Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena. *NeurIPS 2023*. arXiv:2306.05685. https://arxiv.org/abs/2306.05685
  *Establishes and validates the "LLM-as-judge" evaluation technique discussed in this chapter, including its known biases.*

## Part III — Advanced

**Chapters 22–25 — Fine-Tuning, LoRA, and Merging**
- Hu, E. J., Shen, Y., Wallis, P., Allen-Zhu, Z., Li, Y., Wang, S., Wang, L., & Chen, W. (2021). LoRA: Low-Rank Adaptation of Large Language Models. arXiv:2106.09685. https://arxiv.org/abs/2106.09685
  *The LoRA paper — low-rank adapter matrices frozen-base fine-tuning, the technique underlying Chapters 24 and 25 in full (Juno's specific implementation details are documented in `ref.md`, not in this paper).*

**Chapters 26, 28–29 — Inference, KV Cache, Batching**
- Kwon, W., Li, Z., Zhuang, S., Sheng, Y., Zheng, L., Yu, C. H., Gonzalez, J. E., Zhang, H., & Stoica, I. (2023). Efficient Memory Management for Large Language Model Serving with PagedAttention. *SOSP 2023*. arXiv:2309.06180. https://arxiv.org/abs/2309.06180
  *PagedAttention/vLLM — the paging-inspired approach to KV cache memory management referenced in Chapter 28.*
- Yu, G.-I., Jeong, J. S., Kim, G.-W., Kim, S., & Chun, B.-G. (2022). Orca: A Distributed Serving System for Transformer-Based Generative Models. *16th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2022)*. https://www.usenix.org/conference/osdi22/presentation/yu
  *Introduces iteration-level scheduling and selective batching — the paper that effectively defines "continuous batching," the subject of Chapter 29.*

## Part IV — Professional

**Chapter 30 — Pipeline vs Tensor Parallelism**
- Shoeybi, M., Patwary, M., Puri, R., LeGresley, P., Casper, J., & Catanzaro, B. (2019). Megatron-LM: Training Multi-Billion Parameter Language Models Using Model Parallelism. arXiv:1909.08053. https://arxiv.org/abs/1909.08053
  *Intra-layer (tensor) model parallelism for transformers at scale — the source for the tensor-parallelism half of this chapter's comparison.*

**Chapter 34 — Compliance for Generative Apps**
- European Parliament and Council of the European Union. (2024). Regulation (EU) 2024/1689 laying down harmonised rules on artificial intelligence (Artificial Intelligence Act). *Official Journal of the European Union*. https://eur-lex.europa.eu/eli/reg/2024/1689/oj
  *The primary legal text behind the risk-tier framework (prohibited / high-risk / limited-risk / minimal-risk) and the Article 50 transparency obligation discussed in this chapter.*

## General / cross-cutting

- OpenAI. Chat Completions API reference. https://platform.openai.com/docs/api-reference/chat
  *The de facto wire-format standard discussed in Chapter 17, implemented independently by llama.cpp, Ollama, and Juno.*
- OpenTelemetry Authors. OpenTelemetry documentation. https://opentelemetry.io/docs/
  *The distributed-tracing standard referenced in Chapter 32's observability discussion.*

---

## A note on how this list was built

Every entry above was verified by web search against its original source (arXiv abstract page, ACM/USENIX/IEEE publisher page, or the official EUR-Lex text) rather than pulled from memory, specifically to avoid citing a paper with the wrong year, venue, or author list. Where a chapter's content is general engineering practice rather than a single traceable result — for example, the if/else-vs-model heuristics in Chapter 2, the training/inference build-vs-serve analogy in Chapter 6, or the health-dashboard and versioning patterns in Chapters 31 and 33 — no citation is given, because the material reflects standard software engineering practice rather than a specific research claim. Citing a paper for content it doesn't actually support would be a worse outcome than citing nothing.
