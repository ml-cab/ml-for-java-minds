(references)=
# References

Sources for the general machine learning, LLM, and distributed-systems material in this book — everything in Parts I–V that is *not* specific to a particular inference tool's implementation details (those sources, for Juno, llama.cpp, and LocalAI, are listed separately in [rtfms.md](rtfms.md), short for "Read The F\*\*\*ing ManualS," this book's running joke about actually reading the docs before citing them). Entries here are grouped by the chapter they support, with the original publication venue and, where one exists, the arXiv identifier so you can pull the full text directly. Every entry was verified against its original source (arXiv abstract page, ACM/USENIX/IEEE publisher page, or the official EUR-Lex text) before being added here.

## Part I — Beginner

(ref-unreasonable-data)=
### Halevy, Norvig & Pereira (2009) — The Unreasonable Effectiveness of Data

Halevy, A., Norvig, P., & Pereira, F. (2009). The Unreasonable Effectiveness of Data. *IEEE Intelligent Systems*, 24(2), 8–12. https://doi.org/10.1109/MIS.2009.36

*The argument that, at sufficient scale, simple models trained on large amounts of (even noisy) data tend to outperform cleverer hand-crafted theories — cited in [Chapter 3](part1/03-data-features-labels.md) as the research framing behind why data quality and volume dominate classic ML work.*

(ref-gan)=
### Goodfellow et al. (2014) — Generative Adversarial Networks

Goodfellow, I. J., Pouget-Abadie, J., Mirza, M., Xu, B., Warde-Farley, D., Ozair, S., Courville, A., & Bengio, Y. (2014). Generative Adversarial Networks. *NeurIPS 2014*. arXiv:1406.2661. https://arxiv.org/abs/1406.2661

*The paper that framed generative modeling as learning to sample from the training data's distribution via an adversarial generator/discriminator game — cited in [Chapter 4](part1/04-supervised-unsupervised-generative.md) as a landmark in making "learn the distribution, then sample" a mainstream technique.*

(ref-backprop)=
### Rumelhart, Hinton & Williams (1986)

Rumelhart, D. E., Hinton, G. E., & Williams, R. J. (1986). Learning representations by back-propagating errors. *Nature*, 323(6088), 533–536. https://doi.org/10.1038/323533a0

*The original backpropagation paper — the algorithm behind "how does the network learn" in [Chapter 5](part1/05-neural-networks-as-layers-of-math.md).*

(ref-attention)=
### Vaswani et al. (2017) — "Attention Is All You Need"

Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention Is All You Need. *NeurIPS 2017*. arXiv:1706.03762. https://arxiv.org/abs/1706.03762

*The Transformer architecture underlying every modern LLM discussed in [Chapter 7](part1/07-what-is-a-language-model.md) onward.*

(ref-bpe)=
### Sennrich, Haddow & Birch (2016) — Byte-Pair Encoding

Sennrich, R., Haddow, B., & Birch, A. (2016). Neural Machine Translation of Rare Words with Subword Units. *ACL 2016*, 1715–1725. arXiv:1508.07909. https://arxiv.org/abs/1508.07909

*The BPE tokenization scheme referenced when explaining tokens in [Chapter 7](part1/07-what-is-a-language-model.md).*

(ref-word2vec)=
### Mikolov et al. (2013) — word2vec

Mikolov, T., Chen, K., Corrado, G., & Dean, J. (2013). Efficient Estimation of Word Representations in Vector Space. arXiv:1301.3781. https://arxiv.org/abs/1301.3781

*The paper establishing that training on context produces geometrically meaningful embeddings — the core idea behind [Chapter 9](part1/09-vectors-and-similarity.md) and [Chapter 10](part2/10-embeddings-101.md).*

## Part II — Intermediate

(ref-hnsw)=
### Malkov & Yashunin (2018) — HNSW

Malkov, Y. A., & Yashunin, D. A. (2018). Efficient and Robust Approximate Nearest Neighbor Search Using Hierarchical Navigable Small World Graphs. *IEEE Transactions on Pattern Analysis and Machine Intelligence*, 42(4), 824–836. arXiv:1603.09320. https://arxiv.org/abs/1603.09320

*The HNSW algorithm covered as the "B-tree of vector search" in [Chapter 11](part2/11-vector-databases-ann-indexes.md).*

(ref-nucleus)=
### Holtzman et al. (2020) — Nucleus Sampling

Holtzman, A., Buys, J., Du, L., Forbes, M., & Choi, Y. (2020). The Curious Case of Neural Text Degeneration. *ICLR 2020*. arXiv:1904.09751. https://arxiv.org/abs/1904.09751

*Introduces nucleus (top-p) sampling and explains why greedy/beam decoding degenerates — the basis for [Chapter 14](part2/14-temperature-top-p-top-k.md).*

(ref-toolformer)=
### Schick et al. (2023) — Toolformer

Schick, T., Dwivedi-Yu, J., Dessì, R., Raileanu, R., Lomeli, M., Zettlemoyer, L., Cancedda, N., & Scialom, T. (2023). Toolformer: Language Models Can Teach Themselves to Use Tools. *NeurIPS 2023*. arXiv:2302.04761. https://arxiv.org/abs/2302.04761

*One of two foundational papers (with ReAct, below) on how LLMs decide to invoke external tools/APIs — the research background behind [Chapter 15](part2/15-function-calling-tool-use.md).*

(ref-react)=
### Yao et al. (2023) — ReAct

Yao, S., Zhao, J., Yu, D., Du, N., Shafran, I., Narasimhan, K., & Cao, Y. (2023). ReAct: Synergizing Reasoning and Acting in Language Models. *ICLR 2023*. arXiv:2210.03629. https://arxiv.org/abs/2210.03629

*Interleaves reasoning traces with tool/action calls — relevant background for [Chapter 15](part2/15-function-calling-tool-use.md).*

(ref-gptq)=
### Frantar et al. (2022) — GPTQ

Frantar, E., Ashkboos, S., Hoefler, T., & Alistarh, D. (2022). GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers. arXiv:2210.17323. https://arxiv.org/abs/2210.17323

*A widely-used post-training quantization method; grounds the general discussion of trading precision for memory footprint in [Chapter 16](part2/16-gguf-and-quantization.md) (GGUF's own k-quant schemes are a distinct, related approach, documented in the llama.cpp/GGUF project rather than a single paper).*

(ref-rag)=
### Lewis et al. (2020) — Retrieval-Augmented Generation

Lewis, P., Perez, E., Piktus, A., Petroni, F., Karpukhin, V., Goyal, N., Küttler, H., Lewis, M., Yih, W., Rocktäschel, T., Riedel, S., & Kiela, D. (2020). Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. *NeurIPS 2020*. arXiv:2005.11401. https://arxiv.org/abs/2005.11401

*The paper that coined "RAG" and established the retrieve-then-generate pattern — first cited in [Chapter 6](part1/06-training-vs-inference.md) as the third rung of the weights/context/retrieval ladder, and the basis for [Chapter 18](part2/18-rag-for-java-teams.md) in full.*

(ref-promptinjection)=
### Greshake et al. (2023) — Indirect Prompt Injection

Greshake, K., Abdelnabi, S., Mishra, S., Endres, C., Holz, T., & Fritz, M. (2023). Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection. *Proceedings of the 16th ACM Workshop on Artificial Intelligence and Security (AISec '23)*, 79–90. arXiv:2302.12173. https://arxiv.org/abs/2302.12173

*The paper that named and formalized indirect prompt injection as a distinct vulnerability class — the "SQL injection of the LLM era" framing used in [Chapter 19](part2/19-prompt-injection.md).*

(ref-hallucination)=
### Ji et al. (2023) — Survey of Hallucination in NLG

Ji, Z., Lee, N., Frieske, R., Yu, T., Su, D., Xu, Y., Ishii, E., Bang, Y. J., Madotto, A., & Fung, P. (2023). Survey of Hallucination in Natural Language Generation. *ACM Computing Surveys*, 55(12), Article 248. https://doi.org/10.1145/3571730 · arXiv:2202.03629. https://arxiv.org/abs/2202.03629

*A comprehensive survey of what hallucination is, how it's measured, and why it's a structural property rather than a bug — the basis for [Chapter 20](part2/20-safety-and-guardrails.md).*

(ref-llmjudge)=
### Zheng et al. (2023) — LLM-as-Judge

Zheng, L., Chiang, W.-L., Sheng, Y., Zhuang, S., Wu, Z., Zhuang, Y., Lin, Z., Li, Z., Li, D., Xing, E. P., Zhang, H., Gonzalez, J. E., & Stoica, I. (2023). Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena. *NeurIPS 2023*. arXiv:2306.05685. https://arxiv.org/abs/2306.05685

*Establishes and validates the "LLM-as-judge" evaluation technique discussed in [Chapter 21](part2/21-evaluating-llm-output.md), including its known biases.*

## Part III — Advanced

(ref-lora)=
### Hu et al. (2021) — LoRA

Hu, E. J., Shen, Y., Wallis, P., Allen-Zhu, Z., Li, Y., Wang, S., Wang, L., & Chen, W. (2021). LoRA: Low-Rank Adaptation of Large Language Models. arXiv:2106.09685. https://arxiv.org/abs/2106.09685

*The LoRA paper — freezing the base weights and learning low-rank adapter matrices — first cited in [Chapter 6](part1/06-training-vs-inference.md) when explaining that fine-tuning on commodity hardware is now practical, and underlying [Chapter 24](part3/24-lora-explained.md) and [Chapter 25](part3/25-merge-adapters-into-gguf.md) in full (specific inference-tool implementations, Juno, llama.cpp, and LocalAI, are documented in [rtfms.md](rtfms.md)).*

(ref-pagedattention)=
### Kwon et al. (2023) — PagedAttention / vLLM

Kwon, W., Li, Z., Zhuang, S., Sheng, Y., Zheng, L., Yu, C. H., Gonzalez, J. E., Zhang, H., & Stoica, I. (2023). Efficient Memory Management for Large Language Model Serving with PagedAttention. *SOSP 2023*. arXiv:2309.06180. https://arxiv.org/abs/2309.06180

*The paging-inspired approach to KV cache memory management — first cited in [Chapter 6](part1/06-training-vs-inference.md) as the key technique distinguishing vLLM in the on-premise engine table, and covered in depth in [Chapter 28](part3/28-memory-kv-cache-session-affinity.md).*

(ref-orca)=
### Yu et al. (2022) — Orca

Yu, G.-I., Jeong, J. S., Kim, G.-W., Kim, S., & Chun, B.-G. (2022). Orca: A Distributed Serving System for Transformer-Based Generative Models. *16th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2022)*. https://www.usenix.org/conference/osdi22/presentation/yu

*Introduces iteration-level scheduling and selective batching — the paper that effectively defines "continuous batching," the subject of [Chapter 29](part3/29-continuous-batching.md).*

## Part IV — Professional

(ref-megatron)=
### Shoeybi et al. (2019) — Megatron-LM

Shoeybi, M., Patwary, M., Puri, R., LeGresley, P., Casper, J., & Catanzaro, B. (2019). Megatron-LM: Training Multi-Billion Parameter Language Models Using Model Parallelism. arXiv:1909.08053. https://arxiv.org/abs/1909.08053

*Intra-layer (tensor) model parallelism for transformers at scale — the source for the tensor-parallelism half of [Chapter 30](part4/30-pipeline-vs-tensor-parallelism.md)'s comparison.*

(ref-euaiact)=
### EU Artificial Intelligence Act (2024)

European Parliament and Council of the European Union. (2024). Regulation (EU) 2024/1689 laying down harmonised rules on artificial intelligence (Artificial Intelligence Act). *Official Journal of the European Union*. https://eur-lex.europa.eu/eli/reg/2024/1689/oj

*The primary legal text behind the risk-tier framework (prohibited / high-risk / limited-risk / minimal-risk) and the Article 50 transparency obligation discussed in [Chapter 34](part4/34-compliance-for-generative-apps.md).*

## Part V — Beyond LLMs

(ref-random-forests)=
### Breiman (2001) — Random Forests

Breiman, L. (2001). Random Forests. *Machine Learning*, 45(1), 5–32. https://doi.org/10.1023/A:1010933404324

*The ensemble-of-trees algorithm covered in [Chapter 35](part5/35-classical-ml-regression-trees-ensembles.md).*

(ref-xgboost)=
### Chen & Guestrin (2016) — XGBoost

Chen, T., & Guestrin, C. (2016). XGBoost: A Scalable Tree Boosting System. *KDD 2016*, 785–794. arXiv:1603.02754. https://arxiv.org/abs/1603.02754

*The gradient-boosted tree system discussed alongside random forests in [Chapter 35](part5/35-classical-ml-regression-trees-ensembles.md).*

(ref-adam)=
### Kingma & Ba (2015) — Adam

Kingma, D. P., & Ba, J. (2015). Adam: A Method for Stochastic Optimization. *ICLR 2015*. arXiv:1412.6980. https://arxiv.org/abs/1412.6980

*The adaptive optimizer behind the vast majority of modern training runs, including the LoRA loop in [Chapter 24](part3/24-lora-explained.md) — covered directly in [Chapter 36](part5/36-loss-functions-gradient-descent-bias-variance.md).*

(ref-dropout)=
### Srivastava et al. (2014) — Dropout

Srivastava, N., Hinton, G., Krizhevsky, A., Sutskever, I., & Salakhutdinov, R. (2014). Dropout: A Simple Way to Prevent Neural Networks from Overfitting. *Journal of Machine Learning Research*, 15(1), 1929–1958. https://jmlr.org/papers/v15/srivastava14a.html

*The regularization technique discussed as a defense against overfitting in [Chapter 36](part5/36-loss-functions-gradient-descent-bias-variance.md).*

(ref-roc)=
### Fawcett (2006) — ROC Analysis

Fawcett, T. (2006). An Introduction to ROC Analysis. *Pattern Recognition Letters*, 27(8), 861–874. https://doi.org/10.1016/j.patrec.2005.10.010

*The threshold-independent evaluation technique covered in [Chapter 37](part5/37-evaluating-classical-models.md).*

(ref-resnet)=
### He et al. (2016) — Deep Residual Learning (ResNet)

He, K., Zhang, X., Ren, S., & Sun, J. (2016). Deep Residual Learning for Image Recognition. *CVPR 2016*, 770–778. arXiv:1512.03385. https://arxiv.org/abs/1512.03385

*Residual connections, which made very deep CNNs trainable — covered in [Chapter 39](part5/39-computer-vision-cnns-diffusion.md).*

(ref-ddpm)=
### Ho, Jain & Abbeel (2020) — Denoising Diffusion Probabilistic Models

Ho, J., Jain, A., & Abbeel, P. (2020). Denoising Diffusion Probabilistic Models. *NeurIPS 2020*. arXiv:2006.11239. https://arxiv.org/abs/2006.11239

*The iterative-denoising technique behind modern image generation, discussed in [Chapter 39](part5/39-computer-vision-cnns-diffusion.md).*

(ref-lstm)=
### Hochreiter & Schmidhuber (1997) — Long Short-Term Memory

Hochreiter, S., & Schmidhuber, J. (1997). Long Short-Term Memory. *Neural Computation*, 9(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735

*The gated recurrent architecture that partially fixed vanishing gradients before Transformers replaced recurrence outright — the historical anchor for [Chapter 40](part5/40-rnns-to-transformers.md).*

(ref-rlhf)=
### Christiano et al. (2017) — Deep RL from Human Preferences

Christiano, P. F., Leike, J., Brown, T., Martic, M., Legg, S., & Amodei, D. (2017). Deep Reinforcement Learning from Human Preferences. *NeurIPS 2017*. arXiv:1706.03741. https://arxiv.org/abs/1706.03741

*Formalizes learning a reward model from human preference rankings rather than a hand-written reward function — the technique underlying RLHF, covered in [Chapter 41](part5/41-reinforcement-learning-and-rlhf.md).*

(ref-instructgpt)=
### Ouyang et al. (2022) — InstructGPT

Ouyang, L., Wu, J., Jiang, X., Almeida, D., Wainwright, C. L., Mishkin, P., Zhang, C., Agarwal, S., Slama, K., Ray, A., Schulman, J., Hilton, J., Kelton, F., Miller, L., Simens, M., Askell, A., Welinder, P., Christiano, P., Leike, J., & Lowe, R. (2022). Training Language Models to Follow Instructions with Human Feedback. *NeurIPS 2022*. arXiv:2203.02155. https://arxiv.org/abs/2203.02155

*Applies RLHF at scale to produce an instruction-following chat model — the direct ancestor of ChatGPT's training recipe, discussed in [Chapter 41](part5/41-reinforcement-learning-and-rlhf.md).*

(ref-hidden-debt)=
### Sculley et al. (2015) — Hidden Technical Debt in Machine Learning Systems

Sculley, D., Holt, G., Golovin, D., Davydov, E., Phillips, T., Ebner, D., Chaudhary, V., Young, M., Crespo, J.-F., & Dennison, D. (2015). Hidden Technical Debt in Machine Learning Systems. *NeurIPS 2015*, 2503–2511. https://proceedings.neurips.cc/paper/2015/hash/86df7dcfd896fcaf2674f757a2463eba-Abstract.html

*The foundational argument that ML-specific glue code, not the modeling code itself, is where most production ML technical debt accumulates — the framing behind [Chapter 42](part5/42-mlops-for-classical-ml.md).*

(ref-clip)=
### Radford et al. (2021) — CLIP

Radford, A., Kim, J. W., Hallacy, C., Ramesh, A., Goh, G., Agarwal, S., Sastry, G., Askell, A., Mishkin, P., Clark, J., Krueger, G., & Sutskever, I. (2021). Learning Transferable Visual Models From Natural Language Supervision. *ICML 2021*, 8748–8763. arXiv:2103.00020. https://arxiv.org/abs/2103.00020

*Joint image/text embedding training, the bridge technique behind vision-language models and text-to-image generation, discussed in [Chapter 43](part5/43-agents-and-multimodality.md).*

(ref-scaling-laws)=
### Kaplan et al. (2020) — Scaling Laws for Neural Language Models

Kaplan, J., McCandlish, S., Henighan, T., Brown, T. B., Chess, B., Child, R., Gray, S., Radford, A., Wu, J., & Amodei, D. (2020). Scaling Laws for Neural Language Models. arXiv:2001.08361. https://arxiv.org/abs/2001.08361

*The empirical power-law relationship between loss, model size, data size, and compute — the basis for [Chapter 44](part5/44-pretraining-at-scale.md).*

## General / cross-cutting

(ref-openai-api)=
### OpenAI Chat Completions API reference

OpenAI. Chat Completions API reference. https://platform.openai.com/docs/api-reference/chat

*The de facto wire-format standard discussed in [Chapter 17](part2/17-openai-compatible-apis.md), implemented independently by llama.cpp, Ollama, and Juno.*

(ref-otel)=
### OpenTelemetry documentation

OpenTelemetry Authors. OpenTelemetry documentation. https://opentelemetry.io/docs/

*The distributed-tracing standard referenced in [Chapter 32](part4/32-observability-for-llm-apps.md)'s observability discussion.*

---

## A note on how this list was built

Every entry above was verified by web search against its original source (arXiv abstract page, ACM/USENIX/IEEE publisher page, or the official EUR-Lex text) rather than pulled from memory, specifically to avoid citing a paper with the wrong year, venue, or author list. Where a chapter's content is general engineering practice rather than a single traceable result — for example, the if/else-vs-model heuristics in Chapter 2, or the health-dashboard and versioning patterns in Chapters 31 and 33 — no citation is given, because the material reflects standard software engineering practice rather than a specific research claim. Chapter 6's training/inference analogy is similarly general practice, but it now does cite LoRA, RAG, and PagedAttention where those specific techniques are named. Citing a paper for content it doesn't actually support would be a worse outcome than citing nothing. Documentation for the specific inference tools mentioned throughout the book (Juno, llama.cpp, LocalAI) lives in [rtfms.md](rtfms.md), verified the same way, against each project's live docs.

---

[Table of Contents](index.md)