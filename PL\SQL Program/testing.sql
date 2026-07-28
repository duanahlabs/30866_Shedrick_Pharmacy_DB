-- Sample Data + Test/Validation Script

-- Why this exists: the project had only ONE insert statement
-- anywhere (public_holidays). Phase V requires meaningful sample
-- data, and you need data to actually demonstrate procedures,
-- triggers, and the audit system live.
--
-- IMPORTANT — read before running:
-- trg_weekday_block_* triggers block ALL inserts/updates/deletes
-- Monday–Friday on drugs, stock_batches, and dispensing. That
-- means if you try to load this sample data on a weekday, it
-- will fail with ORA-20010. You have two options:
--
--   A) Run this on a Saturday/Sunday (satisfies the rule for real)
--   B) Temporarily disable the three triggers, load data, then
--      re-enable them (commands provided below, commented out)
--
-- Do NOT leave the triggers permanently disabled — that defeats
-- the point of the business rule. Option B is just for loading
-- your one-time sample dataset; re-enable immediately after.
-- ============================================================

-- Uncomment these 3 lines if running on a weekday (Option B):
-- ALTER TRIGGER trg_weekday_block_drugs DISABLE;
-- ALTER TRIGGER trg_weekday_block_stock DISABLE;
-- ALTER TRIGGER trg_weekday_block_dispensing DISABLE;

-- ------------------------------------------------------------
-- SUPPLIERS
-- ------------------------------------------------------------
INSERT INTO suppliers VALUES (1, 'MedSource Rwanda Ltd', 'Alice Uwase', '0788111222', 'alice@medsource.rw', 'Kigali, KG 15 Ave');
INSERT INTO suppliers VALUES (2, 'PharmaCare Distributors', 'Eric Habimana', '0788333444', 'eric@pharmacare.rw', 'Kigali, KN 4 St');
INSERT INTO suppliers VALUES (3, 'East Africa Pharma Supply', 'Grace Mukamana', '0788555666', 'grace@eapharma.com', 'Kigali, KG 9 Ave');

-- ------------------------------------------------------------
-- DRUGS
-- ------------------------------------------------------------
INSERT INTO drugs VALUES (1, 'Amoxicillin', 'Amoxicillin', 'Capsule', '500mg', 'Antibiotic', 1200, 50);
INSERT INTO drugs VALUES (2, 'Paracetamol', 'Acetaminophen', 'Tablet', '500mg', 'Analgesic', 300, 100);
INSERT INTO drugs VALUES (3, 'Metformin', 'Metformin HCl', 'Tablet', '850mg', 'Antidiabetic', 800, 40);
INSERT INTO drugs VALUES (4, 'Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'Antacid', 950, 30);
INSERT INTO drugs VALUES (5, 'Ibuprofen', 'Ibuprofen', 'Tablet', '400mg', 'NSAID', 400, 60);

-- ------------------------------------------------------------
-- STOCK_BATCHES
-- ------------------------------------------------------------
INSERT INTO stock_batches VALUES (1, 1, 1, 'AMX-2026-001', 200, 200, DATE '2025-06-01', DATE '2027-06-01', DATE '2025-06-05');
INSERT INTO stock_batches VALUES (2, 2, 2, 'PCM-2026-014', 500, 500, DATE '2025-08-01', DATE '2027-02-01', DATE '2025-08-03');
INSERT INTO stock_batches VALUES (3, 3, 1, 'MET-2026-007', 150, 150, DATE '2025-05-01', DATE '2026-08-15', DATE '2025-05-04');
INSERT INTO stock_batches VALUES (4, 4, 3, 'OME-2026-022', 80, 80, DATE '2025-09-01', DATE '2026-09-01', DATE '2025-09-06');
INSERT INTO stock_batches VALUES (5, 5, 2, 'IBU-2026-031', 300, 300, DATE '2025-07-01', DATE '2027-01-01', DATE '2025-07-05');
-- deliberately near-expiry batch, for demoing expiry_status() and the innovation dashboard
INSERT INTO stock_batches VALUES (6, 3, 1, 'MET-2025-099', 40, 40, DATE '2025-01-01', DATE '2026-08-20', DATE '2025-01-05');

-- ------------------------------------------------------------
-- PATIENTS
-- ------------------------------------------------------------
INSERT INTO patients VALUES (1, 'Jean', 'Mugisha', 'M', DATE '1988-03-14', '0788777001');
INSERT INTO patients VALUES (2, 'Claudine', 'Uwimana', 'F', DATE '1995-11-02', '0788777002');
INSERT INTO patients VALUES (3, 'Emmanuel', 'Nkurunziza', 'M', DATE '1972-06-21', '0788777003');
INSERT INTO patients VALUES (4, 'Diane', 'Ingabire', 'F', DATE '2001-01-30', '0788777004');

-- ------------------------------------------------------------
-- DOCTORS
-- ------------------------------------------------------------
INSERT INTO doctors VALUES (1, 'Patrick', 'Bizimana', 'General Practice', '0788999001');
INSERT INTO doctors VALUES (2, 'Sarah', 'Mutoni', 'Endocrinology', '0788999002');

-- ------------------------------------------------------------
-- EMPLOYEES
-- ------------------------------------------------------------
INSERT INTO employees VALUES (1, 'Shedrick', 'Duanah', 'Pharmacist', 'sduanah', DATE '2024-01-10', '0788888001');
INSERT INTO employees VALUES (2, 'Aline', 'Umutoni', 'Cashier', 'aumutoni', DATE '2024-03-15', '0788888002');
INSERT INTO employees VALUES (3, 'Bosco', 'Niyonzima', 'InventoryManager', 'bniyonzima', DATE '2023-11-01', '0788888003');

-- ------------------------------------------------------------
-- PRESCRIPTIONS + PRESCRIPTION_ITEMS
-- ------------------------------------------------------------
INSERT INTO prescriptions VALUES (1, 1, 1, DATE '2026-07-20', 'Pending');
INSERT INTO prescriptions VALUES (2, 2, 2, DATE '2026-07-21', 'Pending');
INSERT INTO prescriptions VALUES (3, 3, 1, DATE '2026-07-22', 'Pending');

INSERT INTO prescription_items VALUES (1, 1, 1, 20, 'Twice daily for 10 days');
INSERT INTO prescription_items VALUES (2, 2, 3, 30, 'Once daily with breakfast');
INSERT INTO prescription_items VALUES (3, 3, 2, 10, 'Every 6 hours as needed');

COMMIT;

-- Re-enable triggers if you disabled them above:
-- ALTER TRIGGER trg_weekday_block_drugs ENABLE;
-- ALTER TRIGGER trg_weekday_block_stock ENABLE;
-- ALTER TRIGGER trg_weekday_block_dispensing ENABLE;


-- TEST 1: Dispense a drug — proves the procedure, batch deduction,
-- and dispensing record all work together
EXEC dispense_drug(1, 1, 1, 20);
-- Expect: stock_batches.quantity_available for batch 1 drops
-- from 200 to 180, and a new row appears in dispensing.
SELECT batch_id, quantity_available FROM stock_batches WHERE batch_id = 1;
SELECT * FROM dispensing WHERE batch_id = 1;

-- TEST 2: Record the matching sale
INSERT INTO sales VALUES (1, 1, 2, 24000, SYSDATE, 'Cash');
COMMIT;
SELECT * FROM sales WHERE prescription_id = 1;

-- TEST 3: Auditing — confirm the dispense and stock change were logged
SELECT table_name, operation, record_id, changed_by, change_date
FROM audit_log
ORDER BY change_date DESC;

-- TEST 4: check_stock() and expiry_status() functions
SELECT check_stock(6) AS batch_6_available FROM dual;
SELECT expiry_status(expiry_date) AS status, batch_number
FROM stock_batches
WHERE batch_id = 6;
-- Expect: 'Near Expiry' if today's date is within 30 days of
-- 2026-08-20, otherwise 'Valid' — this is exactly the kind of
-- row your innovation dashboard should surface.

-- TEST 5: Negative stock prevention — this should FAIL
-- (uncomment to test)
-- UPDATE stock_batches SET quantity_available = -5 WHERE batch_id = 1;
-- Expect: ORA-20001, "Stock quantity cannot be negative."

-- TEST 6: Weekday/holiday DML block — this should FAIL on a weekday
-- (uncomment to test; will succeed only on Sat/Sun or a listed holiday)
-- UPDATE drugs SET unit_price = 1300 WHERE drug_id = 1;
-- Expect (on a weekday): ORA-20010, "Database modifications are
-- prohibited Monday-Friday."

-- TEST 7: Security boundary — run this LAST, connected as
-- cashier_demo instead of the schema owner (see
-- 04_database_creation/security_roles_and_grants.sql)
-- (uncomment to test after connecting as cashier_demo)
-- INSERT INTO 30866_shedrick_pharmacy_db.stock_batches
--   (batch_id, drug_id, supplier_id, batch_number, quantity_received,
--    quantity_available, manufacture_date, expiry_date)
--   VALUES (99, 1, 1, 'TEST-999', 10, 10, SYSDATE, SYSDATE+365);
-- Expect: ORA-01031, "insufficient privileges" — cashier_role was
-- never granted INSERT on stock_batches. Screenshot this for your
-- GitHub screenshots/ folder.
