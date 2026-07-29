EXEC dispense_drug(1, 1, 1, 20);
SELECT batch_id, quantity_available FROM stock_batches WHERE batch_id = 1;
SELECT * FROM dispensing WHERE batch_id = 1;

INSERT INTO sales VALUES (1, 1, 2, 24000, SYSDATE, 'Cash');
COMMIT;
SELECT * FROM sales WHERE prescription_id = 1;

SELECT table_name, operation, record_id, changed_by, change_date
FROM audit_log ORDER BY change_date DESC;

SELECT check_stock(6) AS batch_6_available FROM dual;
SELECT expiry_status(expiry_date) AS status, batch_number
FROM stock_batches WHERE batch_id = 6;

-- TEST 5 (should FAIL) -- uncomment to test:
-- UPDATE stock_batches SET quantity_available = -5 WHERE batch_id = 1;

-- TEST 6 (should FAIL on a weekday, once Security Restriction triggers exist):
-- UPDATE drugs SET unit_price = 1300 WHERE drug_id = 1;
