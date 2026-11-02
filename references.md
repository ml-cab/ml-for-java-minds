(references)=
# References

Sources for the general machine learning, LLM, and distributed-systems material in this book — everything in Parts I–V that is *not* specific to a particular inference tool's implementation details (those sources, for Juno, llama.cpp, and LocalAI, are listed separately in [rtfms.md](rtfms.md), short for "Read The Folking ManualS," this book's running joke about actually reading the docs before citing them). Entries here are grouped by the chapter they support, with the original publication venue and, where one exists, the arXiv identifier so you can pull the full text directly. Every entry was verified against its original source (arXiv abstract page, ACM/USENIX/IEEE publisher page, or the official EUR-Lex text) before being added here.

## Part I — Beginner

(ref-unreasonable-data)=
### Halevy, Norvig & Pereira (2009) — The Unreasonable Effectiveness of Data

Halevy, A., Norvig, P., & Pereira, F. (2009). The Unreasonable Effectiveness of Data. *IEEE Intelligent Systems*, 24(2), 8–12. https://doi.org/10.1109/MIS.2009.36

*The argument that, at sufficient scale, simple models trained on large amounts of (even noisy) data tend to outperform cleverer hand-crafted theories — cited in [Chapter 3](#ch-03) as the research framing behind why data quality and volume dominate classic ML work.*

(ref-gan)=
### Goodfellow et al. (2014) — Generative Adversarial Networks

Goodfellow, I. J., Pouget-Abadie, J., Mirza, M., Xu, B., Warde-Farley, D., Ozair, S., Courville, A., & Bengio, Y. (2014). Generative Adversarial Networks. *NeurIPS 2014*. arXiv:1406.2661. https://arxiv.org/abs/1406.2661

*The paper that framed generative modeling as learning to sample from the training data's distribution via an adversarial generator/discriminator game — cited in [Chapter 4](#ch-04) as a landmark in making "learn the distribution, then sample" a mainstream technique.*

(ref-backprop)=
### Rumelhart, Hinton & Williams (1986)

Rumelhart, D. E., Hinton, G. E., & Williams, R. J. (1986). Learning representations by back-propagating errors. *Nature*, 323(6088), 533–536. https://doi.org/10.1038/323533a0

*The original backpropagation paper — the algorithm behind "how does the network learn" in [Chapter 5](#ch-05).*

(ref-attention)=
### Vaswani et al. (2017) — "Attention Is All You Need"

Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention Is All You Need. *NeurIPS 2017*. arXiv:1706.03762. https://arxiv.org/abs/1706.03762

*The self-attention mechanism underlying every modern LLM discussed in [Chapter 7](#ch-07) onward. Core contributions: self-attention (every token attends directly to every other in one parallel operation, eliminating the sequential hidden-state bottleneck of RNNs), multi-head attention (several attention patterns run in parallel, each tracking different token relationships), and positional encoding (order-invariant attention gets explicit position signals). Architecture note: the original paper uses an encoder-decoder stack designed for translation — a separate encoder reads the source language, the decoder generates the target. Modern generative LLMs (GPT, LLaMA, Mistral, and all their descendants) are decoder-only: they apply causal masking so each token attends only to preceding positions and omit the encoder entirely. Training is fully parallel over the sequence; inference is sequential because each generated token is fed back as input.*

(ref-dlbook)=
### Goodfellow, Bengio & Courville (2016) — Deep Learning

Goodfellow, I., Bengio, Y., & Courville, A. (2016). *Deep Learning*. MIT Press. https://www.deeplearningbook.org/contents/mlp.html

*Mathematical foundations of layer-wise forward propagation (weight matrices, activation functions, bias vectors) treated rigorously in the "Deep Feedforward Networks" chapter. Referenced from [Chapter 7](#ch-07) as background reading for the feedforward sublayer and embedding lookup mathematics that Transformer blocks share with classic MLPs. Note: the book was published in 2016, a year before the Transformer; self-attention and LLMs are not covered, but the linear-algebra and feedforward foundations apply directly.*

(ref-bpe)=
### Sennrich, Haddow & Birch (2016) — Byte-Pair Encoding

Sennrich, R., Haddow, B., & Birch, A. (2016). Neural Machine Translation of Rare Words with Subword Units. *ACL 2016*, 1715–1725. arXiv:1508.07909. https://arxiv.org/abs/1508.07909

*The BPE tokenization scheme referenced when explaining tokens in [Chapter 7](#ch-07). Core idea: start with individual characters as the vocabulary; repeatedly merge the most frequent adjacent pair into a new single token; repeat until the vocabulary reaches a target size (typically 32K–100K). Common words get a single token; rare or invented words decompose into recognizable subword pieces — without an explicit "unknown word" fallback. The dominant family of generative LLM tokenizers today (GPT, LLaMA, Mistral, Gemma) are direct descendants. WordPiece, used by BERT-family models, and Unigram, used by some SentencePiece configurations, are distinct algorithms that co-exist alongside BPE in the broader ecosystem.*

(ref-word2vec)=
### Mikolov et al. (2013) — word2vec

Mikolov, T., Chen, K., Corrado, G., & Dean, J. (2013). Efficient Estimation of Word Representations in Vector Space. arXiv:1301.3781. https://arxiv.org/abs/1301.3781

*The paper establishing that training on context produces geometrically meaningful embeddings — the core idea behind [Chapter 9](#ch-09) and [Chapter 10](#ch-10).*

(ref-harris-distributional)=
### Harris (1954) — Distributional Structure

Harris, Z. S. (1954). Distributional Structure. *Word*, 10(2–3), 146–162. https://doi.org/10.1080/00437956.1954.11659520

*The linguistic root of the "distributional hypothesis": words that occur in similar contexts tend to have similar meanings. This is the intuition that word2vec later turned into an algorithm — cited in [Chapter 9](#ch-09) as the answer to why meaning should be geometry at all.*

(ref-firth-synopsis)=
### Firth (1957) — A synopsis of linguistic theory, 1930–1955

Firth, J. R. (1957). A synopsis of linguistic theory, 1930–1955. In *Studies in Linguistic Analysis* (pp. 1–32). Oxford: Philological Society. (Reprinted in F. R. Palmer (Ed.), *Selected Papers of J. R. Firth 1952–1959*, Longman, 1968.)

*Source of the often-quoted slogan about knowing a word by the company it keeps, cited alongside Harris (above) in [Chapter 9](#ch-09). The two linguists are routinely cited together but developed different notions of what counts as "context"; see arXiv:2205.07750 for a careful comparison.*

(ref-vsm)=
### Salton, Wong & Yang (1975) — The Vector Space Model

Salton, G., Wong, A., & Yang, C. S. (1975). A Vector Space Model for Automatic Indexing. *Communications of the ACM*, 18(11), 613–620. https://doi.org/10.1145/361219.361220

*The classic paper that represents documents as vectors in a space and compares them geometrically — the same idea, decades before neural embeddings, behind the semantic search discussed in [Chapter 9](#ch-09).*

(ref-linguistic-regularities)=
### Mikolov, Yih & Zweig (2013) — Linguistic Regularities

Mikolov, T., Yih, W., & Zweig, G. (2013). Linguistic Regularities in Continuous Space Word Representations. *Proceedings of NAACL-HLT 2013*, 746–751. https://aclanthology.org/N13-1090/

*Shows that relationships between words appear as consistent vector offsets, with the well-known example that "King − Man + Woman" lands very close to "Queen" — the "bonus" fact in [Chapter 9](#ch-09). Distinct from the word2vec paper above (Mikolov, Chen, Corrado & Dean, 2013).*

(ref-nn-meaningful)=
### Beyer et al. (1999) — When Is "Nearest Neighbor" Meaningful?

Beyer, K., Goldstein, J., Ramakrishnan, R., & Shaft, U. (1999). When Is "Nearest Neighbor" Meaningful? In C. Beeri & P. Buneman (Eds.), *Database Theory — ICDT'99* (Lecture Notes in Computer Science, vol. 1540, pp. 217–235). Springer. https://doi.org/10.1007/3-540-49257-7_15

*Shows that under broad conditions, as dimensionality grows, the distance to the nearest point approaches the distance to the farthest one, and that this can already appear in 10–15 dimensions. The authors also identify workloads where nearest neighbors remain meaningful, which is the caveat that matters for real embeddings — fact 4 in [Chapter 9](#ch-09).*

(ref-jl-lemma)=
### Johnson & Lindenstrauss (1984) — Random projections

Johnson, W. B., & Lindenstrauss, J. (1984). Extensions of Lipschitz mappings into a Hilbert space. In *Conference in Modern Analysis and Probability (New Haven, Conn., 1982)* (Contemporary Mathematics, vol. 26, pp. 189–206). American Mathematical Society. https://doi.org/10.1090/conm/026/737400

*The original source of the Johnson–Lindenstrauss lemma: a set of points can be mapped into a much lower-dimensional space while only slightly changing the distances between them. Behind fact 5 in [Chapter 9](#ch-09). A technical paper; textbook or lecture-note treatments are a gentler way in.*

(ref-matryoshka)=
### Kusupati et al. (2022) — Matryoshka Representation Learning

Kusupati, A., Bhatt, G., Rege, A., Wallingford, M., Sinha, A., Ramanujan, V., Howard-Snyder, W., Chen, K., Kakade, S., Jain, P., & Farhadi, A. (2022). Matryoshka Representation Learning. *Advances in Neural Information Processing Systems 35 (NeurIPS 2022)*. arXiv:2205.13147. https://proceedings.neurips.cc/paper_files/paper/2022/hash/c32319f4868da7613d78af9993100e42-Abstract.html

*Trains one embedding so that its leading dimensions already form usable smaller embeddings, letting a deployment trade accuracy for memory and search cost by truncating the vector — fact 5 in [Chapter 9](#ch-09).*

(ref-anisotropy)=
### Ethayarajh (2019) — Anisotropy of contextual embeddings

Ethayarajh, K. (2019). How Contextual are Contextualized Word Representations? Comparing the Geometry of BERT, ELMo, and GPT-2 Embeddings. *EMNLP-IJCNLP 2019*. arXiv:1909.00512. https://arxiv.org/abs/1909.00512

*Finds that the representations produced by ELMo, BERT and GPT-2 are anisotropic — crowded into a narrow cone of the space rather than spread evenly — which is why raw cosine scores between unrelated texts need not be near zero (fact 7 in [Chapter 9](#ch-09)). The study covers contextual language-model representations; how much the same holds for a particular embedding model is worth checking on your own data.*

(ref-hubness)=
### Radovanović, Nanopoulos & Ivanović (2010) — Hubness

Radovanović, M., Nanopoulos, A., & Ivanović, M. (2010). Hubs in Space: Popular Nearest Neighbors in High-Dimensional Data. *Journal of Machine Learning Research*, 11(86), 2487–2531. https://jmlr.org/papers/v11/radovanovic10a.html

*Describes "hubness": as dimensionality increases, a few points show up among the nearest neighbors of many others. Cited as fact 8 in [Chapter 9](#ch-09), and a useful suspect when one document keeps surfacing in unrelated RAG queries.*

## Part II — Intermediate

(ref-hnsw)=
### Malkov & Yashunin (2018) — HNSW

Malkov, Y. A., & Yashunin, D. A. (2018). Efficient and Robust Approximate Nearest Neighbor Search Using Hierarchical Navigable Small World Graphs. *IEEE Transactions on Pattern Analysis and Machine Intelligence*, 42(4), 824–836. arXiv:1603.09320. https://arxiv.org/abs/1603.09320

*The HNSW algorithm covered as the "B-tree of vector search" in [Chapter 11](#ch-11).*

(ref-nucleus)=
### Holtzman et al. (2020) — Nucleus Sampling

Holtzman, A., Buys, J., Du, L., Forbes, M., & Choi, Y. (2020). The Curious Case of Neural Text Degeneration. *ICLR 2020*. arXiv:1904.09751. https://arxiv.org/abs/1904.09751

*Introduces nucleus (top-p) sampling and demonstrates why greedy and beam-search decoding produce degenerate, repetitive output despite always picking "the best" token at each step — first cited in [Chapter 7](#ch-07) when explaining temperature and sampling, and the basis for the fuller treatment in [Chapter 14](#ch-14).*

(ref-toolformer)=
### Schick et al. (2023) — Toolformer

Schick, T., Dwivedi-Yu, J., Dessì, R., Raileanu, R., Lomeli, M., Zettlemoyer, L., Cancedda, N., & Scialom, T. (2023). Toolformer: Language Models Can Teach Themselves to Use Tools. *NeurIPS 2023*. arXiv:2302.04761. https://arxiv.org/abs/2302.04761

*One of two foundational papers (with ReAct, below) on how LLMs decide to invoke external tools/APIs — the research background behind [Chapter 15](#ch-15).*

(ref-react)=
### Yao et al. (2023) — ReAct

Yao, S., Zhao, J., Yu, D., Du, N., Shafran, I., Narasimhan, K., & Cao, Y. (2023). ReAct: Synergizing Reasoning and Acting in Language Models. *ICLR 2023*. arXiv:2210.03629. https://arxiv.org/abs/2210.03629

*Interleaves reasoning traces with tool/action calls — relevant background for [Chapter 15](#ch-15).*

(ref-gptq)=
### Frantar et al. (2022) — GPTQ

Frantar, E., Ashkboos, S., Hoefler, T., & Alistarh, D. (2022). GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers. arXiv:2210.17323. https://arxiv.org/abs/2210.17323

*A widely-used post-training quantization method; grounds the general discussion of trading precision for memory footprint in [Chapter 16](#ch-16) (GGUF's own k-quant schemes are a distinct, related approach, documented in the llama.cpp/GGUF project rather than a single paper).*

(ref-rag)=
### Lewis et al. (2020) — Retrieval-Augmented Generation

Lewis, P., Perez, E., Piktus, A., Petroni, F., Karpukhin, V., Goyal, N., Küttler, H., Lewis, M., Yih, W., Rocktäschel, T., Riedel, S., & Kiela, D. (2020). Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. *NeurIPS 2020*. arXiv:2005.11401. https://arxiv.org/abs/2005.11401

*The paper that coined "RAG" and established the retrieve-then-generate pattern — first cited in [Chapter 6](#ch-06) as the third rung of the weights/context/retrieval ladder, and the basis for [Chapter 18](#ch-18) in full.*

(ref-promptinjection)=
### Greshake et al. (2023) — Indirect Prompt Injection

Greshake, K., Abdelnabi, S., Mishra, S., Endres, C., Holz, T., & Fritz, M. (2023). Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection. *Proceedings of the 16th ACM Workshop on Artificial Intelligence and Security (AISec '23)*, 79–90. arXiv:2302.12173. https://arxiv.org/abs/2302.12173

*The paper that named and formalized indirect prompt injection as a distinct vulnerability class — the "SQL injection of the LLM era" framing used in [Chapter 19](#ch-19).*

(ref-hallucination)=
### Ji et al. (2023) — Survey of Hallucination in NLG

Ji, Z., Lee, N., Frieske, R., Yu, T., Su, D., Xu, Y., Ishii, E., Bang, Y. J., Madotto, A., & Fung, P. (2023). Survey of Hallucination in Natural Language Generation. *ACM Computing Surveys*, 55(12), Article 248. https://doi.org/10.1145/3571730 · arXiv:2202.03629. https://arxiv.org/abs/2202.03629

*A comprehensive survey of what hallucination is, how it's measured, and why it's a structural property rather than a bug — the basis for [Chapter 20](#ch-20).*

(ref-llmjudge)=
### Zheng et al. (2023) — LLM-as-Judge

Zheng, L., Chiang, W.-L., Sheng, Y., Zhuang, S., Wu, Z., Zhuang, Y., Lin, Z., Li, Z., Li, D., Xing, E. P., Zhang, H., Gonzalez, J. E., & Stoica, I. (2023). Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena. *NeurIPS 2023*. arXiv:2306.05685. https://arxiv.org/abs/2306.05685

*Establishes and validates the "LLM-as-judge" evaluation technique discussed in [Chapter 21](#ch-21), including its known biases.*

## Part III — Advanced

(ref-lora)=
### Hu et al. (2021) — LoRA

Hu, E. J., Shen, Y., Wallis, P., Allen-Zhu, Z., Li, Y., Wang, S., Wang, L., & Chen, W. (2021). LoRA: Low-Rank Adaptation of Large Language Models. arXiv:2106.09685. https://arxiv.org/abs/2106.09685

*The LoRA paper — freezing the base weights and learning low-rank adapter matrices — first cited in [Chapter 6](#ch-06) when explaining that fine-tuning on commodity hardware is now practical, and underlying [Chapter 24](#ch-24) and [Chapter 25](#ch-25) in full (specific inference-tool implementations, Juno, llama.cpp, and LocalAI, are documented in [rtfms.md](rtfms.md)).*

(ref-pagedattention)=
### Kwon et al. (2023) — PagedAttention / vLLM

Kwon, W., Li, Z., Zhuang, S., Sheng, Y., Zheng, L., Yu, C. H., Gonzalez, J. E., Zhang, H., & Stoica, I. (2023). Efficient Memory Management for Large Language Model Serving with PagedAttention. *SOSP 2023*. arXiv:2309.06180. https://arxiv.org/abs/2309.06180

*The paging-inspired approach to KV cache memory management — first cited in [Chapter 6](#ch-06) as the key technique distinguishing vLLM in the on-premise engine table, and covered in depth in [Chapter 28](#ch-28).*

(ref-orca)=
### Yu et al. (2022) — Orca

Yu, G.-I., Jeong, J. S., Kim, G.-W., Kim, S., & Chun, B.-G. (2022). Orca: A Distributed Serving System for Transformer-Based Generative Models. *16th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2022)*. https://www.usenix.org/conference/osdi22/presentation/yu

*Introduces iteration-level scheduling and selective batching — the paper that effectively defines "continuous batching," the subject of [Chapter 29](#ch-29).*

(ref-roofline)=
### Williams, Waterman & Patterson (2009) — Roofline

Williams, S., Waterman, A., & Patterson, D. (2009). Roofline: An Insightful Visual Performance Model for Multicore Architectures. *Communications of the ACM*, 52(4), 65–76. https://doi.org/10.1145/1498765.1498785

*The standard framework for deciding whether a computation is limited by memory bandwidth or by arithmetic throughput, via its "operational intensity". It underpins the decode-versus-prefill discussion in [Chapter 26](#ch-26).*

(ref-tomilov-vector-api)=
### Tomilov & Turov (2024) — Java Vector API vs native code

Tomilov, N. A., & Turov, V. P. (2024). Evaluating the performance of Java Vector API in vector embedding operations. *Computing, Telecommunications and Control*, 17(4), 7–15. https://doi.org/10.18721/JCSTCS.17401

*Benchmarks vector-distance operations written with the Java Vector API against scalar Java and against C++ called through JNI, Project Panama and other interfaces. Reports that the Vector API can give a measurable speedup, that it is sometimes slower than the JIT's auto-vectorization, and that native calls were faster in most of the benchmarks despite their call overhead. Cited in [Chapter 26](#ch-26). The workload is vector-distance computation, not full LLM matmul, so treat it as a direction rather than a verdict.*

## Part IV — Professional

(ref-megatron)=
### Shoeybi et al. (2019) — Megatron-LM

Shoeybi, M., Patwary, M., Puri, R., LeGresley, P., Casper, J., & Catanzaro, B. (2019). Megatron-LM: Training Multi-Billion Parameter Language Models Using Model Parallelism. arXiv:1909.08053. https://arxiv.org/abs/1909.08053

*Intra-layer (tensor) model parallelism for transformers at scale — the source for the tensor-parallelism half of [Chapter 30](#ch-30)'s comparison.*

(ref-euaiact)=
### EU Artificial Intelligence Act (2024)

European Parliament and Council of the European Union. (2024). Regulation (EU) 2024/1689 laying down harmonised rules on artificial intelligence (Artificial Intelligence Act). *Official Journal of the European Union*. https://eur-lex.europa.eu/eli/reg/2024/1689/oj

*The primary legal text behind the risk-tier framework (prohibited / high-risk / limited-risk / minimal-risk) and the Article 50 transparency obligation discussed in [Chapter 34](#ch-34).*

## Part V — Beyond LLMs

(ref-random-forests)=
### Breiman (2001) — Random Forests

Breiman, L. (2001). Random Forests. *Machine Learning*, 45(1), 5–32. https://doi.org/10.1023/A:1010933404324

*The ensemble-of-trees algorithm covered in [Chapter 35](#ch-35).*

(ref-xgboost)=
### Chen & Guestrin (2016) — XGBoost

Chen, T., & Guestrin, C. (2016). XGBoost: A Scalable Tree Boosting System. *KDD 2016*, 785–794. arXiv:1603.02754. https://arxiv.org/abs/1603.02754

*The gradient-boosted tree system discussed alongside random forests in [Chapter 35](#ch-35).*

(ref-adam)=
### Kingma & Ba (2015) — Adam

Kingma, D. P., & Ba, J. (2015). Adam: A Method for Stochastic Optimization. *ICLR 2015*. arXiv:1412.6980. https://arxiv.org/abs/1412.6980

*The adaptive optimizer behind the vast majority of modern training runs, including the LoRA loop in [Chapter 24](#ch-24) — covered directly in [Chapter 36](#ch-36).*

(ref-dropout)=
### Srivastava et al. (2014) — Dropout

Srivastava, N., Hinton, G., Krizhevsky, A., Sutskever, I., & Salakhutdinov, R. (2014). Dropout: A Simple Way to Prevent Neural Networks from Overfitting. *Journal of Machine Learning Research*, 15(1), 1929–1958. https://jmlr.org/papers/v15/srivastava14a.html

*The regularization technique discussed as a defense against overfitting in [Chapter 36](#ch-36).*

(ref-roc)=
### Fawcett (2006) — ROC Analysis

Fawcett, T. (2006). An Introduction to ROC Analysis. *Pattern Recognition Letters*, 27(8), 861–874. https://doi.org/10.1016/j.patrec.2005.10.010

*The threshold-independent evaluation technique covered in [Chapter 37](#ch-37).*

(ref-resnet)=
### He et al. (2016) — Deep Residual Learning (ResNet)

He, K., Zhang, X., Ren, S., & Sun, J. (2016). Deep Residual Learning for Image Recognition. *CVPR 2016*, 770–778. arXiv:1512.03385. https://arxiv.org/abs/1512.03385

*Residual connections, which made very deep CNNs trainable — covered in [Chapter 39](#ch-39).*

(ref-ddpm)=
### Ho, Jain & Abbeel (2020) — Denoising Diffusion Probabilistic Models

Ho, J., Jain, A., & Abbeel, P. (2020). Denoising Diffusion Probabilistic Models. *NeurIPS 2020*. arXiv:2006.11239. https://arxiv.org/abs/2006.11239

*The iterative-denoising technique behind modern image generation, discussed in [Chapter 39](#ch-39).*

(ref-lstm)=
### Hochreiter & Schmidhuber (1997) — Long Short-Term Memory

Hochreiter, S., & Schmidhuber, J. (1997). Long Short-Term Memory. *Neural Computation*, 9(8), 1735–1780. https://doi.org/10.1162/neco.1997.9.8.1735

*The gated recurrent architecture that partially fixed vanishing gradients before Transformers replaced recurrence outright — the historical anchor for [Chapter 40](#ch-40).*

(ref-rlhf)=
### Christiano et al. (2017) — Deep RL from Human Preferences

Christiano, P. F., Leike, J., Brown, T., Martic, M., Legg, S., & Amodei, D. (2017). Deep Reinforcement Learning from Human Preferences. *NeurIPS 2017*. arXiv:1706.03741. https://arxiv.org/abs/1706.03741

*Formalizes learning a reward model from human preference rankings rather than a hand-written reward function — the technique underlying RLHF, covered in [Chapter 41](#ch-41).*

(ref-instructgpt)=
### Ouyang et al. (2022) — InstructGPT

Ouyang, L., Wu, J., Jiang, X., Almeida, D., Wainwright, C. L., Mishkin, P., Zhang, C., Agarwal, S., Slama, K., Ray, A., Schulman, J., Hilton, J., Kelton, F., Miller, L., Simens, M., Askell, A., Welinder, P., Christiano, P., Leike, J., & Lowe, R. (2022). Training Language Models to Follow Instructions with Human Feedback. *NeurIPS 2022*. arXiv:2203.02155. https://arxiv.org/abs/2203.02155

*Applies RLHF at scale to produce an instruction-following chat model — the direct ancestor of ChatGPT's training recipe, discussed in [Chapter 41](#ch-41).*

(ref-hidden-debt)=
### Sculley et al. (2015) — Hidden Technical Debt in Machine Learning Systems

Sculley, D., Holt, G., Golovin, D., Davydov, E., Phillips, T., Ebner, D., Chaudhary, V., Young, M., Crespo, J.-F., & Dennison, D. (2015). Hidden Technical Debt in Machine Learning Systems. *NeurIPS 2015*, 2503–2511. https://proceedings.neurips.cc/paper/2015/hash/86df7dcfd896fcaf2674f757a2463eba-Abstract.html

*The foundational argument that ML-specific glue code, not the modeling code itself, is where most production ML technical debt accumulates — the framing behind [Chapter 42](#ch-42).*

(ref-clip)=
### Radford et al. (2021) — CLIP

Radford, A., Kim, J. W., Hallacy, C., Ramesh, A., Goh, G., Agarwal, S., Sastry, G., Askell, A., Mishkin, P., Clark, J., Krueger, G., & Sutskever, I. (2021). Learning Transferable Visual Models From Natural Language Supervision. *ICML 2021*, 8748–8763. arXiv:2103.00020. https://arxiv.org/abs/2103.00020

*Joint image/text embedding training, the bridge technique behind vision-language models and text-to-image generation, discussed in [Chapter 43](#ch-43).*

(ref-scaling-laws)=
### Kaplan et al. (2020) — Scaling Laws for Neural Language Models

Kaplan, J., McCandlish, S., Henighan, T., Brown, T. B., Chess, B., Child, R., Gray, S., Radford, A., Wu, J., & Amodei, D. (2020). Scaling Laws for Neural Language Models. arXiv:2001.08361. https://arxiv.org/abs/2001.08361

*The empirical power-law relationship between loss, model size, data size, and compute — the basis for [Chapter 44](#ch-44).*

## General / cross-cutting

(ref-openai-api)=
### OpenAI Chat Completions API reference

OpenAI. Chat Completions API reference. https://platform.openai.com/docs/api-reference/chat

*The de facto wire-format standard discussed in [Chapter 17](#ch-17), implemented independently by llama.cpp, Ollama, and Juno.*

(ref-otel)=
### OpenTelemetry documentation

OpenTelemetry Authors. OpenTelemetry documentation. https://opentelemetry.io/docs/

*The distributed-tracing standard referenced in [Chapter 32](#ch-32)'s observability discussion.*

---

## A note on how this list was built

Every entry above was verified by web search against its original source (arXiv abstract page, ACM/USENIX/IEEE publisher page, or the official EUR-Lex text) rather than pulled from memory, specifically to avoid citing a paper with the wrong year, venue, or author list. Where a chapter's content is general engineering practice rather than a single traceable result — for example, the if/else-vs-model heuristics in Chapter 2, or the health-dashboard and versioning patterns in Chapters 31 and 33 — no citation is given, because the material reflects standard software engineering practice rather than a specific research claim. Chapter 6's training/inference analogy is similarly general practice, but it now does cite LoRA, RAG, and PagedAttention where those specific techniques are named. Citing a paper for content it doesn't actually support would be a worse outcome than citing nothing. Documentation for the specific inference tools mentioned throughout the book (Juno, llama.cpp, LocalAI) lives in [rtfms.md](rtfms.md), verified the same way, against each project's live docs.

---

[Table of Contents](index.md)