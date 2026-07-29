INSERT INTO suppliers VALUES (1, 'MedSource Rwanda Ltd', 'Alice Uwase', '0788111222', 'alice@medsource.rw', 'Kigali, KG 15 Ave');
INSERT INTO suppliers VALUES (2, 'PharmaCare Distributors', 'Eric Habimana', '0788333444', 'eric@pharmacare.rw', 'Kigali, KN 4 St');
INSERT INTO suppliers VALUES (3, 'East Africa Pharma Supply', 'Grace Mukamana', '0788555666', 'grace@eapharma.com', 'Kigali, KG 9 Ave');

INSERT INTO drugs VALUES (1, 'Amoxicillin', 'Amoxicillin', 'Capsule', '500mg', 'Antibiotic', 1200, 50);
INSERT INTO drugs VALUES (2, 'Paracetamol', 'Acetaminophen', 'Tablet', '500mg', 'Analgesic', 300, 100);
INSERT INTO drugs VALUES (3, 'Metformin', 'Metformin HCl', 'Tablet', '850mg', 'Antidiabetic', 800, 40);
INSERT INTO drugs VALUES (4, 'Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'Antacid', 950, 30);
INSERT INTO drugs VALUES (5, 'Ibuprofen', 'Ibuprofen', 'Tablet', '400mg', 'NSAID', 400, 60);

INSERT INTO stock_batches VALUES (1, 1, 1, 'AMX-2026-001', 200, 200, DATE '2025-06-01', DATE '2027-06-01', DATE '2025-06-05');
INSERT INTO stock_batches VALUES (2, 2, 2, 'PCM-2026-014', 500, 500, DATE '2025-08-01', DATE '2027-02-01', DATE '2025-08-03');
INSERT INTO stock_batches VALUES (3, 3, 1, 'MET-2026-007', 150, 150, DATE '2025-05-01', DATE '2026-08-15', DATE '2025-05-04');
INSERT INTO stock_batches VALUES (4, 4, 3, 'OME-2026-022', 80, 80, DATE '2025-09-01', DATE '2026-09-01', DATE '2025-09-06');
INSERT INTO stock_batches VALUES (5, 5, 2, 'IBU-2026-031', 300, 300, DATE '2025-07-01', DATE '2027-01-01', DATE '2025-07-05');
INSERT INTO stock_batches VALUES (6, 3, 1, 'MET-2025-099', 40, 40, DATE '2025-01-01', DATE '2026-08-20', DATE '2025-01-05');

INSERT INTO patients VALUES (1, 'Jean', 'Mugisha', 'M', DATE '1988-03-14', '0788777001');
INSERT INTO patients VALUES (2, 'Claudine', 'Uwimana', 'F', DATE '1995-11-02', '0788777002');
INSERT INTO patients VALUES (3, 'Emmanuel', 'Nkurunziza', 'M', DATE '1972-06-21', '0788777003');
INSERT INTO patients VALUES (4, 'Diane', 'Ingabire', 'F', DATE '2001-01-30', '0788777004');

INSERT INTO doctors VALUES (1, 'Patrick', 'Bizimana', 'General Practice', '0788999001');
INSERT INTO doctors VALUES (2, 'Sarah', 'Mutoni', 'Endocrinology', '0788999002');

INSERT INTO employees VALUES (1, 'Shedrick', 'Duanah', 'Pharmacist', 'sduanah', DATE '2024-01-10', '0788888001');
INSERT INTO employees VALUES (2, 'Aline', 'Umutoni', 'Cashier', 'aumutoni', DATE '2024-03-15', '0788888002');
INSERT INTO employees VALUES (3, 'Bosco', 'Niyonzima', 'InventoryManager', 'bniyonzima', DATE '2023-11-01', '0788888003');

INSERT INTO prescriptions VALUES (1, 1, 1, DATE '2026-07-20', 'Pending');
INSERT INTO prescriptions VALUES (2, 2, 2, DATE '2026-07-21', 'Pending');
INSERT INTO prescriptions VALUES (3, 3, 1, DATE '2026-07-22', 'Pending');

INSERT INTO prescription_items VALUES (1, 1, 1, 20, 'Twice daily for 10 days');
INSERT INTO prescription_items VALUES (2, 2, 3, 30, 'Once daily with breakfast');
INSERT INTO prescription_items VALUES (3, 3, 2, 10, 'Every 6 hours as needed');

INSERT INTO public_holidays VALUES (1, DATE '2026-01-01', 'New Year''s Day');

COMMIT;
