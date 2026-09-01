# Key findings

- The raw payment file has 25,500 rows but only 25,000 unique payment IDs. There are 500 duplicated payment IDs, so raw payment sums should not be used for recovery.
- After keeping one row per payment_id, successful payments total about ₹131.56 Cr across 17,534 payments.
- Monthly recovery is volatile rather than showing a steady +11% month-on-month improvement. March is +11.0% vs February, but April is -7.3%, June is -4.7%, and July is +6.7%.
- August is partial (data runs only through August 8), so it should not be compared directly with full months.
- The borrower file has 30,000 rows but only 11,015 unique borrower IDs. The raw borrower table therefore should not be used as a unique-borrower denominator.
- Accounts contain 455 missing borrower IDs.
- The current evidence supports rejecting the simple statement that recovery improved by 11% every month. The +11% figure occurs for March specifically, not as a sustained trend.
- The dashboard focuses on recovery, volatility, data quality, and portfolio segments rather than claiming causal effects from observational data.
