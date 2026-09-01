-- 05_segment_analysis.sql

WITH payments_clean AS (
    SELECT * FROM read_csv_auto('payments.csv')
    QUALIFY ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY event_at DESC) = 1
)
SELECT a.risk_segment,
       SUM(p.amount) AS recovery,
       COUNT(DISTINCT p.account_id) AS accounts_paid,
       SUM(p.amount) / COUNT(DISTINCT p.account_id) AS recovery_per_account
FROM payments_clean p
JOIN read_csv_auto('accounts.csv') a USING(account_id)
WHERE p.payment_status = 'SUCCESS'
GROUP BY 1
ORDER BY recovery DESC;
