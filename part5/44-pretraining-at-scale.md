(ch-44)=
# 44. Pretraining at Scale: Data, Tokenizers, and Scaling Laws
Every chapter in this book that touches a language model, from [Chapter 6](#ch-06)'s train-vs-inference split onward, has assumed a base model already exists and picks up the story from there: fine-tuning it ([Chapter 23](#ch-23)), quantizing it ([Chapter 16](#ch-16)), serving it ([Chapter 26](#ch-26)–[29](#ch-29)). This closing chapter fills in the one part of the pipeline the rest of the book skipped entirely: how that base model came to exist in the first place.

**Pretraining** is, mechanically, the same next-token-prediction objective [Chapter 7](#ch-07) described, run at a scale that makes everything else in this book look small: not thousands of curated `(prompt, completion)` pairs like [Chapter 23](#ch-23)'s fine-tuning dataset, but trillions of tokens of raw text, scraped, filtered, and deduplicated from the public web, books, code repositories, and other large text sources, with no explicit "correct answer" beyond "predict the actual next word that appeared in the source text." There's no reward model here, no human ranking, just the same cross-entropy loss from [Chapter 36](#ch-36) applied at a scale where a single training run can cost millions of dollars in compute.

**Data quality and deduplication matter more than raw volume**, echoing [Chapter 3](#ch-03)'s Halevy-Norvig-Pereira citation but with an important caveat added by experience since: naively scraped web text is full of near-duplicate pages, low-quality spam, and boilerplate, and training on heavily duplicated content wastes compute re-teaching the model things it already learned, or worse, causes it to memorize and regurgitate specific duplicated passages verbatim rather than generalizing. Modern pretraining pipelines invest heavily in filtering (removing low-quality or duplicate content) and deduplication (near-identical document detection) before a single token reaches the actual training loop, a data-engineering problem closer to building a search index's crawl-and-dedup pipeline than to anything resembling a fine-tuning dataset.

**Tokenizer training happens before model training, and it's frozen afterward.** [Chapter 7](#ch-07) cited Byte-Pair Encoding (BPE, [Sennrich et al., 2016](../references.md#ref-bpe)) as the scheme behind tokens; what wasn't covered is that the tokenizer's vocabulary itself is learned, by scanning a large text corpus and merging the most frequently co-occurring character pairs into single tokens, iteratively, until reaching a target vocabulary size (commonly 32,000 to 100,000+ tokens). This is a one-time, upfront step, the tokenizer's vocabulary is fixed before pretraining begins and never changes afterward, which is exactly why [Chapter 23](#ch-23)'s "match the target chat template exactly" warning matters: a model's tokenizer is baked into it as permanently as a database's character encoding, and mismatching it at any later stage silently corrupts everything downstream.

**Scaling laws** are the empirical discovery that ties this all together: [Kaplan et al. (2020)](../references.md#ref-scaling-laws) found that a language model's loss decreases as a smooth, predictable power-law function of three quantities, model size (parameter count), dataset size (token count), and compute budget, holding roughly across many orders of magnitude.

```
loss ~ (compute_budget) ^ (-alpha)     for some small positive constant alpha,
                                         roughly consistent across model families and scales
```

This predictability is what turned frontier model training from empirical guesswork into something closer to capacity planning: given a fixed compute budget, scaling laws let a team estimate, *before* spending millions of dollars on a training run, roughly how large a model to train and how much data to feed it to get the best achievable loss for that budget, rather than discovering the answer only after the run finishes. It's the training-time analogue of load-testing a system before committing to a hardware budget: a mathematically-grounded prediction replacing a guess, precisely the kind of empirical regularity [Chapter 3](#ch-03) gestured at when it introduced "The Unreasonable Effectiveness of Data" as the research framing behind why scale, done carefully, so reliably pays off.

**Further reading:** Kaplan, J. et al. (2020). [Scaling Laws for Neural Language Models](https://arxiv.org/abs/2001.08361). arXiv:2001.08361.

---

[← Chapter 43: Agents and Multimodality](#ch-43) &nbsp;|&nbsp; [Table of Contents](../index.md)
