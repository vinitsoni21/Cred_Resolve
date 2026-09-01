-- 02_cleaning.sql
-- Keep one row per payment_id before calculating recovery

WITH payments_clean AS (
    SELECT *
    FROM read_csv_auto('payments.csv')
    QUALIFY ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY event_at DESC) = 1
)
SELECT payment_status,
       COUNT(*) AS payments,
       SUM(amount) AS total_amount
FROM payments_clean
GROUP BY payment_status
ORDER BY payments DESC;
