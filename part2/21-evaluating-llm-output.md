(ch-21)=
# 21. Evaluating LLM Output: Why Unit Tests Don't Work and What Replaces Them
A traditional unit test asserts exact equality: `assertEquals("Paris", capital("France"))`. This breaks immediately for LLM output, because the same prompt run twice (even at `temperature=0` in many real-world setups, due to floating point non-associativity across different batch sizes or hardware) can produce text that's *correct* but *not byte-identical*: "The capital of France is Paris." vs "Paris is the capital of France." Both right. `assertEquals` fails on both being compared to each other.

This is the central adjustment: **you're evaluating whether an answer is good, not whether it matches a fixed string.** Several complementary techniques fill the gap left by exact-match assertions:

- **Structural / format checks**: the one place exact assertions still work well. If you're using constrained decoding ([Chapter 13](#ch-13)), you *can* and *should* assert the output is valid JSON matching your schema, because that part is deterministic even when the content isn't.
- **Semantic similarity scoring**: embed the actual output and a reference "gold" answer ([Chapter 9](#ch-09)'s cosine similarity), and assert similarity above a threshold rather than exact match. Looser than exact-match, but catches genuinely wrong answers while tolerating rephrasing.
- **Rule-based / programmatic checks**: for well-defined properties: does the summary mention the refund amount if one was in the source ticket? Is the output under N words? Does it avoid a list of banned phrases? These are ordinary assertions, just checking properties of the text rather than the text itself.
- **LLM-as-judge**: use a second (often stronger or differently-configured) model call to score the first model's output against a rubric ("Does this answer correctly address the question? Score 1–5."), a technique formalized and validated against human preferences by [Zheng et al. (2023)](../references.md#ref-llmjudge). Genuinely useful at scale, but introduces its own non-determinism and cost, so treat judge scores as a signal to track over time and investigate regressions in, not as ground truth to blindly trust.
- **Human evaluation on a sample**: still the gold standard for anything high-stakes, and the calibration source you'd use to validate that your automated metrics (semantic similarity thresholds, LLM-judge rubrics) actually correlate with what a human considers a correct answer.

```
Traditional unit test:     actual == expected                       -> pass/fail
LLM evaluation:            similarity(actual, expected) > threshold  -> pass/fail
                            OR rubric_score(actual) >= 4/5            -> pass/fail
                            OR structural_check(actual) == valid      -> pass/fail
```

The engineering practice that replaces "run the test suite before merging" is an **evaluation set**: a curated, versioned collection of representative prompts with either reference answers or scoring rubrics, run automatically whenever the prompt, the model, or the retrieval pipeline changes: precisely the regression-test role a unit test suite plays, just with fuzzier, threshold-based assertions instead of exact ones. Treat prompt changes with the same seriousness as code changes: no untested prompt changes reach production, the same as no untested code changes should. [Chapter 33](#ch-33) extends this into full production rollout and A/B testing practice for non-deterministic systems.

**Further reading:** Zheng, L. et al. (2023). [Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena](https://arxiv.org/abs/2306.05685). *NeurIPS 2023* — establishes and validates the LLM-as-judge technique, including its known biases (position, verbosity, self-enhancement).

---

[← Chapter 20: Safety and Guardrails: Hallucinations, PII, and What Your App Must Own](#ch-20) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 22: Fine-Tuning vs Prompting vs RAG: Choosing the Right Lever →](#ch-22)
