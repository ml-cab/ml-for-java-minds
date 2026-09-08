(ch-35)=
# 35. Classical ML: Regression, Trees, and Ensembles Before You Ever Touch a Transformer
Everything from [Chapter 10](#ch-10) onward has been about LLMs, and it's easy to walk away thinking "machine learning" and "large language model" are the same thing. They aren't. Most production ML running today, credit scoring, fraud detection, churn prediction, demand forecasting, isn't a transformer at all: it's one of a handful of much older, much cheaper, and often more accurate-for-the-job algorithms that this book has skipped past entirely until now. If your problem is "predict a number or a category from structured, tabular rows," reaching for an LLM is usually the wrong tool, the same way reaching for a distributed message queue to pass one boolean flag between two threads in the same process would be.

**Linear and logistic regression** are the `HashMap` of ML: unglamorous, and the first thing you should reach for before anything fancier. Linear regression fits a straight-line (or hyperplane) relationship between features and a continuous number (`price = w1*sqft + w2*bedrooms + b`); logistic regression does the same thing but squashes the output through a sigmoid to produce a probability for a yes/no classification. Both are fast to train, easy to explain to a non-technical stakeholder ("each extra bedroom adds $12k, holding square footage fixed"), and a legitimate baseline you should beat before justifying anything more complex.

**Decision trees** ask a sequence of yes/no questions about the input, the same way a chain of `if/else` statements would, except the questions and thresholds are *learned* from data rather than hand-written: `if income > 52000: if creditScore > 680: approve`. A single tree is easy to visualize and explain, but prone to overfitting: it can carve out a rule so specific to the training data that it memorizes noise instead of learning a real pattern.

**Ensembles** fix this by combining many trees rather than trusting one:

| Method | How it combines trees | Analogy |
|---|---|---|
| **Random Forest** ([Breiman, 2001](../references.md#ref-random-forests)) | Trains many trees independently on random subsets of data and features, then averages their votes | A load-balanced cluster of independent workers, each seeing a different shard, majority-voting on the answer |
| **Gradient Boosting** (e.g. **XGBoost**, [Chen & Guestrin, 2016](../references.md#ref-xgboost)) | Trains trees *sequentially*, each new tree specifically targeting the previous ensemble's errors | A code-review pipeline where each reviewer's only job is to catch what the last reviewer missed |

```
Random Forest:    tree1, tree2, tree3, ... trained INDEPENDENTLY, in parallel -> majority vote
Gradient Boosting: tree1 -> tree2 (fixes tree1's errors) -> tree3 (fixes what's left) -> ... -> sum
```

Random forests are robust, hard to misconfigure, and a strong default; gradient-boosted trees (XGBoost, LightGBM, CatBoost) usually win on raw accuracy for tabular data and are, to this day, the most common first-place technique in tabular-data machine learning competitions, precisely the domain where transformers, despite dominating text and vision, still don't reliably beat a well-tuned tree ensemble.

The practical decision rule: if your input is a table with a fixed, well-understood set of columns (age, income, transaction count, days-since-last-purchase), start with logistic regression as a baseline, then try a gradient-boosted tree ensemble before reaching for a neural network of any kind, including an LLM. Neural networks, and Part I's whole framing of "a model is a function," earn their keep on unstructured data (text, images, audio) where hand-designed features don't exist; on structured tabular data, trees are frequently both cheaper to train and more accurate.

**Further reading:** Breiman, L. (2001). [Random Forests](https://doi.org/10.1023/A:1010933404324). *Machine Learning*, 45(1), 5–32 · Chen, T., & Guestrin, C. (2016). [XGBoost: A Scalable Tree Boosting System](https://arxiv.org/abs/1603.02754). *KDD 2016*.

---

[← Chapter 34: Compliance for Generative Apps](../part4/34-compliance-for-generative-apps.md) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 36: Loss Functions, Gradient Descent, and the Bias-Variance Trade-off →](#ch-36)
