(ch-37)=
# 37. Evaluating Classical Models: Precision, Recall, ROC-AUC, and Confusion Matrices
[Chapter 21](#ch-21) covered how to evaluate LLM output, where "correct" is fuzzy and text-shaped. Classification models ([Chapter 35](#ch-35)) have the opposite problem: the output is a clean yes/no or a category, so evaluation should be simple, right? It's simple to *compute*, but surprisingly easy to *misread*, and "accuracy" in particular is a metric that quietly lies to you on exactly the datasets where it matters most.

Start with a **confusion matrix**: for a binary classifier (say, "is this transaction fraudulent?"), every prediction falls into exactly one of four buckets.

| | Predicted: Fraud | Predicted: Legitimate |
|---|---|---|
| **Actual: Fraud** | True Positive (TP) | False Negative (FN) |
| **Actual: Legitimate** | False Positive (FP) | True Negative (TN) |

This is the same shape as a monitoring alert's outcome space: a true positive is a real incident that paged you, a false positive is a page for nothing (alert fatigue), a false negative is a real incident that *didn't* page (the dangerous silent failure), and a true negative is quiet because nothing was wrong.

**Accuracy** (`(TP + TN) / total`) is the metric everyone reaches for first, and it's the one that lies on imbalanced data. If fraud is 0.1% of transactions, a model that predicts "legitimate" for *every single transaction* scores 99.9% accuracy while catching zero fraud, the classification equivalent of a monitoring system with a 99.9% uptime dashboard that's actually just never alerting on anything. This is exactly the failure mode two better metrics exist to catch:

- **Precision** = `TP / (TP + FP)`: of everything you flagged as fraud, what fraction actually was? Low precision means you're crying wolf, burning investigator time on false alarms.
- **Recall** = `TP / (TP + FN)`: of all the actual fraud, what fraction did you catch? Low recall means real fraud is slipping through undetected.

```
High precision, low recall:  rarely flags anything, but almost always right when it does
                              -> misses real fraud (dangerous false negatives)

Low precision, high recall:  flags aggressively, catches almost all real fraud
                              -> drowns investigators in false alarms
```

Precision and recall trade off against each other, and which one to prioritize is a business decision, not a purely technical one: a spam filter should favor precision (never lose a real email), a cancer screening test should favor recall (never miss a real case, some false alarms are an acceptable cost). The **F1 score** (the harmonic mean of precision and recall) is a common single number when you need to balance both without a strong preference either way.

**ROC-AUC** (Receiver Operating Characteristic, Area Under the Curve, [Fawcett, 2006](../references.md#ref-roc)) evaluates a model across *every possible decision threshold* at once, rather than the one threshold accuracy/precision/recall implicitly assume. Most classifiers don't output a hard yes/no directly, they output a probability (`0.83` fraud likelihood), and you choose the cutoff (`> 0.5`? `> 0.9`?) separately from training. The ROC curve plots true positive rate against false positive rate as that cutoff slides from 0 to 1; AUC (0.5 = random guessing, 1.0 = perfect separation) summarizes the whole curve into one number, letting you compare two models' underlying ability to separate classes *before* committing to any specific threshold, the same way you'd evaluate a ranking algorithm's quality independent of where you decide to draw the "top K" cutoff.

The practical habit worth internalizing: never report accuracy alone on a real dataset without first checking the class balance, and always pick precision, recall, or a threshold-independent metric like AUC based on which failure mode (false positive or false negative) actually costs your business more.

**Further reading:** Fawcett, T. (2006). [An Introduction to ROC Analysis](https://doi.org/10.1016/j.patrec.2005.10.010). *Pattern Recognition Letters*, 27(8), 861–874.

---

[← Chapter 36: Loss Functions, Gradient Descent, and the Bias-Variance Trade-off](#ch-36) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 38: Feature Engineering: Encoding, Scaling, and Missing Data →](#ch-38)
