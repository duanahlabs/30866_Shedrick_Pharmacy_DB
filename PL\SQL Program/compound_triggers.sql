CREATE OR REPLACE TRIGGER trg_stock_compound
FOR UPDATE OF quantity
ON stock_batches
COMPOUND TRIGGER

    BEFORE STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Stock update started.');
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'Updating Batch ' || :OLD.batch_id
        );
    END BEFORE EACH ROW;

    AFTER EACH ROW IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'New Quantity: ' || :NEW.quantity
        );
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'Stock update completed.'
        );
    END AFTER STATEMENT;

END;
/
