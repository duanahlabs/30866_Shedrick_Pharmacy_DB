 Compound trigger demonstrating BEFORE/AFTER STATEMENT and ROW
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
 
-- ------------------------------------------------------------
-- Business rule: block INSERT/UPDATE/DELETE on weekdays and
-- public holidays. Originally only scoped to DRUGS — broadened
-- here to STOCK_BATCHES and DISPENSING too, so the rule actually
-- protects the database rather than just one table. Triggers are
-- repeated per table because Oracle triggers bind to a single
-- table; if you'd rather not repeat the logic, wrap the two
-- checks in a function (e.g. fn_block_dml_now RETURN BOOLEAN)
-- and call it from each trigger instead.
-- ------------------------------------------------------------
 
CREATE OR REPLACE TRIGGER trg_weekday_block_drugs
BEFORE INSERT OR UPDATE OR DELETE ON drugs
BEGIN
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
       IN ('MON','TUE','WED','THU','FRI') THEN
        RAISE_APPLICATION_ERROR(-20010, 'Database modifications are prohibited Monday-Friday.');
    END IF;
END;
/
 
CREATE OR REPLACE TRIGGER trg_weekday_block_stock
BEFORE INSERT OR UPDATE OR DELETE ON stock_batches
BEGIN
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
       IN ('MON','TUE','WED','THU','FRI') THEN
        RAISE_APPLICATION_ERROR(-20010, 'Database modifications are prohibited Monday-Friday.');
    END IF;
END;
/
 
CREATE OR REPLACE TRIGGER trg_weekday_block_dispensing
BEFORE INSERT OR UPDATE OR DELETE ON dispensing
BEGIN
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
       IN ('MON','TUE','WED','THU','FRI') THEN
        RAISE_APPLICATION_ERROR(-20010, 'Database modifications are prohibited Monday-Friday.');
    END IF;
END;
/
 
CREATE OR REPLACE TRIGGER trg_public_holiday_drugs
BEFORE INSERT OR UPDATE OR DELETE ON drugs
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM public_holidays WHERE holiday_date = TRUNC(SYSDATE);
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Database modifications are not allowed on public holidays.');
    END IF;
END;
/
 
CREATE OR REPLACE TRIGGER trg_public_holiday_stock
BEFORE INSERT OR UPDATE OR DELETE ON stock_batches
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM public_holidays WHERE holiday_date = TRUNC(SYSDATE);
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Database modifications are not allowed on public holidays.');
    END IF;
END;
/
 
CREATE OR REPLACE TRIGGER trg_public_holiday_dispensing
BEFORE INSERT OR UPDATE OR DELETE ON dispensing
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM public_holidays WHERE holiday_date = TRUNC(SYSDATE);
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Database modifications are not allowed on public holidays.');
    END IF;
END;
/
 
-- dispensing_date auto-stamp
CREATE OR REPLACE TRIGGER trg_dispensing_date
BEFORE INSERT ON dispensing
FOR EACH ROW
BEGIN
    :NEW.dispensing_date := SYSDATE;
END;
/
 
-- prevent negative stock
CREATE OR REPLACE TRIGGER trg_prevent_negative_stock
BEFORE UPDATE OF quantity_available ON stock_batches
FOR EACH ROW
BEGIN
    IF :NEW.quantity_available < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Stock quantity cannot be negative.');
    END IF;
END;
/
 
-- Sample holiday row
INSERT INTO public_holidays VALUES (1, DATE '2026-01-01', 'New Year''s Day');
COMMIT;
 
