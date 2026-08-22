(ch-02)=
# 2. From if/else Rules to Learned Behavior: When Models Replace Hard-Coded Logic
Imagine you're asked to write a spam filter. The naive approach:

```java
private static final String SPAM_SMELL = "act now,lottery winner,100% free";

boolean isSpam(String message) {
  for (String smell : SPAM_SMELL.split(",")) {
    if (message.contains(smell)) {
      return true;
    }
  }
  return false;
}
```

This works until spammers stop using those words. You add more rules. Spammers adapt. You add more rules. Six months later you have 4,000 lines of brittle `if/else` that nobody wants to touch, and the false-positive rate is climbing because "wire transfer" also appears in legitimate banking emails.

This is the classic sign that a problem wants a model instead of a rulebook: **the rules are numerous, contradictory in edge cases, and drift over time faster than you can patch them.**

A learned model doesn't encode "if message contains smell" It encodes statistical patterns across thousands of features (word frequencies, sender reputation, formatting quirks) discovered automatically from labeled examples of spam and non-spam. When spam evolves, you retrain on new examples instead of hand-editing a decision tree of exceptions.

| Use `if/else` when... | Use a learned model when... |
|---|---|
| The rule is simple and stable (`age >= 18`) | The "rule" is really thousands of soft correlations |
| You can enumerate every case | Cases are open-ended or drift over time |
| Wrong answers must be 100% explainable | Statistical accuracy is acceptable, and you can measure it |
| No representative data exists yet | You have (or can collect) labeled examples |

This isn't a value judgment, because `if/else` is *usually* the right tool, testable, debuggable, and free of surprises. Reach for a model only when hard-coded logic keeps failing for the same structural reason: **reality has too many exceptions** to fit in code you can review.

Spam filtering is a classic example because it demonstrates concept drift—the statistical properties of the data change over time. So if you can describe the rule precisely, write code. If you need a thing to discover the rule from examples, train a model.

A practical rule of thumb: **keep the boring 80% in plain code, and let the model own only the fuzzy 20%.** E.g. a billing system may use `if/else` for tax rules and a model (if anything) only for fraud-likelihood scoring. Mixing both code for the parts you can specify exactly and models for the parts you can't, brings some balance in our rapid learning world.

---

[← Chapter 1: Machine Learning Without the Mystery: A Developer's Mental Model](#ch-01) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 3: Data, Features, Labels: How a Dataset Looks If You Think in POJOs →](#ch-03)
