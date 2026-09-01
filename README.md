## Files
- `notebook/` – reasoning and analysis
- `sql/` – the main DuckDB checks and transformations
- `output/` – golden dataset and supporting tables
- `dashboard/credresolve_dashboard.xlsx` – one-screen executive dashboard
- `dashboard/dashboard.html` – quick browser version
- `memo/` – executive memo
- `architecture/` – production design

## Main conclusion
The 11% month-on-month improvement is not a sustained trend. March is about +11% versus February, but later months move up and down. Payment duplication also needs to be handled before reporting recovery.

## Dashboard definition
Recovery = successful payment amounts after deduplicating on `payment_id`. August is treated as a partial month because the supplied payment/event data ends on 8 August 2026.

## Recommendation
The current data is not enough to defend a causal ₹10 Cr ROI estimate. The next step should be a controlled borrower-targeting test with a treatment/control group and a fixed recovery window.
