(ch-13)=
# 13. Structured Output: JSON Schema, Constrained Decoding, and Why "Just Ask Nicely" Fails
"Please respond only in JSON" is a request, not a guarantee. Left alone, an LLM occasionally wraps its JSON in a markdown code fence, adds a friendly preamble ("Sure, here's the JSON:"), or produces JSON that's *almost* valid: a trailing comma, an unescaped quote, because at heart it is still just predicting the statistically likely next token, and "helpful preamble" is a statistically common pattern in its training data.

For a Java developer this is intolerable: you cannot `Jackson.readValue()` a string that might or might not parse. Two real solutions exist, in increasing order of reliability:

**1. Prompted JSON + defensive parsing.** Ask clearly, provide a schema example, and wrap parsing in retry logic that re-prompts on failure. Better than nothing, still probabilistic.

```java
try {
    return objectMapper.readValue(modelOutput, TicketSummary.class);
} catch (JsonProcessingException e) {
    // retry with a corrective prompt, or fall back to a stricter mode
}
```

**2. Constrained decoding (grammar-based / JSON-schema-based generation).** This is the reliable fix, and it works at a completely different layer: instead of generating freely and hoping the result is valid, the inference engine restricts *which tokens are even legal* at each generation step, based on a grammar (often a JSON Schema compiled into a state machine, or a formal grammar like GBNF in llama.cpp). If the schema says the next field must be a number, the sampler literally cannot select a token that would start a string, because the invalid path is removed from the probability distribution before sampling happens, not corrected after the fact.

```
Free generation:           model picks the most likely next token from the full vocabulary
Constrained decoding:      model picks the most likely next token from only the
                            tokens the grammar allows at this exact position
```

This is conceptually close to a compiler's parser rejecting invalid syntax before it ever reaches a runtime check, except here the "compiler" runs *during* generation, one token at a time, guaranteeing structural validity by construction rather than catching errors after the fact.

llama.cpp exposes this via `--grammar` (GBNF format) or a `response_format: {"type": "json_schema", ...}` field on its OpenAI-compatible server; Ollama supports a `format` parameter with a JSON Schema. When you control the schema and need guaranteed parseability, extracting structured fields from a document, calling a downstream API with typed arguments ([Chapter 15](#ch-15)), constrained decoding is worth the setup cost. "Just ask nicely" is fine for a demo; it is not fine for a payment-processing pipeline.

---

[← Chapter 12: Prompt Engineering for Engineers: Specs, Contracts, and Failure Modes](#ch-12) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 14: Temperature, Top-P, Top-K: Sampling Knobs That Change Model Personality →](#ch-14)
