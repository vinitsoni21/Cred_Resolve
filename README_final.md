# CredResolve – Collections & Recovery Analysis

> **Data Analyst Assignment | Collections Performance, Data Forensics & Investment Recommendation**

## Executive Summary

This project investigates a simple but important business question:

> **Is recovery really improving by 11% month-on-month?**

Instead of accepting the reported KPI, I rebuilt the recovery view from the raw collections data, checked data-quality problems, investigated operational segments, and separated **observed facts from possible explanations**.

### Key takeaway

**The 11% improvement is not a sustained month-on-month trend.**

After payment-level deduplication:

| Month | Successful Recovery | MoM Change |
|---|---:|---:|
| Jan 2026 | ₹18.72 Cr | — |
| Feb 2026 | ₹17.01 Cr | **-9.1%** |
| Mar 2026 | ₹18.89 Cr | **+11.0%** |
| Apr 2026 | ₹17.51 Cr | **-7.3%** |
| May 2026 | ₹18.43 Cr | **+5.2%** |
| Jun 2026 | ₹17.56 Cr | **-4.7%** |
| Jul 2026 | ₹18.72 Cr | **+6.7%** |
| Aug 2026* | ₹4.71 Cr | **Partial month** |

The **+11.0% result occurs specifically in March versus February**. It should not be interpreted as evidence that recovery has improved by 11% every month.

> **Important:** August contains only a partial period, so it is not compared directly with full months.

---

## 📊 Executive Dashboard

The Excel dashboard is the main executive output of this project.

**Open:** [`dashboard/credresolve_dashboard.xlsx`](dashboard/credresolve_dashboard.xlsx)

It is designed around the question a leadership team would ask first:

> **What changed, is the reported improvement real, and where should we investigate next?**

The dashboard includes:

- Recovery trend and month-on-month movement
- Risk-segment performance
- DPD-level performance
- Payment outcome mix
- Telephony/vendor performance
- Target-channel performance
- Data-quality indicators
- Key business takeaways
- Investment recommendation

**Dashboard preview:**  
_Add `dashboard/dashboard_preview.png` here once the screenshot is exported._

---

# 1. Business Problem

The assignment provides collections data from multiple operational systems including:

- Borrowers
- Accounts
- Agents
- Agent sessions
- Campaigns
- Daily targeting
- Calls and call attempts
- Call dispositions
- WhatsApp
- SMS
- Field visits
- Promises-to-pay
- Payments
- Telephony vendors
- Complaints
- Account status history

The business reports:

> **“Recovery has improved by 11% month-on-month.”**

The goal is not simply to calculate another KPI. The goal is to determine whether that statement survives:

1. Data cleaning
2. Independent metric definitions
3. Data forensics
4. Segment analysis
5. Mix effects
6. Attribution issues
7. Counterfactual thinking
8. Business sanity checks

The assignment specifically warns that the raw data may contain duplicates, missing values, conflicting timestamps, different time zones, inconsistent identifiers, late-arriving events, changed schemas/dispositions, duplicate payment events, overwritten history, multiple agent identifiers, and inconsistent campaign definitions.

---

# 2. Analytical Approach

```text
Raw CSV Files
      │
      ▼
Data Quality Checks
      │
      ▼
Cleaning & Deduplication
      │
      ▼
Golden Analytical Layer
      │
      ├───────────────┐
      ▼               ▼
Recovery Metrics   Operational Analysis
      │               │
      └───────┬───────┘
              ▼
       Business Findings
              │
              ▼
      Executive Dashboard
              │
              ▼
     Investment Recommendation
```

The main principle was:

> **Do not build the dashboard first and then explain the numbers. Build a trustworthy analytical layer first.**

---

# 3. Data Quality & Forensics

One of the main findings is that the raw tables cannot always be treated as clean source-of-truth tables.

## Payments

The payment data contains duplicate `payment_id` records.

- **25,500 raw payment rows**
- **25,000 unique payment IDs**
- **500 excess duplicate rows**
- **486 exact duplicate rows**
- Duplicate payment IDs can materially inflate recovery if counted directly.

After deduplicating at the `payment_id` level, successful payments were used to calculate recovery.

## Borrowers

The borrower table contains repeated borrower IDs and conflicting profile records.

Therefore:

> **Raw borrower row count is not the same thing as unique borrower count.**

A direct account-to-borrower join without resolving borrower records can multiply account rows and distort metrics.

## Calls

The call data also contains duplicate call IDs and some non-identical duplicate records.

This matters because call-level metrics such as contact rate can be inflated if duplicate events are counted as independent calls.

## Agent Identity

The agent master contains inconsistent mappings between agent IDs, employee codes, names, vendors and teams.

For this reason, the analysis avoids pretending that the raw agent table provides a perfectly reliable historical agent master.

## Time Zones

The data contains multiple time zones.

For calling-time analysis, the event-level timezone is preferred over assuming that the current vendor master timezone represents historical calls.

---

# 4. Golden Dataset

The analytical layer follows:

```text
Raw Records
     │
     ├── Duplicate / invalid / conflicting records
     │
     ▼
Corrected / Deduplicated Records
     │
     ▼
Golden Dataset
     │
     ├── Account-level metrics
     ├── Payment metrics
     ├── Recovery metrics
     └── Segment attributes
```

**Output:** [`output/golden_account_dataset.csv`](output/golden_account_dataset.csv)

Main cleaning decisions include:

- Deduplicate payments using `payment_id`
- Prefer populated payment references when duplicate records conflict
- Treat successful payments as realized recovery
- Resolve repeated borrower records deterministically
- Remove exact duplicate event records where appropriate
- Avoid using unreliable historical agent-master mappings as ground truth
- Keep partial-period data separate from complete-month comparisons

---

# 5. Recovery Definition

### Successful Recovery

```text
Recovery = SUM(successful payment amounts)
```

where each `payment_id` is counted once.

### Month-on-Month Change

```text
MoM Change =
(Current Month Recovery - Previous Month Recovery)
÷ Previous Month Recovery
```

This makes the 11% claim directly testable.

---

# 6. What Actually Happened?

After cleaning duplicate payment events:

### February → March

Recovery increased from:

**₹17.01 Cr → ₹18.89 Cr**

which is approximately:

**+11.0% MoM**

So the reported number **does appear in the data**.

However, the complete-month series shows:

- February: **-9.1%**
- March: **+11.0%**
- April: **-7.3%**
- May: **+5.2%**
- June: **-4.7%**
- July: **+6.7%**

Therefore:

> **Fact:** March recovery increased by about 11% versus February.

> **Fact:** The broader monthly series does not show a sustained 11% month-on-month improvement.

> **Interpretation:** The 11% statement is valid as a single month comparison, but misleading if presented as a continuing trend.

---

# 7. Why the Claim Can Be Misleading

Several characteristics of the raw data make headline recovery numbers sensitive to reporting definitions.

### Duplicate payments

Counting duplicate payment events can overstate recovery.

### Denominator changes

Conversion metrics can improve simply because unsuccessful accounts disappear from the denominator.

### Portfolio mix

Changes in the composition of accounts can change aggregate recovery even if collection performance within individual segments does not improve.

### Partial months

August is incomplete, so its raw recovery should not be compared directly with full months.

### Attribution

The data does not provide a clean, universal payment-to-channel attribution field. Channel conversion therefore needs an explicit attribution rule and should not be interpreted as causal from raw event proximity alone.

### Agent identity

Historical agent-level comparisons are constrained by inconsistent agent identifiers and master records.

---

# 8. Segment Analysis

The analysis explores recovery across operational dimensions available in the data:

- Risk
- DPD
- Loan type
- Telephony vendor
- Target channel
- Payment status
- Calling time
- Campaign/strategy information where available

Outputs:

- [`output/risk_performance.csv`](output/risk_performance.csv)
- [`output/dpd_performance.csv`](output/dpd_performance.csv)
- [`output/loan_type_performance.csv`](output/loan_type_performance.csv)
- [`output/vendor_call_performance.csv`](output/vendor_call_performance.csv)
- [`output/target_channel_performance.csv`](output/target_channel_performance.csv)

### Interpretation rule

A segment with higher recovery is **not automatically better because of that segment itself**.

Segment differences may reflect:

- Account volumes
- Principal balances
- DPD mix
- Targeting
- Borrower composition

Therefore conclusions are classified as:

**Fact → Strong Evidence → Correlation → Hypothesis**

rather than treating every segment difference as causal.

---

# 9. Counterfactual / Causal Thinking

The supplied targeting data contains multiple strategy versions across the period rather than one clean before/after treatment flag.

Because of that, a strong causal estimate of:

> “What would recovery have been without the targeting change?”

cannot be reliably identified from the raw data alone.

A stronger production approach would be:

### Treatment

Accounts exposed to the new targeting strategy after the strategy-change date.

### Control

Comparable eligible accounts that remained under the previous strategy.

### Matching / Controls

Balance treatment and control on:

- DPD
- Risk
- Principal/outstanding
- Prior recovery
- Prior contact history
- Borrower/account characteristics
- Geography where available
- Pre-period collection behavior

### Estimation

Use a controlled experiment or Difference-in-Differences design.

The key requirement is to compare similar accounts rather than simply comparing two calendar periods.

---

# 10. ₹10 Cr Investment Recommendation

## Recommendation: Better Borrower Targeting

The strongest direction from the available data is to **pilot better borrower targeting**, rather than immediately committing the full ₹10 Cr to a large operational change.

The dataset already contains targeting-related information such as:

- Strategy version
- Priority
- Recommended channel
- Target date
- Targeting status

This makes targeting a practical area for experimentation.

### Important caveat

The current data does **not** contain enough reliable cost and causal-lift information to claim a precise ROI for a ₹10 Cr investment.

Therefore, I would **not invent an ROI number**.

Instead:

```text
₹10 Cr Budget
     │
     ▼
Controlled Targeting Pilot
     │
     ├── Treatment group
     ├── Control / holdout group
     ├── Pre-period matching
     └── Fixed attribution window
             │
             ▼
      Incremental Recovery
             │
             ▼
      Scale only if ROI clears hurdle
```

### Required business inputs

Before deploying the full ₹10 Cr, the business should provide:

- Cost by channel
- Agent cost / hourly cost
- Telephony cost
- Digital messaging cost
- Commission structure
- Reliable payment attribution
- Treatment/control assignment
- Incremental recovery measurement

Then calculate:

```text
Incremental Recovery
= Treatment Recovery
  - Expected Control Recovery
```

```text
ROI
= (Incremental Recovery - Investment Cost)
  ÷ Investment Cost
```

```text
Break-even
= Investment Cost
  ÷ Contribution per ₹ of Incremental Recovery
```

This gives leadership a measurable decision rather than a speculative ROI.

---

# 11. Dashboard

The dashboard is intentionally designed as a **one-screen executive view** rather than a collection of charts.

### Primary questions answered

**1. What is recovery doing?**  
Monthly recovery trend and MoM movement.

**2. Is the 11% claim real?**  
March is +11.0% versus February, but the pattern is not sustained.

**3. Where should we investigate?**  
Risk, DPD, vendor, channel and payment-level views.

**4. What should leadership do?**  
Run a controlled borrower-targeting pilot before committing the full investment.

---

# 12. Repository Structure

```text
credresolve/
│
├── data/
│   ├── accounts.csv
│   ├── borrowers.csv
│   ├── payments.csv
│   ├── calls.csv
│   ├── call_attempts.csv
│   ├── campaigns.csv
│   ├── daily_targeting.csv
│   └── ...
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_cleaning.sql
│   ├── 03_golden_dataset.sql
│   ├── 04_metrics.sql
│   └── 05_segment_analysis.sql
│
├── notebook/
│   └── cred_resolve_analysis.ipynb
│
├── output/
│   ├── golden_account_dataset.csv
│   ├── data_quality_report.csv
│   ├── monthly_recovery.csv
│   ├── risk_performance.csv
│   ├── dpd_performance.csv
│   ├── loan_type_performance.csv
│   ├── vendor_call_performance.csv
│   └── target_channel_performance.csv
│
├── dashboard/
│   ├── credresolve_dashboard.xlsx
│   ├── dashboard.html
│   └── recovery_trend.png
│
├── memo/
│   ├── executive_memo.md
│   └── executive_memo.pdf
│
├── architecture/
│   └── architecture.svg
│
├── README.md
└── requirements.txt
```

---

# 13. Main Files

| File | Purpose |
|---|---|
| `sql/01_data_quality.sql` | Initial quality checks |
| `sql/02_cleaning.sql` | Cleaning and deduplication |
| `sql/03_golden_dataset.sql` | Golden analytical layer |
| `sql/04_metrics.sql` | Recovery and KPI calculations |
| `sql/05_segment_analysis.sql` | Segment-level analysis |
| `notebook/cred_resolve_analysis.ipynb` | Exploratory analysis and findings |
| `output/golden_account_dataset.csv` | Clean account-level analytical dataset |
| `output/data_quality_report.csv` | Summary of data-quality checks |
| `dashboard/credresolve_dashboard.xlsx` | Executive dashboard |
| `memo/executive_memo.pdf` | Leadership summary |
| `architecture/architecture.svg` | Production data architecture |

---

# 14. Tools Used

- **SQL / DuckDB** – data cleaning, joins and analytical queries
- **Python / Pandas** – exploratory analysis and validation
- **Jupyter Notebook** – analysis workflow
- **Excel** – executive dashboard
- **GitHub** – project organization and submission

---

# 15. Limitations

The analysis deliberately calls out areas where the supplied data is insufficient rather than creating unsupported assumptions.

### Monthly recovery denominator

A reliable month-by-month outstanding balance is not available, so a true historical recovery-rate denominator cannot be reconstructed perfectly.

### Client and language

The supplied schemas do not provide a clean client/language dimension for all accounts, so these dimensions cannot be analysed with the same confidence as risk or DPD.

### Agent history

Agent identifiers and master attributes are inconsistent, limiting reliable historical agent-tenure analysis.

### Channel attribution

Payments do not contain a direct, trustworthy channel attribution field. Channel conversion therefore requires an explicit attribution rule and should not be interpreted as causal from raw event proximity alone.

### Investment ROI

Actual channel/operational costs and causal incremental lift are not sufficiently available to calculate a defensible real-world ROI for the ₹10 Cr investment.

---

# 16. Final Conclusion

### The business claim

**“Recovery has improved by 11% month-on-month.”**

### My conclusion

**Partially true, but misleading as a trend statement.**

The dataset contains a clear **+11.0% increase from February to March**, but the surrounding months do not support a sustained 11% monthly improvement.

The more important analytical finding is:

> **Before making an operational or investment decision, recovery needs to be measured from deduplicated payments, stable denominators, consistent attribution, and comparable account populations.**

For the ₹10 Cr decision, the recommended next step is a **controlled borrower-targeting pilot with a holdout group**, followed by scaling only if the measured incremental recovery and ROI justify the investment.

---

## Assignment Coverage

| Assignment Area | Covered |
|---|:---:|
| What happened? | ✅ |
| Why did it happen? | ✅ |
| Independent recovery definition | ✅ |
| 11% claim validation | ✅ |
| Duplicate payments | ✅ |
| Attribution considerations | ✅ |
| Timezone issues | ✅ |
| Agent identity issues | ✅ |
| Portfolio/segment analysis | ✅ |
| Counterfactual design | ✅ |
| Golden dataset | ✅ |
| Data-quality report | ✅ |
| Executive dashboard | ✅ |
| ₹10 Cr recommendation | ✅ |
| Production architecture | ✅ |

---

### Note

This repository prioritizes **transparent, reproducible analysis over complicated modelling**. Where the data does not support a strong causal conclusion, the analysis says so explicitly.
