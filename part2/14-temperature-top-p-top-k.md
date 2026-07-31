(ch-14)=
# 14. Temperature, Top-P, Top-K: Sampling Knobs That Change Model Personality
After the forward pass, a language model doesn't output "the next token" directly: it outputs a probability distribution over its entire vocabulary (tens of thousands of possible tokens), something like:

```
"Paris"    -> 0.72
"the"      -> 0.09
"a"        -> 0.04
"Lyon"     -> 0.02
... (thousands more, mostly near-zero)
```

**Sampling** is the step that picks one token from this distribution. How you pick determines whether the model feels robotic and repetitive or creative and occasionally unhinged. Three knobs, all commonly available in every serving tool:

- **Temperature** rescales the distribution before sampling. `temperature=0` always picks the single most likely token: fully deterministic, the same input always produces the same output (useful for factual Q&A, structured extraction, or verifying that a fine-tuned model reliably recalls a trained fact, see [Chapter 24](#ch-24)'s discussion of `--lora-play` defaulting to greedy decoding for exactly this reason). Higher temperature (e.g. `1.0`+) flattens the distribution, giving lower-probability tokens a real chance of being picked: more variety, more risk of incoherence. Temperature `0.7` is a common default balance.
- **Top-K** restricts sampling to only the K most probable tokens, discarding the long tail entirely before sampling. `top_k=50` (a common default) means: however flat the distribution gets from temperature, only the 50 most likely tokens are even candidates.
- **Top-P** (nucleus sampling, introduced by [Holtzman et al., 2020](../references.md#ref-nucleus) to fix the bland, repetitive text that greedy and beam-search decoding tend to produce) restricts sampling to the smallest set of tokens whose cumulative probability exceeds P. `top_p=0.9` means: keep adding tokens, most likely first, until their probabilities sum past 90%, then sample only from that set. Unlike top-K's fixed count, top-P's candidate set size adapts: when the model is very confident (one token dominates), the set shrinks to just a few tokens; when it's uncertain, the set grows.

```
Full distribution:   [0.72, 0.09, 0.04, 0.02, 0.01, 0.01, ... long tail ...]

top_k=3:             keep only [0.72, 0.09, 0.04], renormalize, sample from these 3

top_p=0.9:           keep adding until cumulative >= 0.9
                      0.72 + 0.09 + 0.04 + 0.02 + ... -> stop once sum crosses 0.9
                      (candidate set size varies call to call)
```

These knobs typically combine: top-K and top-P both prune the candidate set (whichever is stricter wins), then temperature reshapes what remains, then sampling picks one. Tune them the way you'd tune a cache eviction policy: start from sane defaults (`temperature=0.7, top_p=0.9, top_k=50`, Juno's own defaults, and broadly typical elsewhere), then adjust deliberately for your use case: near-zero temperature for anything requiring consistency and factual reliability, higher temperature and top-P for creative writing or brainstorming assistants.

**Further reading:** Holtzman, A., Buys, J., Du, L., Forbes, M., & Choi, Y. (2020). [The Curious Case of Neural Text Degeneration](https://arxiv.org/abs/1904.09751). *ICLR 2020*.

---

[← Chapter 13: Structured Output: JSON Schema, Constrained Decoding, and Why "Just Ask Nicely" Fails](#ch-13) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 15: Function Calling and Tool Use: Letting the Model Call Your Java Methods →](#ch-15)