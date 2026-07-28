CREATE OR REPLACE TRIGGER trg_dispensing_date
BEFORE INSERT
ON dispensing
FOR EACH ROW
BEGIN
    :NEW.dispensing_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_prevent_negative_stock
BEFORE UPDATE OF quantity
ON stock_batches
FOR EACH ROW
BEGIN
    IF :NEW.quantity < 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Stock quantity cannot be negative.'
        );
    END IF;
END;
/
