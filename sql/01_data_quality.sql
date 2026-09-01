-- 01_data_quality.sql
-- Basic checks I used while exploring the raw data

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT borrower_id) AS unique_borrowers
FROM read_csv_auto('borrowers.csv');

SELECT borrower_id, COUNT(*) AS rows
FROM read_csv_auto('borrowers.csv')
GROUP BY borrower_id
HAVING COUNT(*) > 1
ORDER BY rows DESC;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT payment_id) AS unique_payment_ids,
       COUNT(*) - COUNT(DISTINCT payment_id) AS duplicate_rows
FROM read_csv_auto('payments.csv');

SELECT payment_id, COUNT(*) AS rows
FROM read_csv_auto('payments.csv')
GROUP BY payment_id
HAVING COUNT(*) > 1
ORDER BY rows DESC;
