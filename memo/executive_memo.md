# CredResolve – Executive Memo

## What happened?
The reported “11% month-on-month improvement” is not supported as a sustained trend. After deduplicating payments by `payment_id`, recovery was ₹17.0 Cr in February and ₹18.9 Cr in March (+11.0%), but recovery fell in April and June. July rose again. August is only through 8 August.

## Why?
The strongest immediate explanation is that the raw reporting layer is noisy: there are 500 duplicated payment IDs, 8,566 borrower IDs appearing more than once, and 455 accounts without a borrower ID. Portfolio and operational segments differ, but the data is observational, so these should be treated as correlation/segmentation evidence rather than causal effects.

## Confidence
**Medium** for the payment trend after deduplication. **Lower** for causal explanations because campaign/targeting assignment is not randomized and several source systems have identifier and timestamp issues.

## Recommendation
Do not spend the ₹10 Cr based on the 11% claim alone. The most defensible next step is a controlled borrower-targeting experiment: randomly assign eligible borrowers to the current strategy versus a new targeting strategy, hold the recovery window and attribution rules fixed, and compare recovery per eligible account. Use the result to estimate incremental recovery before scaling.

## Financial view
The current dataset does not provide a defensible causal estimate of incremental recovery or ROI for a ₹10 Cr investment. A pilot should therefore be used to estimate treatment effect, implementation cost, break-even recovery and downside before committing the full budget.
