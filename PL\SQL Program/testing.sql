INSERT INTO public_holidays
VALUES
(
    1,
    DATE '2026-01-01',
    'New Year''s Day'
);

COMMIT;

UPDATE drugs
SET unit_price = 5000
WHERE drug_id = 1;
