-- 04_metrics.sql
-- Independent recovery metric

WITH payments_clean AS (
    SELECT *
    FROM read_csv_auto('payments.csv')
    QUALIFY ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY event_at DESC) = 1
)
SELECT DATE_TRUNC('month', event_at) AS month,
       SUM(amount) FILTER (WHERE payment_status = 'SUCCESS') AS recovery,
       COUNT(*) FILTER (WHERE payment_status = 'SUCCESS') AS successful_payments,
       COUNT(DISTINCT account_id) FILTER (WHERE payment_status = 'SUCCESS') AS accounts_paid
FROM payments_clean
GROUP BY 1
ORDER BY 1;
