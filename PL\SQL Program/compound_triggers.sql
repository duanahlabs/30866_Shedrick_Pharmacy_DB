CREATE OR REPLACE TRIGGER trg_stock_compound
FOR UPDATE OF quantity_available ON stock_batches
COMPOUND TRIGGER
    BEFORE STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Stock update started.');
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Updating Batch ' || :OLD.batch_id);
    END BEFORE EACH ROW;

    AFTER EACH ROW IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('New Quantity Available: ' || :NEW.quantity_available);
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Stock update completed.');
    END AFTER STATEMENT;
END;
/

-- also add: prevent negative stock (simple trigger, pairs naturally
-- with the compound one since both guard stock_batches)
CREATE OR REPLACE TRIGGER trg_prevent_negative_stock
BEFORE UPDATE OF quantity_available ON stock_batches
FOR EACH ROW
BEGIN
    IF :NEW.quantity_available < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Stock quantity cannot be negative.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_dispensing_date
BEFORE INSERT ON dispensing
FOR EACH ROW
BEGIN
    :NEW.dispensing_date := SYSDATE;
END;
/
