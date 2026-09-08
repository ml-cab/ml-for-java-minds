(ch-38)=
# 38. Feature Engineering: Encoding, Scaling, and Missing Data
[Chapter 3](#ch-03) introduced features as the fields on your `TrainingExample` POJO, but glossed over a genuinely large, genuinely unglamorous part of applied ML: most raw data isn't in a shape a classical model ([Chapter 35](#ch-35)) can consume directly, and the work of getting it there, feature engineering, routinely matters more to final accuracy than which algorithm you pick.

**Categorical encoding.** A model doing arithmetic on weights and inputs ([Chapter 5](#ch-05)) can't directly consume a string like `"country": "Bulgaria"`. Two standard fixes:

| Technique | What it does | When to use it |
|---|---|---|
| **One-hot encoding** | Turns one categorical column into N binary columns, one per possible value (`isBulgaria`, `isFrance`, `isGermany`, ...) | Low-cardinality categories (a handful to a few hundred distinct values), and when categories have no natural order |
| **Label / ordinal encoding** | Maps each category to a single integer (`Bulgaria=0, France=1, Germany=2`) | Only when the categories genuinely have an order (`small/medium/large`), because otherwise the model wrongly infers `Germany > France` |

One-hot encoding is the safer default; the trap with label encoding is that a model like linear regression will treat the assigned integers as having real numeric meaning, `2 - 0 = 2`, is `Germany` "twice as much" as `Bulgaria`? Almost never, so encoding unordered categories as ordinal is a silent, easy-to-miss bug, the categorical equivalent of accidentally sorting a `Map<String, Enum>` by the enum's ordinal value and treating that ordering as meaningful.

**Scaling.** Features on wildly different numeric ranges (`age: 0-100` vs. `annual_income: 0-500000`) cause real problems for many algorithms, especially gradient descent ([Chapter 36](#ch-36)): a feature with a huge numeric range dominates the loss surface and slows or destabilizes convergence, the same way an unbounded queue depth metric would swamp a dashboard that also tracks a 0-1 error rate on the same chart.

```
Standardization (z-score):  (x - mean) / standard_deviation   -> centered at 0, unit variance
Min-max scaling:             (x - min) / (max - min)          -> squashed into [0, 1]
```

Standardization is the more common default for algorithms sensitive to feature scale (linear/logistic regression, neural networks); tree-based models ([Chapter 35](#ch-35)) are largely scale-invariant, since a decision tree only asks "is this value above or below a threshold," so scaling rarely matters for random forests or gradient-boosted trees.

**Missing data.** Real-world datasets have gaps: a customer record with no recorded age, a sensor reading that failed to log. Three common strategies, in increasing order of sophistication:

- **Drop the row or column**, when missingness is rare and random, the equivalent of discarding a corrupted log line rather than trying to reconstruct it.
- **Impute** a reasonable default: the column's mean or median for numeric fields, the most common category for categorical ones. Simple, but can quietly understate the model's real uncertainty about that field.
- **Add a "was this missing" indicator column** alongside the imputed value, so the model can learn that missingness *itself* might be informative, which it often is: a customer who declined to provide income might behave differently than one who reported a low income, and imputing the mean silently erases that signal.

The mistake worth calling out explicitly, echoing [Chapter 23](#ch-23)'s "clean the input side" rule for fine-tuning data: whatever encoding, scaling, or imputation logic you fit (which mean to impute, which scaling factors to use) must be fit *only* on the training split and then applied unchanged to validation and test data. Fitting your scaler on the full dataset before splitting leaks information from validation/test into training, inflating your evaluation numbers in a way that won't hold up once the model meets genuinely new data in production, a subtle bug with the same shape as accidentally sharing state between two "isolated" test cases.

---

[← Chapter 37: Evaluating Classical Models](#ch-37) &nbsp;|&nbsp; [Table of Contents](../index.md) &nbsp;|&nbsp; [Chapter 39: Computer Vision: CNNs, Detection, Segmentation, and Diffusion Models →](#ch-39)
