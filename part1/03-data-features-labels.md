(ch-03)=
# 3. Data, Features, Labels: How a Dataset Looks If You Think in POJOs
Every supervised ML dataset is, structurally, a list of objects. If you've ever built a training set in your head as a `List<TrainingExample>`, you already understand this chapter.

```java
record TrainingExample(
    Map<String, Double> features,  // the inputs the model sees
    String label                   // the correct answer, i.e. ground truth
) {}
```

- **Features** are the input fields: the columns of your dataset. For a house-price model: square footage, number of bedrooms, zip code. For a spam filter: word counts, sender domain age, number of links.
- **Labels** are the correct answers you're trying to teach the model to predict. They come from the past: a house that already sold for a known price, an email a human already marked as spam.
- A **dataset** is a `List<TrainingExample>`: usually thousands to billions of rows, split into **training** (what the model learns from), **validation** (what you tune hyperparameters against), and **test** (what you evaluate on once, to know if it generalizes).

| id | sqft | bedrooms | zip | ... | label (price) |
|---|---|---|---|---|---|
| 1 | 1200 | 2 | 10001 | ... | 410,000 |
| 2 | 2400 | 4 | 94107 | ... | 1,150,000 |

*(everything left of "label" is the feature set; "label" alone is the ground truth the model learns to predict)*

A crucial and very Java-flavored point: **feature engineering is schema design.** Choosing which fields to expose to the model, how to normalize them, and how to encode categories (one-hot encoding a `zip code` field is a lot like turning an `enum` into a bitmask) is where most of the actual engineering work in a classic ML project lives, not in the algorithm itself.

**Garbage in, garbage out** is not a cliché here, it's the whole ballgame. If your labels are wrong (mislabeled spam), noisy (inconsistent human judgment calls), or the features don't actually correlate with the label (using shoe size to predict credit risk), no algorithm, however famous, will save you. Data quality review is the ML equivalent of code review, and it deserves the same rigor.

---

[← Chapter 2: From if/else Rules to Learned Behaviour: When Models Replace Hard-Coded Logic](#ch-02) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 4: Supervised, Unsupervised, and Generative AI. Explained Like Design Patterns →](#ch-04)
