-- 03_golden_dataset.sql
-- Account-level analytical layer

WITH payments_clean AS (
    SELECT *
    FROM read_csv_auto('payments.csv')
    QUALIFY ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY event_at DESC) = 1
),
payments_by_account AS (
    SELECT account_id,
           COUNT(*) FILTER (WHERE payment_status = 'SUCCESS') AS successful_payment_count,
           SUM(amount) FILTER (WHERE payment_status = 'SUCCESS') AS recovered_amount,
           MAX(event_at) FILTER (WHERE payment_status = 'SUCCESS') AS last_payment_at
    FROM payments_clean
    GROUP BY account_id
)
SELECT a.*,
       p.successful_payment_count,
       p.recovered_amount,
       p.last_payment_at
FROM read_csv_auto('accounts.csv') a
LEFT JOIN payments_by_account p USING(account_id);
